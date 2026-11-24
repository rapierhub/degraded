local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local entities = require("@modules/entities")

local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera

local Aim = {}

local OriginalIndex = nil
local Installed = false
local RayParams = entities.rayParams()
local RayParamsGen = -1

function Aim.origin2D()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        return Camera.ViewportSize / 2
    end
    return UserInputService:GetMouseLocation()
end

local function screenDistance(pos, center)
    local sp, onScreen = Camera:WorldToViewportPoint(pos)
    if not onScreen or sp.Z <= 0 then
        return math.huge
    end
    return (Vector2.new(sp.X, sp.Y) - center).Magnitude
end

local function part(model, name)
    local p = model:FindFirstChild(name)
    return p and p:IsA("BasePart") and p or nil
end

Aim.part = part

local function isVisible(e, p)
    if not config.Aim.VisibleCheck then
        return true
    end
    if RayParamsGen ~= state.EntitiesGen then
        RayParams = entities.rayParams()
        RayParamsGen = state.EntitiesGen
    end
    local origin = Camera.CFrame.Position
    local hit = workspace:Raycast(origin, p.Position - origin, RayParams)
    return hit == nil or hit.Instance:IsDescendantOf(e.model)
end

local function pickPart(model, center)
    local A = config.Aim
    if A.TargetPart ~= "Closest" then
        local p = part(model, A.TargetPart) or part(model, "HumanoidRootPart")
        return p, p and screenDistance(p.Position, center) or math.huge
    end
    local best, bestD = nil, math.huge
    for _, name in ipairs(A.ClosestParts) do
        local p = part(model, name)
        if p then
            local d = screenDistance(p.Position, center)
            if d < bestD then
                best, bestD = p, d
            end
        end
    end
    return best, bestD
end

local function eligible(e)
    local A = config.Aim
    return A.Kinds[e.kind] and entities.alive(e)
        and not (A.TeamCheck and entities.isTeammate(e))
        and not (A.SkipProtected and entities.protected(e))
end

local function stillValid(t, center)
    if not t or not t.part.Parent or not eligible(t.entity) then
        return false
    end
    if (t.part.Position - Camera.CFrame.Position).Magnitude > config.Aim.MaxDistance then
        return false
    end
    return screenDistance(t.part.Position, center) <= config.Aim.FovRadius and isVisible(t.entity, t.part)
end

function Aim.selectTarget()
    entities.refresh(os.clock())
    local A = config.Aim
    local center = Aim.origin2D()
    local camPos = Camera.CFrame.Position
    local best, bestD = nil, math.huge
    for _, e in ipairs(state.Entities) do
        if eligible(e) then
            local p, d = pickPart(e.model, center)
            if p and d <= A.FovRadius and d < bestD and (p.Position - camPos).Magnitude <= A.MaxDistance then
                if not isVisible(e, p) then
                    p = nil
                    for _, name in ipairs(A.ClosestParts) do
                        local alt = part(e.model, name)
                        if alt and isVisible(e, alt) then
                            p = alt
                            break
                        end
                    end
                end
                if p then
                    best, bestD = { entity = e, part = p }, d
                end
            end
        end
    end
    return best
end

local function finite(v)
    return typeof(v) == "Vector3" and v.X == v.X and v.Y == v.Y and v.Z == v.Z
        and math.abs(v.X) < 1e6 and math.abs(v.Y) < 1e6 and math.abs(v.Z) < 1e6
end

local function pickTarget()
    local A = config.Aim
    local t = state.Target
    if not stillValid(t, Aim.origin2D()) then
        t = Aim.selectTarget()
    end
    if not t or (A.HitChance < 100 and math.random() * 100 >= A.HitChance) then
        return nil
    end
    return t
end

local function redirect(cf)
    local t = pickTarget()
    if not t then
        return nil
    end
    local aimPoint = t.part.Position
    if not finite(aimPoint) or (aimPoint - cf.Position).Magnitude < 0.5 then
        return nil
    end
    return CFrame.lookAt(cf.Position, aimPoint, cf.UpVector)
end

-- fireOnce reads Workspace.CurrentCamera.CFrame once per shot and builds every bullet from it;
-- only that read gets the aimed CFrame, so the real camera never moves.
local function isShotRead()
    for level = 3, 4 do
        if debug.info(level, "n") == config.Native.ShotFunction then
            return true
        end
    end
    return false
end

function Aim.install()
    if Installed or type(hookmetamethod) ~= "function" then
        state.Errors.install = { message = "hookmetamethod unavailable", at = os.clock() }
        return false
    end
    Installed = true
    local shotKey = "CFrame"
    OriginalIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        local value = OriginalIndex(self, key)
        if key == shotKey and state.Loaded and config.Aim.Enabled and not checkcaller()
            and self == Camera and isShotRead() then
            state.Stats.Shots = state.Stats.Shots + 1
            local ok, out = pcall(redirect, value)
            if ok and out then
                state.Stats.Redirected = state.Stats.Redirected + 1
                state.LastRedirectAt = os.clock()
                return out
            elseif not ok then
                state.Errors.silentAim = { message = tostring(out), at = os.clock() }
            end
        end
        return value
    end))
    return true
end

-- The __index hook can't be removed safely; it goes inert once state.Loaded is false.
function Aim.cleanup() end

return Aim

local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local entities = require("@modules/entities")

local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera

local Aim = {}

local BulletController = nil
local OriginalDischarge = nil
local Wrapper = nil
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

-- Body part of a hitbox rig; prefers the queryable "<name>HitZone" child the game's shot trace hits.
local function part(model, name)
    local p = model:FindFirstChild(name)
    if not (p and p:IsA("BasePart")) then
        return nil
    end
    local zone = p:FindFirstChild(name .. config.Native.HitZoneSuffix)
    return zone and zone:IsA("BasePart") and zone or p
end

Aim.part = part

local function isVisible(e, p, origin)
    if not config.Aim.VisibleCheck then
        return true
    end
    if RayParamsGen ~= state.EntitiesGen then
        RayParams = entities.rayParams()
        RayParamsGen = state.EntitiesGen
    end
    origin = origin or Camera.CFrame.Position
    local hit = workspace:Raycast(origin, p.Position - origin, RayParams)
    return hit == nil or entities.ownerOf(hit.Instance) == e.player.UserId
end

local function pickPart(model, center)
    local A = config.Aim
    if A.TargetPart ~= "Closest" then
        local p = part(model, A.TargetPart) or part(model, "UpperTorso")
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
    return entities.alive(e)
        and entities.fresh(e, os.clock())
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

-- Discharge traces from the muzzle when it is clear of the eye line, so aim from there.
local function redirect(eye, muzzle)
    local t = pickTarget()
    if not t then
        return nil
    end
    local aimPoint = t.part.Position
    local origin = (typeof(muzzle) == "CFrame" and finite(muzzle.Position) and (muzzle.Position - eye).Magnitude < 10) and muzzle.Position or eye
    local offset = aimPoint - origin
    if not finite(aimPoint) or offset.Magnitude < 0.5 then
        return nil
    end
    return offset.Unit
end

function Aim.install()
    local mod = entities.findPath(services.ReplicatedStorage, config.Native.BulletControllerPath)
    local ok, bc = false, nil
    if mod and mod:IsA("ModuleScript") then
        ok, bc = pcall(require, mod)
    end
    if not (ok and type(bc) == "table" and type(bc.Discharge) == "function") or table.isfrozen(bc) then
        state.Errors.install = { message = "BulletController.Discharge not found", at = os.clock() }
        return false
    end
    BulletController = bc
    OriginalDischarge = bc.Discharge
    Wrapper = function(self, weaponId, eye, direction, muzzle, ...)
        if state.Loaded and config.Aim.Enabled and typeof(eye) == "Vector3" and typeof(direction) == "Vector3" then
            state.Stats.Shots = state.Stats.Shots + 1
            local good, out = pcall(redirect, eye, muzzle)
            if good and out then
                state.Stats.Redirected = state.Stats.Redirected + 1
                state.LastRedirectAt = os.clock()
                direction = out * math.max(direction.Magnitude, 1e-3)
            elseif not good then
                state.Errors.silentAim = { message = tostring(out), at = os.clock() }
            end
        end
        return OriginalDischarge(self, weaponId, eye, direction, muzzle, ...)
    end
    bc.Discharge = Wrapper

    if type(bc.HitConfirmed) == "table" and type(bc.HitConfirmed.Connect) == "function" then
        state.connect(bc.HitConfirmed, function()
            state.Stats.Hits = state.Stats.Hits + 1
            local key = os.clock() - state.LastRedirectAt < 0.6 and "HitsRedirected" or "HitsNormal"
            state.Stats[key] = state.Stats[key] + 1
        end)
    end
    return true
end

function Aim.cleanup()
    if BulletController and BulletController.Discharge == Wrapper then
        BulletController.Discharge = OriginalDischarge
    end
end

return Aim

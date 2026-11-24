local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local entities = require("@modules/entities")

local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera

local Aim = {}

local VR = nil
local OriginalFrame = nil
local Wrapper = nil
local OriginalOn = nil
local OnWrapper = nil
local Ballistics = nil
local ViewmodelModule = nil
local SniperPending = nil
local SniperUsedAt = -math.huge
local RayParams = entities.rayParams()
local RayParamsGen = -1

local function findPath(root, path)
    local node = root
    for _, name in ipairs(path) do
        node = node and node:FindFirstChild(name)
    end
    return node
end

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

local function isVisible(model, p)
    if not config.Aim.VisibleCheck then
        return true
    end
    if RayParamsGen ~= state.EntitiesGen then
        RayParams = entities.rayParams()
        RayParamsGen = state.EntitiesGen
    end
    local origin = Camera.CFrame.Position
    local hit = workspace:Raycast(origin, p.Position - origin, RayParams)
    return hit == nil or hit.Instance:IsDescendantOf(model)
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
    return screenDistance(t.part.Position, center) <= config.Aim.FovRadius and isVisible(t.entity.model, t.part)
        and (t.part.Name == config.Aim.TargetPart or config.Aim.TargetPart == "Closest" or not isVisible(t.entity.model, part(t.entity.model, config.Aim.TargetPart) or t.part))
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
                if not isVisible(e.model, p) then
                    p = nil
                    for _, name in ipairs(A.ClosestParts) do
                        local alt = part(e.model, name)
                        if alt and isVisible(e.model, alt) then
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

local function redirectFrame(cf, t)
    t = t or pickTarget()
    if not t then
        return nil
    end
    local aimPoint = t.part.Position
    if not finite(aimPoint) or (aimPoint - cf.Position).Magnitude < 0.5 then
        return nil
    end
    return CFrame.lookAt(cf.Position, aimPoint, cf.UpVector)
end

local function sniperBallistics()
    local B = Ballistics
    local ch = services.Players.LocalPlayer.Character
    local tool = ch and ch:FindFirstChildOfClass("Tool")
    if not (B and tool and tonumber(B.RIFLE_SPEED) and type(B.RIFLE_ARC) == "table" and tonumber(B.ZERO)) then
        return nil
    end
    local gs = tool:GetAttribute("GsVelocity")
    return B.RIFLE_SPEED * (type(gs) == "number" and gs or 1), B.RIFLE_ARC, B.ZERO
end

local function dropAt(dist, speed, arc)
    local u = Ballistics.launch(Vector3.zero, Vector3.new(dist, 0, 0), speed, arc)
    if not finite(u) or u.X <= 1e-4 then
        return 0
    end
    return dist * u.Y / u.X
end

local function redirectSniper(cf, t)
    local speed, arc, zero = sniperBallistics()
    if not speed then
        return redirectFrame(cf, t)
    end
    local origin = cf.Position
    local target = t.part.Position
    if config.Aim.Prediction then
        local vel = t.part.AssemblyLinearVelocity
        if finite(vel) and vel.Magnitude < 200 then
            for _ = 1, 3 do
                local ok, time = pcall(Ballistics.flightTime, (target - origin).Magnitude, speed, arc)
                if not ok or type(time) ~= "number" or time ~= time or time > 5 then
                    break
                end
                target = t.part.Position + vel * time
            end
        end
    end
    local offset = target - origin
    local dist = offset.Magnitude
    if not finite(target) or dist < 0.5 then
        return nil
    end
    local up = Vector3.yAxis
    local current = ViewmodelModule and ViewmodelModule.current
    local aimAlpha = type(current) == "table" and tonumber(current.aimAlpha) or 1
    local muzzle = type(current) == "table" and current.muzzleWorld
    local look
    if aimAlpha < config.Native.SniperScopedAlpha and finite(muzzle) and (muzzle - origin).Magnitude < 10 then
        local fromMuzzle = target - muzzle
        local launchDir = (fromMuzzle + up * dropAt(fromMuzzle.Magnitude, speed, arc)).Unit
        local through = muzzle + launchDir * zero - up * dropAt(zero, speed, arc)
        look = (through - origin).Unit
    else
        local launchDir = (offset + up * dropAt(dist, speed, arc)).Unit
        look = (launchDir * zero - up * dropAt(zero, speed, arc)).Unit
    end
    if not finite(look) then
        return nil
    end
    return CFrame.lookAt(origin, origin + look, cf.UpVector)
end

local function isSniperShot(level)
    local src, name = debug.info(level, "sn")
    return name == config.Native.ShotFunction and type(src) == "string" and src:find(config.Native.SniperScript, 1, true) ~= nil
end

function Aim.install()
    local mod = findPath(services.ReplicatedStorage, config.Native.VRPath)
    local ok, vr = false, nil
    if mod and mod:IsA("ModuleScript") then
        ok, vr = pcall(require, mod)
    end
    if not (ok and type(vr) == "table" and type(vr.frame) == "function") then
        state.Errors.install = { message = "VR.frame not found", at = os.clock() }
        return false
    end
    VR = vr
    OriginalFrame = vr.frame
    local shotName = config.Native.ShotFunction
    Wrapper = function(cam, ...)
        local cf = OriginalFrame(cam, ...)
        if state.Loaded and config.Aim.Enabled and typeof(cf) == "CFrame" and debug.info(2, "n") == shotName then
            state.Stats.Shots = state.Stats.Shots + 1
            local sniperTarget = SniperPending
            SniperPending = nil
            local good, out
            if sniperTarget then
                good, out = pcall(redirectSniper, cf, sniperTarget)
            else
                good, out = pcall(redirectFrame, cf)
            end
            if good and out then
                state.Stats.Redirected = state.Stats.Redirected + 1
                state.LastRedirectAt = os.clock()
                return out
            elseif not good then
                state.Errors.silentAim = { message = tostring(out), at = os.clock() }
            end
        end
        return cf
    end
    vr.frame = Wrapper

    Ballistics = nil
    local bmod = findPath(services.ReplicatedStorage, config.Native.BallisticsPath)
    if bmod and bmod:IsA("ModuleScript") then
        local bok, b = pcall(require, bmod)
        if bok and type(b) == "table" and type(b.launch) == "function" and type(b.flightTime) == "function" then
            Ballistics = b
        end
    end
    local vmod = findPath(services.ReplicatedStorage, config.Native.ViewmodelPath)
    if vmod and vmod:IsA("ModuleScript") then
        local vok, vm = pcall(require, vmod)
        ViewmodelModule = vok and type(vm) == "table" and vm or nil
    end
    if type(vr.on) == "function" then
        OriginalOn = vr.on
        OnWrapper = function(...)
            local real = OriginalOn(...)
            if real or not (state.Loaded and config.Aim.Enabled) then
                return real
            end
            if os.clock() - SniperUsedAt > 0.1 and isSniperShot(3) then
                state.Stats.SniperShots = state.Stats.SniperShots + 1
                local ok, t = pcall(pickTarget)
                if not ok then
                    state.Errors.sniper = { message = tostring(t), at = os.clock() }
                elseif not t then
                    state.Stats.SniperNoTarget = state.Stats.SniperNoTarget + 1
                end
                if ok and t then
                    SniperPending = t
                    SniperUsedAt = os.clock()
                    return true
                end
            end
            return real
        end
        vr.on = OnWrapper
    end

    local confirm = findPath(services.ReplicatedStorage, config.Native.HitConfirmPath)
    if confirm and confirm:IsA("RemoteEvent") then
        state.connect(confirm.OnClientEvent, function()
            state.Stats.Hits = state.Stats.Hits + 1
            local key = os.clock() - state.LastRedirectAt < 0.6 and "HitsRedirected" or "HitsNormal"
            state.Stats[key] = state.Stats[key] + 1
        end)
    end
    return true
end

function Aim.cleanup()
    if VR and VR.frame == Wrapper then
        VR.frame = OriginalFrame
    end
    if VR and OnWrapper and VR.on == OnWrapper then
        VR.on = OriginalOn
    end
end

return Aim

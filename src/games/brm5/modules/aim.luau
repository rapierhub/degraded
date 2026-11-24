local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local ballistics = require("@core/ballistics")
local native = require("@modules/native")
local entities = require("@modules/entities")

local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera

local Aim = {}

local Installed = false
local OriginalDischarge = nil
local OriginalMuzzle = nil
local DischargeWrapper = nil
local MuzzleWrapper = nil
local Firing = nil

local RayParams = nil
local RayParamsGen = -1
local Tracks = setmetatable({}, { __mode = "k" })

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

local function isVisible(e, p, origin)
    if not config.Aim.VisibleCheck then
        return true
    end
    if RayParams == nil or RayParamsGen ~= state.EntitiesGen then
        RayParams = entities.rayParams()
        RayParamsGen = state.EntitiesGen
    end
    origin = origin or Camera.CFrame.Position
    local hit = workspace:Raycast(origin, p.Position - origin, RayParams)
    return hit == nil or entities.ownerOf(hit.Instance) == e.uid
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
    return A.Kinds[e.kind] == true
        and entities.alive(e)
        and not (A.TeamCheck and entities.isTeammate(e))
        and not (A.SkipPassive and entities.passive(e))
end

local function stillValid(t, center)
    if not t or not t.part.Parent or not eligible(t.entity) or entities.loaded(t.entity) == nil then
        return false
    end
    if (t.part.Position - Camera.CFrame.Position).Magnitude > config.Aim.MaxDistance then
        return false
    end
    return screenDistance(t.part.Position, center) <= config.Aim.FovRadius and isVisible(t.entity, t.part)
end

function Aim.selectTarget()
    local A = config.Aim
    local center = Aim.origin2D()
    local camPos = Camera.CFrame.Position
    local best, bestD = nil, math.huge
    for _, e in ipairs(state.Entities) do
        local model = eligible(e) and entities.loaded(e)
        if model then
            local p, d = pickPart(model, center)
            if p and d <= A.FovRadius and d < bestD and (p.Position - camPos).Magnitude <= A.MaxDistance then
                if not isVisible(e, p) then
                    p = nil
                    for _, name in ipairs(A.ClosestParts) do
                        local alt = part(model, name)
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

function Aim.track(now)
    local t = state.Target
    if not t then
        return
    end
    local pos = entities.position(t.entity)
    if not pos then
        return
    end
    local track = Tracks[t.entity.actor]
    if not track then
        Tracks[t.entity.actor] = { pos = pos, at = now, velocity = Vector3.zero }
        return
    end
    local dt = now - track.at
    if dt < 0.05 then
        return
    end
    local raw = dt > 0.5 and Vector3.zero or (pos - track.pos) / dt
    if raw.Magnitude > config.Aim.MaxTargetSpeed then
        raw = Vector3.zero
    end
    track.velocity = track.velocity:Lerp(raw, 0.5)
    track.pos = pos
    track.at = now
end

local function targetVelocity(e, now)
    local track = Tracks[e.actor]
    if not (config.Aim.Prediction and track) or now - track.at > 0.5 then
        return Vector3.zero
    end
    return track.velocity
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

local function redirect(firearm, muzzle)
    local bullets = native.Bullets
    local tune = type(firearm._firearm) == "table" and firearm._firearm.Tune
    if not (bullets and type(tune) == "table") then
        return nil
    end
    local velocity, _, range = bullets:GetInfo(tune.Caliber, tune.Barrel)
    if not (ballistics.finite(velocity) and velocity > 1) then
        return nil
    end
    local t = pickTarget()
    if not t then
        return nil
    end
    local origin = muzzle.Position
    local aimPoint = t.part.Position
    if not (entities.finiteVector(origin) and entities.finiteVector(aimPoint)) then
        return nil
    end
    local distance = (aimPoint - origin).Magnitude
    if distance < 0.5 or (ballistics.finite(range) and range > 0 and distance > range) then
        return nil
    end
    if not isVisible(t.entity, t.part, origin) then
        return nil
    end
    local v = targetVelocity(t.entity, os.clock())
    local gravity = config.Native.Gravity
    local pitch, yaw = ballistics.solve(origin.X, origin.Y, origin.Z, aimPoint.X, aimPoint.Y, aimPoint.Z, v.X, v.Y, v.Z, velocity, gravity, 3)
    if not pitch then
        return nil
    end
    local actor = firearm._actor
    local viewModel = type(actor) == "table" and actor.ADS and actor.ViewModel
    local zero = type(viewModel) == "table" and viewModel.Zero
    if type(zero) == "table" then
        zero = zero[4]
    end
    if ballistics.finite(zero) then
        pitch = pitch - ballistics.zeroAngle(zero, velocity, gravity)
    end
    return CFrame.new(origin) * CFrame.fromOrientation(pitch, yaw, 0)
end

function Aim.install()
    local firearm = native.Firearm
    if Installed or not firearm then
        return Installed
    end
    OriginalDischarge = firearm.Discharge
    OriginalMuzzle = firearm.GetMuzzleCFrame
    DischargeWrapper = function(self, ...)
        local previous = Firing
        Firing = self
        local result = table.pack(pcall(OriginalDischarge, self, ...))
        Firing = previous
        if not result[1] then
            error(result[2], 0)
        end
        return table.unpack(result, 2, result.n)
    end
    MuzzleWrapper = function(self, ...)
        local result = table.pack(OriginalMuzzle(self, ...))
        if Firing == self and state.Loaded and config.Aim.Enabled and typeof(result[1]) == "CFrame" then
            state.Stats.Shots = state.Stats.Shots + 1
            local ok, out = pcall(redirect, self, result[1])
            if ok and out then
                state.Stats.Redirected = state.Stats.Redirected + 1
                state.LastRedirectAt = os.clock()
                result[1] = out
            elseif not ok then
                state.Errors.silentAim = { message = tostring(out), at = os.clock() }
            end
        end
        return table.unpack(result, 1, result.n)
    end
    firearm.Discharge = DischargeWrapper
    firearm.GetMuzzleCFrame = MuzzleWrapper
    Installed = true
    return true
end

function Aim.cleanup()
    local firearm = native.Firearm
    if not (Installed and firearm) then
        return
    end
    if firearm.Discharge == DischargeWrapper then
        firearm.Discharge = OriginalDischarge
    end
    if firearm.GetMuzzleCFrame == MuzzleWrapper then
        firearm.GetMuzzleCFrame = OriginalMuzzle
    end
    Installed = false
end

return Aim

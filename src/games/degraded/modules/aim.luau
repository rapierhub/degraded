local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local utility = require("@core/utility")
local ballistics = require("@core/ballistics")
local entities = require("@modules/entities")

local LocalPlayer = services.Players.LocalPlayer
local UserInputService = services.UserInputService
local Camera = workspace.CurrentCamera
local GameShared = getrenv().shared
local DoubleBarrelRemotes = services.ReplicatedStorage:FindFirstChild("DoubleBarrelRemotes")

local up, findUpvalue = utility.up, utility.findUpvalue
local finiteVec = ballistics.finiteVec

local Aim = {}

local suitCache = setmetatable({}, { __mode = "k" })

local function bodyPart(model, name)
    local p = model:FindFirstChild(name)
    if p and p:IsA("BasePart") then
        return p
    end
    local suit = model:FindFirstChild("Suit_" .. name)
    if not suit then
        return nil
    end
    if suit:IsA("BasePart") then
        return suit
    end
    local cached = suitCache[suit]
    if cached and cached.Parent and cached:IsDescendantOf(suit) then
        return cached
    end
    local best = utility.largestPart(suit)
    suitCache[suit] = best
    return best
end

Aim.bodyPart = bodyPart

local function fallbackPart(model)
    return bodyPart(model, "HumanoidRootPart") or model.PrimaryPart or utility.largestPart(model)
end

function Aim.origin2D()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        return Camera.ViewportSize / 2
    end
    return UserInputService:GetMouseLocation()
end

local function screenDistance(worldPos, center)
    local sp, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen or sp.Z <= 0 then
        return math.huge
    end
    return (Vector2.new(sp.X, sp.Y) - center).Magnitude
end

local function isVisible(model, part)
    if not config.Aim.VisibleCheck then
        return true
    end
    local origin = Camera.CFrame.Position
    local hit = workspace:Raycast(origin, part.Position - origin, entities.aimRay)
    return hit == nil or hit.Instance:IsDescendantOf(model)
end

local function pickPart(model, center)
    local mode = config.Aim.TargetPart
    if mode ~= "Closest" then
        local p = bodyPart(model, mode) or fallbackPart(model)
        if p then
            return p, screenDistance(p.Position, center)
        end
        return nil, math.huge
    end
    local best, bestD = nil, math.huge
    for _, name in ipairs(config.Aim.ClosestParts) do
        local p = bodyPart(model, name)
        if p then
            local d = screenDistance(p.Position, center)
            if d < bestD then
                best, bestD = p, d
            end
        end
    end
    if not best then
        best = fallbackPart(model)
        bestD = best and screenDistance(best.Position, center) or math.huge
    end
    return best, bestD
end

local function targetStillValid(t, center)
    if not t or not t.model.Parent or not t.part.Parent or t.humanoid.Health <= 0 then
        return false
    end
    if (t.part.Position - Camera.CFrame.Position).Magnitude > config.Aim.MaxDistance then
        return false
    end
    if screenDistance(t.part.Position, center) > config.Aim.FovRadius then
        return false
    end
    return isVisible(t.model, t.part)
end

function Aim.selectTarget()
    entities.refresh(os.clock())
    local A = config.Aim
    local center = Aim.origin2D()
    if A.StickyTarget and targetStillValid(state.Target, center) then
        return state.Target
    end
    local camPos = Camera.CFrame.Position
    local best, bestD = nil, math.huge
    for _, e in ipairs(state.Entities) do
        if A.Kinds[e.kind] and entities.alive(e) and not e.model:IsDescendantOf(Camera) then
            local part, d = pickPart(e.model, center)
            if part and d <= A.FovRadius and d < bestD
                and (part.Position - camPos).Magnitude <= A.MaxDistance
                and isVisible(e.model, part) then
                best, bestD = { model = e.model, part = part, humanoid = e.humanoid }, d
            end
        end
    end
    return best
end

local function findShotCaller()
    local N = config.Native
    for level = N.StackScanFrom, N.StackScanTo do
        local src, name, fn = debug.info(level, "snf")
        if src == nil then
            break
        end
        if name == N.FirearmsShotName and src:find(N.FirearmsSource, 1, true) then
            return "firearms", fn
        elseif name == N.DoubleBarrelShotName and src:find(N.DoubleBarrelSource, 1, true) then
            return "doublebarrel", fn
        end
    end
    return nil
end

local function isFirearmBallistics(v)
    return type(v) == "table" and type(v.speed) == "number" and type(v.gravity) == "number"
end

function Aim.isToolHolder(v)
    return type(v) == "table" and typeof(rawget(v, "tool")) == "Instance"
end

function Aim.doubleBarrelShell(fn, tool)
    local shellStats = up(fn, config.Native.DoubleBarrelShellStatsUpvalue)
    if type(shellStats) ~= "function" or not tool then
        return nil
    end
    local ammo = tool:GetAttribute("LoadedType") or tool:GetAttribute("AmmoType") or "Buckshot"
    local ok, shell = pcall(shellStats, ammo)
    if ok and type(shell) == "table" and tonumber(shell.speed) then
        return shell
    end
    return nil
end

function Aim.doubleBarrelGravity()
    return (DoubleBarrelRemotes and DoubleBarrelRemotes:GetAttribute("Gravity")) or config.Native.DoubleBarrelDefaultGravity
end

local function gunBallistics(kind, fn)
    local N = config.Native
    if kind == "firearms" then
        local s = findUpvalue(fn, N.FirearmsStatsUpvalue, isFirearmBallistics)
        if s then
            return s.speed, s.gravity, tostring(s.id or "?")
        end
        return N.FirearmsDefaultSpeed, N.FirearmsDefaultGravity, "?"
    end
    local holder = findUpvalue(fn, nil, Aim.isToolHolder)
    local tool = (holder and holder.tool) or utility.equippedTool()
    local shell = Aim.doubleBarrelShell(fn, tool)
    return shell and shell.speed or N.DoubleBarrelDefaultSpeed, Aim.doubleBarrelGravity(), "DoubleBarrel"
end

local function recordShot(entry)
    table.insert(state.Shots, entry)
    if #state.Shots > 32 then
        table.remove(state.Shots, 1)
    end
end

local function redirectShot(base, kind, fn)
    local A = config.Aim
    local center = Aim.origin2D()
    local t = state.Target
    if not targetStillValid(t, center) then
        t = Aim.selectTarget()
    end
    if not t or (A.HitChance < 100 and math.random() * 100 >= A.HitChance) then
        return nil
    end

    local origin = base.Position
    local aimPoint = t.part.Position
    local speed, gravity, weaponId = gunBallistics(kind, fn)
    local flight = 0
    if A.Prediction then
        local vel = t.part.AssemblyLinearVelocity
        if not finiteVec(vel) or vel.Magnitude > 300 then
            vel = Vector3.zero
        end
        aimPoint, flight = ballistics.solveBallistic(origin, t.part.Position, vel, speed, gravity, 5)
    end

    if not finiteVec(aimPoint) or (aimPoint - origin).Magnitude < 1e-3 then
        return nil
    end
    local out = CFrame.lookAt(origin, aimPoint, base.UpVector)

    recordShot({
        at = os.clock(),
        kind = kind,
        weapon = weaponId,
        target = t.model.Name,
        part = t.part.Name,
        dist = (t.part.Position - origin).Magnitude,
        speed = speed,
        gravity = gravity,
        flight = flight,
        angle = math.deg(math.acos(math.clamp(base.LookVector:Dot(out.LookVector), -1, 1))),
    })
    return out
end

local function makeWrapper(original)
    return function(viewCF, ...)
        local base = viewCF
        if type(original) == "function" then
            local ok, r = pcall(original, viewCF, ...)
            if ok and typeof(r) == "CFrame" then
                base = r
            end
        end
        if typeof(base) ~= "CFrame" or not config.Aim.Enabled then
            return base
        end
        local kind, fn = findShotCaller()
        if not kind then
            return base
        end
        state.Stats.Calls = state.Stats.Calls + 1
        local ok, out = pcall(redirectShot, base, kind, fn)
        if ok and out then
            state.Stats.Redirected = state.Stats.Redirected + 1
            return out
        end
        if not ok then
            state.Errors.silentAim = { message = tostring(out), at = os.clock() }
        end
        state.Stats.Skipped = state.Stats.Skipped + 1
        return base
    end
end

function Aim.installWrapper()
    local current = GameShared.HeldViewCFrame
    if state.Wrapper ~= nil and current == state.Wrapper then
        return
    end
    state.OriginalHeld = current
    state.Wrapper = makeWrapper(current)
    GameShared.HeldViewCFrame = state.Wrapper
end

function Aim.cleanup()
    if GameShared.HeldViewCFrame == state.Wrapper then
        GameShared.HeldViewCFrame = state.OriginalHeld
    end
end

return Aim

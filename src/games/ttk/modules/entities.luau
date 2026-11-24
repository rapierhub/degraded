local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")

local Players = services.Players
local LocalPlayer = Players.LocalPlayer

local Entities = {}

local FriendlyFire = nil
local HeadTrack = setmetatable({}, { __mode = "k" })

local function findPath(root, path)
    local node = root
    for _, name in ipairs(path) do
        node = node and node:FindFirstChild(name)
    end
    return node
end

Entities.findPath = findPath

local function friendlyFire()
    if FriendlyFire == nil then
        local mod = findPath(services.ReplicatedStorage, config.Native.FriendlyFirePath)
        local ok, ff = false, nil
        if mod and mod:IsA("ModuleScript") then
            ok, ff = pcall(require, mod)
        end
        FriendlyFire = (ok and type(ff) == "table" and type(ff.Affects) == "function") and ff or false
    end
    return FriendlyFire or nil
end

-- Players are drawn and hit through rigs in workspace.MercPlayers; the character
-- under workspace only carries the Humanoid (health) and HumanoidRootPart.
function Entities.refresh(now)
    if now - state.EntitiesAt < config.Perf.EntityInterval then
        return
    end
    state.EntitiesAt = now
    local folder = workspace:FindFirstChild(config.Native.HitboxFolder)
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local ch = p ~= LocalPlayer and p.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        local rig = h and folder and folder:FindFirstChild(config.Native.HitboxPrefix .. p.Name)
        if rig and rig:IsA("Model") then
            table.insert(list, { model = rig, character = ch, humanoid = h, kind = "Player", label = p.DisplayName, player = p })
        end
    end
    state.Entities = list
    state.EntitiesGen = state.EntitiesGen + 1
end

function Entities.isTeammate(e)
    local ff = friendlyFire()
    if not ff then
        return false
    end
    local ok, affects = pcall(ff.Affects, "Damage", LocalPlayer, e.player)
    return ok and affects == false
end

-- Damage is custom: a killed player's rig gets Dead/Ragdolled while their Humanoid can still read full health.
function Entities.alive(e)
    local rig = e.model
    if rig.Parent == nil or e.character.Parent == nil or e.humanoid.Parent ~= e.character or e.humanoid.Health <= 0 then
        return false
    end
    return rig:GetAttribute("Dead") ~= true and rig:GetAttribute("Ragdolled") ~= true and e.player:GetAttribute("InWorld") ~= false
end

-- False when the rig isn't being updated (out of replication range / fog of war): either it has
-- drifted away from the character root, or its head hasn't moved at all for StaleSeconds.
function Entities.fresh(e, now)
    local head = e.model:FindFirstChild("Head")
    local root = e.character:FindFirstChild("HumanoidRootPart")
    if not (head and head:IsA("BasePart")) then
        return false
    end
    if root and root:IsA("BasePart") and (head.Position - root.Position).Magnitude > config.Esp.MaxRigDrift then
        return false
    end
    local track = HeadTrack[e.model]
    if not track then
        track = { cf = nil, movedAt = now }
        HeadTrack[e.model] = track
    end
    local cf = head.CFrame
    if track.cf ~= cf then
        track.cf = cf
        track.movedAt = now
    end
    return now - track.movedAt <= config.Esp.StaleSeconds
end

function Entities.protected(e)
    return e.player:GetAttribute("SpawnProtected") == true or e.player:GetAttribute("Godmode") == true
end

function Entities.heldItem(e)
    local w = e.player:GetAttribute("CurrentWeapon")
    return type(w) == "string" and w ~= "" and w or nil
end

-- Owner of a hit instance, as the game resolves it (OwnerUserId on the part or its model).
function Entities.ownerOf(inst)
    local id = inst:GetAttribute("OwnerUserId")
    if typeof(id) == "number" then
        return id
    end
    local m = inst:FindFirstAncestorOfClass("Model")
    id = m and m:GetAttribute("OwnerUserId")
    return typeof(id) == "number" and id or nil
end

function Entities.rayParams()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local ignore = { workspace.CurrentCamera }
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            table.insert(ignore, p.Character)
        end
    end
    local folder = workspace:FindFirstChild(config.Native.HitboxFolder)
    if folder then
        for _, prefix in ipairs({ config.Native.HitboxPrefix, config.Native.VisualPrefix }) do
            local own = folder:FindFirstChild(prefix .. LocalPlayer.Name)
            if own then
                table.insert(ignore, own)
            end
        end
    end
    for _, name in ipairs(config.RayIgnoreFolders) do
        local f = workspace:FindFirstChild(name)
        if f then
            table.insert(ignore, f)
        end
    end
    local map = workspace:FindFirstChild("ActiveMap")
    for _, name in ipairs({ "Touchables", "Ignore" }) do
        local f = map and map:FindFirstChild(name)
        if f then
            table.insert(ignore, f)
        end
    end
    params.FilterDescendantsInstances = ignore
    return params
end

return Entities

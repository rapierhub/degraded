local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")

local Players = services.Players
local LocalPlayer = Players.LocalPlayer

local Entities = {}

local function add(list, model, kind, label, player)
    local h = model:FindFirstChildOfClass("Humanoid")
    if h and model:FindFirstChild("HumanoidRootPart") then
        table.insert(list, { model = model, character = model, humanoid = h, kind = kind, label = label, player = player })
    end
end

function Entities.refresh(now)
    if now - state.EntitiesAt < config.Perf.EntityInterval then
        return
    end
    state.EntitiesAt = now
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            add(list, p.Character, "Player", p.DisplayName, p)
        end
    end
    local bots = workspace:FindFirstChild(config.Native.HitboxFolder)
    if bots then
        for _, m in ipairs(bots:GetChildren()) do
            if m:IsA("Model") then
                local name = m:GetAttribute("DisplayName")
                add(list, m, "Bot", type(name) == "string" and name or m.Name)
            end
        end
    end
    state.Entities = list
    state.EntitiesGen = state.EntitiesGen + 1
end

local function teamOf(e)
    if e.player then
        return e.player.Team and e.player.Team.Name or nil
    end
    local t = e.model:GetAttribute("Team")
    return type(t) == "string" and t or nil
end

function Entities.isTeammate(e)
    local mine = LocalPlayer.Team and LocalPlayer.Team.Name
    return mine ~= nil and teamOf(e) == mine
end

function Entities.alive(e)
    if e.model.Parent == nil or e.humanoid.Parent ~= e.model or e.humanoid.Health <= 0 then
        return false
    end
    local zone = e.model:GetAttribute("Zone")
    return zone == nil or zone == config.Native.ArenaZone
end

-- Characters are fully replicated here; nothing goes stale the way TTK's rigs do.
function Entities.fresh()
    return true
end

function Entities.protected(e)
    return e.model:FindFirstChildOfClass("ForceField") ~= nil
end

function Entities.heldItem(e)
    local w = e.model:GetAttribute("Weapon")
    return type(w) == "string" and w ~= "" and w or nil
end

function Entities.ownerModel(inst)
    local m = inst:FindFirstAncestorOfClass("Model")
    while m and m.Parent ~= workspace and m.Parent ~= workspace:FindFirstChild(config.Native.HitboxFolder) do
        m = m:FindFirstAncestorOfClass("Model")
    end
    return m
end

function Entities.rayParams()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local ignore = { workspace.CurrentCamera }
    if LocalPlayer.Character then
        table.insert(ignore, LocalPlayer.Character)
    end
    for _, name in ipairs(config.RayIgnoreFolders) do
        local f = workspace:FindFirstChild(name)
        if f then
            table.insert(ignore, f)
        end
    end
    params.FilterDescendantsInstances = ignore
    return params
end

return Entities

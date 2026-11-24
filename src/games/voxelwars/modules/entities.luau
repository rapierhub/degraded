local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")

local Players = services.Players
local LocalPlayer = Players.LocalPlayer

local Entities = {}

local function myTeamName()
    return LocalPlayer.Team and LocalPlayer.Team.Name or nil
end

function Entities.refresh(now)
    if now - state.EntitiesAt < config.Perf.EntityInterval then
        return
    end
    state.EntitiesAt = now
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local ch = p ~= LocalPlayer and p.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        if h then
            table.insert(list, { model = ch, humanoid = h, kind = "Player", label = p.DisplayName, player = p })
        end
    end
    local bots = workspace:FindFirstChild(config.Native.BotFolder)
    if bots then
        for _, m in ipairs(bots:GetChildren()) do
            local h = m:IsA("Model") and m:FindFirstChildOfClass("Humanoid")
            if h then
                table.insert(list, { model = m, humanoid = h, kind = "Bot", label = m.Name })
            end
        end
    end
    state.Entities = list
    state.EntitiesGen = state.EntitiesGen + 1
end

function Entities.teamOf(e)
    if e.player then
        return e.player.Team and e.player.Team.Name or nil
    end
    local t = e.model:GetAttribute("Team")
    return type(t) == "string" and t or nil
end

function Entities.isTeammate(e)
    local mine = myTeamName()
    return mine ~= nil and Entities.teamOf(e) == mine
end

function Entities.alive(e)
    if e.model.Parent == nil or e.humanoid.Parent ~= e.model or e.humanoid.Health <= 0 then
        return false
    end
    return e.model:GetAttribute("Alive") ~= false
end

function Entities.protected(e)
    return e.model:GetAttribute("Protected") == true
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

local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local utility = require("@core/utility")

local LocalPlayer = services.Players.LocalPlayer

local Entities = {}

local aimRay, refreshAimRay = utility.makeRayParams({ config.RayIgnoreFolders })
local markerRay, refreshMarkerRay = utility.makeRayParams({ config.RayIgnoreFolders, config.MarkerRayIgnoreExtra })
Entities.aimRay = aimRay
Entities.markerRay = markerRay

function Entities.refresh(now)
    if now - state.EntitiesAt < config.Perf.EntityInterval then
        return
    end
    state.EntitiesAt = now
    local list = {}
    for _, p in ipairs(services.Players:GetPlayers()) do
        local ch = p ~= LocalPlayer and p.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        if h then
            table.insert(list, { model = ch, humanoid = h, kind = "Player", label = p.DisplayName })
        end
    end
    for kind, folderName in pairs(config.NpcFolders) do
        local f = workspace:FindFirstChild(folderName)
        if f then
            for _, m in ipairs(f:GetChildren()) do
                local h = m:IsA("Model") and m:FindFirstChildOfClass("Humanoid")
                if h then
                    table.insert(list, { model = m, humanoid = h, kind = kind, label = m.Name })
                end
            end
        end
    end
    state.Entities = list
    state.EntitiesGen = state.EntitiesGen + 1
    refreshAimRay()
    refreshMarkerRay()
end

function Entities.alive(e)
    return e.model.Parent ~= nil and e.humanoid.Parent == e.model and e.humanoid.Health > 0
end

return Entities

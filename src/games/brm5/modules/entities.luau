local config = require("@core/config")
local state = require("@core/state")
local native = require("@modules/native")

local Entities = {}

local function finiteVector(v)
    return typeof(v) == "Vector3" and v.X == v.X and v.Y == v.Y and v.Z == v.Z
        and math.abs(v.X) < 1e6 and math.abs(v.Y) < 1e6 and math.abs(v.Z) < 1e6
end

Entities.finiteVector = finiteVector

function Entities.refresh(now)
    if now - state.EntitiesAt < config.Perf.EntityInterval then
        return
    end
    state.EntitiesAt = now
    local list = {}
    local rep = native.Replicator
    if rep then
        local localUid = rawget(rep, "_uid")
        local count = 0
        for uid, actor in pairs(rep.Actors) do
            count = count + 1
            if count > config.Perf.MaxActors then
                break
            end
            if type(actor) == "table" and type(uid) == "string" and uid ~= localUid and actor.IsLocalPlayer ~= true then
                local owner = actor.Owner
                local isPlayer = typeof(owner) == "Instance" and owner:IsA("Player")
                table.insert(list, {
                    actor = actor,
                    uid = uid,
                    kind = isPlayer and "Player" or "NPC",
                    label = isPlayer and owner.DisplayName or config.Native.NpcLabel,
                    player = isPlayer and owner or nil,
                })
            end
        end
    end
    state.Entities = list
    state.EntitiesGen = state.EntitiesGen + 1
end

function Entities.alive(e)
    local rep = native.Replicator
    return rep ~= nil and rep.Actors[e.uid] == e.actor and e.actor.Alive == true
end

function Entities.isTeammate(e)
    local service = native.Clients
    if not (service and e.player) then
        return false
    end
    local mine = service.LocalClient
    local theirs = service.Clients[e.player]
    local squad = type(mine) == "table" and mine.Squad
    return type(squad) == "string" and squad ~= "" and type(theirs) == "table" and theirs.Squad == squad
end

function Entities.position(e)
    local actor = e.actor
    local pos = actor.UseClient and actor.Position or actor.ServerPosition
    return finiteVector(pos) and pos or nil
end

function Entities.loaded(e)
    local model = e.actor.Character
    if typeof(model) == "Instance" and model:IsDescendantOf(workspace) then
        return model
    end
    return nil
end

function Entities.passive(e)
    local actor = e.actor
    if actor.Downed == true or actor._ziptiedHostage ~= nil then
        return true
    end
    local current = actor.CurrentState
    if type(current) == "table" and (current.Hostage or current.Emote == config.Native.SurrenderEmote) then
        return true
    end
    local model = actor.Character
    return typeof(model) == "Instance" and model:HasTag(config.Native.ProtectedTag)
end

function Entities.health(e)
    local hp = tonumber(e.actor.Health)
    return hp and hp == hp and hp or nil
end

function Entities.heldItem(e)
    local actor = e.actor
    local inventory, equipped = actor._inventory, actor._equipped
    local item = type(inventory) == "table" and equipped ~= nil and inventory[equipped]
    local firearm = type(item) == "table" and item._firearm
    local name = type(firearm) == "table" and firearm.Name
    if type(name) ~= "string" or name == "" then
        return nil
    end
    return (name:gsub(config.Native.NpcItemPrefix, ""))
end

function Entities.ownerOf(inst)
    local uid = inst:GetAttribute(config.Native.ActorAttribute)
    return type(uid) == "string" and uid or nil
end

function Entities.rayParams()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.CollisionGroup = config.Native.BulletCollisionGroup
    local ignore = { workspace.CurrentCamera }
    local rep = native.Replicator
    local localActor = rep and rep.LocalActor
    local character = type(localActor) == "table" and localActor.Character
    if typeof(character) == "Instance" then
        table.insert(ignore, character)
    end
    params.FilterDescendantsInstances = ignore
    return params
end

return Entities

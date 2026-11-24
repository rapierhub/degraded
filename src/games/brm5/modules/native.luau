local config = require("@core/config")
local state = require("@core/state")

local Native = {
    Replicator = nil,
    Bullets = nil,
    Firearm = nil,
    Controller = nil,
    Clients = nil,
    ResolvedAt = -math.huge,
}

local KEYS = { "Replicator", "Bullets", "Firearm", "Controller", "Clients" }

local function load(name, valid)
    for _, mod in ipairs(getloadedmodules()) do
        if mod.Name == name then
            local ok, value = pcall(require, mod)
            if ok and type(value) == "table" and valid(value) then
                return value
            end
        end
    end
    return nil
end

local function isReplicator(v)
    return type(rawget(v, "Actors")) == "table" and type(v.GetFromBodyPart) == "function"
end

local function isBullets(v)
    return type(v.GetInfo) == "function" and type(v.Discharge) == "function"
end

local function isFirearm(v)
    return type(rawget(v, "Discharge")) == "function" and type(rawget(v, "GetMuzzleCFrame")) == "function" and not table.isfrozen(v)
end

local function isController(v)
    return type(rawget(v, "Update")) == "function" and type(rawget(v, "_accelerate")) == "function" and not table.isfrozen(v)
end

local function isClients(v)
    return type(rawget(v, "Clients")) == "table"
end

function Native.complete()
    for _, key in ipairs(KEYS) do
        if not Native[key] then
            return false
        end
    end
    return true
end

function Native.aimReady()
    return Native.Replicator ~= nil and Native.Bullets ~= nil and Native.Firearm ~= nil
end

function Native.resolve(now)
    if Native.complete() or now - Native.ResolvedAt < config.Perf.ResolveInterval then
        return
    end
    Native.ResolvedAt = now
    local N = config.Native
    Native.Replicator = Native.Replicator or load(N.ReplicatorModule, isReplicator)
    Native.Bullets = Native.Bullets or load(N.BulletModule, isBullets)
    Native.Firearm = Native.Firearm or load(N.FirearmModule, isFirearm)
    Native.Controller = Native.Controller or load(N.ControllerModule, isController)
    Native.Clients = Native.Clients or load(N.ClientModule, isClients)
    local missing = {}
    for _, key in ipairs(KEYS) do
        if not Native[key] then
            table.insert(missing, key)
        end
    end
    state.Errors.native = #missing > 0 and { message = "unresolved: " .. table.concat(missing, ", "), at = now } or nil
end

return Native

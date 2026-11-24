local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local utility = require("@core/utility")

local up, findUpvalue = utility.up, utility.findUpvalue
local DoubleBarrelRemotes = services.ReplicatedStorage:FindFirstChild("DoubleBarrelRemotes")

local Patches = {}

local SavedFields = {}
local SavedAttrs = {}

local function setField(t, key, value)
    if type(t) ~= "table" or t[key] == nil then
        return
    end
    local s = SavedFields[t]
    if not s then
        s = {}
        SavedFields[t] = s
    end
    if s[key] == nil then
        s[key] = t[key]
    end
    if t[key] ~= value then
        t[key] = value
        state.Patched = state.Patched + 1
    end
end

local function restoreField(t, key)
    local s = SavedFields[t]
    if s and s[key] ~= nil then
        t[key] = s[key]
        s[key] = nil
    end
end

local function originalField(t, key)
    local s = SavedFields[t]
    if s and s[key] ~= nil then
        return s[key]
    end
    return t[key]
end

local function setAttr(inst, name, value)
    local saved = SavedAttrs[inst]
    if not saved then
        saved = {}
        SavedAttrs[inst] = saved
    end
    if not saved[name] then
        saved[name] = { value = inst:GetAttribute(name) }
    end
    if inst:GetAttribute(name) ~= value then
        inst:SetAttribute(name, value)
    end
end

local function restoreAttr(inst, name)
    local saved = SavedAttrs[inst]
    if saved and saved[name] then
        inst:SetAttribute(name, saved[name].value)
        saved[name] = nil
    end
end

function Patches.restoreAll()
    for t, fields in pairs(SavedFields) do
        for key, value in pairs(fields) do
            t[key] = value
        end
    end
    table.clear(SavedFields)
    for inst, names in pairs(SavedAttrs) do
        for name, saved in pairs(names) do
            pcall(inst.SetAttribute, inst, name, saved.value)
        end
    end
    table.clear(SavedAttrs)
end

local function isFaStats(v)
    return type(v) == "table" and type(v.hipSpread) == "number" and type(v.recoilMult) == "number"
end

local function isFaState(v)
    return type(v) == "table" and type(v.bloom) == "number" and v.lastShot ~= nil
end

local function isFaConfig(v)
    return type(v) == "table" and type(v.MoveSpreadHip) == "number" and type(v.AirSpread) == "number"
end

local function isDbConfig(v)
    return type(v) == "table" and type(v.CameraKick) == "number" and type(v.KickUp) == "number"
end

function Patches.scanClosures()
    local N = config.Native
    local fa, db = {}, {}
    for _, f in ipairs(getgc()) do
        if type(f) == "function" and islclosure(f) then
            local ok, name = pcall(debug.info, f, "n")
            if ok and (name == N.FirearmsShotName or name == N.DoubleBarrelShotName) then
                local src = debug.info(f, "s")
                if src then
                    if name == N.FirearmsShotName and src:find(N.FirearmsSource, 1, true) then
                        table.insert(fa, f)
                    elseif name == N.DoubleBarrelShotName and src:find(N.DoubleBarrelSource, 1, true) then
                        table.insert(db, f)
                    end
                end
            end
        end
    end

    local stats, states, configs = {}, {}, {}
    for _, f in ipairs(fa) do
        local s = findUpvalue(f, N.FirearmsStatsUpvalue, isFaStats)
        local st = findUpvalue(f, N.FirearmsStateUpvalue, isFaState)
        local c = findUpvalue(f, N.FirearmsConfigUpvalue, isFaConfig)
        if s then
            stats[s] = true
        end
        if st then
            states[st] = true
        end
        if c then
            configs[c] = true
        end
    end
    local dbConfigs, shellFns = {}, {}
    for _, f in ipairs(db) do
        local c = findUpvalue(f, N.DoubleBarrelConfigUpvalue, isDbConfig)
        if c then
            dbConfigs[c] = true
        end
        local ss = up(f, N.DoubleBarrelShellStatsUpvalue)
        if type(ss) == "function" and debug.info(ss, "n") == "shellStats" then
            shellFns[ss] = true
        end
    end

    state.FirearmsClosures, state.DoubleBarrelClosures = fa, db
    state.FaStats, state.FaStates, state.FaConfigs = stats, states, configs
    state.DbConfigs, state.DbShellFns = dbConfigs, shellFns
    state.LastScanAt = os.clock()
end

local CameraShake
pcall(function()
    CameraShake = require(services.ReplicatedStorage:WaitForChild("CameraShake", 5))
end)

local function noop() end

local FaSpreadZeroKeys = { "hipSpread", "adsSpread", "bloomPerShot" }
local FaRecoilKeys = { "recoilMult", "kick", "kickSide", "adsKick", "kickBack", "kickTilt", "recoilPitch", "recoilYaw" }
local FaConfigKeys = { "MoveSpreadHip", "MoveSpreadAds", "AirSpread", "AdsBloom" }
local DbRecoilKeys = { "CameraKick", "KickUp", "KickBack", "KickRoll" }

local function zeroOf(v)
    if typeof(v) == "Vector2" then
        return Vector2.zero
    elseif typeof(v) == "Vector3" then
        return Vector3.zero
    elseif type(v) == "number" then
        return 0
    end
    return nil
end

local function zeroKeys(t, keys, on)
    for _, k in ipairs(keys) do
        local z = on and zeroOf(originalField(t, k)) or nil
        if z ~= nil then
            setField(t, k, z)
        else
            restoreField(t, k)
        end
    end
end

local function doubleBarrelAmmoList()
    local list = table.clone(config.Native.DoubleBarrelAmmoTypes)
    local tool = utility.equippedTool()
    if tool then
        for _, attr in ipairs({ "LoadedType", "AmmoType" }) do
            local v = tool:GetAttribute(attr)
            if type(v) == "string" and not table.find(list, v) then
                table.insert(list, v)
            end
        end
    end
    return list
end

function Patches.apply()
    local spread = config.NoSpread.Enabled
    local recoil = config.NoRecoil.Enabled
    local mult = config.NoSpread.PelletSpreadMult

    for s in pairs(state.FaStats) do
        zeroKeys(s, FaSpreadZeroKeys, spread)
        local ps = originalField(s, "pelletSpread")
        if spread and type(ps) == "number" then
            setField(s, "pelletSpread", ps * mult)
        else
            restoreField(s, "pelletSpread")
        end
        zeroKeys(s, FaRecoilKeys, recoil)
    end
    for st in pairs(state.FaStates) do
        if spread then
            st.bloom = 0
        end
        if recoil and config.NoRecoil.NoFovPunch and type(st.fovPunch) == "number" then
            st.fovPunch = 0
        end
    end
    for c in pairs(state.FaConfigs) do
        zeroKeys(c, FaConfigKeys, spread)
    end
    for c in pairs(state.DbConfigs) do
        zeroKeys(c, DbRecoilKeys, recoil)
    end

    if next(state.DbShellFns) then
        local ammoList = doubleBarrelAmmoList()
        for shellStats in pairs(state.DbShellFns) do
            for _, ammo in ipairs(ammoList) do
                local ok, shell = pcall(shellStats, ammo)
                if ok and type(shell) == "table" and type(shell.spread) == "number" then
                    if spread then
                        setField(shell, "spread", originalField(shell, "spread") * mult)
                    else
                        restoreField(shell, "spread")
                    end
                end
            end
        end
    end
    if DoubleBarrelRemotes then
        for _, attr in ipairs({ "HipCone", "AdsCone" }) do
            if spread then
                setAttr(DoubleBarrelRemotes, attr, 0)
            else
                restoreAttr(DoubleBarrelRemotes, attr)
            end
        end
    end

    if type(CameraShake) == "table" and type(originalField(CameraShake, "gun")) == "function" then
        if recoil and config.NoRecoil.NoCameraShake then
            setField(CameraShake, "gun", noop)
        else
            restoreField(CameraShake, "gun")
        end
    end
end

function Patches.queueRescan()
    if state.RescanQueued then
        return
    end
    state.RescanQueued = true
    task.delay(0.25, function()
        state.RescanQueued = false
        if state.Loaded then
            Patches.scanClosures()
            Patches.apply()
        end
    end)
end

function Patches.tick(now)
    local N = config.Native
    local known = #state.FirearmsClosures + #state.DoubleBarrelClosures > 0
    if now - state.LastScanAt > (known and N.RescanIdleInterval or N.RescanInterval) then
        Patches.scanClosures()
    end
    if now - state.LastPatchAt >= config.Perf.PatchInterval then
        state.LastPatchAt = now
        Patches.apply()
    end
end

return Patches

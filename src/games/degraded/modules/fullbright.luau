local services = require("@core/services")
local config = require("@core/config")
local utility = require("@core/utility")

local Lighting = services.Lighting
local setIfDifferent = utility.setIfDifferent

local FullBright = {}

FullBright.BIND = config.Name .. "_FullBright"

local FAR = 1e9
local SAVED_PROPS = { "Brightness", "ClockTime", "Ambient", "OutdoorAmbient", "ExposureCompensation", "FogEnd", "FogStart", "GlobalShadows" }

local LightingSaved = nil
local EffectsSaved = {}
local AtmosphereSaved = {}

local FovSaved = nil

local function enforceFov()
    local C = config.CameraFov
    local cam = workspace.CurrentCamera
    if not cam then
        return
    end
    if C.Enabled then
        if not FovSaved then
            FovSaved = cam.FieldOfView
        end
        setIfDifferent(cam, "FieldOfView", math.clamp(C.Value, 1, 120))
    elseif FovSaved then
        cam.FieldOfView = FovSaved
        FovSaved = nil
    end
end

function FullBright.enforce()
    enforceFov()
    local F = config.FullBright
    if not F.Enabled then
        return
    end
    if not LightingSaved then
        LightingSaved = {}
        for _, prop in ipairs(SAVED_PROPS) do
            LightingSaved[prop] = Lighting[prop]
        end
    end
    setIfDifferent(Lighting, "Brightness", F.Brightness)
    setIfDifferent(Lighting, "ClockTime", F.ClockTime)
    setIfDifferent(Lighting, "Ambient", F.Ambient)
    setIfDifferent(Lighting, "OutdoorAmbient", F.OutdoorAmbient)
    setIfDifferent(Lighting, "ExposureCompensation", F.ExposureCompensation)
    if F.NoFog then
        setIfDifferent(Lighting, "FogEnd", FAR)
        setIfDifferent(Lighting, "FogStart", FAR)
    end
    if F.NoShadows then
        setIfDifferent(Lighting, "GlobalShadows", false)
    end
    for _, name in ipairs(F.DisableEffects) do
        local fx = Lighting:FindFirstChild(name)
        if fx and fx:IsA("PostEffect") then
            if EffectsSaved[fx] == nil then
                EffectsSaved[fx] = fx.Enabled
            end
            setIfDifferent(fx, "Enabled", false)
        end
    end
    if F.NoAtmosphere then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if atm then
            if AtmosphereSaved[atm] == nil then
                AtmosphereSaved[atm] = atm.Density
            end
            setIfDifferent(atm, "Density", 0)
        end
    end
end

function FullBright.restoreFov()
    if FovSaved and workspace.CurrentCamera then
        pcall(function()
            workspace.CurrentCamera.FieldOfView = FovSaved
        end)
    end
    FovSaved = nil
end

function FullBright.restore()
    if LightingSaved then
        for prop, v in pairs(LightingSaved) do
            pcall(function()
                Lighting[prop] = v
            end)
        end
        LightingSaved = nil
    end
    for fx, v in pairs(EffectsSaved) do
        pcall(function()
            fx.Enabled = v
        end)
    end
    table.clear(EffectsSaved)
    for atm, v in pairs(AtmosphereSaved) do
        pcall(function()
            atm.Density = v
        end)
    end
    table.clear(AtmosphereSaved)
end

function FullBright.set(on)
    config.FullBright.Enabled = on and true or false
    if not on then
        FullBright.restore()
    end
end

return FullBright

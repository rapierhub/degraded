local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")

local LocalPlayer = services.Players.LocalPlayer

local Mods = {}

local Recoil, OriginalShot, ShotWrapper = nil, nil, nil
local Viewmodel, OriginalHipSpread, SpreadWrapper = nil, nil, nil
local SavedAimTime = setmetatable({}, { __mode = "k" })
local CheckedAt = -math.huge

local function requirePath(path)
    local node = services.ReplicatedStorage
    for _, name in ipairs(path) do
        node = node and node:FindFirstChild(name)
    end
    if not (node and node:IsA("ModuleScript")) then
        return nil
    end
    local ok, r = pcall(require, node)
    return ok and type(r) == "table" and r or nil
end

function Mods.install()
    local N = config.Native
    Recoil = requirePath(N.GunRecoilPath)
    if Recoil and type(Recoil.shot) == "function" then
        OriginalShot = Recoil.shot
        ShotWrapper = function(self, aim, climb, yaw, ...)
            if state.Loaded and config.Mods.NoRecoil and type(self) == "table" then
                local r = OriginalShot(self, aim, 0, 0, ...)
                self.roll = 0
                return r
            end
            return OriginalShot(self, aim, climb, yaw, ...)
        end
        Recoil.shot = ShotWrapper
    else
        state.Errors.noRecoil = { message = "GunRecoil.shot not found", at = os.clock() }
    end

    Viewmodel = requirePath(N.ViewmodelPath)
    if Viewmodel and type(Viewmodel.hipSpread) == "function" then
        OriginalHipSpread = Viewmodel.hipSpread
        SpreadWrapper = function(...)
            if state.Loaded and config.Mods.NoSpread then
                return 0
            end
            return OriginalHipSpread(...)
        end
        Viewmodel.hipSpread = SpreadWrapper
    else
        state.Errors.noSpread = { message = "Viewmodel.hipSpread not found", at = os.clock() }
    end
end

local function restoreAimTime()
    for tool, value in pairs(SavedAimTime) do
        if tool.Parent then
            pcall(tool.SetAttribute, tool, config.Native.AimTimeAttribute, value)
        end
        SavedAimTime[tool] = nil
    end
end

function Mods.tick(now)
    if now - CheckedAt < 0.2 then
        return
    end
    CheckedAt = now
    local M, attr = config.Mods, config.Native.AimTimeAttribute
    if not M.InstantAds then
        if next(SavedAimTime) then
            restoreAimTime()
        end
        return
    end
    local ch = LocalPlayer.Character
    local tool = ch and ch:FindFirstChildOfClass("Tool")
    if not tool then
        return
    end
    local current = tool:GetAttribute(attr)
    if type(current) ~= "number" or current == M.AdsTime then
        return
    end
    if SavedAimTime[tool] == nil then
        SavedAimTime[tool] = current
    end
    tool:SetAttribute(attr, M.AdsTime)
end

function Mods.cleanup()
    if Recoil and Recoil.shot == ShotWrapper then
        Recoil.shot = OriginalShot
    end
    if Viewmodel and Viewmodel.hipSpread == SpreadWrapper then
        Viewmodel.hipSpread = OriginalHipSpread
    end
    restoreAimTime()
end

return Mods

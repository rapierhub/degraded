local services = require("@core/services")
local config = require("@core/config")
local utility = require("@core/utility")

local Skins = {}

local GunSkins = nil
local Originals = setmetatable({}, { __mode = "k" })
local CheckedAt = -math.huge

local function gunSkins()
    if GunSkins == nil then
        local mod = services.ReplicatedStorage:FindFirstChild(config.Skins.Module)
        local ok, result = false, nil
        if mod and mod:IsA("ModuleScript") then
            ok, result = pcall(require, mod)
        end
        if ok and type(result) == "table" and type(result.apply) == "function" and type(result.toolName) == "function" and type(result.Skins) == "table" then
            GunSkins = result
        else
            GunSkins = false
        end
    end
    return GunSkins or nil
end

function Skins.list()
    local gs = gunSkins()
    local names, ids = {}, {}
    if gs then
        for _, s in ipairs(gs.Skins) do
            if type(s) == "table" and type(s.id) == "string" and type(s.name) == "string" then
                table.insert(names, s.name)
                ids[s.name] = s.id
            end
        end
    end
    return names, ids
end

local function paint(gs, tool, skin)
    tool:SetAttribute("Skin", skin)
    pcall(gs.apply, tool, tool.Name, skin)
end

function Skins.restore()
    local gs = gunSkins()
    for tool, orig in pairs(Originals) do
        if gs and tool.Parent then
            paint(gs, tool, orig.skin)
        end
        Originals[tool] = nil
    end
end

function Skins.tick(now)
    local S = config.Skins
    if now - CheckedAt < S.Interval then
        return
    end
    CheckedAt = now
    if not S.Enabled or not S.Skin then
        if next(Originals) then
            Skins.restore()
        end
        return
    end
    local gs = gunSkins()
    local tool = utility.equippedTool()
    if not (gs and tool and gs.toolName(tool.Name) and gs.skin(S.Skin)) then
        return
    end
    if tool:GetAttribute("Skin") ~= S.Skin then
        if not Originals[tool] then
            Originals[tool] = { skin = tool:GetAttribute("Skin") }
        end
        paint(gs, tool, S.Skin)
    end
end

return Skins

local services = require("@core/services")
local config = require("@core/config")

local LocalPlayer = services.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Utility = {}

function Utility.up(f, i)
    local ok, v = pcall(getupvalue, f, i)
    return ok and v or nil
end

function Utility.findUpvalue(f, preferred, pred)
    if preferred then
        local v = Utility.up(f, preferred)
        if pred(v) then
            return v
        end
    end
    for i = 1, config.Native.UpvalueScanMax do
        local v = Utility.up(f, i)
        if pred(v) then
            return v
        end
    end
    return nil
end

function Utility.equippedTool()
    local ch = LocalPlayer.Character
    return ch and ch:FindFirstChildOfClass("Tool")
end

function Utility.project(worldPos)
    local v = Camera:WorldToViewportPoint(worldPos)
    return v.X, v.Y, v.Z
end

function Utility.largestPart(root)
    local best, bestVol = nil, -1
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("BasePart") then
            local s = d.Size
            local vol = s.X * s.Y * s.Z
            if vol > bestVol then
                best, bestVol = d, vol
            end
        end
    end
    return best
end

function Utility.makeRayParams(folderLists)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local function refresh()
        local ignore = { Camera }
        if LocalPlayer.Character then
            table.insert(ignore, LocalPlayer.Character)
        end
        for _, list in ipairs(folderLists) do
            for _, name in ipairs(list) do
                local f = workspace:FindFirstChild(name)
                if f then
                    table.insert(ignore, f)
                end
            end
        end
        params.FilterDescendantsInstances = ignore
    end
    return params, refresh
end

function Utility.setIfDifferent(inst, prop, value)
    if inst[prop] ~= value then
        inst[prop] = value
    end
end

return Utility

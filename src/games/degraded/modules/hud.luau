local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local aim = require("@modules/aim")

local Hud = {}

local Gui = Instance.new("ScreenGui")
Gui.Name = config.Name
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 1000
if not pcall(function()
    Gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end) then
    Gui.Parent = services.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local FovCircle = Instance.new("Frame")
FovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FovCircle.BackgroundTransparency = 1
FovCircle.Parent = Gui

local FovCorner = Instance.new("UICorner")
FovCorner.CornerRadius = UDim.new(1, 0)
FovCorner.Parent = FovCircle

local FovStroke = Instance.new("UIStroke")
FovStroke.Thickness = 1.5
FovStroke.Transparency = 0.2
FovStroke.Parent = FovCircle

local TargetHighlight = Instance.new("Highlight")
TargetHighlight.FillTransparency = 1
TargetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
TargetHighlight.Parent = Gui

function Hud.update()
    local V, A = config.Visuals, config.Aim
    local center = aim.origin2D()
    FovCircle.Visible = V.ShowFov and A.Enabled
    FovCircle.Size = UDim2.fromOffset(A.FovRadius * 2, A.FovRadius * 2)
    FovCircle.Position = UDim2.fromOffset(center.X, center.Y)
    FovStroke.Color = state.Target and V.LockedColor or V.FovColor
    TargetHighlight.OutlineColor = V.LockedColor
    local adornee = (V.ShowTargetHighlight and state.Target) and state.Target.model or nil
    if TargetHighlight.Adornee ~= adornee then
        TargetHighlight.Adornee = adornee
    end
end

function Hud.cleanup()
    pcall(Gui.Destroy, Gui)
end

return Hud

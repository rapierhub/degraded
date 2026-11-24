local config = require("@core/config")
local state = require("@core/state")
local aim = require("@modules/aim")

local Hud = {}

-- Drawing objects: GUI instances under gethui() can't be written from this game's render thread.
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5
FovCircle.NumSides = 64
FovCircle.Filled = false
FovCircle.Transparency = 0.8
FovCircle.Visible = false

local TargetHighlight = Instance.new("Highlight")
TargetHighlight.FillTransparency = 1
TargetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
TargetHighlight.OutlineColor = config.Visuals.LockedColor
local HighlightAdornee = nil
TargetHighlight.Parent = (gethui and gethui()) or game:GetService("CoreGui")

function Hud.update()
    local V, A = config.Visuals, config.Aim
    local show = V.ShowFov and A.Enabled
    FovCircle.Visible = show
    if show then
        FovCircle.Position = aim.origin2D()
        FovCircle.Radius = A.FovRadius
        FovCircle.Color = state.Target and V.LockedColor or V.FovColor
    end
    local adornee = (V.ShowTargetHighlight and state.Target) and state.Target.entity.model or nil
    if HighlightAdornee ~= adornee then
        HighlightAdornee = adornee
        pcall(function()
            TargetHighlight.Adornee = adornee
        end)
    end
end

function Hud.cleanup()
    pcall(FovCircle.Remove, FovCircle)
    pcall(TargetHighlight.Destroy, TargetHighlight)
end

return Hud

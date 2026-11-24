local config = require("@core/config")
local state = require("@core/state")

local Interface = {}

function Interface.build()
    local Library = loadstring(game:HttpGet(config.UiSource))()
    local Window = Library:Window({ Name = config.Name, Icon = config.WindowIcon })
    local AimPage = Window:Page({ Icon = "crosshair", Columns = 2 })
    local VisualPage = Window:Page({ Icon = "eye", Columns = 2 })
    local MovePage = Window:Page({ Icon = "wind", Columns = 2 })
    Library:CreateSettingsPage(Window)

    local function toggle(section, name, flag, default, callback)
        return section:Toggle({ Name = name, Flag = flag, Default = default, Callback = callback })
    end

    local function slider(section, name, flag, default, min, max, step, suffix, callback)
        return section:Slider({ Name = name, Flag = flag, Default = default, Min = min, Max = max, Decimals = step, Suffix = suffix, Callback = callback })
    end

    local function dropdown(section, name, flag, default, items, callback)
        return section:Dropdown({ Name = name, Flag = flag, Default = default, Items = items, MaxSize = 100, Callback = callback })
    end

    local function color(section, name, flag, default, callback)
        return section:Label(name):Colorpicker({ Flag = flag, Default = default, Callback = callback })
    end

    local function bind(section, name, flag, tbl, key)
        return toggle(section, name, flag, tbl[key], function(v)
            tbl[key] = v
        end)
    end

    local A, V, E = config.Aim, config.Visuals, config.Esp

    local main = AimPage:Section({ Name = "Silent Aim", Icon = "crosshair", Side = 1 })
    local fov = AimPage:Section({ Name = "Field of View", Icon = "circle", Side = 2 })

    toggle(main, "Enabled", "SAEnabled", A.Enabled, function(v)
        A.Enabled = v
        if not v then
            state.Target = nil
        end
    end)
    dropdown(main, "Aim Part", "SAPart", A.TargetPart, config.PartModes, function(v)
        A.TargetPart = v
    end)
    slider(main, "Hit Chance", "SAHitChance", A.HitChance, 0, 100, 1, "%", function(v)
        A.HitChance = v
    end)
    slider(main, "Max Distance", "SAMaxDist", A.MaxDistance, 50, 3000, 10, " studs", function(v)
        A.MaxDistance = v
    end)
    bind(main, "Visibility Check", "SAVisible", A, "VisibleCheck")
    bind(main, "Team Check", "SATeam", A, "TeamCheck")
    bind(main, "Lead Moving Targets", "SAPrediction", A, "Prediction")
    bind(main, "Skip Hostages / Surrendered", "SAPassive", A, "SkipPassive")
    bind(main, "Target NPCs", "SANpc", A.Kinds, "NPC")
    bind(main, "Target Players", "SAPlayer", A.Kinds, "Player")

    slider(fov, "Radius", "SAFov", A.FovRadius, 10, 800, 1, "px", function(v)
        A.FovRadius = v
    end)
    bind(fov, "Show Circle", "SAShowFov", V, "ShowFov")
    bind(fov, "Highlight Target", "SAHighlight", V, "ShowTargetHighlight")
    color(fov, "Circle Color", "SAFovColor", V.FovColor, function(v)
        V.FovColor = v
    end)
    color(fov, "Locked Color", "SALockedColor", V.LockedColor, function(v)
        V.LockedColor = v
    end)

    local esp = VisualPage:Section({ Name = "ESP", Icon = "eye", Side = 1 })
    local colors = VisualPage:Section({ Name = "Colors", Icon = "palette", Side = 2 })

    bind(esp, "Enabled", "FXEsp", E, "Enabled")
    bind(esp, "NPCs", "FXNpc", E.Kinds, "NPC")
    bind(esp, "Players", "FXPlayer", E.Kinds, "Player")
    bind(esp, "Hide Teammates", "FXTeam", E, "TeamCheck")
    bind(esp, "Hostages / Surrendered", "FXPassive", E, "ShowPassive")
    bind(esp, "Boxes", "FXBoxes", E, "Boxes")
    bind(esp, "Skeleton", "FXSkeleton", E, "Skeleton")
    bind(esp, "Tracers", "FXTracers", E, "Tracers")
    bind(esp, "Names", "FXNames", E, "Names")
    bind(esp, "Health", "FXHealth", E, "Health")
    bind(esp, "Distance", "FXDistance", E, "Distance")
    bind(esp, "Held Weapon", "FXHeldItem", E, "HeldItem")
    slider(esp, "Max Distance", "FXEspDist", E.MaxDistance, 50, 7000, 10, " studs", function(v)
        E.MaxDistance = v
    end)

    color(colors, "NPCs", "FXColNpc", E.Colors.NPC, function(v)
        E.Colors.NPC = v
    end)
    color(colors, "Hostages / Surrendered", "FXColPassive", E.Colors.Passive, function(v)
        E.Colors.Passive = v
    end)
    color(colors, "Players", "FXColPlayer", E.Colors.Player, function(v)
        E.Colors.Player = v
    end)
    color(colors, "Teammates", "FXColTeam", E.Colors.Team, function(v)
        E.Colors.Team = v
    end)

    local M = config.Movement
    local flight = MovePage:Section({ Name = "Fly", Icon = "plane", Side = 1 })
    local ground = MovePage:Section({ Name = "Ground", Icon = "zap", Side = 2 })

    bind(flight, "Enabled", "MVFly", M, "Fly")
    pcall(function()
        flight:Label("Toggle Key"):Keybind({ Flag = "MVFlyKey", Default = M.FlyKey, Mode = "Toggle", Callback = function(v)
            M.Fly = v == true
        end })
    end)
    slider(flight, "Speed", "MVFlySpeed", M.FlySpeed, 5, 300, 1, " studs/s", function(v)
        M.FlySpeed = v
    end)

    bind(ground, "Speed Multiplier", "MVSpeed", M, "Speed")
    slider(ground, "Multiplier", "MVSpeedMult", M.SpeedMultiplier, 1, 10, 0.1, "x", function(v)
        M.SpeedMultiplier = v
    end)
    bind(ground, "Shoot While Sprinting", "MVSprintFire", M, "SprintFire")

    return Library
end

function Interface.destroy(library)
    if type(library) == "table" and type(library.Unload) == "function" then
        pcall(library.Unload, library)
    end
end

return Interface

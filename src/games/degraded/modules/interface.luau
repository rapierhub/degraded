local config = require("@core/config")
local state = require("@core/state")
local fullbright = require("@modules/fullbright")
local skins = require("@modules/skins")

local Interface = {}

function Interface.build()
    local Library = loadstring(game:HttpGet(config.UiSource))()
    if type(config.WindowIcon) == "string" and config.WindowIcon:find("rbxasset", 1, true) then
        local ContentProvider = game:GetService("ContentProvider")
        pcall(ContentProvider.PreloadAsync, ContentProvider, { config.WindowIcon })
    end
    local Window = Library:Window({ Name = config.Name, Icon = config.WindowIcon })
    local AimPage = Window:Page({ Icon = "crosshair", Columns = 2 })
    local VisualPage = Window:Page({ Icon = "eye", Columns = 2 })
    Library:CreateSettingsPage(Window)

    local function toggle(section, name, flag, default, callback)
        return section:Toggle({ Name = name, Flag = flag, Default = default, Callback = callback })
    end

    local function slider(section, name, flag, default, min, max, step, suffix, callback)
        return section:Slider({
            Name = name,
            Flag = flag,
            Default = default,
            Min = min,
            Max = max,
            Decimals = step,
            Suffix = suffix,
            Callback = callback,
        })
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

    local A, V = config.Aim, config.Visuals
    local S, R, E, F = config.NoSpread, config.NoRecoil, config.Esp, config.FullBright

    local main = AimPage:Section({ Name = "Silent Aim", Icon = "crosshair", Side = 1 })
    local aimKinds = AimPage:Section({ Name = "Targets", Icon = "users", Side = 1 })
    local fov = AimPage:Section({ Name = "Field of View", Icon = "circle", Side = 2 })
    local weapon = AimPage:Section({ Name = "Weapon", Icon = "target", Side = 2 })

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
    slider(main, "Max Distance", "SAMaxDist", A.MaxDistance, 50, 2000, 10, " studs", function(v)
        A.MaxDistance = v
    end)
    bind(main, "Visibility Check", "SAVisible", A, "VisibleCheck")
    bind(main, "Prediction", "SAPrediction", A, "Prediction")
    bind(main, "Sticky Target", "SASticky", A, "StickyTarget")

    for _, kind in ipairs(config.Kinds) do
        bind(aimKinds, kind .. "s", "SA" .. kind .. "s", A.Kinds, kind)
    end

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

    bind(weapon, "No Spread", "FXSpread", S, "Enabled")
    slider(weapon, "Pellet Spread Keep", "FXPelletMult", S.PelletSpreadMult, 0, 1, 0.05, "x", function(v)
        S.PelletSpreadMult = v
    end)
    bind(weapon, "No Recoil", "FXRecoil", R, "Enabled")
    bind(weapon, "No Camera Shake", "FXShake", R, "NoCameraShake")
    bind(weapon, "No FOV Punch", "FXFovPunch", R, "NoFovPunch")

    local SK = config.Skins
    local skinSection = AimPage:Section({ Name = "Skin Changer", Icon = "brush", Side = 2 })
    local skinNames, skinIds = skins.list()
    local currentName = skinNames[1]
    for name, id in pairs(skinIds) do
        if id == SK.Skin then
            currentName = name
        end
    end
    SK.Skin = currentName and skinIds[currentName] or nil
    toggle(skinSection, "Enabled", "SkinEnabled", SK.Enabled, function(v)
        SK.Enabled = v
    end)
    if #skinNames > 0 then
        dropdown(skinSection, "Skin", "SkinPick", currentName, skinNames, function(v)
            if skinIds[v] then
                SK.Skin = skinIds[v]
            end
        end)
    end

    local esp = VisualPage:Section({ Name = "ESP", Icon = "eye", Side = 1 })
    local espKinds = VisualPage:Section({ Name = "ESP Targets", Icon = "users", Side = 1 })
    local crates = VisualPage:Section({ Name = "Crates", Icon = "package", Side = 1 })
    local world = VisualPage:Section({ Name = "World", Icon = "sun", Side = 2 })
    local colors = VisualPage:Section({ Name = "Colors", Icon = "palette", Side = 2 })

    bind(esp, "Enabled", "FXEsp", E, "Enabled")
    bind(esp, "Boxes", "FXBoxes", E, "Boxes")
    bind(esp, "Skeleton", "FXSkeleton", E, "Skeleton")
    bind(esp, "Tracers", "FXTracers", E, "Tracers")
    bind(esp, "Look Direction", "FXLook", E, "LookDirection")
    bind(esp, "Names", "FXNames", E, "Names")
    bind(esp, "Health", "FXHealth", E, "Health")
    bind(esp, "Distance", "FXDistance", E, "Distance")
    bind(esp, "Drop Marker", "FXDrop", E, "DropMarker")
    bind(esp, "Held Item", "FXHeldItem", E, "HeldItem")
    bind(esp, "Status Tags", "FXStatus", E, "StatusTags")
    slider(esp, "Look Length", "FXLookLen", E.LookLength, 1, 30, 1, " studs", function(v)
        E.LookLength = v
    end)
    slider(esp, "Max Distance", "FXEspDist", E.MaxDistance, 50, 5000, 10, " studs", function(v)
        E.MaxDistance = v
    end)

    for _, kind in ipairs(config.Kinds) do
        bind(espKinds, kind .. "s", "FXEsp" .. kind .. "s", E.Kinds, kind)
        color(colors, kind .. "s", "FXCol" .. kind, E.Colors[kind], function(v)
            E.Colors[kind] = v
        end)
    end
    color(colors, "Drop Marker", "FXColMarker", E.Colors.Marker, function(v)
        E.Colors.Marker = v
    end)

    local C = config.Crates
    bind(crates, "Enabled", "CrateEsp", C, "Enabled")
    bind(crates, "Military Crates", "CrateMilitary", C.Kinds, "Military")
    bind(crates, "Food Crates", "CrateFood", C.Kinds, "Food")
    bind(crates, "Regular Crates", "CrateRegular", C.Kinds, "Regular")
    bind(crates, "Distance", "CrateDistance", C, "Distance")
    slider(crates, "Max Distance", "CrateMaxDist", C.MaxDistance, 50, 3000, 10, " studs", function(v)
        C.MaxDistance = v
    end)
    for _, kind in ipairs({ "Military", "Food", "Regular" }) do
        color(colors, C.Labels[kind], "CrateCol" .. kind, C.Colors[kind], function(v)
            C.Colors[kind] = v
        end)
    end

    local Ev, T, CF = config.Events, config.Traps, config.CameraFov
    local events = VisualPage:Section({ Name = "Events", Icon = "plane", Side = 1 })
    local traps = VisualPage:Section({ Name = "Traps / Turrets", Icon = "shield", Side = 2 })

    bind(events, "Enabled", "EvEsp", Ev, "Enabled")
    for _, kind in ipairs({ "Airdrop", "Heli", "Bradley" }) do
        bind(events, Ev.Labels[kind], "Ev" .. kind, Ev.Kinds, kind)
        color(colors, Ev.Labels[kind], "EvCol" .. kind, Ev.Colors[kind], function(v)
            Ev.Colors[kind] = v
        end)
    end
    bind(events, "Distance", "EvDistance", Ev, "Distance")
    slider(events, "Max Distance", "EvMaxDist", Ev.MaxDistance, 100, 10000, 50, " studs", function(v)
        Ev.MaxDistance = v
    end)

    bind(traps, "Enabled", "TrapEsp", T, "Enabled")
    for _, kind in ipairs(T.Order) do
        bind(traps, T.Labels[kind], "Trap" .. kind, T.Kinds, kind)
    end
    bind(traps, "Health", "TrapHealth", T, "Health")
    bind(traps, "Distance", "TrapDistance", T, "Distance")
    slider(traps, "Max Distance", "TrapMaxDist", T.MaxDistance, 25, 2000, 5, " studs", function(v)
        T.MaxDistance = v
    end)
    color(colors, "Traps", "TrapCol", T.Color, function(v)
        T.Color = v
    end)

    bind(world, "Camera FOV", "FXCamFov", CF, "Enabled")
    slider(world, "FOV", "FXCamFovValue", CF.Value, 30, 120, 1, "°", function(v)
        CF.Value = v
    end)

    toggle(world, "Full Bright", "FXFullBright", F.Enabled, fullbright.set)
    slider(world, "Brightness", "FXBrightness", F.Brightness, 0, 5, 0.1, nil, function(v)
        F.Brightness = v
    end)
    slider(world, "Clock Time", "FXClock", F.ClockTime, 0, 24, 0.5, "h", function(v)
        F.ClockTime = v
    end)
    bind(world, "No Fog", "FXNoFog", F, "NoFog")
    bind(world, "No Shadows", "FXNoShadows", F, "NoShadows")
    bind(world, "No Atmosphere", "FXNoAtm", F, "NoAtmosphere")
    color(world, "Ambient", "FXAmbient", F.Ambient, function(v)
        F.Ambient = v
        F.OutdoorAmbient = v
    end)

    return Library
end

function Interface.destroy(library)
    if type(library) == "table" and type(library.Unload) == "function" then
        pcall(library.Unload, library)
    end
end

return Interface

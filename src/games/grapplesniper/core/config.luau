return {
    Build = { PlaceId = 75407502025821, PlaceVersion = 2221 },

    Native = {
        HitboxFolder = "Bots",
        ShotFunction = "fireOnce",
        ArenaZone = "Arena",
    },

    Aim = {
        Enabled = true,
        FovRadius = 150,
        TargetPart = "Head",
        ClosestParts = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
        MaxDistance = 2000,
        VisibleCheck = true,
        TeamCheck = true,
        SkipProtected = true,
        HitChance = 100,
        Kinds = { Player = true, Bot = true },
    },

    Esp = {
        Enabled = true,
        TeamCheck = true,
        Kinds = { Player = true, Bot = true },
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        HeldItem = true,
        Tracers = false,
        Skeleton = false,
        HideStale = false,
        StaleSeconds = 3,
        MaxRigDrift = 15,
        MaxDistance = 3000,
        Colors = {
            Player = Color3.fromRGB(255, 70, 70),
            Bot = Color3.fromRGB(255, 190, 60),
            Team = Color3.fromRGB(80, 170, 255),
        },
    },

    Visuals = {
        ShowFov = true,
        ShowTargetHighlight = true,
        FovColor = Color3.fromRGB(255, 255, 255),
        LockedColor = Color3.fromRGB(255, 80, 80),
    },

    Perf = { EntityInterval = 0.15, TargetSelectInterval = 0.05 },

    Name = "Pandemonium",
    WindowIcon = "rbxassetid://132509022802512",
    LoadUi = true,
    UiSource = "https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee",

    RayIgnoreFolders = { "ProjectileFX", "WeaponFX", "ShotFeel", "GrappleDebris", "GrappleStyleDebris", "WrapShells", "HealthOrbs", "BackWeapons", "GuardFX", "StatusEffects", "OutlineHighlights", "DamageNumbersFx" },
    PartModes = { "Head", "UpperTorso", "HumanoidRootPart", "Closest" },
    Kinds = { "Player", "Bot" },
}

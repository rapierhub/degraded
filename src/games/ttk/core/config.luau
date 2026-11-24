return {
    Build = { PlaceId = 120189115846709, PlaceVersion = 1953 },

    Native = {
        BulletControllerPath = { "Modules", "Client", "Controllers", "BulletController" },
        FriendlyFirePath = { "Modules", "Shared", "Combat", "FriendlyFire" },
        HitboxFolder = "MercPlayers",
        HitboxPrefix = "MercHitboxes_",
        VisualPrefix = "MercVisual_",
        HitZoneSuffix = "HitZone",
    },

    Aim = {
        Enabled = true,
        FovRadius = 150,
        TargetPart = "Head",
        ClosestParts = { "Head", "UpperTorso", "LowerTorso" },
        MaxDistance = 1500,
        VisibleCheck = true,
        TeamCheck = true,
        SkipProtected = true,
        HitChance = 100,
    },

    Esp = {
        Enabled = true,
        TeamCheck = true,
        Kinds = { Player = true },
        Boxes = true,
        Names = true,
        Health = false,
        HideStale = true,
        StaleSeconds = 3,
        MaxRigDrift = 15,
        Distance = true,
        HeldItem = true,
        Tracers = false,
        Skeleton = false,
        MaxDistance = 3000,
        Colors = {
            Player = Color3.fromRGB(255, 70, 70),
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

    RayIgnoreFolders = { "Ignore", "_CosmeticProjectiles", "_CosmeticBulletHoles", "_GlassDebris", "WeaponDrops", "WeaponDropModels" },
    PartModes = { "Head", "UpperTorso", "LowerTorso", "Closest" },
    Kinds = { "Player" },
}

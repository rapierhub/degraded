return {
    Builds = {
        [13622622708] = 319,
        [5468388011] = 391,
    },

    Native = {
        ReplicatorModule = "ReplicatorService",
        BulletModule = "BulletService",
        FirearmModule = "FirearmInventory",
        ControllerModule = "CharacterController",
        ClientModule = "ClientService",
        StandingHeightState = 0,
        ActorAttribute = "ActorUID",
        ProtectedTag = "PreventPlayerFire",
        SurrenderEmote = "Surrender",
        BulletCollisionGroup = "9",
        Gravity = 32.2,
        RootToHeadTop = 4,
        RootToFeet = 0.9,
        NpcLabel = "NPC",
        NpcItemPrefix = "^AI_",
        HealthScale = 100,
    },

    Aim = {
        Enabled = true,
        FovRadius = 150,
        TargetPart = "Head",
        ClosestParts = { "Head", "UpperTorso", "LowerTorso" },
        MaxDistance = 1500,
        VisibleCheck = true,
        TeamCheck = true,
        SkipPassive = true,
        Prediction = true,
        MaxTargetSpeed = 80,
        HitChance = 100,
        Kinds = { NPC = true, Player = false },
    },

    Esp = {
        Enabled = true,
        Kinds = { NPC = true, Player = true },
        TeamCheck = false,
        ShowPassive = true,
        Boxes = true,
        Names = true,
        Health = false,
        Distance = true,
        HeldItem = true,
        Tracers = false,
        Skeleton = false,
        MaxDistance = 1500,
        Colors = {
            NPC = Color3.fromRGB(255, 70, 70),
            Passive = Color3.fromRGB(255, 210, 70),
            Player = Color3.fromRGB(255, 140, 60),
            Team = Color3.fromRGB(80, 170, 255),
        },
    },

    Movement = {
        Fly = false,
        FlySpeed = 40,
        FlyKey = Enum.KeyCode.F4,
        FlyUpKey = Enum.KeyCode.Space,
        FlyDownKey = Enum.KeyCode.LeftControl,
        Speed = false,
        SpeedMultiplier = 1.5,
        SprintFire = true,
    },

    Visuals = {
        ShowFov = true,
        ShowTargetHighlight = true,
        FovColor = Color3.fromRGB(255, 255, 255),
        LockedColor = Color3.fromRGB(255, 80, 80),
    },

    Perf = { EntityInterval = 0.15, TargetSelectInterval = 0.05, ResolveInterval = 2, MaxActors = 2000 },

    Name = "Pandemonium",
    WindowIcon = "rbxassetid://132509022802512",
    LoadUi = true,
    UiSource = "https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee",

    PartModes = { "Head", "UpperTorso", "LowerTorso", "Closest" },
}

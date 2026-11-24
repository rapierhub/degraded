return {
    Build = { PlaceId = 78884249003161, PlaceVersion = 2675 },

    Native = {
        VRPath = { "Voxel", "VR" },
        BallisticsPath = { "Voxel", "Ballistics" },
        SniperScript = "SniperClient",
        SniperScopedAlpha = 0.6,
        GunRecoilPath = { "Voxel", "GunRecoil" },
        ViewmodelPath = { "Voxel", "Viewmodel" },
        AimTimeAttribute = "GsAimTime",
        ShotFunction = "shoot",
        BotFolder = "BotRigs",
        HitConfirmPath = { "Game", "Remotes", "HitConfirm" },
    },

    Aim = {
        Enabled = true,
        FovRadius = 150,
        TargetPart = "Head",
        ClosestParts = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
        MaxDistance = 1500,
        VisibleCheck = true,
        TeamCheck = true,
        SkipProtected = true,
        HitChance = 100,
        Prediction = true,
        Kinds = { Player = true, Bot = true },
    },

    Mods = { NoRecoil = false, NoSpread = false, InstantAds = false, AdsTime = 0.01 },

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

    Perf = { EntityInterval = 0.5, TargetSelectInterval = 0.05 },

    Name = "Pandemonium",
    WindowIcon = "rbxassetid://132509022802512",
    LoadUi = true,
    UiSource = "https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee",

    RayIgnoreFolders = { "VoxelChips", "VoxelLoose", "VoxelFalling", "GroundMarks", "SniperRounds", "GroundFireFX" },
    PartModes = { "Head", "UpperTorso", "HumanoidRootPart", "Closest" },
    Kinds = { "Player", "Bot" },
}

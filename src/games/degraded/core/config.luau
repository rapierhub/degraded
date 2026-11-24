return {
    Build = { PlaceId = 107088339391423, PlaceVersion = 49 },

    Native = {
        FirearmsSource = "FirearmsClient",
        FirearmsShotName = "tryShoot",
        FirearmsToolUpvalue = 1,
        FirearmsStatsUpvalue = 3,
        FirearmsStateUpvalue = 6,
        FirearmsConfigUpvalue = 12,
        FirearmsDefaultSpeed = 1000,
        FirearmsDefaultGravity = 60,

        DoubleBarrelSource = "DoubleBarrelClient",
        DoubleBarrelShotName = "fire",
        DoubleBarrelShellStatsUpvalue = 9,
        DoubleBarrelConfigUpvalue = 13,
        DoubleBarrelAmmoTypes = { "Buckshot", "Slug" },
        DoubleBarrelDefaultSpeed = 804,
        DoubleBarrelDefaultGravity = 35,


        UpvalueScanMax = 40,
        StackScanFrom = 2,
        StackScanTo = 7,
        RescanInterval = 5,
        RescanIdleInterval = 30,
    },

    Aim = {
        Enabled = true,
        FovRadius = 120,
        TargetPart = "Head",
        ClosestParts = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
        MaxDistance = 800,
        VisibleCheck = true,
        HitChance = 100,
        Prediction = true,
        StickyTarget = false,
        Kinds = { Player = true, Scientist = true, Animal = true, Sleeper = false },
    },

    NoSpread = { Enabled = true, PelletSpreadMult = 0 },
    NoRecoil = { Enabled = true, NoCameraShake = true, NoFovPunch = true },

    Esp = {
        Enabled = true,
        Kinds = { Player = true, Scientist = true, Animal = true, Sleeper = false },
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        Skeleton = false,
        LookDirection = false,
        LookLength = 6,
        MaxDistance = 1500,
        DropMarker = true,
        HeldItem = true,
        StatusTags = true,
        Statuses = { { "Downed", "DOWNED" }, { "GunAim", "AIM" }, { "Sprinting", "RUN" }, { "Crouching", "CROUCH" } },
        Colors = {
            Player = Color3.fromRGB(255, 70, 70),
            Scientist = Color3.fromRGB(255, 190, 60),
            Animal = Color3.fromRGB(120, 200, 255),
            Sleeper = Color3.fromRGB(170, 170, 170),
            Marker = Color3.fromRGB(80, 255, 120),
        },
    },

    Crates = {
        Enabled = true,
        Distance = true,
        MaxDistance = 600,
        Folder = "WorldLoot",
        Kinds = { Military = true, Food = true, Regular = true },
        Names = {
            MilitaryCrate = "Military",
            FoodCrate = "Food",
            RationBox = "Food",
            Crate = "Regular",
        },
        KitNames = {
            Resources_MilitaryCrate = "Military",
            Resources_Crate = "Regular",
        },
        Labels = { Military = "Military Crate", Food = "Food Crate", Regular = "Crate" },
        Colors = {
            Military = Color3.fromRGB(110, 200, 90),
            Food = Color3.fromRGB(255, 170, 80),
            Regular = Color3.fromRGB(200, 170, 120),
        },
    },

    Events = {
        Enabled = true,
        Distance = true,
        MaxDistance = 5000,
        Folders = { Airdrop = "Airdrops", Heli = "PatrolHeli", Bradley = "BradleyAPC" },
        Kinds = { Airdrop = true, Heli = true, Bradley = true },
        Labels = { Airdrop = "Airdrop", Heli = "Patrol Heli", Bradley = "Bradley APC" },
        Colors = {
            Airdrop = Color3.fromRGB(80, 220, 255),
            Heli = Color3.fromRGB(255, 80, 200),
            Bradley = Color3.fromRGB(255, 120, 40),
        },
    },

    Traps = {
        Enabled = true,
        Distance = true,
        Health = true,
        MaxDistance = 300,
        Folder = "Traps",
        Kinds = { AutoTurret = true, FlameTurret = true, ShotgunTrap = true, BearTrap = true, TinCanAlarm = true },
        Labels = { AutoTurret = "Auto Turret", FlameTurret = "Flame Turret", ShotgunTrap = "Shotgun Trap", BearTrap = "Bear Trap", TinCanAlarm = "Tin Can Alarm" },
        Order = { "AutoTurret", "FlameTurret", "ShotgunTrap", "BearTrap", "TinCanAlarm" },
        Color = Color3.fromRGB(255, 90, 90),
    },

    Skins = { Enabled = false, Skin = "DegradeRed", Module = "GunSkins", Interval = 0.25 },

    CameraFov ={ Enabled = false, Value = 90 },

    FullBright = {
        Enabled = true,
        Brightness = 2,
        ClockTime = 12,
        Ambient = Color3.fromRGB(178, 178, 178),
        OutdoorAmbient = Color3.fromRGB(178, 178, 178),
        ExposureCompensation = 0,
        NoFog = true,
        NoShadows = true,
        NoAtmosphere = true,
        DisableEffects = { "DayNightGrade", "Bloom", "SunRays", "DepthOfField" },
    },

    Visuals = {
        ShowFov = true,
        ShowTargetHighlight = true,
        FovColor = Color3.fromRGB(255, 255, 255),
        LockedColor = Color3.fromRGB(255, 80, 80),
    },

    Perf = {
        EntityInterval = 1,
        TargetSelectInterval = 0.05,
        PatchInterval = 0.5,
        MarkerInterval = 0.05,
        MarkerStep = 1 / 40,
    },

    Name = "Pandemonium",
    WindowIcon = "rbxassetid://132509022802512",
    LoadUi = true,
    UiSource = "https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee",

    RayIgnoreFolders = { "FirearmsTracers", "DroppedItems", "ShotgunEffects", "PipePistolEffects", "FirearmsPings" },
    MarkerRayIgnoreExtra = { "StuckArrows" },

    NpcFolders = { Scientist = "Scientists", Animal = "Animals", Sleeper = "Sleepers" },
    PartModes = { "Head", "UpperTorso", "HumanoidRootPart", "Closest" },
    Kinds = { "Player", "Scientist", "Animal", "Sleeper" },
}

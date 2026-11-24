local State = {
    Loaded = true,
    Connections = {},
    Errors = {},
    BuildMismatch = nil,

    Target = nil,
    SelectAt = -math.huge,
    OriginalHeld = nil,
    Wrapper = nil,
    Shots = {},
    Stats = { Calls = 0, Redirected = 0, Skipped = 0 },

    FirearmsClosures = {},
    DoubleBarrelClosures = {},
    FaStats = {},
    FaStates = {},
    FaConfigs = {},
    DbConfigs = {},
    DbShellFns = {},
    LastScanAt = -math.huge,
    LastPatchAt = -math.huge,
    RescanQueued = false,
    Patched = 0,

    Entities = {},
    EntitiesAt = -math.huge,
    EntitiesGen = 0,
    Crates = {},
    CratesAt = -math.huge,
    CratesGen = 0,
    MarkerAt = -math.huge,
    Objects = {},
    ObjectsAt = -math.huge,
    ObjectsGen = 0,
}

function State.connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(State.Connections, c)
    return c
end

function State.guarded(tag, fn)
    return function(...)
        local ok, e = pcall(fn, ...)
        if not ok then
            State.Errors[tag] = { message = tostring(e), at = os.clock() }
        end
    end
end

return State

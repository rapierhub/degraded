local State = {
    Loaded = true,
    Connections = {},
    Errors = {},
    BuildMismatch = nil,

    Target = nil,
    SelectAt = -math.huge,
    Stats = { Shots = 0, Redirected = 0 },
    LastRedirectAt = -math.huge,

    Entities = {},
    EntitiesAt = -math.huge,
    EntitiesGen = 0,
}

function State.connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(State.Connections, c)
    return c
end

function State.guarded(tag, fn)
    return function(...)
        local ok, e = xpcall(fn, debug.traceback, ...)
        if not ok then
            State.Errors[tag] = { message = tostring(e), at = os.clock() }
        end
    end
end

return State

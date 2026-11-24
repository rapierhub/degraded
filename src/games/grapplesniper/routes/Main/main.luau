local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local entities = require("@modules/entities")
local aim = require("@modules/aim")
local esp = require("@modules/esp")
local hud = require("@modules/hud")
local interface = require("@modules/interface")

local RunService = services.RunService

return function()
    if game.PlaceVersion ~= config.Build.PlaceVersion then
        state.BuildMismatch = { measured = config.Build.PlaceVersion, current = game.PlaceVersion }
    end

    local api

    local function unload()
        if not state.Loaded then
            return
        end
        state.Loaded = false
        for _, c in ipairs(state.Connections) do
            pcall(c.Disconnect, c)
        end
        table.clear(state.Connections)
        aim.cleanup()
        esp.cleanup()
        hud.cleanup()
        interface.destroy(api and api.Library)
        getgenv()[config.Name] = nil
    end

    local function onRender()
        local now = os.clock()
        entities.refresh(now)
        if not config.Aim.Enabled then
            state.Target = nil
        elseif now - state.SelectAt >= config.Perf.TargetSelectInterval then
            state.SelectAt = now
            state.Target = aim.selectTarget()
        end
        hud.update()
        esp.draw()
    end

    aim.install()
    -- Rebuild the entity list as soon as a rig spawns or despawns instead of waiting for the interval.
    local rigs = workspace:FindFirstChild(config.Native.HitboxFolder)
    if rigs then
        local function invalidate()
            state.EntitiesAt = -math.huge
        end
        state.connect(rigs.ChildAdded, invalidate)
        state.connect(rigs.ChildRemoved, invalidate)
    end
    state.connect(RunService.RenderStepped, state.guarded("render", onRender))

    api = {
        Config = config,
        State = state,
        SelectTarget = aim.selectTarget,
        Unload = unload,
    }
    getgenv()[config.Name] = api

    if config.LoadUi then
        local ok, lib = pcall(interface.build)
        if ok then
            api.Library = lib
        else
            state.Errors.ui = { message = tostring(lib), at = os.clock() }
        end
    end
end

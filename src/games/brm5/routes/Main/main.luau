local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local native = require("@modules/native")
local entities = require("@modules/entities")
local aim = require("@modules/aim")
local movement = require("@modules/movement")
local esp = require("@modules/esp")
local hud = require("@modules/hud")
local interface = require("@modules/interface")

local RunService = services.RunService

return function()
    local measured = config.Builds[game.PlaceId]
    if measured ~= game.PlaceVersion then
        state.BuildMismatch = { place = game.PlaceId, measured = measured, current = game.PlaceVersion }
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
        movement.cleanup()
        esp.cleanup()
        hud.cleanup()
        interface.destroy(api and api.Library)
        getgenv()[config.Name] = nil
    end

    local function onRender()
        local now = os.clock()
        native.resolve(now)
        if native.aimReady() then
            aim.install()
        end
        movement.install()
        entities.refresh(now)
        if not config.Aim.Enabled then
            state.Target = nil
        elseif now - state.SelectAt >= config.Perf.TargetSelectInterval then
            state.SelectAt = now
            state.Target = aim.selectTarget()
        end
        aim.track(now)
        hud.update()
        esp.draw()
    end

    state.connect(RunService.RenderStepped, state.guarded("render", onRender))

    api = {
        Config = config,
        State = state,
        Native = native,
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

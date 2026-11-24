local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local ballistics = require("@core/ballistics")
local entities = require("@modules/entities")
local aim = require("@modules/aim")
local patches = require("@modules/patches")
local esp = require("@modules/esp")
local fullbright = require("@modules/fullbright")
local hud = require("@modules/hud")
local skins = require("@modules/skins")
local interface = require("@modules/interface")

local RunService = services.RunService
local LocalPlayer = services.Players.LocalPlayer

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
        pcall(RunService.UnbindFromRenderStep, RunService, fullbright.BIND)
        aim.cleanup()
        patches.restoreAll()
        fullbright.restore()
        fullbright.restoreFov()
        skins.restore()
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
        esp.draw(now)
    end

    local function onHeartbeat()
        aim.installWrapper()
        patches.tick(os.clock())
        skins.tick(os.clock())
    end

    local function watchCharacter(char)
        state.connect(char.ChildAdded, function(child)
            if child:IsA("Tool") then
                patches.queueRescan()
            end
        end)
    end

    aim.installWrapper()
    patches.scanClosures()
    patches.apply()

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character)
    end
    state.connect(LocalPlayer.CharacterAdded, watchCharacter)

    state.connect(RunService.RenderStepped, state.guarded("render", onRender))
    state.connect(RunService.Heartbeat, state.guarded("heartbeat", onHeartbeat))
    RunService:BindToRenderStep(fullbright.BIND, Enum.RenderPriority.Last.Value + 1, state.guarded("fullbright", fullbright.enforce))

    api = {
        Config = config,
        State = state,
        SelectTarget = aim.selectTarget,
        SetFullBright = fullbright.set,
        Unload = unload,
        Math = ballistics,
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

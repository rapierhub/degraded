local services = require("@core/services")
local config = require("@core/config")
local state = require("@core/state")
local native = require("@modules/native")
local entities = require("@modules/entities")

local UserInputService = services.UserInputService

local Movement = {}

local Controller = { installed = false }
local Trigger = { installed = false }
local ActiveFirearm = nil

local function canFly(controller)
    local actor = controller._localActor
    if type(actor) ~= "table" or actor.Alive ~= true or actor.Downed then
        return false
    end
    if actor.Seat or actor.OldSeat or actor.Rappelling or actor.Ladder or controller._startPhysics then
        return false
    end
    local current = actor.CurrentState
    return not (type(current) == "table" and current.Dragged)
end

local function fly(controller, input, dt)
    local M = config.Movement
    local actor = controller._localActor
    local pos = controller._position
    local hitbox = controller._groundHitbox
    if typeof(hitbox) == "Instance" and hitbox:IsA("BasePart") then
        pos = hitbox.CFrame:PointToWorldSpace(pos)
    end
    if not entities.finiteVector(pos) then
        error("controller position is not a finite Vector3", 0)
    end
    local move = workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(input.X, 0, input.Y))
    if UserInputService:GetFocusedTextBox() == nil then
        if UserInputService:IsKeyDown(M.FlyUpKey) then
            move = move + Vector3.yAxis
        end
        if UserInputService:IsKeyDown(M.FlyDownKey) then
            move = move - Vector3.yAxis
        end
    end
    if move.Magnitude > 1 then
        move = move.Unit
    end
    local target = pos + move * M.FlySpeed * math.clamp(dt, 0, 0.1)
    if not entities.finiteVector(target) then
        error("fly target is not a finite Vector3", 0)
    end
    local standing = config.Native.StandingHeightState
    controller._position = target
    controller._lastSafePosition = target
    controller._groundHitbox = nil
    controller._groundTimer = nil
    controller.VelocityGravity = 0
    controller.MoveSpeed = 0
    controller.IsGrounded = false
    controller.IsSliding = false
    controller.IsSprinting = false
    controller.HeightState = standing
    controller._lastMovement = input
    actor.HeightState = standing
    actor.Platform = nil
    actor.Grounded = true
    actor.Sliding = false
    actor.Sprinting = false
    actor.SimulatedPosition = target
end

local function installController()
    local class = native.Controller
    if Controller.installed or not class then
        return
    end
    Controller.update = class.Update
    Controller.accelerate = class._accelerate
    Controller.updateWrapper = function(self, input, dt, ...)
        local M = config.Movement
        if state.Loaded and M.Fly and typeof(input) == "Vector2" and type(dt) == "number" and canFly(self) then
            local ok, e = pcall(fly, self, input, dt)
            if ok then
                return
            end
            state.Errors.fly = { message = tostring(e), at = os.clock() }
        end
        local result = table.pack(Controller.update(self, input, dt, ...))
        if state.Loaded and M.SprintFire and ActiveFirearm and ActiveFirearm._active then
            local actor = self._localActor
            if type(actor) == "table" then
                actor.Sprinting = false
            end
        end
        return table.unpack(result, 1, result.n)
    end
    Controller.accelerateWrapper = function(self, dt, ...)
        local M = config.Movement
        local weight = self._weightMulti
        local scale = M.SpeedMultiplier
        if not (state.Loaded and M.Speed and type(weight) == "number" and type(dt) == "number" and type(scale) == "number" and scale > 0 and scale ~= 1) then
            return Controller.accelerate(self, dt, ...)
        end
        self._weightMulti = weight * scale
        local result = table.pack(pcall(Controller.accelerate, self, dt * scale, ...))
        self._weightMulti = weight
        if not result[1] then
            error(result[2], 0)
        end
        return table.unpack(result, 2, result.n)
    end
    class.Update = Controller.updateWrapper
    class._accelerate = Controller.accelerateWrapper
    Controller.installed = true
end

local function installTrigger()
    local class = native.Firearm
    if Trigger.installed or not class or type(rawget(class, "_discharge")) ~= "function" then
        return
    end
    Trigger.discharge = class._discharge
    Trigger.wrapper = function(self, on, ...)
        ActiveFirearm = on and self or nil
        if on and state.Loaded and config.Movement.SprintFire then
            local actor = self._actor
            if type(actor) == "table" then
                actor.Sprinting = false
            end
        end
        return Trigger.discharge(self, on, ...)
    end
    class._discharge = Trigger.wrapper
    Trigger.installed = true
end

function Movement.install()
    installController()
    installTrigger()
end

function Movement.cleanup()
    local controller, firearm = native.Controller, native.Firearm
    if Controller.installed and controller then
        if controller.Update == Controller.updateWrapper then
            controller.Update = Controller.update
        end
        if controller._accelerate == Controller.accelerateWrapper then
            controller._accelerate = Controller.accelerate
        end
        Controller.installed = false
    end
    if Trigger.installed and firearm then
        if firearm._discharge == Trigger.wrapper then
            firearm._discharge = Trigger.discharge
        end
        Trigger.installed = false
    end
    ActiveFirearm = nil
end

return Movement

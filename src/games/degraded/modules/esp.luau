local config = require("@core/config")
local state = require("@core/state")
local utility = require("@core/utility")
local ballistics = require("@core/ballistics")
local entities = require("@modules/entities")
local aim = require("@modules/aim")

local Camera = workspace.CurrentCamera
local project = utility.project
local up, findUpvalue = utility.up, utility.findUpvalue

local Esp = {}

local HEALTH_LOW, HEALTH_HIGH = Color3.fromRGB(255, 60, 60), Color3.fromRGB(60, 255, 90)
local SCREEN_MARGIN = 200

local BONES_R15 = {
    { "Head", "UpperTorso" },
    { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" },
    { "LeftUpperArm", "LeftLowerArm" },
    { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" },
    { "RightUpperArm", "RightLowerArm" },
    { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" },
    { "LeftUpperLeg", "LeftLowerLeg" },
    { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" },
    { "RightUpperLeg", "RightLowerLeg" },
    { "RightLowerLeg", "RightFoot" },
}

local BONES_R6 = {
    { "Head", "Torso" },
    { "Torso", "Left Arm" },
    { "Torso", "Right Arm" },
    { "Torso", "Left Leg" },
    { "Torso", "Right Leg" },
}

local Entries = {}
local EntriesGen = -1
local CrateLabels = {}
local CrateLabelsGen = -1

local function newDrawing(class, props)
    local d = Drawing.new(class)
    for k, v in pairs(props) do
        d[k] = v
    end
    d.Visible = false
    return d
end

local function setVisible(slot, on)
    if slot.shown ~= on then
        slot.shown = on
        slot.d.Visible = on
    end
end

local function setProp(slot, key, value)
    if slot[key] ~= value then
        slot[key] = value
        slot.d[key] = value
    end
end

local function slot(class, props)
    return { d = newDrawing(class, props), shown = false }
end

local function removeSlot(s)
    if s then
        pcall(s.d.Remove, s.d)
    end
end

local function newEntry()
    return {
        box = slot("Square", { Thickness = 1.5, Filled = false }),
        name = slot("Text", { Size = 13, Center = true, Outline = true }),
        hpBack = slot("Square", { Filled = true, Color = Color3.new(0, 0, 0), Transparency = 0.6 }),
        hpFill = slot("Square", { Filled = true }),
        info = slot("Text", { Size = 12, Center = true, Outline = true }),
        tracer = nil,
        look = nil,
        bones = nil,
        gen = -1,
        boneParts = nil,
        headPart = nil,
        bounds = nil,
        visible = false,
    }
end

local function eachSlot(e, fn)
    fn(e.box)
    fn(e.name)
    fn(e.hpBack)
    fn(e.hpFill)
    fn(e.info)
    if e.tracer then
        fn(e.tracer)
    end
    if e.look then
        fn(e.look)
    end
    if e.bones then
        for _, s in ipairs(e.bones) do
            fn(s)
        end
    end
end

local function hideEntry(e)
    if e.visible then
        e.visible = false
        eachSlot(e, function(s)
            setVisible(s, false)
        end)
    end
end

local function removeEntry(model)
    local e = Entries[model]
    if e then
        eachSlot(e, removeSlot)
        Entries[model] = nil
    end
end

local function resolveParts(e, model, hum)
    local bones = hum.RigType == Enum.HumanoidRigType.R6 and BONES_R6 or BONES_R15
    local parts = {}
    for i, bone in ipairs(bones) do
        local a, b = aim.bodyPart(model, bone[1]), aim.bodyPart(model, bone[2])
        if a and b then
            parts[i] = { a, b }
        end
    end
    e.boneParts = parts
    e.boneCount = #bones
    e.headPart = aim.bodyPart(model, "Head") or aim.bodyPart(model, "HumanoidRootPart")
    local ok, cf, size = pcall(model.GetBoundingBox, model)
    if ok and size.Magnitude > 0 and size.Magnitude < 200 then
        e.bounds = { offset = model:GetPivot():ToObjectSpace(cf), size = size }
    else
        e.bounds = nil
    end
    e.gen = state.EntitiesGen
end

local function drawSkeleton(e, color)
    if not e.bones then
        e.bones = {}
        for i = 1, #BONES_R15 do
            e.bones[i] = slot("Line", { Thickness = 1 })
        end
    end
    for i, s in ipairs(e.bones) do
        local pair = i <= e.boneCount and e.boneParts[i]
        local on = false
        if pair and pair[1].Parent and pair[2].Parent then
            local ax, ay, az = project(pair[1].Position)
            local bx, by, bz = project(pair[2].Position)
            if az > 0 and bz > 0 then
                s.d.From = Vector2.new(ax, ay)
                s.d.To = Vector2.new(bx, by)
                setProp(s, "Color", color)
                on = true
            end
        end
        setVisible(s, on)
    end
end

local function hideSlots(list)
    if list then
        for _, s in ipairs(list) do
            setVisible(s, false)
        end
    end
end

local function drawLook(e, color)
    if not e.look then
        e.look = slot("Line", { Thickness = 1.5 })
    end
    local head = e.headPart
    local on = false
    if head and head.Parent then
        local from = head.Position
        local ax, ay, az = project(from)
        local bx, by, bz = project(from + head.CFrame.LookVector * config.Esp.LookLength)
        if az > 0 and bz > 0 then
            e.look.d.From = Vector2.new(ax, ay)
            e.look.d.To = Vector2.new(bx, by)
            setProp(e.look, "Color", color)
            on = true
        end
    end
    setVisible(e.look, on)
end

local function drawEntity(ent, camCF, camPos, vp)
    local E = config.Esp
    local model, hum = ent.model, ent.humanoid
    local e = Entries[model]
    if not e then
        e = newEntry()
        Entries[model] = e
    end
    if e.gen ~= state.EntitiesGen then
        resolveParts(e, model, hum)
    end
    local bounds = e.bounds
    if not bounds then
        hideEntry(e)
        return
    end

    local cf = model:GetPivot() * bounds.offset
    local center = cf.Position
    local dist = (center - camPos).Magnitude
    if dist > E.MaxDistance then
        hideEntry(e)
        return
    end
    local cx, cy, cz = project(center)
    if cz <= 0 or cx < -SCREEN_MARGIN or cy < -SCREEN_MARGIN or cx > vp.X + SCREEN_MARGIN or cy > vp.Y + SCREEN_MARGIN then
        hideEntry(e)
        return
    end
    local x0, y0, x1, y1 = ballistics.screenBounds(cf, bounds.size, project)
    if not x0 then
        hideEntry(e)
        return
    end
    e.visible = true
    local color = E.Colors[ent.kind] or E.Colors.Sleeper

    setVisible(e.box, E.Boxes)
    if E.Boxes then
        setProp(e.box, "Color", color)
        e.box.d.Position = Vector2.new(x0, y0)
        e.box.d.Size = Vector2.new(x1 - x0, y1 - y0)
    end

    setVisible(e.name, E.Names)
    if E.Names then
        setProp(e.name, "Text", E.Distance and ("%s [%d]"):format(ent.label, math.floor(dist + 0.5)) or ent.label)
        setProp(e.name, "Color", color)
        e.name.d.Position = Vector2.new((x0 + x1) * 0.5, y0 - 16)
    end

    setVisible(e.hpBack, E.Health)
    setVisible(e.hpFill, E.Health)
    if E.Health then
        local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local h = y1 - y0
        e.hpBack.d.Position = Vector2.new(x0 - 6, y0)
        e.hpBack.d.Size = Vector2.new(3, h)
        setProp(e.hpFill, "Color", HEALTH_LOW:Lerp(HEALTH_HIGH, frac))
        e.hpFill.d.Position = Vector2.new(x0 - 6, y0 + h * (1 - frac))
        e.hpFill.d.Size = Vector2.new(3, h * frac)
    end

    local infoText = nil
    if E.HeldItem or E.StatusTags then
        local parts = {}
        if E.HeldItem then
            local tool = model:FindFirstChildOfClass("Tool")
            if tool then
                table.insert(parts, tool.Name)
            end
        end
        if E.StatusTags then
            for _, st in ipairs(E.Statuses) do
                if model:GetAttribute(st[1]) == true then
                    table.insert(parts, st[2])
                end
            end
        end
        if #parts > 0 then
            infoText = table.concat(parts, " | ")
        end
    end
    setVisible(e.info, infoText ~= nil)
    if infoText then
        setProp(e.info, "Text", infoText)
        setProp(e.info, "Color", color)
        e.info.d.Position = Vector2.new((x0 + x1) * 0.5, y1 + 2)
    end

    if E.Tracers then
        if not e.tracer then
            e.tracer = slot("Line", { Thickness = 1 })
        end
        setVisible(e.tracer, true)
        setProp(e.tracer, "Color", color)
        e.tracer.d.From = Vector2.new(vp.X * 0.5, vp.Y)
        e.tracer.d.To = Vector2.new((x0 + x1) * 0.5, y1)
    elseif e.tracer then
        setVisible(e.tracer, false)
    end

    if E.Skeleton then
        drawSkeleton(e, color)
    else
        hideSlots(e.bones)
    end

    if E.LookDirection then
        drawLook(e, color)
    elseif e.look then
        setVisible(e.look, false)
    end
end

local function crateKind(model)
    local C = config.Crates
    local kind = C.Names[model.Name]
    if kind then
        return kind
    end
    local kit = model:GetAttribute("KitDressed")
    return type(kit) == "string" and C.KitNames[kit] or nil
end

local function refreshCrates(now)
    if now - state.CratesAt < config.Perf.EntityInterval then
        return
    end
    state.CratesAt = now
    local list = {}
    local folder = workspace:FindFirstChild(config.Crates.Folder)
    if folder then
        for _, m in ipairs(folder:GetChildren()) do
            local kind = m:IsA("Model") and crateKind(m)
            if kind and m:FindFirstChildWhichIsA("BasePart", true) then
                local ok, cf = pcall(m.GetBoundingBox, m)
                if ok then
                    table.insert(list, { model = m, kind = kind, pos = cf.Position })
                end
            end
        end
    end
    state.Crates = list
    state.CratesGen = state.CratesGen + 1
end

local function drawCrates(camPos, vp)
    local C = config.Crates
    local live = CrateLabelsGen ~= state.CratesGen and {} or nil
    for _, crate in ipairs(state.Crates) do
        local label = CrateLabels[crate.model]
        if live then
            live[crate.model] = true
        end
        local on = false
        if C.Enabled and C.Kinds[crate.kind] and crate.model.Parent then
            local dist = (crate.pos - camPos).Magnitude
            if dist <= C.MaxDistance then
                local x, y, z = project(crate.pos)
                if z > 0 and x > -SCREEN_MARGIN and y > -SCREEN_MARGIN and x < vp.X + SCREEN_MARGIN and y < vp.Y + SCREEN_MARGIN then
                    if not label then
                        label = slot("Text", { Size = 13, Center = true, Outline = true })
                        CrateLabels[crate.model] = label
                    end
                    local text = C.Labels[crate.kind]
                    if C.Distance then
                        text = ("%s [%d]"):format(text, math.floor(dist + 0.5))
                    end
                    setProp(label, "Text", text)
                    setProp(label, "Color", C.Colors[crate.kind])
                    label.d.Position = Vector2.new(x, y)
                    on = true
                end
            end
        end
        if label then
            setVisible(label, on)
        end
    end
    if live then
        CrateLabelsGen = state.CratesGen
        for model, label in pairs(CrateLabels) do
            if not live[model] then
                removeSlot(label)
                CrateLabels[model] = nil
            end
        end
    end
end

local ObjectLabels = {}
local ObjectLabelsGen = -1

local function objectPos(inst)
    if inst:IsA("BasePart") then
        return inst.Position
    end
    if inst:IsA("Model") then
        local ok, cf = pcall(inst.GetBoundingBox, inst)
        if ok then
            return cf.Position
        end
    end
    return nil
end

local function refreshObjects(now)
    if now - state.ObjectsAt < config.Perf.EntityInterval then
        return
    end
    state.ObjectsAt = now
    local list = {}
    local V = config.Events
    for kind, folderName in pairs(V.Folders) do
        local f = workspace:FindFirstChild(folderName)
        if f then
            for _, m in ipairs(f:GetChildren()) do
                if objectPos(m) then
                    table.insert(list, { inst = m, group = "Event", kind = kind })
                end
            end
        end
    end
    local T = config.Traps
    local f = workspace:FindFirstChild(T.Folder)
    if f then
        for _, m in ipairs(f:GetChildren()) do
            local kind = m:GetAttribute("TrapKind")
            kind = type(kind) == "string" and kind or m.Name
            if T.Labels[kind] and objectPos(m) then
                table.insert(list, { inst = m, group = "Trap", kind = kind })
            end
        end
    end
    state.Objects = list
    state.ObjectsGen = state.ObjectsGen + 1
end

local function objectStyle(obj)
    if obj.group == "Event" then
        local V = config.Events
        if not (V.Enabled and V.Kinds[obj.kind]) then
            return nil
        end
        return V.Labels[obj.kind], V.Colors[obj.kind], V.MaxDistance, V.Distance, false
    end
    local T = config.Traps
    if not (T.Enabled and T.Kinds[obj.kind]) then
        return nil
    end
    return T.Labels[obj.kind], T.Color, T.MaxDistance, T.Distance, T.Health
end

local function drawObjects(camPos, vp)
    local live = ObjectLabelsGen ~= state.ObjectsGen and {} or nil
    for _, obj in ipairs(state.Objects) do
        local inst = obj.inst
        local label = ObjectLabels[inst]
        if live then
            live[inst] = true
        end
        local on = false
        local text, color, maxDist, showDist, showHp = objectStyle(obj)
        local pos = text and inst.Parent and objectPos(inst)
        if pos then
            local dist = (pos - camPos).Magnitude
            if dist <= maxDist then
                local x, y, z = project(pos)
                if z > 0 and x > -SCREEN_MARGIN and y > -SCREEN_MARGIN and x < vp.X + SCREEN_MARGIN and y < vp.Y + SCREEN_MARGIN then
                    if not label then
                        label = slot("Text", { Size = 13, Center = true, Outline = true })
                        ObjectLabels[inst] = label
                    end
                    if showHp then
                        local hp, maxHp = tonumber(inst:GetAttribute("ThingHealth")), tonumber(inst:GetAttribute("ThingMaxHealth"))
                        if hp and maxHp and maxHp > 0 then
                            text = ("%s %d/%d"):format(text, math.floor(hp + 0.5), math.floor(maxHp + 0.5))
                        end
                    end
                    if showDist then
                        text = ("%s [%d]"):format(text, math.floor(dist + 0.5))
                    end
                    setProp(label, "Text", text)
                    setProp(label, "Color", color)
                    label.d.Position = Vector2.new(x, y)
                    on = true
                end
            end
        end
        if label then
            setVisible(label, on)
        end
    end
    if live then
        ObjectLabelsGen = state.ObjectsGen
        for inst, label in pairs(ObjectLabels) do
            if not live[inst] then
                removeSlot(label)
                ObjectLabels[inst] = nil
            end
        end
    end
end

local Marker = slot("Circle", { Radius = 4, Filled = true, Thickness = 1 })
local MarkerText = slot("Text", { Size = 13, Center = true, Outline = true })

local function heldGunBallistics()
    local tool = utility.equippedTool()
    if not tool then
        return nil
    end
    local N = config.Native
    for i = #state.FirearmsClosures, 1, -1 do
        local f = state.FirearmsClosures[i]
        if up(f, N.FirearmsToolUpvalue) == tool then
            local s = up(f, N.FirearmsStatsUpvalue)
            if type(s) == "table" and tonumber(s.speed) and tonumber(s.gravity) then
                return s.speed, s.gravity, tonumber(s.range) or 1500
            end
        end
    end
    for _, f in ipairs(state.DoubleBarrelClosures) do
        local holder = findUpvalue(f, 3, aim.isToolHolder)
        if holder and holder.tool == tool then
            local shell = aim.doubleBarrelShell(f, tool)
            if shell then
                return shell.speed, aim.doubleBarrelGravity(), tonumber(shell.range) or 200
            end
        end
    end
    return nil
end

local function markerCast(p, d)
    local r = workspace:Raycast(p, d, entities.markerRay)
    return r and r.Position
end

local function updateDropMarker(now, camCF)
    if now - state.MarkerAt < config.Perf.MarkerInterval then
        return
    end
    state.MarkerAt = now
    local E = config.Esp
    local shown = false
    if E.Enabled and E.DropMarker then
        local speed, gravity, range = heldGunBallistics()
        if speed and speed > 0 then
            local camPos = camCF.Position
            local hitPos, flight = ballistics.simulateImpact(camPos, camCF.LookVector, speed, gravity, range / speed * 1.15, markerCast, config.Perf.MarkerStep)
            if hitPos then
                local x, y, z = project(hitPos)
                if z > 0 then
                    local sp = Vector2.new(x, y)
                    setProp(Marker, "Color", E.Colors.Marker)
                    Marker.d.Position = sp
                    setProp(MarkerText, "Color", E.Colors.Marker)
                    setProp(MarkerText, "Text", ("%d  %.2fs"):format(math.floor((hitPos - camPos).Magnitude + 0.5), flight))
                    MarkerText.d.Position = sp + Vector2.new(0, 8)
                    shown = true
                end
            end
        end
    end
    setVisible(Marker, shown)
    setVisible(MarkerText, shown)
end

function Esp.draw(now)
    local E = config.Esp
    local camCF = Camera.CFrame
    local camPos = camCF.Position
    local vp = Camera.ViewportSize

    local live = EntriesGen ~= state.EntitiesGen and {} or nil
    for _, ent in ipairs(state.Entities) do
        if live then
            live[ent.model] = true
        end
        if E.Enabled and E.Kinds[ent.kind] and entities.alive(ent) then
            drawEntity(ent, camCF, camPos, vp)
        else
            local e = Entries[ent.model]
            if e then
                hideEntry(e)
            end
        end
    end
    if live then
        EntriesGen = state.EntitiesGen
        for model in pairs(Entries) do
            if not live[model] then
                removeEntry(model)
            end
        end
    end

    refreshCrates(now)
    drawCrates(camPos, vp)
    refreshObjects(now)
    drawObjects(camPos, vp)
    updateDropMarker(now, camCF)
end

function Esp.cleanup()
    for model in pairs(Entries) do
        removeEntry(model)
    end
    for model, label in pairs(CrateLabels) do
        removeSlot(label)
        CrateLabels[model] = nil
    end
    for inst, label in pairs(ObjectLabels) do
        removeSlot(label)
        ObjectLabels[inst] = nil
    end
    removeSlot(Marker)
    removeSlot(MarkerText)
end

return Esp

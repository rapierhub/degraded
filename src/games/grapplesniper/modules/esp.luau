local config = require("@core/config")
local state = require("@core/state")
local entities = require("@modules/entities")
local aim = require("@modules/aim")

local Camera = workspace.CurrentCamera

local Esp = {}

local HEALTH_LOW, HEALTH_HIGH = Color3.fromRGB(255, 60, 60), Color3.fromRGB(60, 255, 90)
local SCREEN_MARGIN = 200

local BONES = {
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

local Entries = {}
local EntriesGen = -1

local function project(pos)
    local v = Camera:WorldToViewportPoint(pos)
    return v.X, v.Y, v.Z
end

local function slot(class, props)
    local d = Drawing.new(class)
    for k, v in pairs(props) do
        d[k] = v
    end
    d.Visible = false
    return { d = d, shown = false }
end

local function setVisible(s, on)
    if s.shown ~= on then
        s.shown = on
        s.d.Visible = on
    end
end

local function setProp(s, key, value)
    if s[key] ~= value then
        s[key] = value
        s.d[key] = value
    end
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
        info = slot("Text", { Size = 12, Center = true, Outline = true }),
        hpBack = slot("Square", { Filled = true, Color = Color3.new(0, 0, 0), Transparency = 0.6 }),
        hpFill = slot("Square", { Filled = true }),
        hpText = slot("Text", { Size = 11, Center = false, Outline = true }),
        tracer = nil,
        bones = nil,
        visible = false,
    }
end

local function eachSlot(e, fn)
    fn(e.box)
    fn(e.name)
    fn(e.info)
    fn(e.hpBack)
    fn(e.hpFill)
    fn(e.hpText)
    if e.tracer then
        fn(e.tracer)
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

-- The rig's bounding box includes gear (rifles, packs), so box only the body parts.
local BOX_PARTS = { "Head", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftLowerArm", "RightLowerArm" }
local HEAD_TOP = 0.9
local BOX_PAD = 0.12

local function screenBox(model)
    local head = model:FindFirstChild("Head")
    if not (head and head:IsA("BasePart")) then
        return nil
    end
    local x0, y0, x1, y1 = math.huge, math.huge, -math.huge, -math.huge
    local sum, n = Vector3.zero, 0
    local function add(pos)
        local x, y, z = project(pos)
        if z <= 0 then
            return false
        end
        x0, y0, x1, y1 = math.min(x0, x), math.min(y0, y), math.max(x1, x), math.max(y1, y)
        return true
    end
    if not add(head.Position + Vector3.yAxis * HEAD_TOP) then
        return nil
    end
    for _, name in ipairs(BOX_PARTS) do
        local p = model:FindFirstChild(name)
        if p and p:IsA("BasePart") then
            if not add(p.Position) then
                return nil
            end
            sum, n = sum + p.Position, n + 1
        end
    end
    if n < 3 then
        return nil
    end
    local padX, padY = (x1 - x0) * BOX_PAD + 2, (y1 - y0) * BOX_PAD * 0.5
    return x0 - padX, y0 - padY, x1 + padX, y1 + padY, sum / n
end

local function drawSkeleton(e, model, color)
    if not e.bones then
        e.bones = {}
        for i = 1, #BONES do
            e.bones[i] = slot("Line", { Thickness = 1 })
        end
    end
    for i, bone in ipairs(BONES) do
        local s = e.bones[i]
        local a, b = aim.part(model, bone[1]), aim.part(model, bone[2])
        local on = false
        if a and b then
            local ax, ay, az = project(a.Position)
            local bx, by, bz = project(b.Position)
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

local function drawEntity(ent, camPos, vp)
    local E = config.Esp
    local model, hum = ent.model, ent.humanoid
    local e = Entries[model]
    if not e then
        e = newEntry()
        Entries[model] = e
    end
    local x0, y0, x1, y1, center = screenBox(model)
    if not x0 then
        hideEntry(e)
        return
    end
    local dist = (center - camPos).Magnitude
    if dist > E.MaxDistance or x1 < -SCREEN_MARGIN or y1 < -SCREEN_MARGIN or x0 > vp.X + SCREEN_MARGIN or y0 > vp.Y + SCREEN_MARGIN then
        hideEntry(e)
        return
    end
    e.visible = true
    local color = entities.isTeammate(ent) and E.Colors.Team or E.Colors[ent.kind]

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

    local tool = E.HeldItem and entities.heldItem(ent)
    setVisible(e.info, tool ~= nil and tool ~= false)
    if tool then
        setProp(e.info, "Text", tool)
        setProp(e.info, "Color", color)
        e.info.d.Position = Vector2.new((x0 + x1) * 0.5, y1 + 2)
    end

    local showHp = E.Health and ent.kind == "Player"
    setVisible(e.hpBack, showHp)
    setVisible(e.hpFill, showHp)
    setVisible(e.hpText, showHp)
    if showHp then
        local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local h = y1 - y0
        local hpColor = HEALTH_LOW:Lerp(HEALTH_HIGH, frac)
        e.hpBack.d.Position = Vector2.new(x0 - 6, y0)
        e.hpBack.d.Size = Vector2.new(3, h)
        setProp(e.hpFill, "Color", hpColor)
        e.hpFill.d.Position = Vector2.new(x0 - 6, y0 + h * (1 - frac))
        e.hpFill.d.Size = Vector2.new(3, h * frac)
        setProp(e.hpText, "Text", tostring(math.floor(hum.Health + 0.5)))
        setProp(e.hpText, "Color", hpColor)
        local bounds = e.hpText.d.TextBounds
        e.hpText.d.Position = Vector2.new(x0 - 9 - (bounds and bounds.X or 0), y0 + h * (1 - frac) - 6)
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
        drawSkeleton(e, model, color)
    elseif e.bones then
        for _, s in ipairs(e.bones) do
            setVisible(s, false)
        end
    end
end

function Esp.draw()
    local E = config.Esp
    local camPos = Camera.CFrame.Position
    local vp = Camera.ViewportSize
    local now = os.clock()
    local live = EntriesGen ~= state.EntitiesGen and {} or nil
    for _, ent in ipairs(state.Entities) do
        if live then
            live[ent.model] = true
        end
        if E.Enabled and E.Kinds[ent.kind] and entities.alive(ent) and not (E.TeamCheck and entities.isTeammate(ent))
            and (not E.HideStale or entities.fresh(ent, now)) then
            drawEntity(ent, camPos, vp)
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
end

function Esp.cleanup()
    for model in pairs(Entries) do
        removeEntry(model)
    end
end

return Esp

local Ballistics = {}

function Ballistics.finiteVec(v)
    return v.X == v.X and v.Y == v.Y and v.Z == v.Z
        and math.abs(v.X) < 1e6 and math.abs(v.Y) < 1e6 and math.abs(v.Z) < 1e6
end

function Ballistics.solveBallistic(origin, targetPos, targetVel, speed, gravity, iterations)
    if speed <= 0 then
        return targetPos, 0
    end
    local t = (targetPos - origin).Magnitude / speed
    local aim = targetPos
    for _ = 1, iterations or 5 do
        local future = targetPos + targetVel * t
        aim = future + Vector3.new(0, 0.5 * gravity * t * t, 0)
        t = (aim - origin).Magnitude / speed
    end
    return aim, t
end

function Ballistics.simulateImpact(origin, dir, speed, gravity, maxTime, castFn, dt)
    dt = dt or 1 / 120
    local pos, vel, t = origin, dir * speed, 0
    local dv = Vector3.new(0, -gravity * dt, 0)
    while t < maxTime do
        local nextVel = vel + dv
        local step = (vel + nextVel) * (0.5 * dt)
        local hit = castFn(pos, step)
        if hit then
            return hit, t
        end
        pos, vel, t = pos + step, nextVel, t + dt
    end
    return nil
end

local BOX_CORNERS = {}
for _, sx in ipairs({ -1, 1 }) do
    for _, sy in ipairs({ -1, 1 }) do
        for _, sz in ipairs({ -1, 1 }) do
            table.insert(BOX_CORNERS, Vector3.new(sx, sy, sz))
        end
    end
end

function Ballistics.screenBounds(cf, size, project)
    local half = size * 0.5
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for i = 1, 8 do
        local x, y, z = project(cf:PointToWorldSpace(BOX_CORNERS[i] * half))
        if z <= 0 then
            return nil
        end
        minX, maxX = math.min(minX, x), math.max(maxX, x)
        minY, maxY = math.min(minY, y), math.max(maxY, y)
    end
    return minX, minY, maxX, maxY
end

return Ballistics

local Ballistics = {}

function Ballistics.finite(n)
    return type(n) == "number" and n == n and math.abs(n) < 1e9
end

function Ballistics.launchAngle(horizontal, height, velocity, gravity)
    if horizontal < 1e-3 then
        return height >= 0 and math.pi / 2 or -math.pi / 2, math.abs(height) / velocity
    end
    local v2 = velocity * velocity
    local disc = v2 * v2 - gravity * (gravity * horizontal * horizontal + 2 * height * v2)
    if disc < 0 then
        return nil
    end
    local angle = math.atan((v2 - math.sqrt(disc)) / (gravity * horizontal))
    return angle, horizontal / (velocity * math.cos(angle))
end

function Ballistics.solve(ox, oy, oz, tx, ty, tz, vx, vy, vz, velocity, gravity, iterations)
    local ax, ay, az = tx, ty, tz
    local angle, time
    for i = 1, iterations do
        local dx, dz = ax - ox, az - oz
        angle, time = Ballistics.launchAngle(math.sqrt(dx * dx + dz * dz), ay - oy, velocity, gravity)
        if not angle then
            return nil
        end
        if i < iterations then
            ax, ay, az = tx + vx * time, ty + vy * time, tz + vz * time
        end
    end
    return angle, math.atan2(-(ax - ox), -(az - oz)), time
end

function Ballistics.zeroAngle(zero, velocity, gravity)
    local s = zero * gravity / (velocity * velocity)
    if s ~= s or math.abs(s) > 1 then
        return 0
    end
    return math.asin(s) * 0.5
end

return Ballistics

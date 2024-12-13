local function solve_system(m1, m2, p, c)
    local m1x, m1y = table.unpack(m1)
    local m2x, m2y = table.unpack(m2)
    local x0, y0 = table.unpack(p)
    x0 = x0 + c
    y0 = y0 + c

    local numerator = -x0 * m2y * m1x + y0 * m1x * m2x
    local denominator = m1y * m2x - m2y * m1x

    if numerator % denominator ~= 0 then
        return nil
    end

    local x = numerator / denominator
    x = math.floor(x + 0.5)

    if x % m1x ~= 0 or (x0 - x) % m2x ~= 0 then
        return nil
    end

    local c1 = x / m1x
    local c2 = (x0 - x) / m2x

    return c1, c2
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local slopes1 = {}
local slopes2 = {}
local points = {}
for line in file:lines() do
    if line == "" then goto continue end

    local vals = {}
    for val in line:gmatch("%d+") do
        table.insert(vals, tonumber(val))
    end

    if line:find("Button A:") then
        table.insert(slopes1, vals)
    elseif line:find("Button B:") then
        table.insert(slopes2, vals)
    else
        table.insert(points, vals)
    end

    ::continue::
end

io.input():close()

local part1, part2 = 0, 0
local beeg = 10000000000000

for i = 1, #slopes1 do
    -- part 1 calculation
    local c1, c2 = solve_system(slopes1[i], slopes2[i], points[i], 0)
    if c1 and c2 and c1 <= 100 and c2 <= 100 then
        part1 = part1 + 3 * c1 + c2
    end
    -- part 2 calculation
    c1, c2 = solve_system(slopes1[i], slopes2[i], points[i], beeg)
    if c1 and c2 then
        part2 = part2 + 3 * c1 + c2
    end
end

print(string.format("%0.f",part1))
print(string.format("%0.f",part2))
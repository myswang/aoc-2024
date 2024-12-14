local w = 101
local h = 103
local w_mid = w // 2
local h_mid = h // 2
local t = 100

local function sim_robot(robot, time)
    local x, y, dx, dy = table.unpack(robot)
    x = (x + dx * time) % w
    y = (y + dy * time) % h
    return x, y
end

local function print_space(space)
    for i = 1, h do
        for j = 1, w do
            local val = space[i][j]
            if val == 0 then
                io.write(".")
            else
                io.write(val)
            end
        end
        io.write("\n")
    end
end

local function do_iteration(robots, time, print_safety)
    local space = {}
    for i = 1, h do
        space[i] = {}
        for j = 1, w do
            space[i][j] = 0
        end
    end

    local quads = { 0, 0, 0, 0 }
    for _, robot in ipairs(robots) do
        -- print(string.format("robot %d: d: (%d, %d), v: (%d, %d)", i, table.unpack(robot)))
        local x, y = sim_robot(robot, time)
        space[y + 1][x + 1] = space[y + 1][x + 1] + 1
        -- print(x, y)
        if x < w_mid and y < h_mid then
            quads[1] = quads[1] + 1
        elseif x < w_mid and y > h_mid then
            quads[2] = quads[2] + 1
        elseif x > w_mid and y < h_mid then
            quads[3] = quads[3] + 1
        elseif x > w_mid and y > h_mid then
            quads[4] = quads[4] + 1
        end
    end

    if print_safety then
        local safety_factor = 1
        for _, val in ipairs(quads) do
            safety_factor = safety_factor * val
        end
        print(safety_factor)
    end

    print_space(space)
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local robots = {}
for line in file:lines() do
    table.insert(robots, {})
    for val in line:gmatch("-?%d+") do
        table.insert(robots[#robots], tonumber(val))
    end
end

io.input():close()


-- do_iteration(robots, 100, true)

-- brute force to look for the tree
for i = 1, 10000 do
    print(i)
    do_iteration(robots, i, false)
    print("\n")
end

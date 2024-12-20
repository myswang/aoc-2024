-- https://github.com/Tieske/binaryheap.lua
local heap = require("binaryheap")

local mem = {}
local bytes = {}
local h, w = 71, 71
local start = {1, 1}
local finish = {h, w}

local function parse_file(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Failed to open file.")
        os.exit(1)
    end

    for line in file:lines() do
        local x = tonumber(line:match("^%d+"))
        local y = tonumber(line:match("%d+$"))
        table.insert(bytes, {y+1, x+1})
    end

    io.input():close()

    for i = 1, h do
        mem[i] = {}
        for j = 1, w do
            mem[i][j] = "."
        end
    end

    for i = 1, #bytes do
        local y, x = table.unpack(bytes[i])
        mem[y][x] = "#"
    end
end

local function heuristic(a, b)
    return math.abs(b[1] - a[1]) + math.abs(b[2] - a[2])
end

local function a_star()
    local dirs = {
        {0, 1},
        {1, 0},
        {0, -1},
        {-1, 0}
    }
    local pq = heap.minHeap(function (a, b) return a[1] < b[1] end)
    local visited = {}
    pq:insert({0 + heuristic(start, finish), 0, start[1], start[2]})

    while pq:size() > 0 do
        local next = pq:pop()
        if next == nil then
            break
        end
        local _, cost, y, x = table.unpack(next)
        if y == finish[1] and x == finish[2] then
            return cost
        end

        if visited[y] and visited[y][x] and visited[y][x] <= cost then
            goto continue
        end

        if not visited[y] then
            visited[y] = {}
        end
        visited[y][x] = cost

        for _, dir in ipairs(dirs) do
            local ny, nx = y + dir[1], x + dir[2]
            if ny >= 1 and nx >= 1
           and ny <= h and nx <= w
           and mem[ny][nx] ~= "#" then
                local new_cost = cost + 1
                pq:insert({new_cost + heuristic({ny, nx}, finish), new_cost, ny, nx})
            end
        end

        ::continue::
    end

    return math.huge
end

parse_file("input.txt")

for i = #bytes, 1, -1 do
    local y, x = table.unpack(bytes[i])
    mem[y][x] = "."
    if a_star() ~= math.huge then
        y = y-1
        x = x-1
        print(x..","..y)
        break
    end
end
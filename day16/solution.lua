-- https://github.com/Tieske/binaryheap.lua
local heap = require("binaryheap")

local function parse_maze(file_str)
    local maze = {}
    local start, finish
    local file = io.open(file_str, "r")
    if not file then
        print("Failed to open file.")
        return
    end

    for line in file:lines() do
        table.insert(maze, {})
        for char in line:gmatch(".") do
            table.insert(maze[#maze], char)
            if char == "S" then
                start = {#maze, #maze[#maze]}
            elseif char == "E" then
                finish = {#maze, #maze[#maze]}
            end
        end
    end

    io.input():close()

    return maze, start, finish
end

-- https://stackoverflow.com/questions/38965931/hash-function-for-3-integers
local function cantor(x, y)
    return (x + y + 1) * (x + y) // 2 + y
end

local function heuristic(a, b)
    return math.abs(a[1] - b[1]) + math.abs(a[2] - b[2])
end

local function a_star(maze, start, finish)
    local dirs = {
        {0, 1},
        {1, 0},
        {0, -1},
        {-1, 0}
    }

    local pq = heap.minHeap(function(a, b) return a[1] < b[1] end)
    pq:insert({0 + heuristic(start, finish), 0, start[1], start[2], 1, {}})
    local visited = {}
    local min_cost = math.huge
    local min_paths = {}

    while pq:size() > 0 do
        local next = pq:pop()
        if next == nil then
            break
        end
        local _, cost, y, x, facing, path = table.unpack(next)
        local new_path = {}
        for _, pos in ipairs(path) do
            table.insert(new_path, pos)
        end
        table.insert(new_path, cantor(y, x))

        if cost > min_cost then
            goto continue
        end

        if y == finish[1] and x == finish[2] then
            if cost < min_cost then
                min_cost = cost
            end
            table.insert(min_paths, new_path)
            goto continue
        end

        local state = cantor(cantor(y, x), facing)
        if visited[state] ~= nil and visited[state] < cost then
            goto continue
        end
        visited[state] = cost

        for i, dir in ipairs(dirs) do
            local ny, nx = y + dir[1], x + dir[2]
            if maze[ny][nx] ~= "#" then
                local new_cost = cost + 1
                if facing ~= i then
                    local turns = math.abs(facing - i) % 4
                    if turns == 3 then
                        turns = 1
                    end
                    new_cost = new_cost + turns * 1000
                end
                pq:insert({new_cost + heuristic({ny, nx}, finish), new_cost, ny, nx, i, new_path})
            end
        end

        ::continue::
    end
    return min_cost, min_paths
end

local maze, start, finish = parse_maze("input.txt")
local min_cost, min_paths = a_star(maze, start, finish)
print(min_cost)

local unique_tiles = {}
local unique_count = 0
for _, path in ipairs(min_paths) do
    for _, pos in ipairs(path) do
        if unique_tiles[pos] == nil then
            unique_tiles[pos] = true
            unique_count = unique_count + 1
        end
    end
end

print(unique_count)
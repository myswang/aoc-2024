local offsets = {
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
}

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local garden = {}
local visited = {}
for line in file:lines() do
    table.insert(garden, {})
    table.insert(visited, {})
    for char in line:gmatch(".") do
        table.insert(garden[#garden], char)
        table.insert(visited[#visited], false)
    end
end

io.input():close()

local function count_edges(edges)
    local edge_count = 0
    for _, list in pairs(edges) do
        edge_count = edge_count + 1
        table.sort(list)

        for i = 1, #list do
            if i ~= 1 and list[i] - list[i - 1] > 1 then
                edge_count = edge_count + 1
            end
        end

    end
    return edge_count
end

local function get_edge_count(edge_points)
    local vert_edges = {}
    local hori_edges = {}

    for _, point in ipairs(edge_points) do
        local y, x, dy, dx = table.unpack(point)
        if math.abs(dy) == 1 then
            if hori_edges[y] == nil then
                hori_edges[y] = {}
            end
            table.insert(hori_edges[y], x*dy)
        elseif math.abs(dx) == 1 then
            if vert_edges[x] == nil then
                vert_edges[x] = {}
            end
            table.insert(vert_edges[x], y*dx)
        end
    end

    return count_edges(vert_edges) + count_edges(hori_edges)
end

local function flood_fill(y, x)
    local area = 0
    local perimeter = 0
    local stack = {{y, x}}
    local edge_points = {}
    visited[y][x] = true

    while #stack > 0 do
        local y0, x0 = table.unpack(table.remove(stack))
        area = area + 1

        for _, offset in ipairs(offsets) do
            local dy, dx = table.unpack(offset)
            local y1, x1 = y0 + dy, x0 + dx
            if y1 < 1 or x1 < 1 or y1 > #garden or x1 > #garden[1] or garden[y1][x1] ~= garden[y0][x0] then
                table.insert(edge_points, {y1, x1, dy, dx})
                perimeter = perimeter + 1
            elseif not visited[y1][x1] then
                visited[y1][x1] = true
                table.insert(stack, {y1, x1})
            end
        end
    end

    return area * perimeter, area * get_edge_count(edge_points)
end

local part1, part2 = 0, 0
for i = 1, #visited do
    for j = 1, #visited[1] do
        if not visited[i][j] then
            local cost1, cost2 = flood_fill(i, j)
            part1 = part1 + cost1
            part2 = part2 + cost2
        end
    end
end

print("Part 1: "..part1)
print("Part 2: "..part2)
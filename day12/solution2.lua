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
    for i = 1, line:len() do
        local val = line:sub(i, i)
        table.insert(garden[#garden], val)
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
            if i ~= 1 then
                local delta = list[i] - list[i - 1]
                if delta > 1 then
                    edge_count = edge_count + 1
                end
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
    local plot_type = garden[y][x]
    local stack = {{y, x}}
    local edge_points = {}
    visited[y][x] = true

    while #stack > 0 do
        local y0, x0 = table.unpack(table.remove(stack))
        area = area + 1

        for _, offset in ipairs(offsets) do
            local dy, dx = table.unpack(offset)
            local y1, x1 = y0 + dy, x0 + dx
            if y1 >= 1 and x1 >= 1 and y1 <= #garden and x1 <= #garden[1] then
                if garden[y1][x1] ~= plot_type then
                    table.insert(edge_points, {y1, x1, dy, dx})
                elseif not visited[y1][x1] then
                    visited[y1][x1] = true
                    table.insert(stack, {y1, x1})
                end
            else
                table.insert(edge_points, {y1, x1, dy, dx})
            end
        end
    end
    local perimeter = get_edge_count(edge_points)

    local cost = area * perimeter
    return cost
end

local total_cost = 0
for i = 1, #visited do
    for j = 1, #visited[1] do
        if not visited[i][j] then
            total_cost = total_cost + flood_fill(i, j)
        end
    end
end

print(total_cost)



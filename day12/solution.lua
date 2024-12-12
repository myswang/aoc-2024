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

local function flood_fill(y, x)
    local area, perimeter = 0, 0
    local plot_type = garden[y][x]
    local stack = {{y, x}}
    visited[y][x] = true

    while #stack > 0 do
        local y0, x0 = table.unpack(table.remove(stack))
        area = area + 1

        for _, offset in ipairs(offsets) do
            local dy, dx = table.unpack(offset)
            local y1, x1 = y0 + dy, x0 + dx
            if y1 >= 1 and x1 >= 1 and y1 <= #garden and x1 <= #garden[1] then
                if garden[y1][x1] ~= plot_type then
                    perimeter = perimeter + 1
                elseif not visited[y1][x1] then
                    visited[y1][x1] = true
                    table.insert(stack, {y1, x1})
                end
            else
                perimeter = perimeter + 1
            end
        end
    end
    local cost = area * perimeter
    -- print(plot_type, area, perimeter, cost)
    return cost
end

-- print("type", "area", "pmeter", "cost")
local total_cost = 0
for i = 1, #visited do
    for j = 1, #visited[1] do
        if not visited[i][j] then
            total_cost = total_cost + flood_fill(i, j)
        end
    end
end

print(total_cost)




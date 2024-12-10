local lab_map = {}
local start_guard_y, start_guard_x
local dirs = {
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
}

local function traverse_lab_map(lab_map, start_y, start_x)
    local unique_cells = {}
    local cur_dir = 1
    while start_y >= 1 and start_x >= 1 and start_y <= #lab_map and start_x <= #lab_map[1] do
        local cell = lab_map[start_y][start_x]

        if cell == 0 then -- unvisited cell
            table.insert(unique_cells, {start_y, start_x})
            lab_map[start_y][start_x] = cur_dir -- set to first dir encountered
        elseif cell == -1 then -- backout & turn 90 degrees clockwise
            start_y = start_y - dirs[cur_dir][1]
            start_x = start_x - dirs[cur_dir][2]
            cur_dir = (cur_dir + 1) % (#dirs + 1)
            if cur_dir == 0 then
                cur_dir = 1
            end
        elseif cell == cur_dir then -- cycle check
            return {}
        end
        -- update guard positon
        start_y = start_y + dirs[cur_dir][1]
        start_x = start_x + dirs[cur_dir][2]
    end
    return unique_cells
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

for line in file:lines() do
    table.insert(lab_map, {})
    local cell = 0
    for i = 1, line:len() do
        local char = line:sub(i, i)
        if char == "." then
            cell = 0
        elseif char == "^" then
            cell = 0
            start_guard_y = #lab_map
            start_guard_x = i
        elseif char == "#" then
            cell = -1
        end
        table.insert(lab_map[#lab_map], cell)
    end
end

io.input():close()

-- part 1
local unique_cells = traverse_lab_map(lab_map, start_guard_y, start_guard_x)
print(#unique_cells)

-- part 2
local cycle_count = 0
local prev_pos = nil
for _, pos in ipairs(unique_cells) do
    local pos_y = pos[1]
    local pos_x = pos[2]

    -- avoid putitng obstacle at initial guard pos
    if pos_y == start_guard_y and pos_x == start_guard_x then
        goto continue
    end

    -- reset lab_map to original state
    for i = 1, #lab_map do
        for j = 1, #lab_map[1] do
            if lab_map[i][j] ~= -1 then
                lab_map[i][j] = 0
            end
        end
    end
    if prev_pos ~= nil then
        lab_map[prev_pos[1]][prev_pos[2]] = 0
    end

    -- apply new obstacle and test it for cycles
    lab_map[pos_y][pos_x] = -1
    if #traverse_lab_map(lab_map, start_guard_y, start_guard_x) == 0 then
        cycle_count = cycle_count + 1
    end

    prev_pos = pos

    ::continue::
end

print(cycle_count)


local dirs = {
    ["^"] = { -1, 0 },
    [">"] = { 0, 1 },
    ["v"] = { 1, 0 },
    ["<"] = { 0, -1 }
}
local wh, mv = {}, {}
local y, x

local function push_hori(dy, dx)
    local tmp_y, tmp_x = y + dy, x + dx
    while wh[tmp_y][tmp_x] ~= "#" do
        if wh[tmp_y][tmp_x] == "." then
            while wh[tmp_y - dy][tmp_x - dx] ~= "@" do
                wh[tmp_y][tmp_x] = wh[tmp_y - dy][tmp_x - dx]
                wh[tmp_y - dy][tmp_x - dx] = wh[tmp_y - 2 * dy][tmp_x - 2 * dx]
                tmp_y = tmp_y - 2 * dy
                tmp_x = tmp_x - 2 * dx
            end
            wh[tmp_y][tmp_x] = "@"
            wh[tmp_y - dy][tmp_x - dx] = "."
            y = y + dy
            x = x + dx
            break
        end
        tmp_y = tmp_y + dy
        tmp_x = tmp_x + dx
    end
end

local function push_vert(dy, dx)
    local tmp_y, tmp_x = y + dy, x + dx
    if wh[tmp_y][tmp_x] == "]" then
        tmp_x = tmp_x - 1
    end

    local stack = { { tmp_y, tmp_x } }
    local visited = {}
    for i = 1, #wh do
        visited[i] = {}
        for j = 1, #wh[1] do
            visited[i][j] = false
        end
    end

    while #stack > 0 do
        local y0, x0 = table.unpack(table.remove(stack))
        visited[y0][x0] = true
        if wh[y0 + dy][x0] == "#" or wh[y0 + dy][x0 + 1] == "#" then
            return
        end

        if wh[y0 + dy][x0] == "[" and not visited[y0 + dy][x0] then
            table.insert(stack, { y0 + dy, x0 })
        end

        if wh[y0 + dy][x0 - 1] == "[" and not visited[y0 + dy][x0 - 1] then
            table.insert(stack, { y0 + dy, x0 - 1 })
        end
        if wh[y0 + dy][x0 + 1] == "[" and not visited[y0 + dy][x0 + 1] then
            table.insert(stack, { y0 + dy, x0 + 1 })
        end
    end

    for i = 1, #visited do
        for j = 1, #visited[1] do
            if visited[i][j] then
                wh[i][j] = "."
                wh[i][j+1] = "."
            end
        end
    end

    for i = 1, #visited do
        for j = 1, #visited[1] do
            if visited[i][j] then
                wh[i+dy][j] = "["
                wh[i+dy][j+1] = "]"
            end
        end
    end

    wh[y + dy][x + dx] = "@"
    wh[y][x] = "."
    y = y + dy
    x = x + dx
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

for line in file:lines() do
    if line:find("#") then
        table.insert(wh, {})
        for char in line:gmatch(".") do
            if char == "#" then
                table.insert(wh[#wh], "#")
                table.insert(wh[#wh], "#")
            elseif char == "O" then
                table.insert(wh[#wh], "[")
                table.insert(wh[#wh], "]")
            elseif char == "@" then
                table.insert(wh[#wh], "@")
                y, x = #wh, #wh[#wh]
                table.insert(wh[#wh], ".")
            else
                table.insert(wh[#wh], ".")
                table.insert(wh[#wh], ".")
            end
        end
    elseif line == "\n" then
        goto continue
    else
        for char in line:gmatch(".") do
            table.insert(mv, char)
        end
    end
    ::continue::
end

io.input():close()

for _, dir_str in ipairs(mv) do
    local dy, dx = table.unpack(dirs[dir_str])
    if wh[y + dy][x + dx] ~= "." then
        if dx == 0 and wh[y + dy][x + dx] ~= "#" then
            push_vert(dy, dx)
        else
            push_hori(dy, dx)
        end
    else
        wh[y + dy][x + dx] = "@"
        wh[y][x] = "."
        y = y + dy
        x = x + dx
    end
end

local res = 0
for i = 2, #wh - 1 do
    for j = 3, #wh[1] - 2 do
        if wh[i][j] == "[" then
            res = res + 100 * (i-1) + (j-1)
        end
    end
end

for _, line in ipairs(wh) do
    print(table.concat(line))
end

print(res)
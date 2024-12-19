local dirs = {
    ["^"] = {-1, 0},
    [">"] = {0, 1},
    ["v"] = {1, 0},
    ["<"] = {0, -1}
}

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local wh, mv = {}, {}
local y, x
for line in file:lines() do
    if line:find("#") then
        table.insert(wh, {})
        for char in line:gmatch(".") do
            table.insert(wh[#wh], char)
            local back = #wh[#wh]
            if char == "@" then
                -- wh[#wh][back] = "."
                y, x = #wh, back
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

for _, char in ipairs(mv) do
    -- print("next move: "..char)
    -- for _, line in ipairs(wh) do
    --     print(table.concat(line))
    -- end
    local dy, dx = table.unpack(dirs[char])
    if wh[y+dy][x+dx] == "O" or wh[y+dy][x+dx] == "#" then
        local tmp_y, tmp_x = y+dy, x+dx
        while wh[tmp_y][tmp_x] ~= "#" do
            if wh[tmp_y][tmp_x] == "." then
                wh[tmp_y][tmp_x] = "O"
                wh[y+dy][x+dx] = "@"
                wh[y][x] = "."
                y = y + dy
                x = x + dx
                break
            end
            tmp_y = tmp_y + dy
            tmp_x = tmp_x + dx
        end
    else
        wh[y+dy][x+dx] = "@"
        wh[y][x] = "."
        y = y + dy
        x = x + dx
    end
end

-- for _, line in ipairs(wh) do
--     print(table.concat(line))
-- end

-- print(table.concat(mv))

local res = 0
for i = 2, #wh - 1 do
    for j = 2, #wh[1] - 1 do
        if wh[i][j] == "O" then
            res = res + 100 * (i-1) + (j-1)
        end
    end
end

print(res)
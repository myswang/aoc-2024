local track = {}
local start, finish
local dirs = {
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
}

local function parse_file(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Failed to open file.")
        os.exit(1)
    end

    for line in file:lines() do
        table.insert(track, {})
        for char in line:gmatch(".") do
            table.insert(track[#track], char)
            if char == "S" then
                start = {#track, #track[#track]}
            elseif char == "E" then
                finish = {#track, #track[#track]}
            end
        end
    end

    io.input():close()
end

parse_file("input.txt")

local count = 0
while not (start[1] == finish[1] and start[2] == finish[2]) do
    local y, x = table.unpack(start)
    track[y][x] = count
    count = count + 1
    for _, dir in ipairs(dirs) do
        local ny, nx = y + dir[1], x + dir[2]
        if track[ny][nx] == "." or track[ny][nx] == "E" then
            start[1] = ny
            start[2] = nx
            break
        end
    end
end
track[finish[1]][finish[2]] = count

-- iterate in the x direction
local cheat_count = 0
for i = 2, #track - 1 do
    for j = 2, #track[1] - 3 do
        local left = track[i][j]
        local mid = track[i][j+1]
        local right = track[i][j+2]
        if left ~= "#" and mid == "#" and right ~= "#" then
            local diff = math.abs(tonumber(right) - tonumber(left)) - 2
            if diff >= 100 then
                cheat_count = cheat_count + 1
            end
        end
    end
end

for i = 2, #track[1] - 3 do
    for j = 2, #track - 1 do
        local left = track[i][j]
        local mid = track[i+1][j]
        local right = track[i+2][j]
        if left ~= "#" and mid == "#" and right ~= "#" then
            local diff = math.abs(tonumber(right) - tonumber(left)) - 2
            if diff >= 100 then
                cheat_count = cheat_count + 1
            end
        end
    end
end

print(cheat_count)
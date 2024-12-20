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
local positions = {}
while not (start[1] == finish[1] and start[2] == finish[2]) do
    local y, x = table.unpack(start)
    track[y][x] = count
    table.insert(positions, {y, x})
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
table.insert(positions, {finish[1], finish[2]})

local counter, counter2 = 0, 0
for i = 1, #positions do
    local y0, x0 = table.unpack(positions[i])
    for j = i, #positions do
        local y, x = table.unpack(positions[j])
        local dist = math.abs(y - y0) + math.abs(x - x0)
        if dist <= 2 then
            local diff = math.abs(track[y][x] - track[y0][x0]) - dist
            if diff >= 100 then
                counter = counter + 1
            end
        end
        if dist <= 20 then
            local diff = math.abs(track[y][x] - track[y0][x0]) - dist
            if diff >= 100 then
                counter2 = counter2 + 1
            end
        end
    end
end

print(counter)
print(counter2)
-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local antennas = {}
local antinodes = {}
local y = 1
for line in file:lines() do
    table.insert(antinodes, {})
    local x = 1
    for char in line:gmatch(".") do
        if char ~= "." then
            if antennas[char] == nil then
                antennas[char] = {}
            end
            table.insert(antennas[char], {y, x})
        end
        table.insert(antinodes[#antinodes], ".")
        x = x + 1
    end
    y = y + 1
end

io.input():close()

local result = 0
for _, positions in pairs(antennas) do
    for i = 1, #positions do
        for j = i, #positions do
            if i == j then
                goto continue
            end
            local pos1 = positions[i]
            local pos2 = positions[j]

            local dist_y = pos1[1] - pos2[1]
            local dist_x = pos1[2] - pos2[2]

            local anti_y = pos1[1]
            local anti_x = pos1[2]
            while anti_y >= 1 and anti_x >= 1 and anti_y <= #antinodes and anti_x <= #antinodes[1] do
                if antinodes[anti_y][anti_x] == "." then
                    antinodes[anti_y][anti_x] = "#"
                    result = result + 1
                end
                anti_y = anti_y + dist_y
                anti_x = anti_x + dist_x
            end

            anti_y = pos1[1]
            anti_x = pos1[2]
            while anti_y >= 1 and anti_x >= 1 and anti_y <= #antinodes and anti_x <= #antinodes[1] do
                if antinodes[anti_y][anti_x] == "." then
                    antinodes[anti_y][anti_x] = "#"
                    result = result + 1
                end
                anti_y = anti_y - dist_y
                anti_x = anti_x - dist_x
            end

            ::continue::
        end
    end
end

-- for _, line in ipairs(antinodes) do
--     for _, val in ipairs(line) do
--         io.write(val)
--     end
--     io.write("\n")
-- end

print(result)
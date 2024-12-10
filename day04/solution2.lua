-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local words = {}
for line in file:lines() do
    table.insert(words, {})
    for char in line:gmatch(".") do
        table.insert(words[#words], char)
    end
end

io.input():close()

local xmas_count = 0
for i = 1, #words - 2 do
    for j = 1, #words[i] - 2 do
        local cross1 = words[i][j]..words[i+1][j+1]..words[i+2][j+2]
        local cross2 = words[i][j+2]..words[i+1][j+1]..words[i+2][j]
        if (cross1 == "MAS" or cross1 == "SAM") and (cross2 == "MAS" or cross2 == "SAM") then
            xmas_count = xmas_count + 1
        end
    end
end

print(xmas_count)
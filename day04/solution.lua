local offsets = {
    {1, 0},
    {0, 1},
    {1, 1},
    {1, -1}
}

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local words = {}
for line in file:lines() do
    table.insert(words, "")
    for char in line:gmatch(".") do
        words[#words] = words[#words]..char
    end
end

io.input():close()

local xmas_count = 0
for i, line in ipairs(words) do
    for j = 1, line:len() do
        for _, offset in ipairs(offsets) do
            local temp = ""
            for k = 0, 3 do
                local i1 = i + offset[1] * k
                local j1 = j + offset[2] * k
                if i1 >= 1 and j1 >= 1 and i1 <= #words and j1 <= line:len() then
                    temp = temp..words[i1]:sub(j1, j1)
                end
            end
            if temp:len() == 4 and temp == "XMAS" or temp:reverse() == "XMAS" then
                xmas_count = xmas_count + 1
            end
        end
    end
end

print(xmas_count)
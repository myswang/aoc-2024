-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local result = 0
for line in file:lines() do
    for match in line:gmatch("mul%(%d+,%d+%)") do
        local temp = 1
        for val in match:gmatch("%d+") do
            temp = temp * val
        end
        result = result + temp
    end
end

io.input():close()
print(result)
-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local disk_str = file:read()
io.input():close()

local disk = {}
local counter = 0
for val in disk_str:gmatch("%d") do
    local blk_id = -1
    if counter % 2 == 0 then
        blk_id = counter // 2
    end

    for _ = 1, val do
        table.insert(disk, blk_id)
    end
    counter = counter + 1
end

local left = 1
while left < #disk do
    if disk[left] == -1 then
        if disk[#disk] ~= -1 then
            disk[left] = disk[#disk]
            left = left + 1
        end
        table.remove(disk)
    else
        left = left + 1
    end
end

if disk[#disk] == -1 then
    table.remove(disk)
end

local result = 0
for idx, val in ipairs(disk) do
    result = result + (idx-1) * val
end

for _, val in ipairs(disk) do
    if val == -1 then
        io.write(".")
    else
        io.write("("..val..")")
    end
end
io.write("\n")

print(result)
-- Day 9 Part 2 solution
-- (array method)

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local disk_str = file:read()
io.input():close()

local disk = {}
local file_locs = {}
local counter = 0
local disk_ptr = 1
for val in disk_str:gmatch("%d") do
    local blk_id = -1
    if counter % 2 == 0 then
        blk_id = math.floor(counter / 2)
        table.insert(file_locs, {pos=disk_ptr, len=tonumber(val)})
    end

    for _ = 1, val do
        table.insert(disk, blk_id)
        disk_ptr = disk_ptr + 1
    end
    counter = counter + 1
end

for i = #file_locs, 1, -1 do
    local id = i - 1
    local pos = file_locs[i]["pos"]
    local len = file_locs[i]["len"]

    local left = 1
    while left < pos do
        if disk[left] == -1 then
            local free_space = 0
            while true do
                if disk[left+free_space] ~= -1 then
                    break
                end
                free_space = free_space + 1
            end
            if free_space >= len then
                for j = 0, len-1 do
                    disk[left+j] = id
                    disk[pos+j] = -1
                end
                left = left + free_space + 1
                goto continue
            end
            left = left + free_space
        end
        left = left + 1
    end
    ::continue::
end

local result = 0
for idx, val in ipairs(disk) do
    if disk[idx] ~= -1 then
        result = result + (idx-1) * val
    end
end

print(result)
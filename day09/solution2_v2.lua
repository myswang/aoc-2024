-- Day 9 Part 2 solution
-- (linked list method)

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local disk_str = file:read()
io.input():close()

local disk = {}
local disk_ptr = 1
for i = 1, disk_str:len() do
    local val = disk_str:sub(i, i)
    if i % 2 == 1 then
        table.insert(disk, {next=nil, prev=nil, pos=disk_ptr, len=tonumber(val)})
        if i > 1 then
            local blk_id = math.floor(i / 2)
            disk[blk_id].next = blk_id + 1
            disk[blk_id + 1].prev = blk_id
        end
    end
    disk_ptr = disk_ptr + val
end

for i = #disk, 1, -1 do
    local cur = disk[i]
    local next = 1
    while next ~= i do
        local f1 = disk[next]
        if f1.next ~= nil then
            local f2 = disk[f1.next]
            local free_space = f2.pos - f1.pos - f1.len
            if free_space >= cur.len then
                cur.pos = f1.pos+f1.len
                if cur.prev ~= nil then
                    disk[cur.prev].next = cur.next
                end
                if cur.next ~= nil then
                    disk[cur.next].prev = cur.prev
                end
                cur.next = f1.next
                cur.prev = next
                f1.next = i
                f2.prev = i
                break
            else
                next = f1.next
            end
        end
    end
end

local result = 0
for i = 1, #disk do
    local cur = disk[i]
    for j = cur.pos, cur.pos+cur.len-1 do
        result = result + (i-1) * (j-1)
    end
end

print(result)
local function update_map(map, key, count)
    if map[key] == nil then
        map[key] = count
    else
        map[key] = map[key] + count
    end
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local input_str = file:read()
io.input():close()

local counts = {}
for val in input_str:gmatch("%d+") do
    val = tonumber(val)
    if val ~= nil then
        update_map(counts, val, 1)
    end
end

for _ = 1, 75 do
    local new_counts = {}
    for key, val in pairs(counts) do
        if key == 0 then
            update_map(new_counts, 1, val)
        else
            local num_digits = math.floor(math.log(key, 10) + 1)
            if num_digits % 2 == 0 then
                local mask = 10 ^ (num_digits / 2)
                local left = math.floor(key / mask)
                local right = math.floor(key % mask)
                update_map(new_counts, left, val)
                update_map(new_counts, right, val)
            else
                update_map(new_counts, key*2024, val)
            end
        end
    end
    counts = new_counts
end

local result = 0
for _, val in pairs(counts) do
    result = result + val
end

print(result)
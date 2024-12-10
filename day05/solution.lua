local rules = {}
local updates = {}

local function check_update(update)
    for i = 1, #update do
        for j = 1, #update do
            if (i < j and rules[update[j]] ~= nil and rules[update[j]][update[i]] == true)
            or (i > j and rules[update[i]] ~= nil and rules[update[i]][update[j]] == true) then
                return {i, j}
            end
        end
    end
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

for line in file:lines() do
    if line:find("|") ~= nil then
        for k, v in line:gmatch("(%d+)|(%d+)") do
            if rules[k] == nil then
                rules[k] = {}
            end
            rules[k][v] = true
        end
    elseif line:find(",") ~= nil then
        table.insert(updates, {})
        for v in line:gmatch("%d+") do
            table.insert(updates[#updates], v)
        end
    end
end

io.input():close()

local result = 0
local result2 = 0
for _, update in ipairs(updates) do
    if check_update(update) == nil then
        local middle = #update // 2 + 1
        result = result + update[middle]
    else
        while true do
            local check = check_update(update)
            if check == nil then
                local middle = #update // 2 + 1
                result2 = result2 + update[middle]
                break
            else
                update[check[1]], update[check[2]] = update[check[2]], update[check[1]]
            end
        end
    end
end

print(result)
print(result2)

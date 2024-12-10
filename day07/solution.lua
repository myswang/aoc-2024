local function do_math(result, nums, acc, idx)
    if idx == 0 then
        return acc == result
    elseif acc > result then
        return false
    end

    local num = nums[idx]

    return do_math(result, nums, acc + num, idx - 1)
        or do_math(result, nums, acc * num, idx - 1)
        or do_math(result, nums, tonumber(tostring(acc) .. tostring(num)), idx - 1)
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local equations = {}
for line in file:lines() do
    table.insert(equations, {})
    for k, v in line:gmatch("(%d+):(.*)") do
        for num in v:reverse():gmatch("%d+") do
            table.insert(equations[#equations], tonumber(num:reverse()))
        end
        table.insert(equations[#equations], tonumber(k))

    end
end

io.input():close()

local result_sum = 0
for _, nums in ipairs(equations) do
    local result = table.remove(nums)
    if do_math(result, nums, 0, #nums) then
        result_sum = result_sum + result
    end
end
print(result_sum)

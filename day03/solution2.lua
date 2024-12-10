-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local result = 0
local mul_enabled = true
local patterns = {
    ["mul"] = "mul%(%d+,%d+%)",
    ["do_mul"] = "do%(%)",
    ["dont_mul"] = "don't%(%)"
}

for line in file:lines() do
    local cur_start = 1
    while cur_start < #line do
        local cur1 = #line
        local cur2 = #line
        local kind = nil

        for new_kind, pattern in pairs(patterns) do
            local new1, new2 = line:find(pattern, cur_start)
            if new1 == nil then
                goto continue
            elseif new1 < cur1 then
                cur1 = new1
                cur2 = new2
                kind = new_kind
            end
            ::continue::
        end

        if kind == nil then
            break
        end

        local match = line:sub(cur1, cur2)
        if kind == "mul" and mul_enabled then
            local temp = 1
            for val in match:gmatch("%d+") do
                temp = temp * val
            end
            result = result + temp
        elseif kind == "do_mul" then
            mul_enabled = true
        elseif kind == "dont_mul" then
            mul_enabled = false
        end

        cur_start = cur2 + 1
    end
end

io.input():close()
print(result)
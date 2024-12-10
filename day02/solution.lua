local function is_safe(level)
    local prev_diff = nil
    for i = 2, #level do
        local prev_val = level[i-1]
        local diff = level[i] - prev_val
        local diff_abs = math.abs(diff)
        if diff_abs < 1 or diff_abs > 3 or
          (prev_diff ~= nil and ((prev_diff > 0 and diff < 0) or (prev_diff < 0 and diff > 0))) then
            return false
        end
        prev_diff = diff
    end
    return true
end

-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

-- read levels from report
local reports = {}
for line in file:lines() do
    table.insert(reports, {})
    for word in line:gmatch("%S+") do
        local val = tonumber(word)
        table.insert(reports[#reports], val)
    end
end

io.input():close()

local safe_report_count = 0
local other_safe_report = 0
for _, level in ipairs(reports) do
    if is_safe(level) then
        safe_report_count = safe_report_count + 1
    else
        for i = 1, #level do
            local new_level = {}
            for j = 1, #level do
                if j ~= i then
                    table.insert(new_level, level[j])
                end
            end
            if is_safe(new_level) then
                other_safe_report = other_safe_report + 1
                goto continue
            end
        end
    end
    ::continue::
end

print(safe_report_count)
print(safe_report_count + other_safe_report)
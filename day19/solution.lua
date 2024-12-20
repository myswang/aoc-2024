local patterns = {}
local designs = {}

local function parse_file(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Failed to open file.")
        os.exit(1)
    end

    for line in file:lines() do
        if line:find(",") then
            for pattern in line:gmatch("%a+") do
                table.insert(patterns, pattern)
            end
        elseif line == "" then
            goto continue
        else
            table.insert(designs, line)
        end
        ::continue::
    end

    io.input():close()
end

local function get_ways(design)
    local n = #design + 1
    local dp = {}
    dp[1] = 1

    for i = 2, n do
        dp[i] = 0
        for _, pattern in ipairs(patterns) do
            local len = #pattern
            if i >= len and design:sub(i-len, i-1) == pattern then
                dp[i] = dp[i] + dp[i-len]
            end
        end
    end

    return dp[n]
end

parse_file("input.txt")

local counter = 0
local num_ways = 0
for _, design in ipairs(designs) do
    local ways = get_ways(design)
    if ways > 0 then
        counter = counter + 1
    end
    num_ways = num_ways + ways
end

print(counter)
print(num_ways)
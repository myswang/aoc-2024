-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

local lines = {}
local trailheads = {}
for line in file:lines() do
    table.insert(lines, {})
    for i = 1, line:len() do
        local val = tonumber(line:sub(i, i))
        table.insert(lines[#lines], val)
        if val == 0 then
            table.insert(trailheads, {#lines, i})
        end
    end
end

io.input():close()

local score_sum = 0
for _, start in ipairs(trailheads) do
    local score = 0
    local stack = {start}
    while #stack > 0 do
        local pos = table.remove(stack)
        local y, x = table.unpack(pos)
        if lines[y][x] == 9 then
            score = score + 1
        else
            local neighbours = {}
            if y > 1 then table.insert(neighbours, {y-1, x}) end
            if x > 1 then table.insert(neighbours, {y, x-1}) end
            if y < #lines then table.insert(neighbours, {y+1, x}) end
            if x < #lines[1] then table.insert(neighbours, {y, x+1}) end

            for _, neighbour in ipairs(neighbours) do
                local y0, x0 = table.unpack(neighbour)
                if lines[y0][x0] - lines[y][x] == 1 then
                    table.insert(stack, neighbour)
                end
            end
        end
    end
    score_sum = score_sum + score
end

print(score_sum)

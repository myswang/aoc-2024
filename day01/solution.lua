-- open the file
local file = io.open("input.txt", "r")
if not file then
    print("Failed to open file.")
    return
end

-- two lists
local list1 = {}
local list2 = {}
-- read file line-by-line into the lists
for line in file:lines() do
    local count = 0
    for word in line:gmatch("%S+") do
        local val = tonumber(word)
        if count < 1 then
            table.insert(list1, val)
        else
            table.insert(list2, val)
        end
        count = count + 1
    end
end

io.input():close()

-- PART 1 SOLUTION:

-- sort the lists
table.sort(list1)
table.sort(list2)

-- calculate absolute difference between two values
local distance = 0
for i = 1, #list1 do
    distance = distance + math.abs(list1[i] - list2[i])
end

print(distance)

-- PART 2 SOLUTION

-- compute hashmap to store similarity scores
local sim_scores = {}
for _, val in ipairs(list2) do
    if sim_scores[val] == nil then
        sim_scores[val] = val; -- add a new entry if it doesn't exist
    else
        sim_scores[val] = sim_scores[val] + val -- add value again
    end
end

-- calculate sum of similarity scores
local sum_scores = 0
for _, val in ipairs(list1) do
    local score = sim_scores[val]
    if score ~= nil then
        sum_scores = sum_scores + score
    end
end

print(sum_scores)



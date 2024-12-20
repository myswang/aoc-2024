--            1   2  3  4  5
-- registers: PC, A, B, C, Z
local regs = {1}
local prog = {}
local output = {}

local function parse_file(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Failed to open file.")
        os.exit(1)
    end

    for line in file:lines() do
        if line:find("Register") then
            table.insert(regs, tonumber(line:match("%d+")))
        elseif line:find("Program") then
            for val in line:gmatch("%d+") do
                table.insert(prog, tonumber(val))
            end
        end
    end
    table.insert(regs, 0)

    io.input():close()
end

parse_file("input.txt")

local function find(program, ans, iter)
    if iter == 0 then return ans end
    for t = 0, 7 do
        local a = (ans << 3) + t
        local b = a % 8
        b = b ~ 3
        local c = a >> b
        b = b ~ 5
        b = b ~ c
        if b % 8 == program[iter] then
            local sub = find(program, a, iter-1)
            if not sub then goto continue end
            return sub
        end
        ::continue::
    end
end

print(find(prog, 0, #prog))


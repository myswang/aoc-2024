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

    table.insert(prog, 8)
    table.insert(prog, 0)
    io.input():close()
end

local function ht()
    regs[1] = -1
end

local function wr(A)
    regs[A] = regs[5]
end

local function ot()
    table.insert(output, regs[5])
end

local function dv(A)
    local val = A
    if A > 3 then
        val = regs[A-2]
    end
    regs[5] = regs[2] >> val
    regs[1] = regs[1] + 2
end

local function xl(val)
    regs[5] = regs[3] ~ val
    regs[1] = regs[1] + 2
end

local function xc()
    regs[5] = regs[3] ~ regs[4]
    regs[1] = regs[1] + 2
end

local function md(A)
    local val = A
    if A > 3 then
        val = regs[A-2]
    end
    regs[5] = val % 8
    regs[1] = regs[1] + 2
end

local function jn(val)
    if regs[2] ~= 0 then
        regs[5] = val + 1
    else
        regs[5] = regs[1] + 2
    end
end


local function execute(opcode, val)
    if opcode == 0 then     -- adv
        dv(val)
        wr(2)
    elseif opcode == 1 then -- bxl
        xl(val)
        wr(3)
    elseif opcode == 2 then -- bst
        md(val)
        wr(3)
    elseif opcode == 3 then -- jnz
        jn(val)
        wr(1)
    elseif opcode == 4 then -- bxc
        xc()
        wr(3)
    elseif opcode == 5 then -- out
        md(val)
        ot()
    elseif opcode == 6 then -- bdv
        dv(val)
        wr(3)
    elseif opcode == 7 then -- cdv
        dv(val)
        wr(4)
    elseif opcode == 8 then
        ht()
    else
        print("unsupported opcode: "..opcode)
        ht()
    end
end

parse_file("input.txt")

while regs[1] ~= -1 do
    local pc = regs[1]
    if not prog[pc] or not prog[pc+1] then
        ht()
        break
    else
        execute(prog[pc], prog[pc+1])
    end
end

print(table.concat(output, ","))

--             1  2  3  4
-- registers: PC, A, B, C
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
    io.input():close()
end

local function get_val(A)
    if A > 3 then
        A = regs[A - 2]
    end
    return A
end

local function idv(A, B)
    regs[B] = regs[2] >> get_val(A)
    regs[1] = regs[1] + 2
end

local function bxi(A)
    if A == -1 then
        A = regs[4]
    end
    regs[3] = regs[3] ~ A
    regs[1] = regs[1] + 2
end

local function ist(A, B)
    local res = get_val(A) % 8
    if B == -1 then
        table.insert(output, res)
    else
        regs[3] = res
    end
    regs[1] = regs[1] + 2
end

local function jnz(A)
    if regs[2] ~= 0 then
        regs[1] = A + 1
    else
        regs[1] = regs[1] + 2
    end
end

local function execute(opcode, operand)
    if opcode == 0 then     -- adv
        idv(operand, 2)
    elseif opcode == 1 then -- bxl
        bxi(operand)
    elseif opcode == 2 then -- bst
        ist(operand, 3)
    elseif opcode == 3 then -- jnz
        jnz(operand)
    elseif opcode == 4 then -- bxc
        bxi(-1)
    elseif opcode == 5 then -- out
        ist(operand, -1)
    elseif opcode == 6 then -- bdv
        idv(operand, 3)
    elseif opcode == 7 then -- cdv
        idv(operand, 4)
    else
        print("unsuppored opcode: "..opcode)
        os.exit(1)
    end
end

-- reverse engineered program from my own input
-- this probably won't work with other inputs
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

parse_file("input.txt")

while true do
    local pc = regs[1]
    if not prog[pc] or not prog[pc+1] then
        break
    else
        execute(prog[pc], prog[pc+1])
    end
end

print(table.concat(output, ","))
print(find(prog, 0, #prog))
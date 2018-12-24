module Day19

import ..Day16: addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
import ..load_input

struct Instruction
    op::Function
    a::Int
    b::Int
    c::Int
end

function parse_input(input)
    ip_reg = parse(Int, match(r"#ip (\d+)\n", input).captures[1])
    matches = eachmatch(r"(.*) (\d+) (\d+) (\d+)\n", input)
    program = [Instruction(eval(Meta.parse(match.captures[1])),
                           parse(Int, match.captures[2]),
                           parse(Int, match.captures[3]),
                           parse(Int, match.captures[4]))
               for match in matches]
    ip_reg, program
end

function run_program(ip_reg, program, regs=Int.(zeros(6)))
    while regs[ip_reg+1] >= 0 && regs[ip_reg+1] < length(program)
        next_inst = program[regs[ip_reg+1]+1]
        regs = next_inst.op(next_inst, regs)
        regs[ip_reg+1] += 1
    end

    regs[ip_reg+1] -= 1
    regs
end

function run_a()
    ip_reg, program = Day19.parse_input(load_input("19a"))
    regs = run_program(ip_reg, program)

    regs[1]
end

function run_b()
    # when the registers start as [1, 0, 0, 0, 0, 0]
    # the program computers the sum of the factors of 10551330
    sum([x for x in 1:10551330 if 10551330 % x == 0])
end

end # module

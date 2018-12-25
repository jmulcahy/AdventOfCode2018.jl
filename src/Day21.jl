module Day21

import ..load_input
import ..Day19: parse_input, run_program

function run_until_28(ip_reg, program)
    regs = [0, 0, 0, 0, 0, 0]
    while regs[ip_reg+1] >= 0 && regs[ip_reg+1] < length(program)
        next_inst = program[regs[ip_reg+1]+1]
        if regs[ip_reg+1] == 28
            break
        end

        regs = next_inst.op(next_inst, regs)
        regs[ip_reg+1] += 1
    end

    regs[ip_reg+1] -= 1
    regs[4]
end

function find_longest(ip_reg, program)
    regs = [0, 0, 0, 0, 0, 0]
    prior = -1
    stoppers = Set{Int}()
    while true
        next_inst = program[regs[ip_reg+1]+1]
        inst_num = regs[ip_reg+1]
        if inst_num == 28
            stopper = regs[4]
            if stopper in stoppers
                return prior
            end
            push!(stoppers, stopper)
            prior = stopper
        end

        regs = next_inst.op(next_inst, regs)
        regs[ip_reg+1] += 1
    end
end

function run_a()
    ip_reg, program = parse_input(load_input("21a"))
    run_until_28(ip_reg, program)
end

function run_b()
    ip_reg, program = parse_input(load_input("21a"))
    find_longest(ip_reg, program)
end

end # module

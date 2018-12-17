module Day16

import ..load_input

struct Instruction
    opcode::Int
    a::Int
    b::Int
    c::Int
end

struct Sample
    old_regs::Array{Int, 1}
    inst::Instruction
    new_regs::Array{Int, 1}
end

function parse_inputa(input)
    regex = r"Before: \[(.), (.), (.), (.)\]\n(\d+) (.) (.) (.)\nAfter:  \[(.), (.), (.), (.)\]\n"
    matches = eachmatch(regex, input)
    samples = Array{Sample, 1}()
    for match in matches
        parsed = [parse(Int64, c) for c in match.captures]
        old_regs = [parsed[1], parsed[2], parsed[3], parsed[4]]
        inst = Instruction(parsed[5], parsed[6], parsed[7], parsed[8])
        new_regs = [parsed[9], parsed[10], parsed[11], parsed[12]]
        push!(samples, Sample(old_regs, inst, new_regs))
    end

    samples
end

function addr(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] + new_regs[inst.b+1]
    new_regs
end

function addi(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] + inst.b
    new_regs
end

function mulr(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] * new_regs[inst.b+1]
    new_regs
end

function muli(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] * inst.b
    new_regs
end

function banr(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] & new_regs[inst.b+1]
    new_regs
end

function bani(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] & inst.b
    new_regs
end

function borr(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] | new_regs[inst.b+1]
    new_regs
end

function bori(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1] | inst.b
    new_regs
end

function setr(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = new_regs[inst.a+1]
    new_regs
end

function seti(inst, regs)
    new_regs = deepcopy(regs)
    new_regs[inst.c+1] = inst.a
    new_regs
end

function gtir(inst, regs)
    new_regs = deepcopy(regs)
    if inst.a > new_regs[inst.b+1]
        new_regs[inst.c+1] = 1
    else
        new_regs[inst.c+1] = 0
    end

    new_regs
end

function gtri(inst, regs)
    new_regs = deepcopy(regs)
    if new_regs[inst.a+1] > inst.b
        new_regs[inst.c+1] = 1
    else
        new_regs[inst.c+1] = 0
    end

    new_regs
end

function gtrr(inst, regs)
    new_regs = deepcopy(regs)
    if new_regs[inst.a+1] > new_regs[inst.b+1]
        new_regs[inst.c+1] = 1
    else
        new_regs[inst.c+1] = 0
    end

    new_regs
end

function eqir(inst, regs)
    new_regs = deepcopy(regs)
    if inst.a == new_regs[inst.b+1]
        new_regs[inst.c+1] = 1
    else
        new_regs[inst.c+1] = 0
    end

    new_regs
end

function eqri(inst, regs)
    new_regs = deepcopy(regs)
    if new_regs[inst.a+1] == inst.b
        new_regs[inst.c+1] = 1
    else
        new_regs[inst.c+1] = 0
    end

    new_regs
end

function eqrr(inst, regs)
    new_regs = deepcopy(regs)
    if new_regs[inst.a+1] == new_regs[inst.b+1]
        new_regs[inst.c+1] = 1
    else
        new_regs[inst.c+1] = 0
    end

    new_regs
end

function test_sample(sample::Sample)
    functions = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]
    matches = []

    for i in eachindex(functions)
        func_result = functions[i](sample.inst, sample.old_regs)
        if func_result == sample.new_regs
            push!(matches, functions[i])
        end
    end

    matches
end

function run_a()
    input = load_input("16a")
    samples = parse_inputa(input)
    gt_3s = falses(length(samples))

    for i in eachindex(samples)
        matches = test_sample(samples[i])
        if length(matches) >= 3
            gt_3s[i] = true
        end
    end

    count(i -> i == true, gt_3s)
end

function extract_opcodes(samples)
    functions = Set([addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr])
    hypotheses = fill(functions, length(functions))
    for sample in samples
        opcode = sample.inst.opcode+1
        hypothesis = Set(test_sample(sample))
        hypotheses[opcode] = intersect(hypotheses[opcode], hypothesis)
    end

    all_one = false
    while !all_one
        # iterate through all hypotheses
        for i in eachindex(hypotheses)
            # if there is only one for an opcode, delete it from others
            if length(hypotheses[i]) == 1
                for j in eachindex(hypotheses)
                    if i != j
                        delete!(hypotheses[j], first(hypotheses[i]))
                    end
                end
            end
        end

        # check to see if we've narrowed all hypotheses to one
        all_one = true
        for i in eachindex(hypotheses)
            if length(hypotheses[i]) != 1
                all_one = false
                break
            end
        end
    end

    [first(hypo) for hypo in hypotheses]
end

function parse_inputb(input)
    matches = eachmatch(r"(\d+) (\d) (\d) (\d)\n", input)
    insts = Array{Instruction, 1}()

    for match in matches
        parsed = [parse(Int64, c) for c in match.captures]
        inst = Instruction(parsed[1], parsed[2], parsed[3], parsed[4])
        push!(insts, inst)
    end

    insts
end

function run_program(insts, opcodes, initial_state=[0, 0, 0, 0])
    regs = [0, 0, 0, 0]
    for inst in insts
        regs = opcodes[inst.opcode+1](inst, regs)
    end

    regs
end

function run_b()
    samples = parse_inputa(load_input("16a"))
    opcodes = extract_opcodes(samples)

    insts = parse_inputb(load_input("16b"))
    run_program(insts, opcodes)[1]
end


end # module

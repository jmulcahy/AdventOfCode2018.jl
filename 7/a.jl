import DataStructures

function load(filename)
    open(filename) do file
        read(file, String)
    end
end

function parse_input(input)
    raw_instructions = eachmatch(r"Step (.) must be finished before step (.) can begin.", input)
    instructions = Dict{Char, Array{Char, 1}}()
    num_parents = Dict{Char, Int64}()
    for inst in raw_instructions
        (parent, child) = [capture[1] for capture in inst.captures]
        num_parents[child] = get(num_parents, child, 0) + 1
        instructions[parent] = push!(get(instructions, parent, []), child)
    end

    # '^' denotes the root of the directed acyclic graph
    parentless = setdiff(Set(keys(instructions)), Set(keys(num_parents)))
    instructions['^'] = []
    for child in parentless
        num_parents[child] = 1
        instructions['^'] = push!(instructions['^'], child)
    end
    num_parents['^'] = 0

    (instructions, num_parents)
end

function instruction_order(instructions, remaining_parents, start_instruction='^', order="")
    order_copy = deepcopy(order)
    rp_copy = deepcopy(remaining_parents)

    sorted_available = DataStructures.mutable_binary_minheap([start_instruction])

    while !isempty(sorted_available)
        next_instruction = pop!(sorted_available)
        if haskey(instructions, next_instruction)
            for child in instructions[next_instruction]
                rp_copy[child] -= 1
                if rp_copy[child] == 0
                    push!(sorted_available, child)
                end
            end
        end

        if next_instruction != '^'
            order_copy *= next_instruction
        end
    end

    order_copy
end


(instructions, num_parents) = parse_input(load("input_a.txt"))

order = instruction_order(instructions, num_parents)

println(order)

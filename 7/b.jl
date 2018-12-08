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

function instruction_time(instructions, remaining_parents, num_workers, base_time, start_instruction='^')
    rp_copy = deepcopy(remaining_parents)

    sorted_available = DataStructures.mutable_binary_minheap(Char)
    workers = DataStructures.PriorityQueue()
    workers['^'] = 0

    current_time = 0
    while !isempty(workers)
        (next_instruction, current_time) = DataStructures.dequeue_pair!(workers)
        if haskey(instructions, next_instruction)
            for child in instructions[next_instruction]
                rp_copy[child] -= 1
                if rp_copy[child] == 0
                    push!(sorted_available, child)
                end
            end
        end

        while length(workers) < num_workers && !isempty(sorted_available)
            next_available = pop!(sorted_available)
            workers[next_available] = current_time + base_time + Int64(next_available) - Int64('A') + 1
        end
    end

    current_time
end


(instructions, num_parents) = parse_input(load("input_a.txt"))

total_time = instruction_time(instructions, num_parents, 5, 60)

println(total_time)

module Day1

import ..load_input

function parse_input()
    input = load_input("1a")
    [parse(Int, line) for line in split(strip(input), r"\n")]
end

function process_a(nums)
    sum(nums)
end

function run_a()
    nums = parse_input()
    process_a(nums)
end

function process_b(nums)
    visited = Set()
    current = 0

    for num in Iterators.flatten(Iterators.repeated(nums))
        current += num
        if current in visited
            break;
        end
        push!(visited, current)
    end

    current
end

function run_b()
    nums = parse_input()
    process_b(nums)
end

end # module

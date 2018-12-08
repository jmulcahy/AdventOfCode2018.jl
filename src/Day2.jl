module Day2

import ..load_input

function process_a(lines)
    twos = 0
    threes = 0

    for line in lines
        cs = Dict{Char}{Int64}()
        for c in line
            cs[c] = get(cs, c, 0) + 1
        end
        if 2 in values(cs)
            twos += 1
        end
        if 3 in values(cs)
            threes += 1
        end
    end

    twos * threes
end

function run_a()
    input = load_input("2a")
    lines = split(strip(input), r"\n")
    process_a(lines)
end

function process_b(input)
    result = match(r"(.*)(.)(.*)\n(?:.*\n)*\1[^\2]\3\n", input)
    result.captures[1] * result.captures[3]
end

function run_b()
    input = load_input("2a")
    process_b(input)
end

end # module

module Day5

import ..load_input
import DataStructures

function load(filename)
    open(filename) do file
        read(file, String)
    end
end
function parse_input()
    input = string(strip(load_input("5a")))
end

function remove_matches(s::String)
    cleaned = DataStructures.Stack{Char}()
    for current in s

        if isempty(cleaned)
            DataStructures.push!(cleaned, current)
            continue
        end

        prior = DataStructures.top(cleaned)
        if (islowercase(prior) && isuppercase(current) && prior == lowercase(current)) ||
            (isuppercase(prior) && islowercase(current) && prior == uppercase(current))
            DataStructures.pop!(cleaned)
        else
            DataStructures.push!(cleaned, current)
        end
    end

    reverse(join(cleaned))
end

function run_a()
    input = parse_input()
    length(remove_matches(input))
end

function process_over_chars(input::String)
    chars = ['a' + idx for idx in 0:25]
    regexes = [Regex(char * '|' * uppercase(char)) for char in chars]
    results = [remove_matches(replace(input, regex => "")) for regex in regexes]
    minimum([length(result) for result in results])
end

function run_b()
    input = parse_input()
    process_over_chars(input)
end

end # module

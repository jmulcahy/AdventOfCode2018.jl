module Day5

import ..load_input

function load(filename)
    open(filename) do file
        read(file, String)
    end
end
function parse_input()
    input = string(strip(load_input("5a")))
end

function get_and_remove_match(s::String)
    for idx in 2:length(s)
        prior = s[idx-1]
        current = s[idx]
        if (islowercase(prior) && isuppercase(current) && prior == lowercase(current)) ||
            (isuppercase(prior) && islowercase(current) && prior == uppercase(current))
            return s[1:(idx-2)] * s[(idx+1):end]
        end
    end
    s
end

function process_string(input::String)
    prior = ""
    current = get_and_remove_match(input)
    while prior != current
        prior = current
        current = get_and_remove_match(prior)
    end
    current
end

function run_a()
    input = parse_input()
    length(process_string(input))
end

function process_over_chars(input::String)
    chars = ['a' + idx for idx in 0:25]
    regexes = [Regex(char * '|' * uppercase(char)) for char in chars]
    results = [process_string(replace(input, regex => "")) for regex in regexes]
    minimum([length(result) for result in results])
end

function run_b()
    input = parse_input()
    process_over_chars(input)
end

end # module

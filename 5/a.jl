function load(filename)
    open(filename) do file
        read(file, String)
    end
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

function process_string(input)
    prior = ""
    current = get_and_remove_match(input)
    while prior != current
        prior = current
        current = get_and_remove_match(prior)
    end
    current
end

input = strip(load("input_a.txt"))

result = process_string(input)

println(length(result))

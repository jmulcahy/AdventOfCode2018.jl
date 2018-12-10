module Day8

import ..load_input

function parse_input(input)
    [parse(Int64, x) for x in split(input)]
end

function sum_node_metadata(stream, start=1)
    node_count = stream[start]
    metadata_count = stream[start+1]
    metadata_sum = 0
    next_node_start = start+2

    for node in 1:node_count
        (node_metadata_sum, next_node_start) = sum_node_metadata(stream, next_node_start)
        metadata_sum += node_metadata_sum
    end

    metadata_sum += sum(stream[next_node_start:(next_node_start+metadata_count-1)])

    next_node_start += metadata_count

    (metadata_sum, next_node_start)
end

function run_a()
    stream = parse_input(load_input("8a"))
    sum_node_metadata(stream)[1]
end

function sum_node(stream, start=1)
    node_count = stream[start]
    metadata_count = stream[start+1]
    next_node_start = start+2

    if node_count == 0
        return (sum(stream[next_node_start:(next_node_start+metadata_count-1)]), next_node_start+metadata_count)
    end

    node_sums = zeros(typeof(stream[1]), node_count)

    for node in 1:node_count
        (node_sums[node], next_node_start) = sum_node(stream, next_node_start)
    end

    node_sum = 0
    for node in stream[next_node_start:(next_node_start+metadata_count-1)]
        if node > 0 && node <= node_count
            node_sum += node_sums[node]
        end
    end

    next_node_start += metadata_count

    (node_sum, next_node_start)
end

function run_b()
    stream = parse_input(load_input("8a"))
    sum_node(stream)[1]
end

end # module

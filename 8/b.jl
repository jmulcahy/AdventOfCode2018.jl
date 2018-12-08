function load(filename)
    open(filename) do file
        read(file, String)
    end
end

function parse_input(input)
    [parse(Int64, x) for x in split(input)]
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

stream = parse_input(load("input_a.txt"))

result = sum_node(stream)

println("$(result[1])")

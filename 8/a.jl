function load(filename)
    open(filename) do file
        read(file, String)
    end
end

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

input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

stream = parse_input(input)
stream = parse_input(load("input_a.txt"))

result = sum_node_metadata(stream)

println("$(result[1])")

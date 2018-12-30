module Day25

import LightGraphs: SimpleGraph, add_edge!, connected_components
import ..load_input

function parse_input(input)
    matches = eachmatch(r"(-?\d+),(-?\d+),(-?\d+),(-?\d+)\n", input)
    [[parse(Int, str) for str in match.captures] for match in matches]
end

function manhattan_distance(point1, point2)
    sum(abs.(point1 .- point2))
end

function count_constellations(points)
    # build graph connecting points
    point_graph = SimpleGraph(length(points))
    for i in 1:length(points)
        for j in (i+1):length(points)
            if manhattan_distance(points[i], points[j]) <= 3
                add_edge!(point_graph, i, j)
            end
        end
    end
    # find connected sets
    components = connected_components(point_graph)

    length(components)
end

function run_a()
    input = load_input("25a")
    points = parse_input(input)

    count_constellations(points)
end

end # module

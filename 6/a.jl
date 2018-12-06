function load(filename)
    open(filename) do file
        read(file, String)
    end
end

function parse_input(input)
    raw_points = eachmatch(r"(\d+), (\d+)", input)
    list_points = [[parse(Int64, val) for val in raw_point.captures] for raw_point in raw_points]
    hcat(list_points...)'
end

function find_closest(point, points)
    distances = [sum(abs.(point .- points[idx, :])) for idx in 1:size(points, 1)]
    (min_val, min_idx) = findmin(distances)
    min_remove = distances
    min_remove[min_idx] += 1
    if min_val == minimum(min_remove)
        -1
    else
        min_idx
    end
end

function process_points(points)
    top_left = minimum(points, dims=1)
    bottom_right = maximum(points, dims=1)
    num_neighbors = zeros(size(points, 1))

    for x in top_left[1]:bottom_right[1]
        for y in top_left[2]:bottom_right[2]
            closest = find_closest([x, y], points)
            if closest == -1 # there was a tie
                continue
            end
            # if a point has a neighbor on an edge, it will have infinity neighbors
            if x == top_left[1] || x == bottom_right[1] || y == top_left[2] || y == bottom_right[2]
                num_neighbors[closest] = -1
            end
            if num_neighbors[closest] != -1
                num_neighbors[closest] += 1
            end
        end
    end

    maximum(num_neighbors)
end


points = parse_input(load("input_a.txt"))
result = process_points(points)

println(result)

module Day6

import ..load_input

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

function process_points_a(points)
    top_left = minimum(points, dims=1)
    bottom_right = maximum(points, dims=1)
    num_neighbors = Int.(zeros(size(points, 1)))

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

function parse_input()
    input = load_input("6a")
    raw_points = eachmatch(r"(\d+), (\d+)", input)
    list_points = [[parse(Int64, val) for val in raw_point.captures] for raw_point in raw_points]
    hcat(list_points...)'
end

function run_a()
    points = parse_input()
    process_points_a(points)
end

function total_distance(point, points)
    distances = [sum(abs.(point .- points[idx, :])) for idx in 1:size(points, 1)]
    sum(distances)
end

function process_points_b(points, max_distance)
    top_left = minimum(points, dims=1)
    bottom_right = maximum(points, dims=1)
    area_within = 0

    for x in top_left[1]:bottom_right[1]
        for y in top_left[2]:bottom_right[2]
            distance = total_distance([x, y], points)
            if distance < max_distance
                area_within += 1
            end
        end
    end

    prior_area_within = -1
    grown = 0
    while area_within != prior_area_within
        prior_area_within = area_within
        grown += 1
        # grow search space along strips around the outside of the already searched box
        # top
        area_within += sum([total_distance([top_left[1]-grown, idx], points) < max_distance ? 1 : 0
                            for idx in (top_left[2]-grown):(bottom_right[2]+grown)])
        # bottom
        area_within += sum([total_distance([bottom_right[1]+grown, idx], points) < max_distance ? 1 : 0
                            for idx in (top_left[2]-grown):(bottom_right[2]+grown)])
        # left
        area_within += sum([total_distance([idx, top_left[2]-grown], points) < max_distance ? 1 : 0
                            for idx in (top_left[1]-grown+1):(bottom_right[1]+grown-1)])
        # right
        area_within += sum([total_distance([idx, bottom_right[2]+grown], points) < max_distance ? 1 : 0
                            for idx in (top_left[1]-grown+1):(bottom_right[1]+grown-1)])
    end

    area_within
end

function run_b()
    points = parse_input()
    process_points_b(points, 10000)
end

end # module

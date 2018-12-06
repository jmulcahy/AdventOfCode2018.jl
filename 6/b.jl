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

function total_distance(point, points)
    distances = [sum(abs.(point .- points[idx, :])) for idx in 1:size(points, 1)]
    sum(distances)
end

function process_points(points, max_distance)
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


points = parse_input(load("input_a.txt"))
result = process_points(points, 10000)

println(result)

module Day17

import AdventOfCode2018: load_input
import DataStructures: Stack

function parse_input(input)
    ground_map = Set{Tuple{Int, Int}}()
    y_max = 0
    y_min = typemax(Int)

    x_matches = eachmatch(r"x=(\d+), y=(\d+)..(\d+)\n", input)
    for match in x_matches
        caps = [parse(Int, c) for c in match.captures]
        y_max = max(y_max, caps[2], caps[3])
        y_min = min(y_min, caps[2], caps[3])
        union!(ground_map, Set(((y, caps[1]) for y in caps[2]:caps[3])))
    end

    y_matches = eachmatch(r"y=(\d+), x=(\d+)..(\d+)\n", input)
    for match in y_matches
        caps = [parse(Int, c) for c in match.captures]
        y_max = max(y_max, caps[1])
        y_min = min(y_min, caps[1])
        union!(ground_map, Set(((caps[1], x) for x in caps[2]:caps[3])))
    end

    ground_map, y_min, y_max
end

function expand((y, x), dir, ground_map, water_map)
    keep_expanding = true
    new_water = Set{Tuple{Int, Int}}()
    current = 0
    hit_wall = false
    next_pos = (y, x)

    while keep_expanding
        next_pos = (y, x) .+ current .* dir
        next_pos_below = next_pos .+ (1, 0)
        if (next_pos_below in ground_map || next_pos_below in water_map)
            if next_pos in ground_map
                hit_wall = true
                keep_expanding = false
            else
                push!(new_water, next_pos)
            end
        else
            keep_expanding = false
        end

        current += 1
    end

    hit_wall, next_pos, new_water
end

function run_water(ground_map, (y, x), y_max)
    water_map = Set{Tuple{Int, Int}}()
    source_map = Set{Tuple{Int, Int}}()
    sources = Stack{Tuple{Int, Int}}()
    push!(sources, (y, x))

    while !isempty(sources)
        source = pop!(sources)
        if source in ground_map || source in water_map || source[1] > y_max
            continue
        end
        next_pos = source .+ (1, 0)

        if next_pos in ground_map || next_pos in water_map
            # expand left
            hit_wall_left, left_pos, left_water = expand(source, (0, -1), ground_map, water_map)
            # expand right
            hit_wall_right, right_pos, right_water = expand(source, (0, 1), ground_map, water_map)

            if hit_wall_left && hit_wall_right
                union!(water_map, left_water)
                union!(water_map, right_water)
                push!(sources, source .+ (-1, 0))
            else
                union!(source_map, left_water)
                union!(source_map, right_water)
                if !hit_wall_left
                    push!(sources, left_pos)
                end
                if !hit_wall_right
                    push!(sources, right_pos)
                end
            end
        else
            push!(sources, next_pos)
            push!(source_map, source)
        end

    end

    water_map, source_map
end

function run_a()
    ground_map, y_min, y_max = parse_input(load_input("17a"))
    water_map, source_map = Day17.run_water(ground_map, (y_min, 500), y_max)
    length(union(water_map, source_map))
end

function run_b()
    ground_map, y_min, y_max = parse_input(load_input("17a"))
    water_map, source_map = Day17.run_water(ground_map, (y_min, 500), y_max)
    length(water_map)
end

function print_maps(water_map, source_map, ground_map)
    fill_map = union(water_map, source_map)
    xs = [x for (y, x) in fill_map]
    x_min = minimum(xs) - 1
    x_max = maximum(xs) + 1

    ys = [y for (y, x) in fill_map]
    y_min = minimum(ys) - 1
    y_max = maximum(ys) + 1

    for y in y_min:y_max
        for x in x_min:x_max
            if (y, x) in water_map
                print("~")
            elseif (y, x) in ground_map
                print("#")
            elseif (y, x) in source_map
                print("|")
            else
                print(".")
            end
        end
        println()
    end
end

end # module

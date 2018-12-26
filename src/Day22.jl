module Day22

import ..load_input
import DataStructures: binary_minheap, top
import Base.<

@enum Terrain begin
    Rocky = 0
    Wet = 1
    Narrow = 2
end

@enum Tool begin
    ClimbingGear
    Torch
    Neither
end

struct TileState
    position::Tuple{Int, Int}
    tool::Tool
end

struct TileTime
    tile_state::TileState
    time::Int
end

function Base.isless(lhs::TileTime, rhs::TileTime)
    lhs.time < rhs.time
end

function parse_input(input)
    depth = parse(Int, match(r"depth: (\d+)", input).captures[1])
    location_matches = match(r"target: (\d+),(\d+)", input)

    location = Tuple(parse(Int, coord) for coord in location_matches.captures)

    depth, location
end

function fill_cave(depth, target, margin=(0, 0))
    cave = Int.(zeros(target .+ 1 .+ margin))
    modval = 20183
    cave[1, :] = [(y * 48271 + depth) % modval for y in 0:(size(cave, 2)-1)]
    cave[:, 1] = [(x * 16807 + depth) % modval for x in 0:(size(cave, 1)-1)]

    for y in 2:size(cave, 2)
        for x in 2:size(cave, 1)
            cave[x, y] = (cave[x-1, y] * cave[x, y-1] + depth) % modval
            if (x, y) == target .+ 1
                cave[x, y] = 0
            end
        end
    end

    cave .% 3
end

function run_a()
    depth, location = parse_input(load_input("22a"))
    sum(fill_cave(depth, location))
end

function find_shortest(cave, target)
    time = typemax(Int)
    initial_tile_state = TileState((0, 0), Torch)
    frontier = binary_minheap([TileTime(initial_tile_state, 0)])
    visiteds = Dict{TileState, Int}()

    while !isempty(frontier) && time > top(frontier).time
        tile_time = pop!(frontier)
        current_tile = tile_time.tile_state
        current_time = tile_time.time

        # skip if a tile is unvisited or this path is faster than the previous
        if !(current_tile in keys(visiteds)) || visiteds[current_tile] > current_time
            visiteds[current_tile] = current_time

            current_tool = current_tile.tool

            # go over adjacent tiles
            adjs = [(-1, 0), (0, -1), (1, 0), (0, 1)]
            for adj in adjs
                next_pos = current_tile.position .+ adj
                # check bounds
                if !all(next_pos .>= 0) || !all(next_pos .< size(cave))
                    continue
                end

                next_terrain = Terrain(cave[next_pos[1]+1, next_pos[2]+1])

                # check if moving to the next tile is valid
                if (next_terrain == Rocky && current_tool != Neither) ||
                    (next_terrain == Wet && current_tool != Torch) ||
                    (next_terrain == Narrow && current_tool != ClimbingGear)
                    push!(frontier, TileTime(TileState(next_pos, current_tool), current_time+1))
                end
            end

            # add staying in place but changing tools
            for tool in 0:2
                typed_tool = Tool(tool)
                current_terrain = Terrain(cave[current_tile.position[1]+1, current_tile.position[2]+1])
                if current_tool != typed_tool &&
                    ((current_terrain == Rocky && typed_tool != Neither) ||
                    (current_terrain == Wet && typed_tool != Torch) ||
                    (current_terrain == Narrow && typed_tool != ClimbingGear))
                    push!(frontier, TileTime(TileState(current_tile.position, typed_tool), current_time+7))
                end
            end
        end

        if current_tile.position == target && current_tile.tool == Torch && current_time < time
            time = current_time
        end
    end

    time
end

function run_b()
    depth, location = parse_input(load_input("22a"))
    margin = 2 * maximum(location)

    cave = fill_cave(depth, location, (margin, margin))

    find_shortest(cave, location)
end

end # module

module Day20

import DataStructures: Stack, top
import LightGraphs: SimpleGraph, add_vertex!, add_edge!, vertices, dijkstra_shortest_paths
import ..load_input

function build_rooms(input)
    steps = collect(input)[2:(end-1)]

    door_graph = SimpleGraph()
    add_vertex!(door_graph)

    room_map = Dict{Array{Int, 1}, Int}()
    room_map[[0, 0]] = 1

    room_stack = Stack{Array{Int, 1}}()
    push!(room_stack, [0, 0])

    step_idx = 1
    while step_idx <= length(steps)
        curr_step = steps[step_idx]
        if curr_step == '('
            push!(room_stack, top(room_stack))
        elseif curr_step == '|'
            pop!(room_stack)
            push!(room_stack, top(room_stack))
        elseif curr_step == ')'
            pop!(room_stack)
        else
            curr_room = pop!(room_stack)
            next_room = deepcopy(curr_room)
            if curr_step == 'N'
                next_room .+= [0, 1]
            elseif curr_step == 'W'
                next_room .+= [-1, 0]
            elseif curr_step == 'S'
                next_room .+= [0, -1]
            elseif curr_step == 'E'
                next_room .+= [1, 0]
            end
            push!(room_stack, next_room)
            if !(next_room in keys(room_map))
                add_vertex!(door_graph)
                room_map[next_room] = length(vertices(door_graph))
            end
            add_edge!(door_graph, room_map[curr_room], room_map[next_room])
        end
        step_idx += 1
    end

    door_graph, room_map
end

function door_dists(input)
    room_graph, room_map = build_rooms(input)
    ds = dijkstra_shortest_paths(room_graph, 1)
    ds.dists
end

function run_a()
    input = strip(load_input("20a"))
    maximum(door_dists(input))
end

function run_b()
    input = strip(load_input("20a"))
    count(d -> d >= 1000, door_dists(input))
end

end # module

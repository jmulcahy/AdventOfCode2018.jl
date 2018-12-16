module Day13

import Base.<
import ..load_input
import DataStructures: OrderedSet

const TURN_LEFT = [0 1; -1 0]
const GO_STRAIGHT = [1 0; 0 1]
const TURN_RIGHT = [0 -1; 1 0]

const UP = [-1 0]
const LEFT = [0 -1]
const DOWN = [1 0]
const RIGHT = [0 1]

input = "/->-\\        
|   |  /----\\
| /-+--+-\\  |
| | |  | v  |
\\-+-/  \\-+--/
  \\------/   
"


struct Cart
    position::Array{Int, 2}
    heading::Array{Int, 2}

    next_turn::Array{Int, 2}
end

Cart(position::Array{Int, 2}, heading::Array{Int, 2}) = Cart(position, heading, TURN_LEFT)

function Cart(position::Array{Int, 2}, direction::Char)
    if direction == '^'
        Cart(position, UP)
    elseif direction == '<'
        Cart(position, LEFT)
    elseif direction == 'v'
        Cart(position, DOWN)
    elseif direction == '>'
        Cart(position, RIGHT)
    else
        throw("Bad direction: " * direction)
    end
end


function Base.isless(lhs::Cart, rhs::Cart)
    if lhs.position[1] < rhs.position[1]
        true
    elseif lhs.position[1] == rhs.position[1] && lhs.position[2] < rhs.position[2]
        true
    else
        false
    end
end

function turn(cart::Cart, direction::Array{Int, 2})
    new_heading = cart.heading * direction
    Cart(cart.position .+ new_heading, new_heading, cart.next_turn)
end

function parse_input(input)
    char_array = collect(input)
    num_rows = count(c -> c == '\n', char_array)
    num_cols = findfirst(c -> c == '\n', char_array)[1] - 1
    track_map = permutedims(reshape(filter(c -> c != '\n', char_array), (num_cols, num_rows)), [2, 1])

    positions = findall(c -> c == '^' || c == '<' || c == 'v' || c == '>', track_map)

    carts = sort([Cart([pos[1] pos[2]], track_map[pos]) for pos in positions])

    (carts, track_map)
end

function update(cart, track_map)
    current_track = track_map[cart.position[1], cart.position[2]]
    if current_track == '\\'
        if cart.heading == UP || cart.heading == DOWN
            turn(cart, TURN_LEFT)
        elseif cart.heading == LEFT || cart.heading == RIGHT
            turn(cart, TURN_RIGHT)
        else
            throw("error in " * current_track)
        end
    elseif current_track == '/'
        if cart.heading == UP || cart.heading == DOWN
            turn(cart, TURN_RIGHT)
        elseif cart.heading == LEFT || cart.heading == RIGHT
            turn(cart, TURN_LEFT)
        else
            throw("error in " * current_track)
        end
    elseif current_track == '+'
        new_cart = turn(cart, cart.next_turn)
        if cart.next_turn == TURN_LEFT
            Cart(new_cart.position, new_cart.heading, GO_STRAIGHT)
        elseif cart.next_turn == GO_STRAIGHT
            Cart(new_cart.position, new_cart.heading, TURN_RIGHT)
        else
            Cart(new_cart.position, new_cart.heading, TURN_LEFT)
        end
    else
        Cart(cart.position .+ cart.heading, cart.heading, cart.next_turn)
    end
end

function collide_and_remove(cart, carts)
    match = nothing

    for old_cart in carts
        if cart.position == old_cart.position
            if match != nothing
                return (true, (match, old_cart))
            end
            match = old_cart
        end
    end
    (false, (nothing, nothing))
end

function run_carts(carts, track_map)
    new_carts = deepcopy(carts)
    num_carts = length(carts)

    while true
        current_carts = sort(new_carts)
        for idx in 1:num_carts
            new_carts[idx] = update(current_carts[idx], track_map)
            (collision, _) = collide_and_remove(new_carts[idx], new_carts)
            if collision
                reversed_dims = new_carts[idx].position .- 1
                return [reversed_dims[2], reversed_dims[1]]

            end
        end
    end
end

function run_a()
    (carts, track_map) = parse_input(load_input("13a"))
    run_carts(carts, track_map)
end

function run_until_1(carts, track_map)
    new_carts = Ref(deepcopy(carts))

    while true
        if length(new_carts.x) == 1
            reversed_dims = new_carts.x[1].position .- 1
            return [reversed_dims[2], reversed_dims[1]]
        elseif length(new_carts.x) == 0
            return nothing
        end

        current_carts = sort(new_carts.x)
        removeds = Set{Cart}()
        for idx in 1:length(current_carts)
            if current_carts[idx] in removeds
                new_carts.x[idx] = current_carts[idx]
                continue
            end
            new_carts.x[idx] = update(current_carts[idx], track_map)
            (collision, collided_carts) = collide_and_remove(new_carts.x[idx], new_carts.x)
            if collision
                push!(removeds, collided_carts[1])
                push!(removeds, collided_carts[2])
            end
        end

        new_carts.x = [cart for cart in new_carts.x if !(cart in removeds)]
    end
end

function run_b()
    (carts, track_map) = parse_input(load_input("13a"))
    run_until_1(carts, track_map)
end

end # module

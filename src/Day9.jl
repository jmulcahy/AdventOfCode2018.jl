module Day9

import ..load_input

mutable struct MarbleCircle{T}
    value::T
    next::MarbleCircle{T}
    previous::MarbleCircle{T}

    # MarbleCircle{T}(value::T) where T = (self = new(); self.value = value; self.next = self; self.previous = self)
    function MarbleCircle{T}(val::T) where T
        self = new()
        self.value = val
        self.next = self
        self.previous = self
        self
    end

    function MarbleCircle{T}(v::T, n::MarbleCircle, p::MarbleCircle) where T
        new(v, n, p)
    end
end

function Base.iterate(mc::MarbleCircle{T}) where T
    (mc, mc)
end

function Base.iterate(initial_mc::MarbleCircle{T}, mc::MarbleCircle{T}) where T
    if mc.next.value == initial_mc.value
        nothing
    else
        (mc.next, mc.next)
    end
end

function Base.values(mc::MarbleCircle{T}) where T
    values = Array{T, 1}()
    for i in mc
        push!(values, i.value)
    end

    values
end

function play_marble!(mc::MarbleCircle{T}, value::T) where T
    one_clockwise = mc.next
    two_clockwise = mc.next.next

    new_marble = MarbleCircle{T}(value, two_clockwise, one_clockwise)
    one_clockwise.next = new_marble
    two_clockwise.previous = new_marble

    new_marble
end

function score!(mc::MarbleCircle{T}) where T
    current = mc
    # rotate counterclockwise
    for i in 1:7
        current = current.previous
    end

    prev = current.previous
    next = current.next

    prev.next = next
    next.previous = prev

    (next, current.value)
end

function play_game(num_players::Int, final_marble::Int)
    last_marble_score = 0

    marble_circle = MarbleCircle{Int}(0)

    current_player = 1
    current_marble = 1
    scores = Int.(zeros(num_players))
    for i in 1:final_marble
        if current_marble % 23 != 0
            marble_circle = play_marble!(marble_circle, current_marble)
        else
            (marble_circle, removed_marble) = score!(marble_circle)
            last_marble_score = removed_marble + current_marble
            scores[current_player] += last_marble_score
        end

        current_marble += 1
        current_player = current_player % num_players + 1
    end

    maximum(scores)
end

function parse_input()
    input = load_input("9a")
    captures = match(r"(\d+) players; last marble is worth (\d+) points", input).captures
    (num_players = parse(Int, captures[1]), final_marble = parse(Int, captures[2]))
end

function run_a()
    input = parse_input()
    play_game(input.num_players, input.final_marble)
end

function run_b()
    input = parse_input()
    play_game(input.num_players, input.final_marble * 100)
end

end # module

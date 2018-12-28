module Day23

import Base.<
import ..load_input

using JuMP, Cbc

struct Nanobot
    x::Int
    y::Int
    z::Int
    radius::Int
end

function Base.isless(lhs::Nanobot, rhs::Nanobot)
    lhs.radius < rhs.radius
end

function parse_input(input)
    matches = eachmatch(r"pos=<([-]?\d+),([-]?\d+),([-]?\d+)>, r=(\d+)", input)
    parsed = [[parse(Int, cap) for cap in match.captures] for match in matches]

    [Nanobot(p[1], p[2], p[3], p[4]) for p in parsed]
end

function in_range(bot, other_bot)
    abs(bot.x - other_bot.x) + abs(bot.y - other_bot.y) + abs(bot.z - other_bot.z) <= bot.radius
end

function run_a()
    bots = parse_input(load_input("23a"))
    strongest = maximum(bots)

    count(bot -> in_range(strongest, bot), bots)
end

function find_best_position(bots, scale = 1e10)
    m = Model(solver=CbcSolver())

    @variable(m, c[1:length(bots)], Bin)
    @variable(m, x, Int)
    @variable(m, y, Int)
    @variable(m, z, Int)

    @objective(m, Max, sum(c))

    for (i, bot) in enumerate(bots)
        for (s1, s2, s3) in ((-1, -1, -1), (-1, -1, 1), (-1, 1, -1), (-1, 1, 1),
                             (1, -1, -1), (1, -1, 1), (1, 1, -1), (1, 1, 1))
            @constraint(m,
                        s1 * (x - bot.x) +
                        s2 * (y - bot.y) +
                        s3 * (z - bot.z)
                        <= bot.radius + (1 - c[i]) * scale)
        end
    end

    status = solve(m)

    Int.(round.((getvalue(x), getvalue(y), getvalue(z))))
end

function run_b()
    bots = parse_input(load_input("23a"))

    position = find_best_position(bots)

    sum(position)
end


end # module

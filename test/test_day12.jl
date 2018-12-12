@testset "Day 12" begin
    import AdventOfCode2018: Day12, load_input
    @testset "Example" begin
        input = "initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #"

        (state, rules) = Day12.parse_input(input)
        (final_state, first_pot_number) = Day12.propagate_plants(state, rules, 20)
        @test Day12.sum_plants(final_state, first_pot_number) == 325
    end

    @testset "Answers" begin
        @test Day12.run_a() == 1917
        @test Day12.run_b() == 1250000000991
    end
end


@testset "Day 15" begin
    import AdventOfCode2018: Day15

    test_input1 = "#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
"
    test_board = Day15.parse_input(test_input1)
    @testset "Helpers" begin
        @test Day15.find_candidates(Day15.GoblinType, test_board) == [(2, 5), (3, 4), (6, 6)]
        @test Day15.best_move((2, 3), (2, 5), test_board) == ([2, 4], 1)
    end

    @testset "Examples" begin
        test_input2 = "#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
"
        test_board2 = Day15.parse_input(test_input2)
        (final_board2, final_round2) = Day15.run_board(test_board2)
        @test Day15.eval_board(final_board2, final_round2) == 36334
        @test Day15.find_lowest_attack(test_input1) == 4988
    end

    @testset "Answers" begin
        @test_skip Day15.run_a() == 228730
        @test_skip Day15.run_b() == 33621
    end

end

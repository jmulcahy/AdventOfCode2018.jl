@testset "Day 9" begin
    import AdventOfCode2018.Day9: play_game, run_a, run_b

    @testset "Examples" begin
        @test play_game(9, 23) == 32
        @test play_game(10, 1618) == 8317
        @test play_game(13, 7999) == 146373
        @test play_game(17, 1104) == 2764
        @test play_game(21, 6111) == 54718
        @test play_game(30, 5807) == 37305
    end

    @testset "Answers" begin
        @test run_a() == 390093
        @test run_b() == 3150377341
    end
end

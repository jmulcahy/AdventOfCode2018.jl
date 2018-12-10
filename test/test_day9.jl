@testset "Day 9" begin
    import AdventOfCode2018: Day9

    @testset "Examples" begin
        @test Day9.play_game(9, 23) == 32
        @test Day9.play_game(10, 1618) == 8317
        @test Day9.play_game(13, 7999) == 146373
        @test Day9.play_game(17, 1104) == 2764
        @test Day9.play_game(21, 6111) == 54718
        @test Day9.play_game(30, 5807) == 37305
    end

    @testset "Answers" begin
        @test Day9.run_a() == 390093
        @test Day9.run_b() == 3150377341
    end
end

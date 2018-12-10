@testset "Day 5" begin
    import AdventOfCode2018: Day5

    @testset "Answers" begin
        @test_skip Day5.run_a() == 10598
        @test_skip Day5.run_b() == 5312
    end
end

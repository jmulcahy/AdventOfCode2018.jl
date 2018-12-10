@testset "Day 1" begin
    import AdventOfCode2018: Day1

    @testset "Answers" begin
        @test Day1.run_a() == 520
        @test Day1.run_b() == 394
    end
end

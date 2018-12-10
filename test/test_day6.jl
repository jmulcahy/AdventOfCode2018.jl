@testset "Day 6" begin
    import AdventOfCode2018: Day6

    @testset "Answers" begin
        @test Day6.run_a() == 5333
        @test Day6.run_b() == 35334
    end
end

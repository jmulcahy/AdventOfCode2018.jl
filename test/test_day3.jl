@testset "Day 3" begin
    import AdventOfCode2018: Day3

    @testset "Answers" begin
        @test Day3.run_a() == 109785
        @test Day3.run_b() == 504
    end
end

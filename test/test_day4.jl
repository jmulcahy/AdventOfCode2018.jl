@testset "Day 4" begin
    import AdventOfCode2018: Day4

    @testset "Answers" begin
        @test Day4.run_a() == 115167
        @test Day4.run_b() == 32070
    end
end

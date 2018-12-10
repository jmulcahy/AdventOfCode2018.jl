@testset "Day 2" begin
    import AdventOfCode2018: Day2

    @testset "Answers" begin
        @test Day2.run_a() == 6150
        @test Day2.run_b() == "rteotyxzbodglnpkudawhijsc"
    end
end

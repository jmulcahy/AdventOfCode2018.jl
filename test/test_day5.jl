@testset "Day 5" begin
    import AdventOfCode2018: Day5

    @testset "Examples" begin
        @test Day5.remove_matches("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
    end

    @testset "Answers" begin
        @test Day5.run_a() == 10598
        @test Day5.run_b() == 5312
    end
end

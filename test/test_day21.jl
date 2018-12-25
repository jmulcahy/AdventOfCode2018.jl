@testset "Day 21" begin
    import AdventOfCode2018: Day21

    @testset "Answers" begin
        @test Day21.run_a() == 3173684
        @test_skip Day21.run_b() == 12464363
    end
end

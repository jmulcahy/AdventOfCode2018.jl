@testset "Day 22" begin
    import AdventOfCode2018: Day22

    @testset "Example" begin
        cave = Day22.fill_cave(510, (10, 10), (20, 20))
        @test sum(cave[1:11, 1:11]) == 114
        @test Day22.find_shortest(cave, (10, 10)) == 45
    end

    @testset "Answers" begin
        @test Day22.run_a() == 11462
        @test Day22.run_b() == 1054
    end
end


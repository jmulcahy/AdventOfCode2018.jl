@testset "Day 17" begin
    import AdventOfCode2018: Day17, load_input
    @testset "Example" begin
        input = "x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
"

        ground_map, y_min, y_max = Day17.parse_input(input)
        water_map, source_map = Day17.run_water(ground_map, (y_min, 500), y_max)
        @test length(union(water_map, source_map)) == 57
        @test length(water_map) == 29
    end

    @testset "Answers" begin
        @test Day17.run_a() == 27042
        @test Day17.run_b() == 22214
    end
end

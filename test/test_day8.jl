@testset "Day 8" begin
    import AdventOfCode2018: Day8

    @testset "Examples" begin
        input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
        stream = Day8.parse_input(input)
        @test Day8.sum_node_metadata(stream) == (138, 17)
        @test Day8.sum_node(stream) == (66, 17)
    end

    @testset "Answers" begin
        @test Day8.run_a() == 42196
        @test Day8.run_b() == 33649
    end
end

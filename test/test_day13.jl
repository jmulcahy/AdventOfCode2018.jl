@testset "Day 13" begin
    import AdventOfCode2018: Day13

    @testset "Examples" begin
        input_a = "/->-\\        
|   |  /----\\
| /-+--+-\\  |
| | |  | v  |
\\-+-/  \\-+--/
  \\------/   
"
        (carts_a, track_map_a) = Day13.parse_input(input_a)
        @test Day13.run_carts(carts_a, track_map_a) == [7, 3]

        input_b = "/>-<\\  
|   |  
| /<+-\\
| | | v
\\>+</ |
  |   ^
  \\<->/
"
        (carts_b, track_map_b) = Day13.parse_input(input_b)

        @test Day13.run_until_1(carts_b, track_map_b) == [6, 4]
    end

    @testset "Answers" begin
        @test Day13.run_a() == [53, 133]
        @test Day13.run_b() == [111, 68]
    end
end

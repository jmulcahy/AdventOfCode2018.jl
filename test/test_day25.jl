@testset "Day 25" begin
    import AdventOfCode2018: Day25

    @testset "Examples" begin
        input1 = "0,0,0,0
 3,0,0,0
 0,3,0,0
 0,0,3,0
 0,0,0,3
 0,0,0,6
 9,0,0,0
12,0,0,0
"
        @test Day25.count_constellations(Day25.parse_input(input1)) == 2

        input2 = "-1,2,2,0
0,0,2,-2
0,0,0,-2
-1,2,0,0
-2,-2,-2,2
3,0,2,-1
-1,3,2,2
-1,0,-1,0
0,2,1,-2
3,0,0,0
"
        @test Day25.count_constellations(Day25.parse_input(input2)) == 4

        input3 = "1,-1,0,1
2,0,-1,0
3,2,-1,0
0,0,3,1
0,0,-1,-1
2,3,-2,0
-2,2,0,0
2,-2,0,-1
1,-1,0,-1
3,2,0,2
"
        @test Day25.count_constellations(Day25.parse_input(input3)) == 3

        input4 = "1,-1,-1,-2
-2,-2,0,1
0,2,1,3
-2,3,-2,1
0,2,3,-2
-1,-1,1,-2
0,-2,-1,0
-2,2,3,-1
1,2,2,0
-1,-2,0,-2
"
        @test Day25.count_constellations(Day25.parse_input(input4)) == 8
    end

    @testset "Answers" begin
        @test Day25.run_a() == 388
    end
end

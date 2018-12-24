@testset "Day 20" begin
    import AdventOfCode2018: Day20
    @testset "Examples" begin
        input1 = "^WNE\$"
        @test maximum(Day20.door_dists(input1)) == 3
        input2 = "^ENWWW(NEEE|SSE(EE|N))\$"
        @test maximum(Day20.door_dists(input2)) == 10
        input3 = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN\$"
        @test maximum(Day20.door_dists(input3)) == 18
    end

    @testset "Answers" begin
        @test Day20.run_a() == 3835
        @test Day20.run_b() == 8520
    end
end

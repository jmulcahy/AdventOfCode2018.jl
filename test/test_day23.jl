@testset "Day 23" begin
    import AdventOfCode2018: Day23
    @testset "Example" begin
        input1 = "pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
"
        bots1 = Day23.parse_input(input1)
        strongest = maximum(bots1)
        @test count(bot -> Day23.in_range(strongest, bot), bots1) == 7

        input2 = "pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
"
        bots2 = Day23.parse_input(input2)
        @test Day23.find_best_position(bots2, 1e5) == (12, 12, 12)
    end

    @testset "Answers" begin
        @test Day23.run_a() == 491
        @test Day23.run_b() == 60474080
    end
end

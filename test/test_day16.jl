@testset "Day 16" begin
    import AdventOfCode2018: Day16
    @testset "Examples" begin
        test_input = "Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
"
        sample = Day16.parse_inputa(test_input)[1]
        @test Day16.test_sample(sample) == [Day16.addi, Day16.mulr, Day16.seti]
    end

    @testset "Answers" begin
        @test Day16.run_a() == 592
        @test Day16.run_b() == 557
    end
end

@testset "Day 7" begin
    import AdventOfCode2018: Day7
    @testset "Examples" begin
        test_input = "Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin."
        (instructions, num_parents) = Day7.parse_input(test_input)

        @test Day7.instruction_order(instructions, num_parents) == "CABDFE"
        @test Day7.instruction_time(instructions, num_parents, 2, 0) == 15
    end

    @testset "Answers" begin
        @test Day7.run_a() == "BGJCNLQUYIFMOEZTADKSPVXRHW"
        @test Day7.run_b() == 1017
    end
end

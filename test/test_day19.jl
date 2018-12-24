@testset "Day 19" begin
    import AdventOfCode2018: Day19

    @testset "Example" begin
        input = "#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
"
        ip_reg, program = Day19.parse_input(input)
        @test Day19.run_program(ip_reg, program) == [6, 5, 6, 0, 0, 9]
    end

    @testset "Answer" begin
        @test Day19.run_a() == 2304
        @test Day19.run_b() == 28137600
    end
end

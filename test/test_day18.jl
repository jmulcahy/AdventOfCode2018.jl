@testset "Day 18" begin
    import AdventOfCode2018: Day18

    @testset "Example" begin
        input = ".#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
"
        output = ".||##.....
||###.....
||##......
|##.....##
|##.....##
|##....##|
||##.####|
||#####|||
||||#|||||
||||||||||
"
        in_board = Day18.parse_input(input)
        out_board = Day18.parse_input(output)

        @test Day18.run_board(in_board, 10) == out_board
    end
    @testset "Answers" begin
        @test Day18.run_a() == 663502
        @test Day18.run_b() == 201341
    end
end

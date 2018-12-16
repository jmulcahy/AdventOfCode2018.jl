@testset "Day 14" begin
    import AdventOfCode2018: Day14

    @testset "Helpers" begin
        @test Day14.extract_digits(123) == [1, 2, 3]
        @test Day14.update_board!([3, 7, -1, -1], (1, 2), 2) == ([3, 7, 1, 0], [1, 2], 4)
        @test Day14.array_to_num([1, 2, 3]) == "123"
    end

    @testset "Examples" begin
        @test Day14.recipes_after(9, 10) == "5158916779"
        @test Day14.recipes_after(5, 10) == "0124515891"
        @test Day14.recipes_after(18, 10) == "9251071085"
        @test Day14.recipes_after(2018, 10) == "5941429882"

        @test Day14.recipes_before("51589", 10000) == 9
        @test Day14.recipes_before("01245", 10000) == 5
        @test Day14.recipes_before("92510", 10000) == 18
        @test Day14.recipes_before("59414", 10000) == 2018
    end

    @testset "Answers" begin
        @test Day14.run_a() == "1631191756"
        @test Day14.run_b() == 20219475
    end
end

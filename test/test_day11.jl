@testset "Day 11" begin
    import AdventOfCode2018: Day11

    @testset "Fuel Cell Power" begin
        @test Day11.fuel_cell_power((3, 5), 8) == 4
        @test Day11.fuel_cell_power((122, 79), 57) == -5
        @test Day11.fuel_cell_power((217, 196), 39) == 0
        @test Day11.fuel_cell_power((101, 153), 71) == 4
    end

    @testset "Examples" begin
        @test Day11.greatest_power((300, 300), 18, 3)[2] == CartesianIndex(33, 45)
        @test Day11.greatest_power((300, 300), 42, 3)[2] == CartesianIndex(21, 61)
    end

    @testset "Answers" begin
        @test Day11.run_a() == CartesianIndex(21, 77)
        @test_skip Day11.run_b() == ((255, CartesianIndex(224, 222)), 27)
    end
end

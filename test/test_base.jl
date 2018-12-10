@testset "Base" begin
    import AdventOfCode2018: load_input
    @test load_input("test") == "test123\n"
end

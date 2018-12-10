using Test

days_finished = 9

@testset "AdventOfCode2018" begin
    for day in 1:days_finished
        fp = joinpath(dirname(@__FILE__), "test_day$day.jl")
        include(fp)
    end
end

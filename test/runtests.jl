using Test
import AdventOfCode2018: number_of_days


@testset "AdventOfCode2018" begin
    for day in 1:number_of_days
        fp = joinpath(dirname(@__FILE__), "test_day$day.jl")
        include(fp)
    end

    include("test_base.jl")
end

module AdventOfCode2018

function load_input(problem)
    filename = "input_" * problem * ".txt"
    path = joinpath(dirname(pathof(AdventOfCode2018)), "..", "inputs", filename)
    open(path) do file
        read(file, String)
    end
end

include("Day1.jl")
include("Day2.jl")
include("Day3.jl")
include("Day4.jl")
include("Day5.jl")
include("Day6.jl")
include("Day7.jl")
include("Day8.jl")
include("Day9.jl")

end # module

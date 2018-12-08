module AdventOfCode2018

function load_input(problem)
    filename = "input_" * problem * ".txt"
    path = joinpath(dirname(pathof(AdventOfCode2018)), "..", "inputs", filename)
    open(path) do file
        read(file, String)
    end
end

include("Day1.jl")

end # module
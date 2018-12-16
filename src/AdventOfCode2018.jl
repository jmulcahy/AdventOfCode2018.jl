module AdventOfCode2018

function load_input(problem)
    filename = "input_$problem.txt"
    path = joinpath(dirname(pathof(AdventOfCode2018)), "..", "inputs", filename)
    open(path) do file
        read(file, String)
    end
end

const number_of_days = 13

for day in 1:number_of_days
    fp = joinpath(dirname(@__FILE__), "Day$day.jl")
    include(fp)
end

end # module

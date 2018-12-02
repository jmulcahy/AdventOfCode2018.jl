s = open("input_a.txt") do file
    read(file, String)
end

result = sum(map(line -> parse(Int, line), split(strip(s), r"\n")))

println(result)

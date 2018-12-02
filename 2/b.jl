s = open("input_a.txt") do file
    read(file, String)
end

result = match(r"(.*)(.)(.*)\n(?:.*\n)*\1[^\2]\3\n", s)

println("$(result.captures[1])$(result.captures[3])")

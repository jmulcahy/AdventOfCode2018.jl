s = open("input1a.txt") do file
    read(file, String)
end

ans = sum(map(line -> parse(Int, line), split(strip(s), r"\n")))

print("$ans")

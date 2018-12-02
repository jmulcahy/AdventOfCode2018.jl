s = open("input1a.txt") do file
    read(file, String)
end

nums = map(line -> parse(Int, line), split(strip(s), r"\n"))


visited = Set()
current = 0

for num in Iterators.flatten(Iterators.repeated(nums))
    global current += num
    if current in visited
        break;
    end
    push!(visited, current)
end

println(current)

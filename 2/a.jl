s = open("input_a.txt") do file
    read(file, String)
end

lines = split(strip(s), r"\n")

twos = 0
threes = 0

for line in lines
    cs = Dict{Char}{Int64}()
    for c in line
        cs[c] = get(cs, c, 0) + 1
    end
    if 2 in values(cs)
        global twos += 1
    end
    if 3 in values(cs)
        global threes += 1
    end
end

println("$(twos*threes)")

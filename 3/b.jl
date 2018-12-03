function load(filename)
    open(filename) do file
        read(file, String)
    end
end

function parse_input(file_text)
    parse_line = line -> map(s -> parse(Int64, s), match(r"#(.*) @ (.*),(.*): (.*)x(.*)", line).captures)
    make_dict = captures -> Dict(:claim_id => captures[1], :start_col => captures[2],
                                 :start_row => captures[3], :width => captures[4],
                                 :height => captures[5])
    lines = split(strip(file_text), r"\n")
    map(line -> make_dict(parse_line(line)), lines)
end

claims = parse_input(load("input_a.txt"))

claim_mask = zeros(1001, 1001)

for claim in claims
    claim_mask[(claim[:start_col]+1):(claim[:start_col] + claim[:width]),
               (claim[:start_row]+1):(claim[:start_row] + claim[:height])] .+= 1
end

for claim in claims
    if all(x -> x == 1, claim_mask[(claim[:start_col]+1):(claim[:start_col] + claim[:width]),
                                   (claim[:start_row]+1):(claim[:start_row] + claim[:height])])
        print(claim[:claim_id])
    end
end

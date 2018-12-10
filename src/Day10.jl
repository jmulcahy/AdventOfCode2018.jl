module Day10

import ..load_input

function parse_input(input)
    matches = eachmatch(r"position=<\s*(-?\d+), \s*(-?\d+)> velocity=<\s*(-?\d+), \s*(-?\d+)>", input)
    hcat([[parse(Int, capture) for capture in match.captures] for match in matches]...)'
end

function update_states(states)
    new_states = deepcopy(states)
    for i in 1:size(new_states, 1)
        new_states[i, 1] += new_states[i, 3]
        new_states[i, 2] += new_states[i, 4]
    end
    new_states
end

function create_mask(states)
    (min_row, min_col, _, _) = minimum(states, dims=1)
    (max_row, max_col, _, _) = maximum(states, dims=1)
    mask_rows = max_row - min_row + 1
    mask_cols = max_col - min_col + 1

    mask = falses(mask_rows, mask_cols)
    for i in 1:size(states, 1)
        state_row = states[i, 1] - min_row + 1
        state_col = states[i, 2] - min_col + 1
        mask[state_row, state_col] = true
    end

    mask
end

function run()
    states = parse_input(load_input("10a"))
    for i in 1:100000
        states = update_states(states)
        (min_row, min_col, _, _) = minimum(states, dims=1)
        (max_row, max_col, _, _) = maximum(states, dims=1)
        if (max_row - min_row) * (max_col - min_col) < 1000
            return (create_mask(states), i)
        end
    end
end

function print_mask(mask)
    for col in 1:size(mask, 2)
        for row in 1:size(mask, 1)
            if mask[row, col]
                print("#")
            else
                print(" ")
            end
        end
        println()
    end
end

end # module

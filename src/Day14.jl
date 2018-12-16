module Day14

function extract_digits(num)
    num_digits = length(string(num))
    [div(num, 10^digit) % 10 for digit in (num_digits-1):-1:0]
end

function update_board!(board, positions, last)
    position_sum = sum((board[p] for p in positions))
    new_recipes = extract_digits(position_sum)
    new_last = last + length(new_recipes)
    board[(last+1):new_last] = new_recipes

    new_positions = [(p + board[p]) % new_last + 1 for p in positions]

    (board, new_positions, new_last)
end

function array_to_num(array)
    prod(string(c) for c in array)
end

function recipes_after(num_recipes, num_after)
    board = fill(-1, (num_recipes+num_after)*2)
    board[1:2] = [3, 7]

    recipes = 2
    positions = (1, 2)
    while recipes < num_recipes + num_after
        (board, positions, recipes) = update_board!(board, positions, recipes)
    end

    array_to_num(board[(num_recipes+1):(num_recipes+num_after)])
end

function run_a()
    recipes_after(409551, 10)
end

function match_sequence(array, sequence)
    for k in 1:(length(array) - length(sequence))
        if array[k:(k+length(sequence)-1)] == sequence
            return k - 1
        end
    end
end

function string_to_array(str)
    [parse(Int64, c) for c in str]
end

function recipes_before(sequence, max_recipes)
    board = fill(-1, max_recipes)
    board[1:2] = [3, 7]

    recipes = 2
    positions = (1, 2)

    while recipes < div(length(board), 2)
        (board, positions, recipes) = update_board!(board, positions, recipes)
    end

    match_sequence(board, string_to_array(sequence))
end

function run_b()
    recipes_before("409551", 100000000)
end

end # module

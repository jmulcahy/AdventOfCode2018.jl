module Day18

import ..load_input

function parse_input(input)
    char_array = collect(input)
    num_rows = count(c -> c == '\n', char_array)
    num_cols = findfirst(c -> c == '\n', char_array)[1] - 1

    permutedims(reshape(filter(c -> c != '\n', char_array), (num_cols, num_rows)), [2, 1])
end

function update_tile(region)
    if region[2, 2] == '.'
        num_trees = count(c -> c == '|', region)
        if num_trees >= 3
            '|'
        else
            '.'
        end
    elseif region[2, 2] == '|'
        num_lumberyards = count(c -> c == '#', region)
        if num_lumberyards >= 3
            '#'
        else
            '|'
        end
    elseif region[2, 2] == '#'
        num_trees = count(c -> c == '|', region)
        num_lumberyards = count(c -> c == '#', region) - 1
        if num_lumberyards >= 1 && num_trees >= 1
            '#'
        else
            '.'
        end
    end

end

function update_board(board)
    new_board = deepcopy(board)
    for col in 2:(size(board, 2) - 1)
        for row in 2:(size(board, 1) - 1)
            new_board[row, col] = update_tile(@view board[(row-1):(row+1), (col-1):(col+1)])
        end
    end

    new_board
end

function run_board(board, turns)
    padded = fill(' ', size(board) .+ (2, 2))
    padded[2:(end-1), 2:(end-1)] = board

    for _ in 1:turns
        padded = update_board(padded)
    end

    padded[2:(end-1), 2:(end-1)]
end

function score(board)
    num_trees = count(c -> c == '|', board)
    num_lumberyards = count(c -> c == '#', board)

    num_trees * num_lumberyards
end


function run_a()
    board = parse_input(load_input("18a"))
    final_board = run_board(board, 10)

    score(final_board)
end

function run_b()
    board = parse_input(load_input("18a"))
    scores = Dict{Int, Int}()

    board = run_board(board, 1000)
    new_score = score(board)
    minute = 1000
    scores[minute] = new_score

    # the automata is periodic, need to find the period and values
    while true
        board = run_board(board, 1)
        new_score = score(board)
        minute += 1
        if new_score in values(scores)
            break
        else
            scores[minute] = new_score
        end
    end

    idx = (1000000000 - 1000) % 28 + 1000
    scores[idx]
end

end # module

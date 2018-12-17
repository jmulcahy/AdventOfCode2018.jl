module Day15

import ..load_input

abstract type Tile end
abstract type Blocked <: Tile end

struct Open <: Tile
end

@enum CreatureType begin
    ElfType
    GoblinType
end

struct Creature <: Blocked
    health::Int
    attack::Int
    creature_type::CreatureType
    moved::Bool
end

Elf(elf_attack::Int=3) = Creature(200, elf_attack, ElfType, false)
Goblin() = Creature(200, 3, GoblinType, false)

struct Wall <: Blocked
end

function char_to_tile(c::Char, elf_attack::Int)::Tile
    if c == '.'
        Open()
    elseif c == '#'
        Wall()
    elseif c == 'E'
        Elf(elf_attack)
    elseif c == 'G'
        Goblin()
    else
        throw("Invalid tile type")
    end
end

function parse_input(input, elf_attack=3)
    char_array = collect(input)
    num_rows = count(c -> c == '\n', char_array)
    num_cols = findfirst(c -> c == '\n', char_array)[1] - 1
    tile_chars = permutedims(reshape(filter(c -> c != '\n', char_array), (num_cols, num_rows)), [2, 1])

    map(x -> char_to_tile(x, elf_attack), tile_chars)
end

function try_attack!(board, (row, col))
    tile = board[row, col]
    adjacents = [[row-1, col], [row, col-1], [row, col+1], [row+1, col]]

    adj_health = map(adj -> begin
                     adj_tile = board[adj[1], adj[2]]
                     if typeof(adj_tile) == Creature && adj_tile.creature_type != tile.creature_type
                     adj_tile.health
                     else
                     typemax(Int)
                     end
                     end, adjacents)

    (low_health, adj_idx) = findmin(adj_health)
    if low_health == typemax(Int)
        false
    else
        chosen_adj = adjacents[adj_idx]
        chosen = board[chosen_adj[1], chosen_adj[2]]
        if chosen.health - tile.attack > 0
            board[chosen_adj[1], chosen_adj[2]] =
                Creature(chosen.health - tile.attack, chosen.attack, chosen.creature_type, chosen.moved)
        else
            board[chosen_adj[1], chosen_adj[2]] = Open()
        end
        true
    end
end

function find_candidates(creature_type, board)
    candidates = Array{Tuple{Int, Int}, 1}()

    (max_row, max_col) = size(board)
    for row in 1:max_row
        for col in 1:max_col
            if typeof(board[row, col]) == Creature && board[row, col].creature_type != creature_type
                adjacents = [(row-1, col), (row+1, col), (row, col-1), (row, col+1)]
                for adj in adjacents
                    if typeof(board[adj[1], adj[2]]) == Open
                        push!(candidates, adj)
                    end
                end
            end
        end
    end


    candidates
end

function dist_grid!(dist_grid, (row1, col1), (row2, col2), board)
    adjacents = [[row2-1, col2], [row2+1, col2], [row2, col2-1], [row2, col2+1]]

    for adj in adjacents
        if typeof(board[adj[1], adj[2]]) <: Blocked
            continue
        end

        if dist_grid[adj[1], adj[2]] > dist_grid[row2, col2] + 1
            dist_grid[adj[1], adj[2]] = dist_grid[row2, col2] + 1
            dist_grid!(dist_grid, (row1, col1), adj, board)
        end
    end

    nothing
end

function best_move((row1, col1), (row2, col2), board)

    dist_grid = fill(typemax(Int), size(board))
    dist_grid[row2, col2] = 0

    dist_grid!(dist_grid, (row1, col1), (row2, col2), board)

    best_distance = typemax(Int) - 1
    move = [row1, col1]

    adjacents = [[row1-1, col1], [row1, col1-1], [row1, col1+1], [row1+1, col1]]
    for adj in adjacents
        if best_distance > dist_grid[adj[1], adj[2]]
            best_distance = dist_grid[adj[1], adj[2]]
            move = adj
        end
    end

    (move, best_distance)
end

function move!(board, (row, col))
    creature_type = board[row, col].creature_type
    candidates = find_candidates(creature_type, board)

    distance = typemax(Int) - 1
    move = [row, col]
    for candidate in candidates
        (cand_move, cand_dist) = best_move((row, col), candidate, board)

        if cand_dist < distance
            move = cand_move
            distance = cand_dist
        elseif cand_dist == distance
            if cand_move[1] < move[1]
                move = cand_move
            elseif cand_move[1] == move[1] && cand_move[2] < move[2]
                move = cand_move
            end
        end
    end

    (best_row, best_col) = move
    current = board[row, col]
    board[row, col] = Open()
    board[best_row, best_col] = Creature(current.health, current.attack, current.creature_type, true)

    try_attack!(board, (best_row, best_col))

    nothing
end

function tile_turn!((row, col), board)
    tile = board[row, col]

    if typeof(tile) != Creature || tile.moved
        nothing
    elseif try_attack!(board, (row, col))
        nothing
    else
        move!(board, (row, col))
    end
end

function board_turn(board)
    new_board = deepcopy(board)
    (max_row, max_col) = size(board)
    for row in 1:max_row
        for col in 1:max_col
            tile_turn!((row, col), new_board)
        end
    end

    for row in 1:max_row
        for col in 1:max_col
            current = new_board[row, col]
            if typeof(current) == Creature
                new_board[row, col] = Creature(current.health, current.attack, current.creature_type, false)
            end
        end
    end

    new_board
end

function run_board(board)
    new_board = deepcopy(board)
    enemies_left = true
    round = 0
    while enemies_left
        new_board = board_turn(new_board)

        if count(i -> typeof(i) == Creature && i.creature_type == ElfType, new_board) == 0 ||
            count(i -> typeof(i) == Creature && i.creature_type == GoblinType, new_board) == 0
            enemies_left = false
            break
        else
            round += 1
        end
    end

    (new_board, round)
end

function print_board(board)
    for row in 1:size(board, 1)
        for col in 1:size(board, 2)
            tile_type = typeof(board[row, col])
            if tile_type == Open
                print(".")
            elseif tile_type == Wall
                print("#")
            elseif tile_type == Creature
                if board[row, col].creature_type == ElfType
                    print("E")
                else
                    print("G")
                end
            end
        end
        println()
    end
end

function eval_board(board, final_round)
    creatures = filter(t -> typeof(t) == Creature, board)
    health_sum = sum([t.health for t in creatures])

    health_sum * final_round
end

function run_a()
    board = parse_input(load_input("15a"))
    (final_board, final_round) = run_board(board)
    eval_board(final_board, final_round)
end

function find_lowest_attack(input)
    elf_attack = 2
    elves_dead = true
    (final_board, final_round) = run_board(parse_input(input, 2))

    iself(tile) = typeof(tile) == Creature && tile.creature_type == ElfType
    while elves_dead
        elf_attack += 1
        board = parse_input(input, elf_attack)
        (final_board, final_round) = run_board(parse_input(input, elf_attack))
        if count(iself, board) == count(iself, final_board)
            elves_dead = false
        end
    end

    eval_board(final_board, final_round)
end

function run_b()
    input = load_input("15a")
    find_lowest_attack(input)
end


end # module

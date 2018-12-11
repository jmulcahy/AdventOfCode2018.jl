module Day11

import DSP: conv2

function fuel_cell_power((x, y)::Tuple{Int, Int}, serial_number::Int)
    rack_id = x + 10
    pre_div = (rack_id * y + serial_number) * rack_id
    div(pre_div, 100) % 10 - 5
end

function create_grid((x_max, y_max)::Tuple{Int, Int}, serial_number::Int)
    grid = Int.(zeros(x_max, y_max))

    for y in 1:y_max
        for x in 1:x_max
            grid[x, y] = fuel_cell_power((x, y), serial_number)
        end
    end

    grid
end

function greatest_power(grid_dims::Tuple{Int, Int}, serial_number::Int, square_size::Int)
    grid = create_grid(grid_dims, serial_number)
    powers = conv2(Int.(ones(square_size, square_size)), grid)
    findmax(powers[square_size:(end-square_size+1), square_size:(end-square_size+1)])
end

function run_a()
    greatest_power((300, 300), 3999, 3)[2]
end

function run_b()
    greatest_powers = [greatest_power((300, 300), 3999, square_size) for square_size in 1:300]
    findmax(greatest_powers)
end




end # module

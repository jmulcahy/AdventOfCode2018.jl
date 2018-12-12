module Day12

import ..load_input

function parse_input(input)
    initial_state = match(r"initial state: (.*)\n", input).captures[1]

    rules_matches = eachmatch(r"(.....) => #", input)
    rules = Set{String}([match.captures[1] for match in rules_matches])

    (initial_state, rules)
end

function apply_rules(state, rules, first_pot_number)
    prepended_state = "....." * state * "....."

    new_state = String([prepended_state[(i-2):(i+2)] in rules ? '#' : '.' for i in 3:(length(prepended_state)-2)])

    first_plant = findfirst("#", new_state)[1] - 1

    (strip(new_state, '.'), first_pot_number + first_plant - 3)
end

function propagate_plants(initial_state, rules, num_generations)
    state = deepcopy(initial_state)
    first_pot_number = 0
    for i in 1:num_generations
        (current_state, first_pot_number) = apply_rules(state, rules, first_pot_number)
        if current_state == state
            return (current_state, first_pot_number, i)
        end
        state = current_state
    end

    (state, first_pot_number, num_generations)
end

function sum_plants(state, first_pot_number)
    sum([state[i] == '#' ? (first_pot_number + i - 1) : 0 for i in 1:length(state)])
end

function run_a()
    (state, rules) = parse_input(load_input("12a"))

    (final_state, first_pot_number, _) = propagate_plants(state, rules, 20)

    sum_plants(final_state, first_pot_number)
end

function run_b()
    (state, rules) = parse_input(load_input("12a"))

    # when the pattern converges, it just slides to the right by 1 for each generation

    (final_state, first_pot_number, gens_to_converge) = propagate_plants(state, rules, 50_000_000_000)

    sum_plants(final_state, 50_000_000_000 - (gens_to_converge - first_pot_number))
end


end # module

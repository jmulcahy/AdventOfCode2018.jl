module Day24

import Base.<
import DataStructures: PriorityQueue, enqueue!, dequeue!, peek
import ..load_input

@enum DamageType begin
    Slashing
    Fire
    Radiation
    Bludgeoning
    Cold
end

function DamageType(str::String)
    if str == "slashing"
        Slashing
    elseif str == "fire"
        Fire
    elseif str == "radiation"
        Radiation
    elseif str == "bludgeoning"
        Bludgeoning
    elseif str == "cold"
        Cold
    else
        nothing
    end
end

struct Group
    num_units::Int
    hit_points::Int
    immunities::Set{DamageType}
    weaknesses::Set{DamageType}
    attack_power::Int
    attack_type::DamageType
    initiative::Int
end

function Group(arr, boost=0)
    nu = parse(Int, arr[1])
    hp = parse(Int, arr[2])
    ims = Set{DamageType}()
    wks = Set{DamageType}()
    if arr[3] != nothing
        ims = Set((DamageType(String(str)) for str in split(arr[3], ", ")))
    end
    if arr[4] != nothing
        wks = Set((DamageType(String(str)) for str in split(arr[4], ", ")))
    end
    if arr[5] != nothing
        ims = Set((DamageType(String(str)) for str in split(arr[5], ", ")))
    end
    ap = parse(Int, arr[6])
    at = DamageType(String(arr[7]))
    init = parse(Int, arr[8])

    Group(nu, hp, ims, wks, ap+boost, at, init)
end

function Base.isless(lhs::Group, rhs::Group)
    (lhs.attack_power * lhs.num_units < rhs.attack_power * rhs.num_units) ||
        (lhs.attack_power * lhs.num_units == rhs.attack_power * rhs.num_units && lhs.initiative < rhs.initiative)
end

function parse_groups(raw_group, boost=0)
    group_regex = r"(\d+) units each with (\d+) hit points(?: \((?:immune to (.*?))?(?:; )?(?:weak to (.*?))?(?:; )?(?:immune to (.*?))?(?:; )?\))? with an attack that does (\d+) (.*) damage at initiative (\d+)\n"
    matched_groups = eachmatch(group_regex, raw_group)

    [Group(matched_group.captures, boost) for matched_group in matched_groups]
end

function parse_input(input, boost=0)
    raw_immune_groups = match(r"Immune System:\n((?:.+\n)*)", input).captures[1]
    immune_groups = parse_groups(raw_immune_groups, boost)

    raw_infection_groups = match(r"Infection:\n((?:.+\n)*)", input).captures[1]
    infection_groups = parse_groups(raw_infection_groups)

    immune_groups, infection_groups
end

function attack_damage(attacker, defender)
    if attacker.attack_type in defender.immunities
        0
    elseif attacker.attack_type in defender.weaknesses
        2 * attacker.num_units * attacker.attack_power
    else
        attacker.num_units * attacker.attack_power
    end
end

function select_targets(attackers, defenders)
    # both inputs need to be sorted before this function
    # key is attacker's priority, value tuple is the (attacker index, defender index)
    attack_queue = PriorityQueue{Tuple{Int, Int}, Int}(Base.Order.Reverse)
    attacked = Set{Group}()

    # select targets
    for (a_idx, attacker) in enumerate(attackers)
        potential_attacks = [defender in attacked ? -1 : attack_damage(attacker, defender)
                             for defender in defenders]

        dmg, d_idx = findmax(potential_attacks)
        if dmg > 0
            enqueue!(attack_queue, ((a_idx, d_idx) => attacker.initiative))
            push!(attacked, defenders[d_idx])
        end
    end

    attack_queue
end

function attack(attacker, defender)
    if attacker.num_units <= 0
        return defender
    end

    damage = attack_damage(attacker, defender)
    remaining_hp = defender.num_units * defender.hit_points - damage
    remaining_units = Int(ceil(remaining_hp / defender.hit_points))

    Group(remaining_units, defender.hit_points,
          defender.immunities, defender.weaknesses,
          defender.attack_power, defender.attack_type, defender.initiative)
end

function run_round(immune_groups, infection_groups)
    imms = sort(immune_groups, rev=true)
    infs = sort(infection_groups, rev=true)

    # select targets
    imms_queue = select_targets(imms, infs)
    infs_queue = select_targets(infs, imms)

    imms_attacked = 0
    infs_attacked = 0

    # perform attacks
    while !isempty(imms_queue) || !isempty(infs_queue)
        next_imm = typemin(Int)
        if !isempty(imms_queue)
            next_imm = peek(imms_queue)[2]
        end

        next_inf = typemin(Int)
        if !isempty(infs_queue)
            next_inf = peek(infs_queue)[2]
        end

        if next_imm > next_inf
            a_idx, d_idx = dequeue!(imms_queue)
            infs[d_idx] = attack(imms[a_idx], infs[d_idx])
        else
            a_idx, d_idx = dequeue!(infs_queue)
            imms[d_idx] = attack(infs[a_idx], imms[d_idx])
        end
    end

    # prune the dead
    still_alive(group) = group.num_units > 0
    filter(still_alive, imms), filter(still_alive, infs)
end

function run_battle(immune_groups, infection_groups)
    imms = deepcopy(immune_groups)
    infs = deepcopy(infection_groups)

    while !isempty(imms) && !isempty(infs)
        imms, infs = run_round(imms, infs)
    end

    imms, infs
end

function run_a()
    input = load_input("24a")
    immune_groups, infection_groups = parse_input(input)
    final_immunes, final_infections = run_battle(immune_groups, infection_groups)

    sum([imm.num_units for imm in final_immunes]) + sum([inf.num_units for inf in final_infections])
end

function run_b()
    input = load_input("24a")
    # found with manual binary search since the numbers are low, 26-28 seem to loop infinitely
    # they could be detected by seeing that nothing dies between rounds
    immune_groups, infection_groups = parse_input(input, 29)
    final_immunes, final_infections = run_battle(immune_groups, infection_groups)

    sum([imm.num_units for imm in final_immunes])
end

end # module

@testset "Day 24" begin
    import AdventOfCode2018: Day24

    @testset "Examples" begin
        input1 = "Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
"
        imms1, infs1 = Day24.parse_input(input1)
        final_imms1, final_infs1 = Day24.run_battle(imms1, infs1)
        @test sum([imm.num_units for imm in final_imms1]) + sum([inf.num_units for inf in final_infs1]) == 5216
    end

    @testset "Answers" begin
        @test Day24.run_a() == 18346
        @test Day24.run_b() == 8698
    end
end

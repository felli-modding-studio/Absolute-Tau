function AbsoluteTau.get_probability_vars(cen, num, den)
    local amount = SMODS.calculate_context({
        tau_probability_mod = true,
        numerator = num,
        denominator = den,
        center = cen
    })
    local fixed = SMODS.calculate_context({
        tau_fix_probability = true,
        numerator = num,
        denominator = den,
        center = cen
    })
    if (fixed and amount) then
        amount.numerator = fixed.numerator or amount.numerator
        amount.denominator = fixed.denominator or amount.denominator
    end
    return (amount and amount.numerator or num), (amount and amount.denominator or den)
end

local fakecreate = create_card
function create_card(...)
    local out = fakecreate(...)

    if out.config.center.tauic_variant then
        local denominator = G.GAME.tau_denominator
        local numerator = G.GAME.tau_numerator

        numerator, denominator = vallkarri.get_tau_probability_vars(out.config.center.key, numerator, denominator)

        local roll = (pseudorandom("roll_tauic") * (denominator - 1)) + 1
        if roll <= numerator then
            out:set_ability(out.config.center.tauic_variant)
            out:juice_up()
            play_sound("explosion_release1", 1, 3)
            G.GAME.tau_denominator = G.GAME.base_tau_denominator
        else
            out:juice_up()
            G.GAME.tau_denominator = G.GAME.tau_denominator - G.GAME.tau_denominator_inc
        end
    end
    return out
end

SMODS.Joker {
    key = "tauist",
    loc_txt = {
        name = "Tauist",
        text = {
            "{C:tau_tau_colours}Tauic{} Jokers are {X:tau_tau_colours,C:white}X#1#{} more likely to spawn",
            "Increase by {X:valk_tauic,C:white}X#2#{} at end of round",
        }
    },
    config = { extra = { mult = 1, gain = 0.25} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.gain } }
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=8, y=4},
    soul_pos = {x=8, y=8, extra = {x=9, y=4}},
    cost = 12,
    calculate = function(self, card, context)
        if context.tau_probability_mod then
            return {
                numerator = context.numerator * card.ability.extra.mult
            }
        end

        if context.end_of_round and context.main_eval then
            SMODS.scale_card(card, {ref_table = card.ability.extra, scalar_value = "gain", ref_value = "mult"})
        end
    end
}
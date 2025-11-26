SMODS.Atlas {
    key = "stickers",
    px = 71,
    py = 95,
    path = "stickers.png",
}

SMODS.Sticker {
    key = "transformative",
    config = { rounds = 5 },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if not card.config.center.tauic_variant then
                card:remove_sticker(self.key)
                return
            end
            card.ability.transform_rounds = card.ability.transform_rounds or self.config.rounds
            card.ability.transform_rounds = card.ability.transform_rounds - 1
            SMODS.calculate_effect({message = localize { type = 'variable', key = 'a_remaining', vars = { card.ability.transform_rounds } }}, card)
            if card.ability.transform_rounds <= 0 then
                card:set_ability(card.config.center.tauic_variant)
                SMODS.calculate_effect({message = localize("k_upgrade_ex")}, card)
                play_sound("explosion_release1", 1, 3)

                card:remove_sticker(self.key)
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.transform_rounds or self.config.rounds
            }
        }
    end,
    badge_colour = HEX("523DBA"),,
    atlas = "stickers",
    pos = {x=0,y=0},

}
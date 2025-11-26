SMODS.Consumable {
    set = "Spectral",
    key = "absolutetau",

    cost = 25,
    atlas = "main",
    pos = {x=3, y=5},
    -- is_soul = true,
    soul_rate = 0.01,
    hidden = true,

    loc_txt = { 
        name = "Absolute Tau",
        text = {
            "Apply {C:blue}Transformative{} to {C:attention}#1#{}",
            "selected eligible Joker",
        }
    },

    can_use = function(self, card)
        if #G.jokers.highlighted > card.ability.extra.max or #G.jokers.highlighted < 1 then
            return false
        end

        for _,joker in pairs(G.jokers.highlighted) do
            if not joker.config.center.tauic_variant then
                return false
            end
        end
        return true 
    end,

    in_pool = function()
        for _,joker in pairs(G.jokers.cards) do
            if joker.config.center.tauic_variant then
                return true 
            end
        end
        return false 
    end,
    config = {extra = {max = 1}},

    use = function(self, card, area, copier) 
        
        for _,joker in pairs(G.jokers.highlighted) do
            joker:add_sticker("tau_transformative", true)
        end

    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.max}}
    end,
}
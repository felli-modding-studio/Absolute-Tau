SMODS.Atlas {
    key = "decks",
    path = "decks.png",
    px = 71,
    py = 95,
}

SMODS.Back {
    key = "tauic",
    loc_txt = {
        name = "Tauic Deck",
        text = {
            "{C:tauic}Tauic{} Jokers are {C:attention}thrice{} as common",
            "for each {C:tauic}non-Tauic{} Joker owned",
            -- "{C:attention}X3{} Blind Size",
        }
    },
    pos = {x=0, y=0},
    atlas = "decks",
    calculate = function(self, back, context)
        if context.tau_probability_mod then

            local count = 0
            for _,joker in pairs(G.jokers.cards) do
                count = count + (joker.config.center.tau and 1 or 0) 
            end

            return {
                denominator = context.denominator / (3 ^ count)
            }
        end
    end
}

if CardSleeves then
    CardSleeves.Sleeve {
        key = "s_tauic",
        atlas = "decks",
        loc_txt = {
            name = "Tauic Sleeve",
            text = {
                "{C:cry_ember}Tauic{} Jokers are",
                "{C:attention}exponentially{} more common",
                -- "{C:attention}X3{} Blind Size",
            }
        },
        pos = { x = 0, y = 1 },
        unlocked = true,
        calculate = function(self, back, context)
            if context.tau_probability_mod then
                return {
                    denominator = context.denominator ^ 0.5
                }
            end
        end
    }
end
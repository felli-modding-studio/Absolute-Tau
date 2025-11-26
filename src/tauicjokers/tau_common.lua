AbsoluteTau.Tauic {
    original = { "j_joker" },
    key = "joker",
    loc_txt = {
        name = "{C:tauic}Tauic Joker{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult for every {C:tauic}Tauic{} Joker owned",
            "{C:inactive}(Includes self){}",
        }
    },

    config = { extra = { mult = 1.4444 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    soul_pos = { x = 0, y = 1 },
    calculate = function(self, card, context)
        if (context.other_joker and context.other_joker.config.center.tauic) then
            return { xmult = card.ability.extra.mult }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_chaos" },
    key = "chaos",
    loc_txt = {
        name = "{C:tauic}Tauic Chaos the Clown{}",
        text = {
            "{C:attention}#1#{} free {C:green}rerolls{} in shop",
            "When blind selected, gain {C:attention}#2#{} {C:blue}hand{} and {C:red}discard{} per {C:green}reroll{} in last shop",
            "{C:inactive}(Currently {C:attention}+#3#{} {C:blue}Hands{C:inactive} and {C:red}Discards{C:inactive})",
        }
    },

    config = { extra = { rerolls = 2, bonus = 1, current = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rerolls, card.ability.extra.bonus, card.ability.extra.current } }
    end,
    soul_pos = { x = 1, y = 1 },
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.rerolls)
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(-card.ability.extra.rerolls)
    end,

    calculate = function(self, card, context)
        if (context.setting_blind) then
            ease_hands_played(card.ability.extra.bonus * card.ability.extra.current)
            ease_discard(card.ability.extra.bonus * card.ability.extra.current)
            card.ability.extra.current = 0
        end

        if (context.reroll_shop) then
            card.ability.extra.current = card.ability.extra.current + 1
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_lusty_joker", "j_greedy_joker", "j_wrathful_joker", "j_gluttenous_joker" },
    key = "sin",
    loc_txt = {
        name = "{C:tauic}Tauic Sin Joker{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult when a card is scored",
            "Increase by {X:mult,C:white}X#2#{} for every consecutive card of the same Suit scored",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult, gaining on {V:1}#4#{C:inactive})",
        }
    },

    config = { extra = { base = 1, cur = 1, gain = 0.1, current_suit = "Spades" } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.base,
                card.ability.extra.gain,
                card.ability.extra.cur,
                card.ability.extra.current_suit,
                colours = {
                    G.C.SUITS[card.ability.extra.current_suit]
                }
            }
        }
    end,
    soul_pos = { x = 2, y = 1 },
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            if context.other_card:is_suit(card.ability.extra.current_suit) then
                SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "cur", scalar_value = "gain" })
            else
                card.ability.extra.cur = card.ability.extra.base
                card.ability.extra.current_suit = context.other_card.base.suit
                SMODS.calculate_effect({ message = localize("k_reset_ex") }, card)
            end

            return {
                xmult = card.ability.extra.cur
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_blue_joker" },
    key = "blue",
    loc_txt = {
        name = "{C:tauic}Tauic Blue Joker{}",
        text = {
            "{X:chips,C:white}X#1#{} Chips for each",
            "remaining card in {C:attention}deck{}",
            "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
        }
    },

    config = { extra = { per = 1 } },
    loc_vars = function(self, info_queue, card)
        local n = 52
        if G.deck then
            n = #G.deck.cards
        end
        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.per * n
            }
        }
    end,
    soul_pos = { x = 7, y = 10 },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xchips = card.ability.extra.per * #G.deck.cards
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_even_steven", "j_odd_todd" },
    key = "number",
    loc_txt = {
        name = "{C:tauic}Tauic Number Brothers{}",
        text = {
            "Scored {C:attention}odd-numbered{} ranks give {X:chips,C:white}X#1#{} Chips",
            "Scored {C:attention}even-numbered{} ranks give {X:mult,C:white}X#1#{} Mult",
        }
    },

    config = { extra = { mul = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mul } }
    end,
    soul_pos = { x = 8, y = 4 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                xmult = (context.other_card:get_id() % 2) == 0 and card.ability.extra.mul,
                xchips = ((context.other_card:get_id() + 1) % 2) == 0 and card.ability.extra.mul,
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_egg" },
    key = "egg",
    loc_txt = {
        name = "{C:tauic}Tauic Egg{}",
        text = {
            "Gains {C:money}$#1#{} of Sell Value at end of round",
            "{C:green}#2# in #3#{} Chance to come back after being removed",
            "{C:attention}Doubles{} Sell Value gain at end of round",
        }
    },

    config = { extra = { gain = 3, num = 3, den = 5 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, to_number(card.ability.extra.num),
            to_number(card.ability.extra.den))
        return { vars = { card.ability.extra.gain, num, den } }
    end,
    soul_pos = { x = 0, y = 10 },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.gain
            card.ability.extra.gain = card.ability.extra.gain * 2
            card:set_cost()
            return {
                message = localize("k_val_up"),
                colour = G.C.MONEY
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if (not from_debuff) and SMODS.pseudorandom_probability(card, "tau_egg", to_number(card.ability.extra.num), to_number(card.ability.extra.den)) then
            SMODS.add_card({ key = self.key })
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_mystic_summit" },
    key = "summit",
    loc_txt = {
        name = "{C:tauic}Tauic Summit{}",
        text = {
            "{C:attention}Double{} Mult of played hand",
            "if all {C:red}Discards{} have been used",
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    soul_pos = { x = 2, y = 0 },
    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.discards_left <= 0 then
            vallkarri.simple_hand_text(context.scoring_name)
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { mult = "X2" })
            if G.GAME.hands[context.scoring_name] then
                G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult * 2
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    update_hand_text({ immediate = true, nopulse = true, delay = 0 },
                        { mult = 0, chips = 0, level = '', handname = '' })
                end
            }))
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_banner" },
    key = "banner",
    loc_txt = {
        name = "{C:tauic}Tauic Banner{}",
        text = {
            "{X:chips,C:white}X#1#{} Chips per discard remaining",
            "{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
        }
    },

    config = { extra = { per = 3 } },
    loc_vars = function(self, info_queue, card)
        local d = 4
        if G and G.GAME and G.GAME.current_round then
            d = G.GAME.current_round.discards_left
        end
        return { vars = { card.ability.extra.per, 1 + (card.ability.extra.per * d) } }
    end,
    soul_pos = { x = 8, y = 2 },
    calculate = function(self, card, context)
        if context.joker_main then
            return { xchips = 1 + (card.ability.extra.per * G.GAME.current_round.discards_left) }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_credit_card" },
    key = "credit",
    loc_txt = {
        name = "{C:tauic}Tauic Credit Card{}",
        text = {
            "Refund {C:attention}#1#%{} of all money lost",
        }
    },

    config = { extra = { refund = 50 } }, --value is pointless, it's always a 3/4 refund//not anymore!
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.refund } }
    end,
    soul_pos = { x = 9, y = 0 },
    immutable = true, --fuck you
    calculate = function(self, card, context)
        if context.money_altered and to_big(context.amount) < to_big(0) then
            ease_dollars(context.amount * -(card.ability.extra.refund / 100))
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_jolly", "j_zany", "j_mad", "j_crazy", "j_droll", "j_sly", "j_wily", "j_clever", "j_devious", "j_crafty" },
    key = "emotional",
    loc_txt = {
        name = "{C:tauic}Tauic Emotional Joker{}",
        text = {
            "{X:chips,C:white}X#1#{} Chips and {X:mult,C:white}X#1#{} Mult",
            "per {C:attention}poker hand{} contained in played hand",
        }
    },

    config = { extra = { gain = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain } }
    end,
    soul_pos = { x = 1, y = 0 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.poker_hands) then
            local count = 0

            for i, hand in pairs(context.poker_hands) do
                if (hand and next(hand) ~= nil) then
                    -- print(hand)
                    count = count + 1
                end
            end


            if (context.joker_main) then
                for i = 1, count do
                    SMODS.calculate_effect({ xmult = card.ability.extra.gain, xchips = card.ability.extra.gain }, card)
                end
            end
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_half" },
    key = "half",
    loc_txt = {
        name = "{C:tauic}Tauic Half Joker{}",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:attention}Doubles{} when you play {C:attention}#2#{} or less cards ",
        }
    },

    config = { extra = { mult = 20, req = 3, two = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.req } }
    end,
    soul_pos = { x = 1, y = 2 },
    calculate = function(self, card, context)
        if context.before and context.scoring_hand then
            if #context.scoring_hand <= card.ability.extra.req then
                SMODS.scale_card(card,
                    { ref_table = card.ability.extra, ref_value = "mult", scalar_value = "two", operation = "X" })
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_8_ball" },
    key = "8ball",
    loc_txt = {
        name = "{C:tauic}Tauic 8 Ball{}",
        text = {
            "When an {C:attention}8{} is scored, create a random {C:tarot}Tarot{} card",
            "with {C:attention}Octuple{} values",
        }
    },

    config = { extra = { vmult = 8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.vmult } }
    end,
    soul_pos = { x = 0, y = 5 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 and G.consumeables.config.card_count < G.consumeables.config.card_limit then
            local tarot = SMODS.add_card({ set = "Tarot" })
            Cryptid.manipulate(tarot, { value = card.ability.extra.vmult })
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_smiley" },
    key = "smiley"
,    loc_txt = {
        name = "{C:tauic}Tauic Smiley Face{}",
        text = {
            "{C:attention}Non-face{} cards are converted into a random {C:attention}face{} card when {C:attention}scored{}",
            "{C:attention}Face{} cards give {X:mult,C:white}X#1#{} Mult",
        }
    },

    config = { extra = { xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    soul_pos = { x = 6, y = 15 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if not context.other_card:is_face() then
                local faces = { "Jack", "King", "Queen" }
                SMODS.change_base(context.other_card, nil, faces[pseudorandom("tau_smiley", 1, #faces)])
            else
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_gros_michel" },
    key = "michel",
    loc_txt = {
        name = "{C:tauic}Tauic Gros Michel{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}#2# in #3#{} chance to convert into {C:tauic}Tauic Cavendish{} at end of round",
        }
    },

    config = { extra = { xmult = 15, outof = 15, num = 1 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.outof, 'tau_michel')
        return { vars = { card.ability.extra.xmult, num, den } }
    end,
    soul_pos = { x = 7, y = 6 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.main_eval and SMODS.pseudorandom_probability(card, 'tau_michel', card.ability.extra.num, card.ability.extra.outof) then
            card:set_ability("j_valk_tau_cavendish")
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_cavendish" },
    key = "cavendish",
    loc_txt = {
        name = "{C:tauic}Tauic Cavendish{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            "{C:green}#2# in #3#{} chance to",
        }
    },

    config = { extra = { emult = 3.33, outof = 1000 } },
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.outof)
        return { vars = { card.ability.extra.emult, n, d } }
    end,
    soul_pos = { x = 5, y = 11 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                emult = card.ability.extra.emult
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_delayed_grat" },
    key = "gratification",
    loc_txt = {
        name = "{C:tauic}Tauic Delayed Gratification{}",
        text = {
            "Gain {C:money}current money{} as discards",
            "Earn {C:money}$#1#{} for every {C:red}#2#{} Discards left at end of round",
        }
    },

    config = { extra = { dollar = 1, per = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollar, card.ability.extra.per } }
    end,
    soul_pos = { x = 4, y = 3 },
    calculate = function(self, card, context)
        if context.setting_blind then
            ease_discard(to_number(math.min(G.GAME.dollars, 1e100)))
        end
    end,
    calc_dollar_bonus = function(self, card)
        return math.floor(G.GAME.current_round.discards_left / card.ability.extra.per)
    end
}

AbsoluteTau.Tauic {
    original = { "j_hanging_chad" },
    key = "chad",
    loc_txt = {
        name = "{C:tauic}Tauic Hanging Chad{}",
        text = {
            "Retrigger the {C:attention}first{} played card {C:attention}once{} for each card played",
        }
    },

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    soul_pos = { x = 9, y = 6 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == G.play.cards[1] then
            return {
                repetitions = #G.play.cards,
                message = localize("k_again_ex"),
                card = card,
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_misprint" },
    key = "misprint",
    loc_txt = {
        name = "{C:tauic}Tauic Misprint{}",
        text = {
            "{X:dark_edition,C:white}#1##2#{}#3#",
        }
    },

    immutable = true,
    config = { extra = { min = 1.01, max = 9.99 } },
    loc_vars = function(self, info_queue, card)
        local function corrupt_text(text, amount, available_chars)
            local chars = (available_chars or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[];:',.<>/?|")
            -- amount is a 0-1 being a chance to replace each character with a rnd one

            for i = 1, #text do
                if math.random() < amount then
                    local rand_index = math.random(1, #chars)
                    local random_char = chars:sub(rand_index, rand_index)
                    text = text:sub(1, i - 1) .. random_char .. text:sub(i + 1)
                end
            end
            return text
        end
        local text = corrupt_text("^", 0.2)
        local text1 = corrupt_text("xxx", 1, "01234567890123456789012345678901234567890123456789")
        local text2 = corrupt_text(" Mult", 0.2)
        return { vars = { text, text1, text2 } }
    end,
    soul_pos = { x = 6, y = 3 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local temp = (pseudorandom("tau_misprint") * (card.ability.extra.max - card.ability.extra.min)) +
                card.ability.extra.min
            return {
                emult = temp
            }
        end
    end,
}


AbsoluteTau.Tauic {
    original = { "j_photograph" },
    key = "photograph",
    loc_txt = {
        name = "{C:tauic}Tauic Photograph{}",
        text = {
            "The first scored {C:attention}face{} card gives",
            "{X:dark_edition,C:white}^#1#{} Mult",
        }
    },

    immutable = true,
    config = { extra = { amount = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount } }
    end,
    soul_pos = { x = 2, y = 13 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            local first_face = nil
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then
                    first_face = context.scoring_hand[i]; break
                end
            end
            if context.other_card == first_face then
                return { emult = card.ability.extra.amount }
            end
        end
    end,
}


AbsoluteTau.Tauic {
    original = { "j_ice_cream" },
    key = "icecream",
    loc_txt = {
        name = "{C:tauic}Tauic Ice Cream{}",
        text = {
            "Gains {X:chips,C:white}X#2#{} per hand played",
            "{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive} Chips)",
        }
    },

    immutable = true,
    config = { extra = { cur = 1, gain = 0.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cur, card.ability.extra.gain } }
    end,
    soul_pos = { x = 4, y = 10 },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.after and context.main_eval then
            SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "cur", scalar_value = "gain" })
        end

        if context.joker_main then
            return {
                xchips = card.ability.extra.cur
            }
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_ride_the_bus" },
    key = "bus",
    loc_txt = {
        name = "{C:tauic}Tauic Ride the Bus{}",
        text = {
            "{C:attention}Non-face{} cards give",
            "{X:mult,C:white}X#1#{} Mult when scored",
        }
    },

    config = { extra = { powmult = 1.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.powmult } }
    end,
    blueprint_compat = true,
    soul_pos = { x = 1, y = 6 },
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            if not context.other_card:is_face() then
                return { xmult = card.ability.extra.powmult }
            end
        end
    end
}

AbsoluteTau.Tauic {
    original = { "j_raised_fist" },
    key = "fist",
    loc_txt = {
        name = "{C:tauic}Tauic Raised Fist{}",
        text = {
            "The lowest ranked card {C:attention}held in hand{} gives",
            "{X:dark_edition,C:white}^Mult{} equal to {C:attention}#1#x{} its value",
            "{C:inactive,s:0.8}(Cannot go below {X:dark_edition,C:white,s:0.8}^1{s:0.8,C:inactive} Mult)",
        }
    },

    config = { extra = { percent = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end,
    blueprint_compat = true,
    soul_pos = { x = 8, y = 3 },
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.hand and not context.end_of_round) then
            -- code taken from original raised fist
            local nominal, card_id = 15, 15
            local raised_card = nil
            for i = 1, #G.hand.cards do
                if card_id >= (G.hand.cards[i].base.id or math.huge) and not SMODS.has_no_rank(G.hand.cards[i]) then
                    nominal = G.hand.cards[i].base.nominal
                    card_id = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if context.other_card == raised_card then
                return { emult = math.max(nominal * card.ability.extra.percent, 1) }
            end
        end
    end
}

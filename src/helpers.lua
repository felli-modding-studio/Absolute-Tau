function AbsoluteTau.get_cards(area)
    local cards = {}
    for _, card in pairs(area.cards) do
        table.insert(cards, card)
    end
    return cards
end

function AbsoluteTau.enhanced_in_deck(enhancement)
    if not G.playing_cards then
        return 0
    end
    local count = 0
    for i, card in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(card, enhancement) then
            count = count + 1
        end
    end

    return count
end

function AbsoluteTau.level_all_hands(card, levels)
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
        { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end
    }))
    update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.9,
        func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            return true
        end
    }))
    update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.9,
        func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = nil
            return true
        end
    }))
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+'..(levels or 1) })
    delay(1.3)
    for poker_hand_key, _ in pairs(G.GAME.hands) do
        SMODS.smart_level_up_hand(card, poker_hand_key, true, levels or 1)
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
        { mult = 0, chips = 0, handname = '', level = '' })
end

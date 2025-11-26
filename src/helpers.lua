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
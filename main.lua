AbsoluteTau = {}

AbsoluteTau.gradient = SMODS.Gradient{
    key = "tau_colours",
    colours = {
        HEX("523DBA"),
        HEX("D1CFE3"),
        HEX("BCC24A")
    },
    cycle = 10
}

SMODS.Atlas {
    key = "tau",
    path = "tauic_jokers.png",
    px = 71,
    py = 95,
}

SMODS.Rarity {
    key = 'tauic',
    loc_txt = {
        name = 'Tauic'
    },
    badge_colour = AbsoluteTau.gradient,
    pools = { ["Joker"] = false },
    
}

function AbsoluteTau.get_cards(area)
    local cards = {}
    for _, card in pairs(area.cards) do
        table.insert(cards, card)
    end
    return cards
end

AbsoluteTau.Tauic = SMODS.Joker:extend {
    tauic = true,
    required_params = {
        "original"
    },
    inject = function(self, i)
        local okey = nil
        if type(self.original) == "table" then
            okey = self.original[1]
            for _,value in pairs(self.original) do
                G.P_CENTERS[value].tauic_variant = self.key
            end
        elseif type(self.original) == "string" then
            okey = self.original
            G.P_CENTERS[self.original].tauic_variant = self.key
        else
            error("What the fuck are you doing bro")
        end
        self.key = "tauic_"..okey
        SMODS.Joker.inject(self)

        
    end,
    no_doe = true,
    pos = {x=0,y=0},
    atlas = "tau",
    rarity = "tau_tauic",
    cost = 15,
}
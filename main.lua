AbsoluteTau = {}

AbsoluteTau.gradient = SMODS.Gradient {
    key = "tau_colours",
    colours = {
        HEX("523DBA"),
        HEX("D1CFE3"),
        HEX("BCC24A")
    },
    cycle = 10
}

loc_colour()

G.ARGS.LOC_COLOURS.tauic = AbsoluteTau.gradient

SMODS.Atlas {
    key = "tau",
    path = "tauic_jokers.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "alt",
    path = "cards.png",
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

AbsoluteTau.Tauic = SMODS.Joker:extend {
    tauic = true,
    required_params = {
        "original"
    },
    inject = function(self, i)
        if type(self.original) == "table" then
            for _, value in pairs(self.original) do
                G.P_CENTERS[value].tauic_variant = self.key
            end
        elseif type(self.original) == "string" then
            G.P_CENTERS[self.original].tauic_variant = self.key
        else
            error("What the fuck are you doing bro 👀👀👀👀👀👀👀👀👀👀👀👀👀👀")
        end
        print(self.atlas)
        SMODS.Joker.inject(self)
    end,
    no_doe = true,
    pos = { x = 0, y = 0 },
    atlas = "tau_tau",
    rarity = "tau_tauic",
    cost = 15,
}

local files = {
    "src/spawn_override.lua",
    "src/helpers.lua",
    "src/decks.lua",
    "src/seals.lua",
    "src/spectrals.lua",
    "src/stickers.lua",
    "src/originalcards/jokers.lua",
    "src/originalcards/spectrals.lua",
    "src/tauicjokers/tau_common.lua",
    "src/tauicjokers/tau_uncommon.lua",
    "src/tauicjokers/tau_rare.lua",
    "src/tauicjokers/tau_legendary.lua",
}

for i, dir in ipairs(files) do
    print("AbsoluteTau: Loading " .. dir)
    assert(SMODS.load_file(dir))()
end
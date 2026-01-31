local addonName, AptoHUD = ...

-- Todo: Consider tracking things like Whirlwind charges for Warrior, or Stagger for Brewmaster?

-- Enum.PowerType is a built-in Blizzard system for looking up these types

local power_mana = { primary = Enum.PowerType.Mana }
local power_energy = { primary = Enum.PowerType.Energy }
local power_rage = { primary = Enum.PowerType.Rage }

-- local power_dk = { primary = Enum.PowerType.RunicPower , secondary = Enum.PowerType.Runes }
-- disabling runes for DK for now because
local power_dk = { primary = Enum.PowerType.RunicPower }
local power_dh = { primary = Enum.PowerType.Fury }
local power_evoker = { primary = Enum.PowerType.Mana, secondary = Enum.PowerType.Essence }
local power_hunter = { primary = Enum.PowerType.Focus }
local power_mage = power_mana
local power_paladin = { primary = Enum.PowerType.Mana, secondary = Enum.PowerType.HolyPower }
local power_priest = power_mana
local power_rogue = { primary = Enum.PowerType.Energy , secondary = Enum.PowerType.ComboPoints }
local power_shaman = power_mana
local power_warlock = power_mana
local power_warrior = power_rage

local powerStartsAtZeroList = {
    Enum.PowerType.Rage,
    Enum.PowerType.RunicPower,
    Enum.PowerType.HolyPower,
    Enum.PowerType.ComboPoints,
    Enum.PowerType.Fury,
    Enum.PowerType.ArcaneCharges,
    Enum.PowerType.Insanity,
    Enum.PowerType.Maelstrom,
}
local powerStartsAtZero = {}
for _, name in ipairs(powerStartsAtZeroList) do
    powerStartsAtZero[name] = true
end

-- See wowlookups/ClassSpecs for the numbers used here
local PowerLookup = {
    deathknight = {
        -- Blood
        [250] = power_dk,
        -- Frost
        [251] = power_dk,
        -- Unholy
        [252] = power_dk
    },
    demonhunter = {
        -- Devourer
        [577] = power_dh,
        -- Havoc
        [581] = power_dh,
        -- Vengeance
        [1480] = power_dh
    },
    druid = {
        -- balance
        [102] = { primary = Enum.PowerType.Mana, secondary = Enum.PowerType.LunarPower },
        -- feral
        [103] = { primary = Enum.PowerType.Energy, secondary = Enum.PowerType.ComboPoints },
        -- guardian
        [104] = power_rage,
        -- resto
        [105] = power_mana
    },
    evoker = {
        -- Augmentation
        [1473] = power_evoker,
        -- Devastation
        [1467] = power_evoker,
        -- Preservation
        [1468] = power_evoker
    },
    hunter = {
        -- Beast Master
        [253] = power_hunter,
        -- Marksmanship
        [254] = power_hunter,
        -- Survival
        [255] = power_hunter
    },
    mage = {
        -- Arcane
        [62] = { primary = Enum.PowerType.Mana, secondary = Enum.PowerType.ArcaneCharges },
        -- Fire
        [63] = power_mage,
        -- Frost
        [64] = power_mage
    },
    monk = {
        -- Brewmaster
        [268] = { primary = Enum.PowerType.Energy },
        -- Mistweaver
        [270] = power_mana,
        -- Windwalker
        [269] = { primary = Enum.PowerType.Energy, secondary = Enum.PowerType.Chi }
    },
    paladin = {
        -- Holy
        [65] = power_paladin,
        -- Protection
        [66] = power_paladin,
        -- Retribution
        [70] = power_paladin
    },
    priest = {
        -- Discipline
        [256] = power_priest,
        -- Holy
        [257] = power_priest,
        -- Shadow
        [258] = { primary = Enum.PowerType.Mana, secondary = Enum.PowerType.Insanity }
    },
    rogue = {
        -- Assassination
        [259] = power_rogue,
        -- Outlaw
        [260] = power_rogue,
        -- Subtlety
        [261] = power_rogue
    },
    shaman = {
        -- Elemental
        [262] = { primary = Enum.PowerType.Mana, secondary = Enum.PowerType.Maelstrom },
        -- Enhancement
        [263] = power_shaman,
        -- Resto
        [264] = power_shaman
    },
    warlock = {
        -- Affliction
        [265] = power_warlock,
        -- Demonology
        [266] = power_warlock,
        -- Destruction
        [267] = power_warlock
    },
    warrior = {
        -- Arms
        [71] = power_warrior,
        -- Fury
        [72] = power_warrior,
        -- Protection
        [73] = power_warrior
    }
}

-- Gets the power type ID from a lookup, based on the class and spec ID and type of power
function AptoHUD.Utils.GetPowerFromClassAndSpec(class, specID, resourceType)
    local class = class:lower()
    local powerType = PowerLookup[class] and PowerLookup[class][specID][resourceType]
    if not powerType then
        return nil, nil
    end
    local startsAtZero = powerStartsAtZero[specData] or false
    if AptoHUD.debug then
        print("GetPowerFromClassAndSpec", powerType, startsAtZero)
    end
    return powerType, startsAtZero
end

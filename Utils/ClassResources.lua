local addonName, AptoHUD = ...

-- Todo: Consider tracking things like Whirlwind charges for Warrior, or Stagger for Brewmaster?

local power_mana = { primary = "Mana" }
local power_energy = { primary = "Energy" }
local power_rage = { primary = "Rage" }

local power_dk = { primary = "RunicPower" , secondary = "Runes" }
local power_dh = { primary = "Fury" }
local power_evoker = { primary = "Mana", secondary = "Essence" }
local power_hunter = { primary = "Focus" }
local power_mage = power_mana
local power_paladin = { primary = "Mana", secondary = "HolyPower" }
local power_priest = power_mana
local power_rogue = { primary = "Energy" , secondary = "ComboPoints" }
local power_shaman = power_mana
local power_warlock = power_mana
local power_warrior = power_rage

local powerStartsAtZeroList = {
    "Rage",
    "RunicPower",
    "HolyPower",
    "ComboPoints",
    "Fury",
    "ArcaneCharges",
    "Insanity",
    "Maelstrom",
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
        [102] = { primary = "Mana", secondary = "LunarPower" },
        -- feral
        [103] = { primary = "Energy", secondary = "ComboPoints" },
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
        [62] = { primary = "Mana", secondary = "ArcaneCharges" },
        -- Fire
        [63] = power_mage,
        -- Frost
        [64] = power_mage
    },
    monk = {
        -- Brewmaster
        [268] = { primary = "Energy" },
        -- Mistweaver
        [270] = power_mana,
        -- Windwalker
        [269] = { primary = "Energy", secondary = "Chi" }
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
        [258] = { primary = "Mana", secondary = "Insanity" }
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
        [262] = { primary = "Mana", secondary = "Maelstrom" },
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

local function GetPowerID(powerName)
    for _, entry in ipairs(AptoHUD.WOW.PowerTypes) do
        if entry.Name == powerName then
            return entry.EnumValue
        end
    end
end

local function IsStartsAtZero(powerName)
    return powerStartsAtZero[powerName] or false
end

-- Gets the power type ID from a lookup, based on the class and spec ID
function AptoHUD.Utils.GetPowerFromClassAndSpec(class, specID)
    local class = class:lower()
    local specData = PowerLookup[class] and PowerLookup[class][specID]
    if not specData then
        return nil, nil
    end

    local primary   = GetPowerID(specData.primary)
    local primaryStartsAtZero = IsStartsAtZero(specData.primary)
    local secondary = specData.secondary and GetPowerID(specData.secondary) or nil
    local secondaryStartsAtZero = IsStartsAtZero(specData.secondary)

    return primary, primaryStartsAtZero, secondary, secondaryStartsAtZero
end

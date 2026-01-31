local addonName, AptoHUD = ...

local power_mana = { primary = "Mana" }
local power_energy = { primary = "Energy" }
local power_rage = { primary = "Rage" }

local power_dk = { primary = "RunicPower" , secondary = "Runes" }
local power_dh = { primary = "Fury" }
local power_evoker = { primary = "Mana", secondary = "Essence" }
local power_hunter = { primary = "Focus" }
local power_mage = power_mana
local power_monk = power_energy
local power_paladin = { primary = "Mana", secondary = "HolyPower" }
local power_priest = power_mana
local power_rogue = { primary = "Energy" , secondary = "ComboPoints"}
local power_shaman = power_mana
local power_warlock = power_mana
local power_warrior = power_rage

AptoHUD.Power = {
    deathknight = {
        -- Blood
        250 = power_dk
        -- Frost
        251 = power_dk
        -- Unholy
        252 = power_dk
    },
    demonhunter = {
        -- Devourer
        577 = power_dh
        -- Havoc
        581 = power_dh
        -- Vengeance
        1480 = power_dh
    },
    druid = {
        -- balance
        102 = { primary = "LunarPower" }
        -- feral
        103 = { primary = "Energy", secondary = "ComboPoints" }
        -- guardian
        104 = power_rage
        -- resto
        105 = power_mana
    },
    evoker = {
        -- Augmentation
        1473 = power_evoker
        -- Devastation
        1467 = power_evoker
        -- Preservation
        1468 = power_evoker
    },
    hunter = {
        -- Beast Master
        253 = power_hunter
        -- Marksmanship
        254 = power_hunter
        -- Survival
        255 = power_hunter
    },
    mage = {
        -- Arcane
        62 = { primary = "Mana", secondary = "ArcaneCharges" }
        -- Fire
        63 = power_mage
        -- Frost
        64 = power_mage
    },
    monk = {

    },
    paladin = {},
    priest = {},
    rogue = {},
    shaman = {},
    warlock = {},
    warrior = {}
}

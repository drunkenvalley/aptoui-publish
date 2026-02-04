local addonName, AptoHUD = ...

AptoHUD.Utils.ClassBuffLookup = {
    mage = {},
    rogue = {},
}
AptoHUD.Utils.ClassBuffLookup["evoker"]["Blessing of the Bronze"] = {
    blessingbronze = "Blessing of the Bronze"
}
AptoHUD.Utils.ClassBuffLookup["mage"]["Arcane Intellect"] = {
    arcaneint = "Arcane Intellect"
}
AptoHUD.Utils.ClassBuffLookup["rogue"]["Lethal Poison"] = {
    deadly = "Deadly Poison",
    instant = "Instant Poison",
    wound = "Wound Poison",
}
AptoHUD.Utils.ClassBuffLookup["rogue"]["Non-Lethal Poison"] = {
    atrophic = "Atrophic Poison",
    crippling = "Crippling Poison",
    numbing = "Numbing Poison",
}


-- buffsList = {name = "name"}
-- aurasList = {name = true}
local function CheckActiveBuff(buffsList, aurasList)
    for _, buffName in pairs(buffsList) do
        if aurasList[buffName] then
            return true
        end
    end
    return false
end

function AptoHUD.Utils.HasMissingClassBuff(class)
    local activeBuffs = {}
    AuraUtil.ForEachAura("player", "HELPFUL", nil, function(aura)
        activeBuffs[aura] = true
    end)

    local missingBuffTypes = {}
    for buffCategoryName, buffCategoryBuffNames in pairs(AptoHUD.Utils.ClassBuffLookup[class]) do
        missingBuffTypes[buffCategoryName] = not CheckActiveBuff(buffCategoryBuffNames, activeBuffs)
    end

    return missingBuffTypes
end

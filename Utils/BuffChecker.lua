local addonName, AptoHUD = ...

local RoguePoisons = {
    [2823] = true,   -- Deadly Poison
    [8679] = true,   -- Wound Poison
    [315584] = true, -- Instant Poison
    [381664] = true, -- Amplifying Poison
}

local buffList = {}

-- TODO: build out buffList as a lookup of class / spec to expected buffs
-- e.g. mage arcane int, priest fort, etc
-- can we use the in-built "glow" on missing buff that shows on action bars? possibly secret?

function AptoHUD.Utils.HasMissingClassBuff()
    local slots = { UnitAuraSlots("player", "HELPFUL") }
    local class, specID = AptoHUD.Utils.GetClassAndSpec()

    for _, slot in ipairs(slots) do
        local aura = C_UnitAuras.GetAuraDataBySlot("player", slot)
        if aura and aura.spellId and buffList[class][specID][aura.spellId] then
            return true
        end
    end

    return false
end

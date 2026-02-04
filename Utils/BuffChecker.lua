local addonName, AptoHUD = ...

local classBuffList = {
    rogue = {
        [2823] = true,  -- Deadly Poison
        [3408] = true, -- Crippling Poison
        [5761] = true,  -- Numbing Poison
        [8679] = true,  -- Wound Poison
        [315584] = true,  -- Instant Poison
        [381637] = true, -- Atrophic Poison
        [381664] = true,  -- Amplifying Poison
    }
}

local classBuffListNames = {
    rogue = {
        Lethal = {
            deadly = "Deadly Poison",
            instant = "Instant Poison",
            wound = "Wound Poison",
        },
        NonLethal = {
            atrophic = "Atrophic Poison",
            crippling = "Crippling Poison",
            numbing = "Numbing Poison",
        }
    }
}

-- TODO: build out buffList as a lookup of class / spec to expected buffs
-- e.g. mage arcane int, priest fort, etc
-- can we use the in-built "glow" on missing buff that shows on action bars? possibly secret?

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

function AptoHUD.Utils.HasMissingClassBuff()
    local activeBuffs = {}
    AuraUtil.ForEachAura("player", "HELPFUL", nil, function(aura)
        activeBuffs[aura] = true
    end)

    local class, _ = AptoHUD.Utils.GetClassAndSpec()
    local missingBuffTypes = {}
    for buffCategoryName, buffCategoryBuffNames in pairs(classBuffListNames[class]) do
        missingBuffTypes[buffCategoryName] = not CheckActiveBuff(buffCategoryBuffNames, activeBuffs)
    end

    return missingBuffTypes
end

local function CreateBuffReminder(textString)
    local reminder = CreateFrame("Frame", nil, UIParent)
    reminder:SetSize(150, 30)
    reminder:SetPoint("CENTER")
    reminder.text = reminder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    reminder.text:SetPoint("CENTER")
    reminder.text:SetText(textString)
    reminder:Hide()
end

local function UpdateBuffReminder()
    if HasActivePoison() then
        reminder:Hide()
    else
        reminder:Show()
    end
end

-- TODO: sort out actually showing this for a player

-- local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_LOGIN")
-- f:RegisterEvent("UNIT_AURA")

-- f:SetScript("OnEvent", function(self, event, unit)
--     if event == "PLAYER_LOGIN" or unit == "player" then
--         UpdatePoisonReminder()
--     end
-- end)

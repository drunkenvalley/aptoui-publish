local addonName, AptoHUD = ...

local classBuffListNames = {
    mage = {
        Int = {
            name = "Arcane Intellect",
            buffs = {
                arcaneint = "Arcane Intellect"
            }
        }
    },
    rogue = {
        Lethal = {
            name = "Lethal Poison",
            buffs = {
                deadly = "Deadly Poison",
                instant = "Instant Poison",
                wound = "Wound Poison",
            },
        NonLethal = {
            name = "Non-Lethal Poison",
            buffs = {
                atrophic = "Atrophic Poison",
                crippling = "Crippling Poison",
                numbing = "Numbing Poison",
            }
        }
    },
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
    for buffCategoryType, buffCategoryInfo in pairs(classBuffListNames[class]) do
        missingBuffTypes[buffCategoryInfo.name] = not CheckActiveBuff(buffCategoryInfo.buffs, activeBuffs)
    end

    return missingBuffTypes
end

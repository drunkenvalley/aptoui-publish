local addonName, AptoHUD = ...

function AptoHUD.Utils.GetClassAndSpec()
    local _, class = UnitClass("player")
    local class = class:lower()
    local specID = AptoHUD.Utils.GetPlayerSpec()
    return class, specID
end

function AptoHUD.Utils.GetPlayerSpec()
    local spec = C_SpecializationInfo.GetSpecialization()
    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
    return specID
end

function AptoHUD.Utils.GetClassColour()
    local _, class = UnitClass("player")
    local colour = RAID_CLASS_COLORS[class]
    return colour
end

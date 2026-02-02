local addonName, AptoHUD = ...

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

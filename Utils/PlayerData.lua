local addonName, AptoHUD = ...

function AptoHUD.Utils.GetPlayerClass()
    local _, class = UnitClass("player")
    return class:upper()
end

function AptoHUD.Utils.GetPlayerSpec()
    local spec = C_SpecializationInfo.GetSpecialization()
    local specID = C_SpecializationInfo.GetSpecializationInfo(spec)
    return spec, specID
end

function AptoHUD.Utils.GetClassColour()
    local class = AptoHUD.Utils.GetPlayerClass()
    local c = AptoHUD.WOW.ClassColours[class]
    return c.r, c.g, c.b
end

local addonName, AptoHUD = ...

AptoHUD.WOW.PowerTypes = {
    { Name = "Mana", Type = "PowerType", EnumValue = 0 },
    { Name = "Rage", Type = "PowerType", EnumValue = 1 },
    { Name = "Focus", Type = "PowerType", EnumValue = 2 },
    { Name = "Energy", Type = "PowerType", EnumValue = 3 },
    { Name = "ComboPoints", Type = "PowerType", EnumValue = 4 },
    { Name = "Runes", Type = "PowerType", EnumValue = 5 },
    { Name = "RunicPower", Type = "PowerType", EnumValue = 6 },
    { Name = "SoulShards", Type = "PowerType", EnumValue = 7 },
    { Name = "LunarPower", Type = "PowerType", EnumValue = 8 },
    { Name = "HolyPower", Type = "PowerType", EnumValue = 9 },
    { Name = "Alternate", Type = "PowerType", EnumValue = 10 },
    { Name = "Maelstrom", Type = "PowerType", EnumValue = 11 },
    { Name = "Chi", Type = "PowerType", EnumValue = 12 },
    { Name = "Insanity", Type = "PowerType", EnumValue = 13 },
    { Name = "BurningEmbers", Type = "PowerType", EnumValue = 14 },
    { Name = "DemonicFury", Type = "PowerType", EnumValue = 15 },
    { Name = "ArcaneCharges", Type = "PowerType", EnumValue = 16 },
    { Name = "Fury", Type = "PowerType", EnumValue = 17 },
    { Name = "Pain", Type = "PowerType", EnumValue = 18 },
    { Name = "Essence", Type = "PowerType", EnumValue = 19 },
    { Name = "RuneBlood", Type = "PowerType", EnumValue = 20 },
    { Name = "RuneFrost", Type = "PowerType", EnumValue = 21 },
    { Name = "RuneUnholy", Type = "PowerType", EnumValue = 22 },
    { Name = "AlternateQuest", Type = "PowerType", EnumValue = 23 },
    { Name = "AlternateEncounter", Type = "PowerType", EnumValue = 24 },
    { Name = "AlternateMount", Type = "PowerType", EnumValue = 25 },
    { Name = "Balance", Type = "PowerType", EnumValue = 26 },
    { Name = "Happiness", Type = "PowerType", EnumValue = 27 },
    { Name = "ShadowOrbs", Type = "PowerType", EnumValue = 28 },
    { Name = "RuneChromatic", Type = "PowerType", EnumValue = 29 },
}

AptoHUD.WOW.ClassToSpecIDToPower = {}

for specID, formatString in pairs(AptoHUD.WOW.SPEC_FORMAT_STRINGS) do
    local class, spec = formatString:match("([^%-]+)%-(.+)")

    if class and spec then
        AptoHUD.WOW.SpecIDToClassAndSpec[class] = AptoHUD.WOW.SpecIDToClassAndSpec[class] or {}
        AptoHUD.WOW.SpecIDToClassAndSpec[class][spec] = specID
    end
end

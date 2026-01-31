local addonName, AptoHUD = ...

-- saved variables must be global not local
AptoHUDDB = AptoHUDDB or {};

-- Settings
AptoHUD.HUD.PlayerHealthEvents = {
    "UNIT_HEALTH",
    "UNIT_MAXHEALTH",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
}
AptoHUD.HUD.PlayerPowerEvents = {
    "UNIT_POWER_UPDATE",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
}
AptoHUD.HUD.HUDAlpha = {
    combat = 0.8,
    noCombat = 0.4
}
AptoHUD.HUD.HUDScale = 3
AptoHUD.HUD.Textures = {
    Health = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl",
    Power = {
        primary = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-br",
        secondary = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-top",
    }
}

-- ----- Initial setup

local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN");

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        print("AptoHUD loaded");

        AptoHUDDB.playerName = UnitName("player");
        print("Hello,", AptoHUDDB.playerName);
        print(AptoHUD.Utils.GetPlayerClass())
        print(AptoHUD.Utils.GetClassColour())
        local playerSpec, playerSpecID = AptoHUD.Utils.GetPlayerSpec()
        print(playerSpec, playerSpecID)
        print(AptoHUD.WOW.SPEC_FORMAT_STRINGS[playerSpecID])
    end
end);

-- Load HUD
AptoHUD.HUD.CreateHexSegmentPlayerHP(UIParent, "CENTER", 0, 0)
AptoHUD.HUD.CreateHexSegmentPlayerPower(UIParent, "CENTER", 0, 0)

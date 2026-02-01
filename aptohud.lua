local addonName, AptoHUD = ...

-- saved variables must be global not local
AptoHUDDB = AptoHUDDB or {};

-- Settings
AptoHUD.debug = false
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
    Combat = 0.8,
    NoCombat = 0.4,
    Border = 0.5,
}
AptoHUD.HUD.Textures = {
    HexBottomLeft = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl",
    HexBottomLeftBorder = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl-border",
    HexBottomRight = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-br",
    HexBottomRightBorder = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-br-border",
    HexTop = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-top",
    HexTopBorder = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-top-border",
    HexSmall = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-64",
}

-- ----- Initial setup

local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN");

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        -- PlayerFrame:UnregisterAllEvents()
        -- PlayerFrame:Hide()

        AptoHUDDB.playerName = UnitName("player");
        print("AptoHUD loaded. Hello,", AptoHUDDB.playerName);

        -- Health
        AptoHUD.HUD.CreateHexSegmentPlayerHP(
            UIParent, "CENTER", AptoHUD.HUD.Offset.Main.X, AptoHUD.HUD.Offset.Main.Y
        )

        -- Power
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.Main.X, AptoHUD.HUD.Offset.Main.Y, "primary",
            AptoHUD.HUD.Textures.HexBottomRight, AptoHUD.HUD.Textures.HexBottomRightBorder
        )
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.Main.X, AptoHUD.HUD.Offset.Main.Y, "secondary",
            AptoHUD.HUD.Textures.HexTop, AptoHUD.HUD.Textures.HexTopBorder
        )

        -- Text elements 1
        AptoHUD.HUD.CreateHexIcon(
            UIParent, "CENTER",
            AptoHUD.HUD.Offset.Icon.X,
            AptoHUD.HUD.Offset.Icon.Y
        )
    end
end);

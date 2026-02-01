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
            UIParent, "CENTER", AptoHUD.HUD.Offset.X, AptoHUD.HUD.Offset.Y
        )

        -- Power
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.X, AptoHUD.HUD.Offset.Y, "primary",
            AptoHUD.HUD.Textures.HexBottomRight, AptoHUD.HUD.Textures.HexBottomRightBorder
        )
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.X, AptoHUD.HUD.Offset.Y, "secondary",
            AptoHUD.HUD.Textures.HexTop, AptoHUD.HUD.Textures.HexTopBorder
        )

        -- Test elements 1
        for i = 1, 6, 1 do
            local IconX, IconY = AptoHUD.HUD.GetIconPosition(i)
            print(IconX, IconY)
            AptoHUD.HUD.CreateHexIcon(UIParent, "CENTER", IconX, IconY)
        end
    end
end);

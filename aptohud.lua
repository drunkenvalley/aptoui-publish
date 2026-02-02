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
        AptoHUD.HUD.CreateHexSegmentPlayerHP()

        -- Power
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            "primary",
            AptoHUD.HUD.Textures.HexBottomRight,
            AptoHUD.HUD.Textures.HexBottomRightBorder
        )
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            "secondary",
            AptoHUD.HUD.Textures.HexTop,
            AptoHUD.HUD.Textures.HexTopBorder
        )
        AptoHUD.HUD.ResourceIcons("secondary")
        AptoHUD.HUD.ResourceIcons("rogue_charged")

        -- Test elements 1
        -- for i = 1, 6, 1 do
        --     local IconX, IconY = AptoHUD.HUD.GetIconPosition(i)
        --     AptoHUD.HUD.CreateHexIcon(UIParent, "CENTER", IconX, IconY)
        --     for j = 1, i, 1 do
        --         local IconOffsetX, IconOffsetY = AptoHUD.HUD.GetIconOffset(j)
        --         AptoHUD.HUD.CreateHexIcon(UIParent, "CENTER", IconX + IconOffsetX, IconY + IconOffsetY)
        --     end
        -- end
        -- AptoHUD.HUD.IconStrip(5, 1, true)
        -- AptoHUD.HUD.IconStrip(3, 1, false)
        -- AptoHUD.HUD.IconStrip(7, 2, true)
        -- AptoHUD.HUD.IconStrip(7, 3, false, "secondary")
        -- AptoHUD.HUD.IconStrip(3, 4, true)
        -- AptoHUD.HUD.IconStrip(4, 5, true)
        -- AptoHUD.HUD.IconStrip(6, 6, false)
    end
end);

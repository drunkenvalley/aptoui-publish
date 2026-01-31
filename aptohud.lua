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
AptoHUD.HUD.Offset = {
    x = 0,
    y = -50
}
AptoHUD.HUD.SmallHexOffsets = {
    x64 = 57,
    y64 = 48
}
AptoHUD.HUD.HUDAlpha = {
    combat = 0.8,
    noCombat = 0.4
}
AptoHUD.HUD.HUDScale = 0.75
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
            UIParent, "CENTER", AptoHUD.HUD.Offset.x, AptoHUD.HUD.Offset.y
        )

        -- Power
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.x, AptoHUD.HUD.Offset.y, "primary",
            AptoHUD.HUD.Textures.HexBottomRight, AptoHUD.HUD.Textures.HexBottomRightBorder
        )
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.x, AptoHUD.HUD.Offset.y, "secondary",
            AptoHUD.HUD.Textures.HexTop, AptoHUD.HUD.Textures.HexTopBorder
        )

        -- Test elements
        AptoHUD.HUD.CreateHexTest(
            UIParent, "CENTER",
            AptoHUD.HUD.Offset.x,
            AptoHUD.HUD.Offset.y
        )
        AptoHUD.HUD.CreateHexTest(
            UIParent, "CENTER",
            AptoHUD.HUD.Offset.x + AptoHUD.HUD.SmallHexOffsets.x64,
            AptoHUD.HUD.Offset.y
        )
        AptoHUD.HUD.CreateHexTest(
            UIParent, "CENTER",
            AptoHUD.HUD.Offset.x + AptoHUD.HUD.SmallHexOffsets.x64 / 2,
            AptoHUD.HUD.Offset.y + AptoHUD.HUD.SmallHexOffsets.y64
        )
    end
end);

function AptoHUD.HUD.CreateHexTest(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(64, 64)
    frame:SetScale(0.5)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    local maskTexture = AptoHUD.HUD.Textures.HexSmall
    mask:SetTexture(maskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)
    local r, g, b = AptoHUD.Utils.GetClassColour()

    mask:Show()
    mask:SetVertexColor(r, g, b, 1)
    return frame
end

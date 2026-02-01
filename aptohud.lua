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
    MainX = 0,
    MainY = -50,
    GridX = 150,
    GridY = 0
}
AptoHUD.HUD.SmallHexOffsets = {
    x64 = 57,
    y64 = 48
}
AptoHUD.HUD.HUDAlpha = {
    Combat = 0.8,
    NoCombat = 0.4,
    Border = 0.5,
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
            UIParent, "CENTER", AptoHUD.HUD.Offset.MainX, AptoHUD.HUD.Offset.MainY
        )

        -- Power
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.MainX, AptoHUD.HUD.Offset.MainY, "primary",
            AptoHUD.HUD.Textures.HexBottomRight, AptoHUD.HUD.Textures.HexBottomRightBorder
        )
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            UIParent, "CENTER", AptoHUD.HUD.Offset.MainX, AptoHUD.HUD.Offset.MainY, "secondary",
            AptoHUD.HUD.Textures.HexTop, AptoHUD.HUD.Textures.HexTopBorder
        )

        -- Text elements 1
        for xOffset = 0, AptoHUD.HUD.SmallHexOffsets.x64 * 2, AptoHUD.HUD.SmallHexOffsets.x64 do
            for yOffset = 0, AptoHUD.HUD.SmallHexOffsets.y64 * 2, AptoHUD.HUD.SmallHexOffsets.y64 * 2 do
                AptoHUD.HUD.CreateHexTest(
                    UIParent, "CENTER",
                    AptoHUD.HUD.Offset.GridX + xOffset,
                    AptoHUD.HUD.Offset.GridY + yOffset
                )
            end
        end
        for xOffset = AptoHUD.HUD.SmallHexOffsets.x64 / 2, AptoHUD.HUD.SmallHexOffsets.x64 * 2, AptoHUD.HUD.SmallHexOffsets.x64 do
            for yOffset = AptoHUD.HUD.SmallHexOffsets.y64, AptoHUD.HUD.SmallHexOffsets.y64 * 2, AptoHUD.HUD.SmallHexOffsets.y64 * 2 do
                AptoHUD.HUD.CreateHexTest(
                    UIParent, "CENTER",
                    AptoHUD.HUD.Offset.GridX + xOffset,
                    AptoHUD.HUD.Offset.GridY + yOffset
                )
            end
        end

        -- Test elements 2
        -- AptoHUD.HUD.CreateHexTest(
        --     UIParent, "CENTER",
        --     AptoHUD.HUD.Offset.x,
        --     AptoHUD.HUD.Offset.y
        -- )
        -- AptoHUD.HUD.CreateHexTest(
        --     UIParent, "CENTER",
        --     AptoHUD.HUD.Offset.x + AptoHUD.HUD.SmallHexOffsets.x64,
        --     AptoHUD.HUD.Offset.y
        -- )
        -- AptoHUD.HUD.CreateHexTest(
        --     UIParent, "CENTER",
        --     AptoHUD.HUD.Offset.x + AptoHUD.HUD.SmallHexOffsets.x64 / 2,
        --     AptoHUD.HUD.Offset.y + AptoHUD.HUD.SmallHexOffsets.y64
        -- )
    end
end);

function AptoHUD.HUD.CreateHexTest(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(64, 64)
    frame:SetScale(0.5)
    frame:SetPoint(point, parent, point, xOffset, yOffset)
    frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)

    local mask = frame:CreateMaskTexture()
    local maskTexture = AptoHUD.HUD.Textures.HexSmall
    mask:SetTexture(maskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    local classColour = AptoHUD.Utils.GetClassColour()
    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, 1)
    fill:SetAllPoints()
    fill:Show()
    fill:SetVertexColor(classColour.r, classColour.g, classColour.b, 1)
    fill:AddMaskTexture(mask)

    return frame
end

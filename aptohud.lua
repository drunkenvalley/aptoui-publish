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
AptoHUD.HUD.Scale = {
    Main = 1,
    Grid = 1,
}
AptoHUD.HUD.Size = {
    Main = 512,
    Grid = 64
}

AptoHUD.HUD.Offset = {
    MainX = 0,
    MainY = 0,
}

-- this is based on the specific drawn textures, using top right point coords vs centre point
local HexInsidePoints = {
    Top = { X = 210, Y = 0 },
    Side = { X = 180, Y = 107 },
}

local GridOffsetBuffer = 0
AptoHUD.HUD.Offset.GridX = (
    AptoHUD.HUD.Offset.MainX
    + HexInsidePoints.Side.X
    -- + HexInsideOffsets.Main.Side.X
    -- - AptoHUD.HUD.Size.Grid * HexWidthFactor * AptoHUD.HUD.Scale.Grid / 2
    - GridOffsetBuffer
)
AptoHUD.HUD.Offset.GridY = (
    AptoHUD.HUD.Offset.MainY
    + HexInsidePoints.Side.Y
    -- + HexInsideOffsets.Main.Side.Y
    -- - AptoHUD.HUD.Size.Grid * HexHeightFactor * AptoHUD.HUD.Scale.Grid / 2
    - GridOffsetBuffer
)
print(AptoHUD.HUD.Size.Grid * AptoHUD.HUD.Scale.Grid / 2)
print(AptoHUD.HUD.Size.Grid * AptoHUD.HUD.Scale.Grid / 2)

AptoHUD.HUD.SmallHexOffsets = {
    X64 = 57,
    Y64 = 48
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
        AptoHUD.HUD.CreateHexIcon(
            UIParent, "CENTER",
            AptoHUD.HUD.Offset.GridX,
            AptoHUD.HUD.Offset.GridY
        )
    end
end);

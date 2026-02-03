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
    "PLAYER_TARGET_CHANGED",
}
AptoHUD.HUD.PlayerPowerEvents = {
    "UNIT_POWER_UPDATE",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "UNIT_MAXPOWER",
    "PLAYER_TARGET_CHANGED",
}
AptoHUD.HUD.HUDAlpha = {
    Combat = 0.6,
    NoCombat = 0.3,
    Border = 0.75,
    Icon = 1,
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

-- ----- Apply HUD

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_MAXPOWER")
local healthFrame = nil
local powerFrame = nil
local powerIcons = nil

local function destroyHUDFrame(frame)
    if frame then
        frame:UnregisterAllEvents()
        frame:SetScript("OnEvent", nil)
        frame:Hide()
        frame = nil
    end
end

local function createHUDFrame(frameName)
    local frame = CreateFrame("Frame", frameName, UIParent)
    frame:SetPoint("CENTER")
    frame:SetSize(1, 1)
    return frame
end

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        -- PlayerFrame:UnregisterAllEvents()
        -- PlayerFrame:Hide()

        AptoHUDDB.playerName = UnitName("player");
        print("AptoHUD loaded. Hello,", AptoHUDDB.playerName);

        -- Health
        if healthFrame then
            destroyHUDFrame(healthFrame)
        end
        healthFrame = createHUDFrame("healthFrame")
        AptoHUD.HUD.CreateHexSegmentPlayerHP(healthFrame)
    end
    if event == "PLAYER_LOGIN" or event == "UNIT_MAXPOWER" then
        if powerFrame then
            destroyHUDFrame(powerFrame)
        end
        powerFrame = createHUDFrame("powerFrame")
        AptoHUD.HUD.CreateHexSegmentPlayerPower(
            powerFrame,
            "primary",
            AptoHUD.HUD.Textures.HexBottomRight,
            AptoHUD.HUD.Textures.HexBottomRightBorder
        )

        if powerIcons then
            destroyHUDFrame(powerIcons)
        end
        powerIcons = createHUDFrame("powerIcons")
        local resources = AptoHUD.Utils.GetResourceTypes()
        for resourceType, _ in pairs(resources) do
            if resourceType ~= "primary" then
                AptoHUD.HUD.ResourceIcons(powerIcons, resourceType)
            end
        end
    end
end);

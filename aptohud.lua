local addonName, AptoHUD = ...

-- saved variables must be global not local
AptoHUDDB = AptoHUDDB or {};

-- Settings
local PlayerHealthEvents = {
    "UNIT_HEALTH",
    "UNIT_MAXHEALTH",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
}
local PlayerPowerEvents = {
    "UNIT_POWER_UPDATE",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
}
local HUDAlpha = {
    combat = 0.75,
    noCombat = 0.4
}
local HUDScale = 3

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

-- ----- Player Health

-- Get secret health values
local function GetHealthValues(unitName)
    local perc1 = UnitHealthPercent(unitName, false, CurveConstants.ZeroToOne)
    local perc1r = UnitHealthPercent(unitName, false, CurveConstants.Reverse)
    return perc1, perc1r
end

-- Updates the mask based on health values
local function UpdateHealthTextureUsingPercent(unitName, textureItem)
    local perc1, perc1r = GetHealthValues(unitName)
    if not perc1 then
        textureItem:Hide()
        return
    end
    textureItem:Show()
    textureItem:SetVertexColor(perc1r, perc1, 0, perc1r)
end

local function CreateHexSegmentPlayerHP(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(128, 128)
    frame:SetScale(HUDScale)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, HUDAlpha.noCombat)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    mask:SetTexture("Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)

    local unitName = "player"
    UpdateHealthTextureUsingPercent(unitName, fill)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdateHealthTextureUsingPercent(unitName, fill)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            fill:SetColorTexture(1, 1, 1, HUDAlpha.noCombat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            fill:SetColorTexture(1, 1, 1, HUDAlpha.combat)
        end
    end)

    local regEvents = PlayerHealthEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdateHealthTextureUsingPercent(unitName, fill)
    return frame
end

-- ----- Power System

local function GetPrimaryResource()
    class = GetPlayerClass()
    return ClassPrimaryPower[class]
end

-- Get secret power values
local function GetPowerValues(unitName)
    local powerType = GetPrimaryResource()
    local perc1 = UnitPowerPercent(unitName, powerType, false, CurveConstants.ZeroToOne)
    local perc1r = UnitPowerPercent(unitName, powerType, false, CurveConstants.Reverse)
    return perc1, perc1r
end

-- Updates the mask based on power values
local function UpdatePowerTextureUsingPercent(unitName, textureItem, getFuncType, r, g, b)
    local perc1, perc1r = GetPowerValues(unitName)
    if not perc1 then
        textureItem:Hide()
        return
    end
    textureItem:Show()
    textureItem:SetVertexColor(r, g, b, perc1)
end

local function CreateHexSegmentPlayerPower(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(128, 128)
    frame:SetScale(HUDScale)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, HUDAlpha.noCombat)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    mask:SetTexture("Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-br", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)
    local r, g, b = GetClassColour()

    local unitName = "player"
    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            fill:SetColorTexture(1, 1, 1, HUDAlpha.noCombat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            fill:SetColorTexture(1, 1, 1, HUDAlpha.combat)
        end
    end)

    local regEvents = PlayerPowerEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)
    return frame
end


-- Load elements

local hexPlayerHP = CreateHexSegmentPlayerHP(UIParent, "CENTER", 0, 0)
-- local hexPlayerPower = CreateHexSegmentPlayerPower(UIParent, "CENTER", 0, 0)

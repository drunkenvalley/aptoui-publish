local addonName, AptoHUD = ...

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

function AptoHUD.HUD.CreateHexSegmentPlayerPower(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(128, 128)
    frame:SetScale(AptoHUD.HUD.HUDScale)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(AptoHUD.HUD.Textures.Power, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)
    local r, g, b = AptoHUD.Utils.GetClassColour()

    local unitName = "player"
    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.combat)
        end
    end)

    local regEvents = AptoHUD.HUD.PlayerPowerEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)
    return frame
end

local addonName, AptoHUD = ...

-- ----- Power System

local function GetResources(resourceType)
    local class = AptoHUD.Utils.GetPlayerClass()
    local spec, specID = AptoHUD.Utils.GetPlayerSpec()
    local primary, primaryStartsAtZero, secondary, secondaryStartsAtZero = AptoHUD.Utils.GetPowerFromClassAndSpec(class, specID)
    if resourceType == "primary" then
        return primary, primaryStartsAtZero
    elseif resourceType == "secondary" then
        return secondary, secondaryStartsAtZero
    end
    return nil
end

-- Get secret power values
local function GetPowerValues(unitName, resourceType)
    local powerType, startsAtZero = GetResources(resourceType)
    if startsAtZero then
        curveType = CurveConstants.ZeroToOne
    else
        curveType = CurveConstants.Reverse
    end
    local perc1 = UnitPowerPercent(unitName, powerType, false, curveType)
    return perc1
end

-- Updates the mask based on power values
local function UpdatePowerTextureUsingPercent(unitName, textureItem, getFuncType, r, g, b, resourceType)
    local perc1 = GetPowerValues(unitName, resourceType)
    if not perc1 then
        textureItem:Hide()
        return
    end
    textureItem:Show()
    textureItem:SetVertexColor(r, g, b, perc1)
end

function AptoHUD.HUD.CreateHexSegmentPlayerPower(parent, point, xOffset, yOffset, resourceType)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(128, 128)
    frame:SetScale(AptoHUD.HUD.HUDScale)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    local maskTexture = AptoHUD.HUD.Textures.Power[resourceType]
    mask:SetTexture(maskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)
    local r, g, b = AptoHUD.Utils.GetClassColour()

    local unitName = "player"
    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b, resourceType)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b, resourceType)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.combat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
        end
    end)

    local regEvents = AptoHUD.HUD.PlayerPowerEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b)
    return frame
end

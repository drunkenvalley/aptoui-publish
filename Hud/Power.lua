local addonName, AptoHUD = ...

-- Retrieve the type of resource that counts as primary / secondary for this class/spec
local function GetResources(resourceType)
    local class = AptoHUD.Utils.GetPlayerClass()
    local spec, specID = AptoHUD.Utils.GetPlayerSpec()
    local powerType, startsAtZero = AptoHUD.Utils.GetPowerFromClassAndSpec(class, specID, resourceType)
    return powerType, startsAtZero
end

-- Get secret power values
local function GetPowerValues(unitName, resourceType)
    if AptoHUD.debug then
        print("GetPowerValues unitname resourcetype", unitName, resourceType)
    end
    local powerType, startsAtZero = GetResources(resourceType)
    if powerType == nil then
        return nil
    end if
    if startsAtZero then
        curveType = CurveConstants.ZeroToOne
    else
        curveType = CurveConstants.Reverse
    end
    local perc1 = UnitPowerPercent(unitName, powerType, false, curveType)
    if AptoHUD.debug then
        print("GetPowerValues resourcetype perc1", resourceType, perc1)
    end
    return perc1
end

-- Updates the mask based on power values
local function UpdatePowerTextureUsingPercent(unitName, textureItem, getFuncType, r, g, b, resourceType)
    if AptoHUD.debug then
        print("UpdatePowerTextureUsingPercent", unitName, textureItem, getFuncType, r, g, b, resourceType)
    end
    local perc1 = GetPowerValues(unitName, resourceType)
    if AptoHUD.debug then
        print("UpdatePowerTextureUsingPercent", perc1)
    end
    if not perc1 then
        textureItem:Hide()
        return
    end
    textureItem:Show()
    textureItem:SetVertexColor(r, g, b, perc1)
end

function AptoHUD.HUD.CreateHexSegmentPlayerPower(parent, point, xOffset, yOffset, resourceType)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(512, 512)
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

    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, r, g, b, resourceType)
    return frame
end

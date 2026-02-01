local addonName, AptoHUD = ...

-- Retrieve the type of resource that counts as primary / secondary for this class/spec
local function GetResources(resourceType)
    local _, class = UnitClass("player")
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
    if AptoHUD.debug then
        print("GetPowerValues powerType startsAtZero", powerType, startsAtZero)
    end
    if powerType == nil then
        return nil
    end
    if startsAtZero then
        curveType = CurveConstants.ZeroToOne
    else
        curveType = CurveConstants.Reverse
    end
    local colour = PowerBarColor[powerType]
    local perc1 = UnitPowerPercent(unitName, powerType, false, curveType)
    if AptoHUD.debug then
        print("GetPowerValues resourcetype perc1", resourceType, perc1)
    end
    return perc1, colour.r, colour.g, colour.b
end

-- Updates the mask based on power values
local function UpdatePowerTextureUsingPercent(unitName, textureItem, getFuncType, resourceType)
    if AptoHUD.debug then
        print("UpdatePowerTextureUsingPercent", unitName, textureItem, getFuncType, r, g, b, resourceType)
    end
    local perc1, r, g, b = GetPowerValues(unitName, resourceType)
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

function AptoHUD.HUD.CreateHexSegmentPlayerPower(
    parent, point, xOffset, yOffset, resourceType, texturePath, textureBorderPath
)
    local frame = CreateFrame("Frame", nil, parent)
    local xSize = AptoHUD.HUD.Size.Main * AptoHUD.HUD.Scale.Main
    local ySize = AptoHUD.HUD.Size.Main * AptoHUD.HUD.Scale.Main
    frame:SetSize(xSize, ySize)
    frame:SetPoint(point, parent, point, xOffset, yOffset)
    frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)

    AptoHUD.HUD.CreateBorder(frame, textureBorderPath)

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(texturePath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, 1)
    fill:SetAllPoints()
    fill:AddMaskTexture(mask)

    local unitName = "player"
    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, resourceType)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, resourceType)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            frame:SetAlpha(AptoHUD.HUD.HUDAlpha.Combat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)
        end
    end)

    local regEvents = AptoHUD.HUD.PlayerPowerEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdatePowerTextureUsingPercent(unitName, fill, GetPowerValues, resourceType)
    return frame
end

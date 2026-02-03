local addonName, AptoHUD = ...

-- powerType is the number of power type e.g. Enum.PowerType.Energy which is the same as 3
-- resourceType is "primary", "secondary", etc and gets looked up from Utils/ClassResources

-- Retrieve the type of resource that counts as primary / secondary for this class/spec
local function GetResources(resourceType)
    local powerType, startsAtZero = AptoHUD.Utils.GetPowerType(resourceType)
    return powerType, startsAtZero
end

-- Get secret power values
local function GetPowerPercent(unitName, resourceType)
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
    local curveType = CurveConstants.ZeroToOne
    -- if startsAtZero then
    --     local curveType = CurveConstants.ZeroToOne
    -- else
    --     local curveType = CurveConstants.Reverse
    -- end
    local perc1 = UnitPowerPercent(unitName, powerType, false, curveType)
    if AptoHUD.debug then
        print("GetPowerValues resourcetype perc1", resourceType, perc1)
    end
    return perc1
end

-- Updates the mask based on power values
-- PowerBarColor is a Blizzard lookup
local function UpdatePowerTextureUsingPercent(unitName, textureItem, resourceType)
    local powerType = GetResources(resourceType)
    local colour = PowerBarColor[powerType] or {r = 1, g = 1, b = 1}
    local perc1 = GetPowerPercent(unitName, resourceType)
    if AptoHUD.debug then
        print("UpdatePowerTextureUsingPercent", perc1)
    end
    if not perc1 then
        textureItem:Hide()
        return
    end
    textureItem:Show()
    textureItem:SetVertexColor(colour.r, colour.g, colour.b, perc1)
end

function AptoHUD.HUD.CreateHexSegmentPlayerPower(parent, resourceType, texturePath, textureBorderPath)
    local frame = CreateFrame("Frame", nil, parent)
    local xSize = AptoHUD.HUD.Size.Main * AptoHUD.HUD.Scale.Main
    local ySize = AptoHUD.HUD.Size.Main * AptoHUD.HUD.Scale.Main
    frame:SetSize(xSize, ySize)
    frame:SetPoint("CENTER", parent, "CENTER", AptoHUD.HUD.Offset.X, AptoHUD.HUD.Offset.Y)
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
    UpdatePowerTextureUsingPercent(unitName, fill, resourceType)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdatePowerTextureUsingPercent(unitName, fill, resourceType)
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

    UpdatePowerTextureUsingPercent(unitName, fill, resourceType)
    return frame
end

-- Specific power handling

-- Runes for death knights
-- GetRuneCooldown is Blizzard function
local function GetRuneOffCooldownCount()
    local maxRunes = UnitPowerMax("player", Enum.PowerType.Runes)
    local currentRunes = 0
    for i = 1, maxRunes do
        local start, duration, available = GetRuneCooldown(i)
        if available then
            currentRunes = currentRunes + 1
        end
    end
    return currentRunes, maxRunes
end

-- Supercharged combo points have their own system
-- GetUnitChargedPowerPoints is a Blizzard function returning a table with
-- index numbers of each charged combo point
-- UnitPowerMax is a Blizzard function
local function GetSuperchargedComboPoints()
    local chargedIndices = GetUnitChargedPowerPoints("player")
    local chargeCount = 0
    if type(chargedIndices) == "table" then
        for _, idx in ipairs(chargedIndices) do
            chargeCount = chargeCount + 1
        end
    end
    return chargeCount, UnitPowerMax("player", Enum.PowerType.ComboPoints)
end

-- returns current and max resource count
-- UnitPower and UnitPowerMax are Blizzard functions
local function GetResourceCount(resourceType)
    local powerType = AptoHUD.Utils.GetPowerType(resourceType)
    return UnitPower("player", powerType), UnitPowerMax("player", powerType)
end

local resourceHandlers = {
    primary = { func = GetResourceCount, args = { "primary" } },
    secondary = { func = GetResourceCount, args = { "secondary" } },
    rogue_charged = { func = GetSuperchargedComboPoints, args = {} },
    dk_runes = { func = GetRuneOffCooldownCount, args = {} },
}

local function ResourceGetter(resourceType)
    local entry = resourceHandlers[resourceType]
    if not entry then return nil end
    return entry.func(unpack(entry.args))
end

local function UpdatePowerTextureUsingCount(iconNumber, unitName, textureItem, resourceType)
    local powerType = GetResources(resourceType)
    local powerCount, _ = ResourceGetter(resourceType)
    -- mid grey
    local colour = {r = 0.5, g = 0.5, b = 0.5}
    local alpha = 0
    if resourceType == "secondary" then
        alpha = 0.5
    end
    if type(powerCount) == "number" then
        if powerCount >= iconNumber then
            colour = AptoHUD.Utils.GetPowerColour(powerType)
            alpha = 1
        end
    end
    textureItem:Show()
    textureItem:SetVertexColor(colour.r, colour.g, colour.b, alpha)
end

function AptoHUD.HUD.ResourceIcons(parent, resourceType)
    local _, countMax = ResourceGetter(resourceType)
    if countMax == nil then return nil end
    local frameLayer = 0
    if resourceType == "rogue_charged" then
        frameLayer = 1
    end
    local frames = AptoHUD.HUD.IconStrip(parent, countMax, 3, false, frameLayer)

    -- link frames to event handlers
    for iconNumber, frameData in ipairs(frames) do
        local unitName = "player"
        local frame = frameData["frame"]
        local fill = frameData["fill"]
        UpdatePowerTextureUsingCount(iconNumber, unitName, fill, resourceType)

        frame:SetScript("OnEvent", function(_, event, eventUnit)
            if eventUnit == unitName or event == "RUNE_POWER_UPDATE" or event == "RUNE_TYPE_UPDATE" then
                UpdatePowerTextureUsingCount(iconNumber, unitName, fill, resourceType)
            end
            if event == "PLAYER_REGEN_DISABLED" then
                frame:SetAlpha(AptoHUD.HUD.HUDAlpha.Icon)
            elseif event == "PLAYER_REGEN_ENABLED" then
                frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)
            end
        end)

        local genericEvents = AptoHUD.HUD.PlayerPowerEvents
        local specificEvents = AptoHUD.Utils.GetPowerEvents(GetResources(resourceType))
        for _, eventName in ipairs(genericEvents) do
            frame:RegisterEvent(eventName)
        end
        for _, eventName in ipairs(specificEvents) do
            frame:RegisterEvent(eventName)
        end

        UpdatePowerTextureUsingCount(iconNumber, unitName, fill, resourceType)
    end
    return frames
end

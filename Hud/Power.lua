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
local function UpdatePowerTextureUsingPercent(unitName, textureItem, getFuncType, resourceType)
    if AptoHUD.debug then
        print("UpdatePowerTextureUsingPercent", unitName, textureItem, getFuncType, r, g, b, resourceType)
    end
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

-- Specific power handling

-- Runes for death knights
-- GetRuneCooldown is Blizzard function
local function GetRuneOffCooldownCount()
    local maxRunes = UnitPowerMax("player", Enum.PowerType.Runes)
    local current = 0
    for i = 1, maxRunes do
        local start, duration, available = GetRuneCooldown(i)
        if available then
            current = current + 1
        end
    end
    return current
end

-- Supercharged combo points have their own system
local function GetSuperchargedComboPoints()
    print(GetUnitChargedPowerPoints("player"))
    return GetUnitChargedPowerPoints("player") or {}
end

-- returns current and max resource count
-- UnitPower and UnitPowerMax are Blizzard functions
local function GetResourceCount(resourceType)
    local powerType = AptoHUD.Utils.GetPowerType(resourceType)
    return {
        current = UnitPower("player", powerType),
        max = UnitPowerMax("player", powerType)
    }
end

function AptoHUD.Resources.GetResourceCounts()
    return {
        primary = GetResourceCount("primary"),
        secondary = GetResourceCount("secondary"),
        rogue_charged = GetSuperchargedComboPoints(),
        dk_runes = GetRuneOffCooldownCount(),
    }
end

-- saved variables must be global not local
AptoHUDDB = AptoHUDDB or {};

-- Using UnitHealthPercent as not secret

local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN");

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        print("AptoHUD loaded");

        -- Save player name
        AptoHUDDB.playerName = UnitName("player");
        print("Hello,", AptoHUDDB.playerName);
    end
end);

-- Get secret health values
local function GetHealthValues(unitName)
    local perc1 = UnitHealthPercent(unitName, false, CurveConstants.ZeroToOne)
    local perc1r = UnitHealthPercent(unitName, false, CurveConstants.Reverse)
    local perc100 = UnitHealthPercent(unitName, false, CurveConstants.ScaleTo100)
    return perc1, perc1r, perc100
end

-- Create a health percentage display number
local function CreateHealthPercentDisplay(parent, point, unitName, xOffset, yOffset, regEvents)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(60, 30)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.text:SetPoint("CENTER")

    local function Update()
        local perc1, perc1r, perc100 = GetHealthValues(unitName)
        if perc100 == nil then
            frame.text:SetText("")
        else
            frame.text:SetText(("%.0f"):format(perc100))
            frame.text:SetTextColor(perc1r, perc1, 0)
        end
    end

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if event == "PLAYER_TARGET_CHANGED" and unitName == "target" then
            Update()
            return
        end

        if eventUnit == unitName then
            Update()
        end
    end)

    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    Update()

    return frame
end

-- Set up display items
local display_playerhp = CreateHealthPercentDisplay(
    UIParent, "CENTER", "player", -100, 0,
    { "UNIT_HEALTH", "UNIT_MAXHEALTH" }
)
local display_targethp = CreateHealthPercentDisplay(
    UIParent, "CENTER", "target", 100, 0,
    { "UNIT_HEALTH", "UNIT_MAXHEALTH", "PLAYER_TARGET_CHANGED" }
)

-- Updates the mask based on health values
local function UpdateTextureUsingPercent(unitName, textureItem)
    local perc1, perc1r, perc100 = GetHealthValues(unitName)
    if not perc1 then
        textureItem:Hide()
        return
    end
    textureItem:Show()
    textureItem:SetVertexColor(perc1r, perc1, 0, perc1r)
end

local function CreateHexSegmentPlayerHP(parent, point, xOffset, yOffset)
    local unitName = "player"
    local regEvents = { "UNIT_HEALTH", "UNIT_MAXHEALTH" }

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(100, 100)
    frame:SetScale(3.5)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, 0.75)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    mask:SetTexture("Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)

    UpdateTextureUsingPercent(unitName, fill)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdateTextureUsingPercent(unitName, fill)
        end
    end)

    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end


    UpdateTextureUsingPercent(unitName, fill)
    return frame
end

local hex_playerhp = CreateHexSegmentPlayerHP(UIParent, "CENTER", 0, 0)

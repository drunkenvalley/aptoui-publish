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

-- Set the frame colour dynamically depending on the health percentage
local function SetFrameColourFromPercent(frame, percent)
    local greenThreshold = 80
    local redThreshold = 40
    if percent > greenThreshold then
        frame.text:SetTextColor(0, 1, 0)
    elseif percent < redThreshold then
        frame.text:SetTextColor(1, 0, 0)
    else
        local t = (greenThreshold - percent) / redThreshold
        r = t
        g = 1 - t
        frame.text:SetTextColor(r, g, 0)
    end
end

-- Create a health percentage display number
local function CreateHealthPercentDisplay(parent, point, unitForHealthPercent, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.text:SetPoint(point, xOffset, yOffset)

    local function Update()
        local hp = UnitHealthPercent(unitForHealthPercent, false, CurveConstants.ScaleTo100)
        frame.text:SetText(hp)
        SetFrameColourFromPercent(frame, hp)
    end

    frame:SetScript("OnEvent", function(_, event, unitForHealthPercent)
        if unit == unitForHealthPercent then
            Update()
        end
    end)

    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")

    Update() -- initialize

    return frame
end

-- Usage:
local display_playerhp = CreateHealthPercentDisplay(UIParent, "CENTER", "player", -100, 0)
display_playerhp:SetPoint("CENTER")
local display_targethp = CreateHealthPercentDisplay(UIParent, "CENTER", "target", 100, 0)
display_targethp:SetPoint("CENTER")

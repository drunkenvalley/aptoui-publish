local addonName, AptoHUD = ...

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


function AptoHUD.HUD.CreateHexSegmentPlayerHP(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(128, 128)
    frame:SetScale(AptoHUD.HUD.HUDScale)
    frame:SetPoint(point, parent, point, xOffset, yOffset)

    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
    fill:SetAllPoints()

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(AptoHUD.HUD.Textures.Health, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    fill:AddMaskTexture(mask)

    local unitName = "player"
    UpdateHealthTextureUsingPercent(unitName, fill)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdateHealthTextureUsingPercent(unitName, fill)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.combat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            fill:SetColorTexture(1, 1, 1, AptoHUD.HUD.HUDAlpha.noCombat)
        end
    end)

    local regEvents = AptoHUD.HUD.PlayerHealthEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdateHealthTextureUsingPercent(unitName, fill)
    return frame
end

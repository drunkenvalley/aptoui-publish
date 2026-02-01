local addonName, AptoHUD = ...

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
    local xSize = AptoHUD.HUD.Size.Main * AptoHUD.HUD.Scale.Main
    local ySize = AptoHUD.HUD.Size.Main * AptoHUD.HUD.Scale.Main
    frame:SetSize(xSize, ySize)
    frame:SetPoint(point, parent, point, xOffset, yOffset)
    frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)

    AptoHUD.HUD.CreateBorder(frame, AptoHUD.HUD.Textures.HexBottomLeftBorder)

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(AptoHUD.HUD.Textures.HexBottomLeft, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    local fill = frame:CreateTexture(nil, "ARTWORK", nil, 1)
    fill:SetColorTexture(1, 1, 1, 1)
    fill:SetAllPoints()
    fill:AddMaskTexture(mask)

    local unitName = "player"
    UpdateHealthTextureUsingPercent(unitName, fill)

    frame:SetScript("OnEvent", function(_, event, eventUnit)
        if eventUnit == unitName then
            UpdateHealthTextureUsingPercent(unitName, fill)
        end
        if event == "PLAYER_REGEN_DISABLED" then
            frame:SetAlpha(AptoHUD.HUD.HUDAlpha.Combat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)
        end
    end)

    local regEvents = AptoHUD.HUD.PlayerHealthEvents
    for _, eventName in ipairs(regEvents) do
        frame:RegisterEvent(eventName)
    end

    UpdateHealthTextureUsingPercent(unitName, fill)
    return frame
end

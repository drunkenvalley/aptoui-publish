local addonName, AptoHUD = ...

function AptoHUD.HUD.CreateHexIcon(parent, point, xOffset, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    local xSize = AptoHUD.HUD.Size.Icon * AptoHUD.HUD.Scale.Icon
    local ySize = AptoHUD.HUD.Size.Icon * AptoHUD.HUD.Scale.Icon
    frame:SetSize(xSize, ySize)
    frame:SetPoint(point, parent, point, xOffset, yOffset)
    frame:SetAlpha(AptoHUD.HUD.HUDAlpha.NoCombat)

    local mask = frame:CreateMaskTexture()
    local maskTexture = AptoHUD.HUD.Textures.HexSmall
    mask:SetTexture(maskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    local classColour = AptoHUD.Utils.GetClassColour()
    local fill = frame:CreateTexture(nil, "ARTWORK")
    fill:SetColorTexture(1, 1, 1, 1)
    fill:SetAllPoints()
    fill:Show()
    fill:SetVertexColor(classColour.r, classColour.g, classColour.b, 1)
    fill:AddMaskTexture(mask)

    return frame
end

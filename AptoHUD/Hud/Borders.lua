local addonName, AptoUI = ...

function AptoUI.HUD.CreateBorder(frame, texturePath)
    local maskBorder = frame:CreateMaskTexture()
    maskBorder:SetTexture(texturePath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    maskBorder:SetAllPoints()

    local classColour = AptoUI.Utils.GetClassColour()
    local border = frame:CreateTexture(nil, "ARTWORK", nil, 0)
    border:SetColorTexture(1, 1, 1, AptoUI.HUD.HUDAlpha.Main.Border)
    border:AddMaskTexture(maskBorder)
    border:SetAllPoints()
    border:Show()
    border:SetVertexColor(classColour.r, classColour.g, classColour.b, 1)
end
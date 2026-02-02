local addonName, AptoHUD = ...

local function OffsetWrapping(offsetNumber)
    if offsetNumber > 6 then
        offsetNumber = offsetNumber - 6
    elseif offsetNumber < 1 then
        offsetNumber = offsetNumber + 6
    end
    return offsetNumber
end

local function CreateHexIcon(parent, point, xOffset, yOffset, iconScale)
    local frame = CreateFrame("Frame", nil, parent)
    local xSize = AptoHUD.HUD.Size.Icon * iconScale
    local ySize = AptoHUD.HUD.Size.Icon * iconScale
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

function AptoHUD.HUD.IconStrip(iconCount, locationNumber, isClockwise, iconScale)
    local iconScale = AptoHUD.HUD.GetIconChainScale(iconCount)
    local offsetNumber = OffsetWrapping(3 + locationNumber - 1)
    local offsetIterate = -1
    if not isClockwise then
        offsetNumber = offsetNumber + 1
        offsetIterate = 1
    end
    local xPosition, yPosition = AptoHUD.HUD.GetIconPosition(locationNumber, iconScale)
    CreateHexIcon(UIParent, "CENTER", xPosition, yPosition, iconScale)
    if iconCount > 1 then
        for i = 2, iconCount, 1 do
            local xOffset, yOffset = AptoHUD.HUD.GetIconOffset(offsetNumber, iconScale)
            xPosition = xPosition + xOffset
            yPosition = yPosition + yOffset
            CreateHexIcon(UIParent, "CENTER", xPosition, yPosition, iconScale)
            if i % 2 == 0 then
                offsetNumber = offsetNumber + offsetIterate
            else
                offsetNumber = offsetNumber - offsetIterate
            end
            offsetNumber = OffsetWrapping(offsetNumber)
        end
    end
end

-- Todo:
-- Use power colours instead of class colours (see Power.lua)
-- Set up discrete resources to use icons, start with combo points and runes

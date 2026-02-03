local addonName, AptoHUD = ...

local function OffsetWrapping(offsetNumber)
    if offsetNumber > 6 then
        offsetNumber = offsetNumber - 6
    elseif offsetNumber < 1 then
        offsetNumber = offsetNumber + 6
    end
    return offsetNumber
end

local function CreateIcon(parent, xOffset, yOffset, iconScale, frameLayer, texturePath)
    local frame = CreateFrame("Frame", nil, parent)
    local xSize = AptoHUD.HUD.Size.Icon * iconScale
    local ySize = AptoHUD.HUD.Size.Icon * iconScale
    frame:SetSize(xSize, ySize)
    frame:SetPoint("CENTER", parent, "CENTER", xOffset, yOffset)
    frame:SetAlpha(1)

    local mask = frame:CreateMaskTexture()
    local maskTexture = texturePath
    mask:SetTexture(maskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()

    local colours = AptoHUD.Utils.GetClassColour()
    local fill = frame:CreateTexture(nil, "ARTWORK", nil, frameLayer)
    fill:SetColorTexture(1, 1, 1, 1)
    fill:SetAllPoints()
    fill:Show()
    fill:SetVertexColor(colours.r, colours.g, colours.b, 1)
    fill:AddMaskTexture(mask)

    return { frame = frame, fill = fill }
end

function AptoHUD.HUD.IconStrip(parent, iconCount, locationNumber, isClockwise, frameLayer, texturePath)
    local iconScale = AptoHUD.HUD.GetIconChainScale(iconCount)
    local offsetNumber = OffsetWrapping(3 + locationNumber - 1)
    local offsetIterate = -1
    if not isClockwise then
        offsetNumber = offsetNumber + 1
        offsetIterate = 1
    end
    local xPosition, yPosition = AptoHUD.HUD.GetIconPosition(locationNumber, iconScale)
    local frames = {}
    frames[1] = CreateIcon(parent, xPosition, yPosition, iconScale, frameLayer, texturePath)
    if iconCount > 1 then
        for i = 2, iconCount, 1 do
            local xOffset, yOffset = AptoHUD.HUD.GetIconOffset(offsetNumber, iconScale)
            xPosition = xPosition + xOffset
            yPosition = yPosition + yOffset
            frames[i] = CreateIcon(parent, xPosition, yPosition, iconScale, frameLayer, texturePath)
            if i % 2 == 0 then
                offsetNumber = offsetNumber + offsetIterate
            else
                offsetNumber = offsetNumber - offsetIterate
            end
            offsetNumber = OffsetWrapping(offsetNumber)
        end
    end
    return frames
end

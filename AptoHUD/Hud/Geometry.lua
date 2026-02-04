local addonName, AptoUI = ...

AptoUI.HUD.Scale = {
    Main = 0.7,
    Icon = 1,
}

AptoUI.HUD.Size = {
    Main = 512,
    Icon = 64
}


-- Y offset applied to make it more centred on the character
AptoUI.HUD.Offset = { X = 0, Y = -50 }

-- this is based on the specific drawn textures, using top right point coords vs centre point
local HexPoints = {
    Inside = {
        Top = { X = 0, Y = 210 },
        Side = { X = 180, Y = 107 },
    },
    Outside = {
        Top = { X = 0, Y = 256 },
        Side = { X = 220, Y = 128 },
    },
}
local HexIconSizeRatio = AptoUI.HUD.Size.Icon / AptoUI.HUD.Size.Main
local IconOffsetBuffer = 3

-- locationNumber: 1 = top, numbered clockwise
local function GetLocationFactors(locationNumber)
    if locationNumber == 1 or locationNumber == 4 then
        locationType = "Top"
    else
        locationType = "Side"
    end
    if locationNumber == 1 or locationNumber == 4 then
        xFactor = 0
    elseif locationNumber == 5 or locationNumber == 6 then
        xFactor = -1
    else
        xFactor = 1
    end
    if locationNumber == 1 or locationNumber == 2 or locationNumber == 6 then
        yFactor = 1
    else
        yFactor = -1
    end
    return locationType, xFactor, yFactor
end

function AptoUI.HUD.GetIconPosition(locationNumber, iconScale)
    local iconScale = iconScale or AptoUI.HUD.Scale.Icon
    local locationType, xFactor, yFactor = GetLocationFactors(locationNumber)
    local hexIconScaleRatio = iconScale / AptoUI.HUD.Scale.Main
    local x = (
        AptoUI.HUD.Offset.X
        + HexPoints.Inside[locationType].X * AptoUI.HUD.Scale.Main * xFactor
        - HexPoints.Outside[locationType].X * AptoUI.HUD.Scale.Main * HexIconSizeRatio * hexIconScaleRatio * xFactor
        - IconOffsetBuffer * xFactor
    )
    local y = (
        AptoUI.HUD.Offset.Y
        + HexPoints.Inside[locationType].Y * AptoUI.HUD.Scale.Main * yFactor
        - HexPoints.Outside[locationType].Y * AptoUI.HUD.Scale.Main * HexIconSizeRatio * hexIconScaleRatio * yFactor
        - IconOffsetBuffer * yFactor
    )
    return x, y
end

local IconOffsets = {
    Side = {
        X = HexPoints.Outside.Side.X * 2,
        Y = 0,
    },
    Top = {
        X = HexPoints.Outside.Side.X,
        Y = HexPoints.Outside.Side.Y * 3,
    }
}

-- locationNumber: 1 = top right, numbered clockwise
local function GetLocationFactorsOffset(locationNumber)
    if locationNumber == 2 or locationNumber == 5 then
        locationType = "Side"
    else
        locationType = "Top"
    end
    if locationNumber == 1 or locationNumber == 2 or locationNumber == 3 then
        xFactor = 1
    else
        xFactor = -1
    end
    if locationNumber == 1 or locationNumber == 6 then
        yFactor = 1
    elseif locationNumber == 3 or locationNumber == 4 then
        yFactor = -1
    else
        yFactor = 0
    end
    return locationType, xFactor, yFactor
end

function AptoUI.HUD.GetIconOffset(locationNumber, scaleFactor)
    local locationType, xFactor, yFactor = GetLocationFactorsOffset(locationNumber)
    local scaleFactor = scaleFactor or AptoUI.HUD.Scale.Icon
    local x = IconOffsets[locationType].X * xFactor * HexIconSizeRatio * scaleFactor
    local y = IconOffsets[locationType].Y * yFactor * HexIconSizeRatio * scaleFactor
    return x, y
end

local function GetIconChainLength(iconCount)
    local iconSize = AptoUI.HUD.Size.Icon
    local fullLength = math.floor(iconCount / 2)
    local halfLength = math.floor((iconCount + 1) / 2)
    return fullLength * iconSize + halfLength * iconSize / 2
end
local HexInsideLength = HexPoints.Inside.Side.Y * 2 * AptoUI.HUD.Scale.Main - 2 * IconOffsetBuffer

function AptoUI.HUD.GetIconChainScale(iconCount)
    local maxScale = AptoUI.HUD.Scale.Icon
    local mainScale = AptoUI.HUD.Scale.Main
    local chainToHexInsideRatio = HexInsideLength / GetIconChainLength(iconCount)
    return min(maxScale, chainToHexInsideRatio)
end

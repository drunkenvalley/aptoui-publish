
local addonName, AptoHUD = ...

AptoHUD.HUD.Scale = {
    Main = 0.75,
    Icon = 0.4,
}

AptoHUD.HUD.Size = {
    Main = 512,
    Icon = 64
}

-- Y offset applied to make it more centred on the character
AptoHUD.HUD.Offset = { X = 0, Y = -50 }

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
local HexIconSizeRatio = AptoHUD.HUD.Size.Icon / AptoHUD.HUD.Size.Main
local HexIconScaleRatio = AptoHUD.HUD.Scale.Icon / AptoHUD.HUD.Scale.Main
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

function AptoHUD.HUD.GetIconPosition(locationNumber)
    local locationType, xFactor, yFactor = GetLocationFactors(locationNumber)
    local x = (
        AptoHUD.HUD.Offset.X
        + HexPoints.Inside[locationType].X * AptoHUD.HUD.Scale.Main * xFactor
        - HexPoints.Outside[locationType].X * AptoHUD.HUD.Scale.Main * HexIconSizeRatio * HexIconScaleRatio * xFactor
        - IconOffsetBuffer * xFactor
    )
    local y = (
        AptoHUD.HUD.Offset.Y
        + HexPoints.Inside[locationType].Y * AptoHUD.HUD.Scale.Main * yFactor
        - HexPoints.Outside[locationType].Y * AptoHUD.HUD.Scale.Main * HexIconSizeRatio * HexIconScaleRatio * yFactor
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

-- TODO: Fix offset distances
function AptoHUD.HUD.GetIconOffset(locationNumber)
    local locationType, xFactor, yFactor = GetLocationFactorsOffset(locationNumber)
    local x = IconOffsets[locationType].X * xFactor * HexIconSizeRatio * AptoHUD.HUD.Scale.Icon
    local y = IconOffsets[locationType].Y * yFactor * HexIconSizeRatio * AptoHUD.HUD.Scale.Icon
    return x, y
end

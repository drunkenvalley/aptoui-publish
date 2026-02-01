
local addonName, AptoHUD = ...

AptoHUD.HUD.Scale = {
    Main = 0.75,
    Icon = 0.35,
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
        Top = {
            X = 0 * AptoHUD.HUD.Scale.Main,
            Y = 210 * AptoHUD.HUD.Scale.Main,
        },
        Side = {
            X = 180 * AptoHUD.HUD.Scale.Main,
            Y = 107 * AptoHUD.HUD.Scale.Main,
        },
    },
    Outside = {
        Top = {
            X = 0 * AptoHUD.HUD.Scale.Main,
            Y = 256 * AptoHUD.HUD.Scale.Main,
        },
        Side = {
            X = 220 * AptoHUD.HUD.Scale.Main,
            Y = 128 * AptoHUD.HUD.Scale.Main,
        },
    },
}
local HexIconSizeRatio = AptoHUD.HUD.Size.Icon / AptoHUD.HUD.Size.Main
local HexIconScaleRatio = AptoHUD.HUD.Scale.Icon / AptoHUD.HUD.Scale.Main

local IconOffsetBuffer = 3

local SmallHexOffsets = {
    X = AptoHUD.HUD.Size.Icon * HexPoints.Outside.Side.X / AptoHUD.HUD.Size.Main,
    Y = AptoHUD.HUD.Size.Icon * HexPoints.Outside.Side.Y / AptoHUD.HUD.Size.Main,
}

-- 1 = top, numbered clockwise
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
        + HexPoints.Inside[locationType].X * xFactor
        - HexPoints.Outside[locationType].X * HexIconSizeRatio * HexIconScaleRatio * xFactor
        - IconOffsetBuffer * xFactor
    )
    local y = (
        AptoHUD.HUD.Offset.Y
        + HexPoints.Inside[locationType].Y * yFactor
        - HexPoints.Outside[locationType].Y * HexIconSizeRatio * HexIconScaleRatio * yFactor
        - IconOffsetBuffer * yFactor
    )
    return x, y
end

function AptoHUD.HUD.OffsetIcon(locationNumber)
    local locationType, xFactor, yFactor = GetLocationFactors(locationNumber)
    local x = (
        0
    )
    local y = (
        0
    )
    return x, y
end


local addonName, AptoHUD = ...

AptoHUD.HUD.Scale = {
    Main = 0.75,
    Icon = 0.35,
}
AptoHUD.HUD.Size = {
    Main = 512,
    Icon = 64
}
AptoHUD.HUD.Offset = {
    Main = { X = 0, Y = 0, },
    Side = {},
}

-- this is based on the specific drawn textures, using top right point coords vs centre point
local HexPoints = {
    Inside = {
        Top = {
            X = 210 * AptoHUD.HUD.Scale.Main,
            Y = 0 * AptoHUD.HUD.Scale.Main,
        },
        Side = {
            X = 180 * AptoHUD.HUD.Scale.Main,
            Y = 107 * AptoHUD.HUD.Scale.Main,
        },
    },
    Outside = {
        Top = {
            X = 256 * AptoHUD.HUD.Scale.Main,
            Y = 0 * AptoHUD.HUD.Scale.Main,
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
AptoHUD.HUD.Offset.Icon.X = (
    AptoHUD.HUD.Offset.Main.X
    + HexPoints.Inside.Side.X -- get to the inside of the top right
    - HexPoints.Outside.Side.X * HexIconSizeRatio * HexIconScaleRatio  -- offset by the size of the icon
    - IconOffsetBuffer -- Provide buffer to main hex
)
AptoHUD.HUD.Offset.Icon.Y = (
    AptoHUD.HUD.Offset.Main.Y
    - HexPoints.Inside.Side.Y
    - HexPoints.Outside.Side.Y * HexIconSizeRatio * HexIconScaleRatio
    - IconOffsetBuffer
)

AptoHUD.HUD.SmallHexOffsets = {
    X = AptoHUD.HUD.Size * AptoHUD.HUD.HexPoints.Outside.Side.X / AptoHUD.HUD.Size.Main,
    Y = AptoHUD.HUD.Size * AptoHUD.HUD.HexPoints.Outside.Side.Y / AptoHUD.HUD.Size.Main,
}

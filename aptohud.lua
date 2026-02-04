local addonName, AptoHUD = ...

-- saved variables must be global not local
AptoHUDDB = AptoHUDDB or {};

-- Settings
AptoHUD.debug = false
AptoHUD.HUD.PlayerHealthEvents = {
    "UNIT_HEALTH",
    "UNIT_MAXHEALTH",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_TARGET_CHANGED",
}
AptoHUD.HUD.PlayerPowerEvents = {
    "UNIT_POWER_UPDATE",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "UNIT_MAXPOWER",
    "PLAYER_TARGET_CHANGED",
}
AptoHUD.HUD.HUDAlpha = {
    Main = {
        Combat = .8,
        NoCombat = .2,
        Border = .5,
    },
    Icon = {
        Combat = 1,
        NoCombat = .5,
    },
}
AptoHUD.HUD.Textures = {
    HexBottomLeft = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl",
    HexBottomLeftBorder = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-bl-border",
    HexBottomRight = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-br",
    HexBottomRightBorder = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-br-border",
    HexTop = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-top",
    HexTopBorder = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-512-top-border",
    HexSmallRing = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-64",
    HexSmallFill = "Interface\\AddOns\\AptoHUD\\Textures\\hex-ring-inner-64",
}

-- ----- Apply HUD

local hudHealthEvents = {
    PLAYER_LOGIN = true,
}
local hudPowerEvents = {
    PLAYER_LOGIN = true,
    UNIT_MAXPOWER = true,
    UPDATE_SHAPESHIFT_FORM = true,
    UPDATE_SHAPESHIFT_FORMS = true,
    PLAYER_TALENT_UPDATE = true,
    UNIT_DISPLAYPOWER = true,
    RUNE_TYPE_UPDATE = true,
}
local hudBuffCheckEvents = {
    PLAYER_LOGIN = true,
    UNIT_AURA = true,
}

local function isUpdateEvent(eventList, eventFired)
    return eventList[eventFired] == true
end

local frame = CreateFrame("Frame")
for eventName, _ in pairs(hudHealthEvents) do
    frame:RegisterEvent(eventName)
end
for eventName, _ in pairs(hudPowerEvents) do
    frame:RegisterEvent(eventName)
end

local healthFrame = nil
local powerFrame = nil
local powerIcons = nil

local function destroyHUDFrame(frame)
    if not frame or type(frame) ~= "table" then
        return
    end
    if frame then
        frame:UnregisterAllEvents()
        frame:SetScript("OnEvent", nil)
        frame:SetScript("OnHide", nil)
        frame:SetScript("OnShow", nil)
    end
    local children = { frame:GetChildren() }
    for _, child in ipairs(children) do
        destroyHUDFrame(child)
    end
    frame:Hide()
end

local function createHUDFrame(frameName)
    local frame = CreateFrame("Frame", frameName, UIParent)
    frame:SetPoint("CENTER")
    frame:SetSize(1, 1)
    return frame
end

local playerLoggedIn = false

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        playerLoggedIn = true
        -- PlayerFrame:UnregisterAllEvents()
        -- PlayerFrame:Hide()

        AptoHUDDB.playerName = UnitName("player");
        print("AptoHUD loaded. Hello,", AptoHUDDB.playerName);
    end
    if playerLoggedIn then
        if isUpdateEvent(hudHealthEvents, event) then
            -- Health
            if healthFrame then
                destroyHUDFrame(healthFrame)
            end
            healthFrame = createHUDFrame("healthFrame")
            AptoHUD.HUD.CreateHexSegmentPlayerHP(healthFrame)
        end
        if isUpdateEvent(hudPowerEvents, event) then
            if powerFrame then
                destroyHUDFrame(powerFrame)
            end
            powerFrame = createHUDFrame("powerFrame")
            AptoHUD.HUD.CreateHexSegmentPlayerPower(
                powerFrame,
                "primary",
                AptoHUD.HUD.Textures.HexBottomRight,
                AptoHUD.HUD.Textures.HexBottomRightBorder
            )

            if powerIcons then
                destroyHUDFrame(powerIcons)
            end
            powerIcons = createHUDFrame("powerIcons")
            local resources = AptoHUD.Utils.GetResourceTypes()
            for resourceType, _ in pairs(resources) do
                if resourceType ~= "primary" then
                    AptoHUD.HUD.ResourceIcons(powerIcons, resourceType)
                end
            end
        end
        if isUpdateEvent(hudBuffCheckEvents, event) then
            local missingBuffs = AptoHUD.Utils.HasMissingClassBuff()
            for buffTypeName, buffTypeMissing in pairs(missingBuffs) do
                print(buffTypeName, buffTypeMissing)
            end
        end
    end
end);

-- Apply castbar customisation
local CastBar = {}

CastBar.config = {
    -- do not reduce width past 225 if using default textures,
    -- this is the min size of the textures Blizzard uses
    width  = 350,
    height = 40,
    alpha  = 0.5,
    textInside = true,
    scale = 0.5
}

function CastBar:Apply()
    local bar = PlayerCastingBarFrame
    if not bar then return end

    bar:SetWidth(self.config.width)
    bar:SetHeight(self.config.height)
    bar:SetAlpha(self.config.alpha)
    bar:SetScale(self.config.scale)

    local text = bar.Text or bar.TextLabel or bar.TextString
    if text then
        text:ClearAllPoints()

        if self.config.textInside then
            text:SetPoint("CENTER", bar, "CENTER", 0, 0)
            text:SetJustifyH("CENTER")
            text:SetJustifyV("MIDDLE")
        else
            text:SetPoint("TOP", bar, "BOTTOM", 0, -2)
        end
        text:SetScale(1 / self.config.scale)
    end

    -- disable background "shadow"
    for i, region in ipairs({ PlayerCastingBarFrame:GetRegions() }) do
        if i < 3 then
            local tex = region.GetTexture and region:GetTexture()
            if tex then
                region:SetTexture(nil)
                region:Hide()
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CVAR_UPDATE")

frame:SetScript("OnEvent", function(self, event, cvar)
    if event == "PLAYER_LOGIN" then
        CastBar:Apply()

        -- these are to make sure the text gets moved back into the cast bar after edit mode
        hooksecurefunc(PlayerCastingBarFrame, "ApplySystemAnchor", function()
            CastBar:Apply()
        end)
    -- make sure edits get re-applied after edit mode deactivated
    elseif event == "CVAR_UPDATE" and cvar == "editMode" then
        -- Edit Mode toggled on/off
        C_Timer.After(0.1, function()
            CastBar:Apply()
        end)
    end
end)

AptoUI.CastBar.Config = {
    -- do not reduce width past 225 if using default textures,
    -- this is the min size of the textures Blizzard uses
    -- use the scale option instead and increase the height proportionally
    -- if you want a less-wide cast bar
    width  = 350,
    height = 40,
    alpha  = 0.5,
    textInside = true,
    scale = 0.5
}

function CustomiseCastBar()
    local config = AptoUI.CastBar.Config
    local bar = PlayerCastingBarFrame
    if not bar then return end

    bar:SetWidth(config.width)
    bar:SetHeight(config.height)
    bar:SetAlpha(config.alpha)
    bar:SetScale(config.scale)

    local text = bar.Text or bar.TextLabel or bar.TextString
    if text then
        text:ClearAllPoints()

        if config.textInside then
            text:SetPoint("CENTER", bar, "CENTER", 0, 0)
            text:SetJustifyH("CENTER")
            text:SetJustifyV("MIDDLE")
        else
            text:SetPoint("TOP", bar, "BOTTOM", 0, -2)
        end
        text:SetScale(1 / config.scale)
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
        CustomiseCastBar()

        -- this is to make sure the text gets moved back into the cast bar after edit mode
        hooksecurefunc(PlayerCastingBarFrame, "ApplySystemAnchor", function()
            CustomiseCastBar()
        end)
    -- make sure edits get re-applied after edit mode deactivated
    elseif event == "CVAR_UPDATE" and cvar == "editMode" then
        -- Edit Mode toggled on/off
        C_Timer.After(0.1, function()
            CustomiseCastBar()
        end)
    end
end)

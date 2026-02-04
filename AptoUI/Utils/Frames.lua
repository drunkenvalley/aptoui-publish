function AptoUI.Utils.isUpdateEvent(eventList, eventFired)
    return eventList[eventFired] == true
end

function AptoUI.Utils.DestroyHUDFrame(frame)
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
        AptoUI.Utils.DestroyHUDFrame(child)
    end
    frame:Hide()
end

function AptoUI.Utils.CreateHUDFrame(frameName)
    local frame = CreateFrame("Frame", frameName, UIParent)
    frame:SetPoint("CENTER")
    frame:SetSize(1, 1)
    return frame
end

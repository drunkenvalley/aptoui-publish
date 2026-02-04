local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        playerLoggedIn = true
        AptoUI.Reminders.CreateBuffReminders()
    end
end);

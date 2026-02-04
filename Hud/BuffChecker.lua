local addonName, AptoHUD = ...

local buffCheckEvents = {
    UNIT_AURA = true,
    UPDATE_SHAPESHIFT_FORM = true,
}
local combatEvent = "PLAYER_REGEN_DISABLED"
local outOfCombatEvent = "PLAYER_REGEN_ENABLED"

local function CreateBuffReminder(parent, classBuffType, reminderIndex)
    local reminder = CreateFrame("Frame", classBuffType, parent)
    local ySize = 30
    reminder:SetSize(150, ySize)
    reminder:SetPoint("CENTER", parent, "CENTER", 0, reminderIndex * ySize)
    reminder.text = reminder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    reminder.text:SetPoint("CENTER")
    reminder.text:SetText("Missing buff: ", classBuffType)
    reminder:Hide()
    return reminder
end

local function ShowBuffReminder(frame, isMissing)
    if isMissing then
        frame:Show()
    else
        frame:Hide()
    end
end

function AptoHUD.HUD.CreateBuffReminders()
    local class, _ = AptoHUD.Utils.GetClassAndSpec()
    local classBuffs = AptoHUD.Utils.ClassBuffLookup[class]

    local buffReminderFrame = AptoHUD.Utils.CreateHUDFrame(class)

    local reminders = {}
    local reminderIndex = 0
    for classBuffType, _ in pairs(classBuffs) do
        local reminderFrame = CreateBuffReminder(buffReminderFrame, classBuffType, reminderIndex)
        reminders[classBuffType] = reminderFrame
        reminderFrame:RegisterEvent("PLAYER_LOGIN")
        reminderFrame:RegisterEvent(combatEvent)
        reminderFrame:RegisterEvent(outOfCombatEvent)
        reminderFrame:SetScript("OnEvent", function(self, event, unit)
            if event == combatEvent then
                print("in combat")
                for eventName, _ in pairs(hudPowerEvents) do
                    reminderFrame:UnRegisterEvent(eventName)
                end
            elseif event == outOfCombatEvent then
                print("out of combat")
                for eventName, _ in pairs(hudPowerEvents) do
                    reminderFrame:RegisterEvent(eventName)
                end
            end
            if AptoHUD.Utils.isUpdateEvent(AptoHUD.HUD.BuffCheckEvents) then
                print("buff checking event", classBuffType)
                local isMissing = AptoHUD.Utils.HasMissingClassBuff(class)[classBuffType] or false
                ShowBuffReminder(reminderFrame, isMissing)
            end
        end)
        reminderIndex = reminderIndex + 1
    end
    return reminders
end

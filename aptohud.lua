-- saved variables must be global not local
AptoHUDDB = AptoHUDDB or {};

local player_hppercent = UnitHealthPercent("player", false, CurveConstants.ScaleTo100);
local target_hppercent = UnitHealthPercent("target", false, CurveConstants.ScaleTo100);

local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN");

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        print("AptoHUD loaded");

        -- Save player name
        AptoHUDDB.playerName = UnitName("player");
        print("Hello,", AptoHUDDB.playerName);
    end
end);

SLASH_APTOHUD1 = "/aptohud";
SlashCmdList["APTOHUD"] = function()
    print("AptoHUD: Your HP [", player_hppercent, "], Target HP [", target_hppercent, "]");
end;

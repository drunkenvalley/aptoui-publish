local addonName, ns = ...

-- saved variables  must be a global table not local so other modules can access
AptoHUDDB = AptoHUDDB or {};

-- AptoUI must be a global table not local so other modules can access
AptoUI = AptoUI or {}   -- global namespace
AptoUI.Utils = AptoUI.Utils or {}
AptoUI.CastBar = AptoUI.CastBar or {}
AptoUI.Reminders = AptoUI.Reminders or {}
AptoUI.HUD = AptoUI.HUD or {}
AptoUI.Resources = AptoUI.Resources or {}
AptoUI.WOW = AptoUI.WOW or {}

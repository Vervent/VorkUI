---
--- Created by Vorka for Vorkui
---
--- In the profile we want to find
---     - Theme in use for default data
---     - User tweak from theme to final UI
---
--- Process
---     - Load profile
---     - adapt themes
---     - adapt usertweak
---

local AddOn = ...
local V, C = select(2, ...):unpack()

local Profiles = CreateFrame("Frame")
local Install = V.Install

local db

local defaults = {
    profile = {}
}

local function ApplyTheme(db)

    if db.Profile then
        for k,v in pairs (db.Profile) do
            C[k] = v
        end
    end

end

--[[
    This function initialize profile if not existing or get saved var from AceDB
--]]
local function InitializeProfile(self)

    Install:RegisterOptions()

    if not VorkuiDB then
        VorkuiDB = { }
        -- TODO Launch INSTALL SYSTEM
        Install:Launch(VorkuiDB)
    else
        -- TODO PUSH CHANGES IN RIGHT THEMES BEFORE UF GENERATION
        ApplyTheme(VorkuiDB)

    end

end

function Profiles:OnEvent(event, addonName)
    if event == "ADDON_LOADED" and addonName == AddOn then
        InitializeProfile( self )
    end
end


Profiles:RegisterEvent("ADDON_LOADED")
Profiles:SetScript('OnEvent', Profiles.OnEvent)

V.Profiles = Profiles
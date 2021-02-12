local V  = select(2, ...):unpack()

local Themes = V.Themes
local Profiles = V.Profiles

if not Themes["Default"] then
    Themes["Default"] = {}
end

Themes["Default"].RegisterModules = function(partyLayout, raidLayout)
    Themes["Default"].SetPlayerProfile()
    Themes["Default"].SetPetProfile()
    Themes["Default"].SetTargetProfile()
    Themes["Default"].SetTargetTargetProfile()
    Themes["Default"].SetFocusProfile()
    Themes["Default"].SetFocusTargetProfile()
    Themes["Default"].SetPartyProfile(partyLayout or 'Expanded')
    Themes["Default"].SetRaidProfile(raidLayout or 'Compact')

    Profiles:RegisterOption('Theme', nil, nil, nil, 'Name', 'Default')

    Profiles:UpdateDB()
end

Themes["Default"].ChangePartyLayout = function(newLayout)
    Profiles:WipeInDB({'UnitFrames', 'PartyLayout'})
    Themes["Default"].SetPartyProfile(newLayout)
    Profiles:UpdateDB()
end

Themes["Default"].ChangeRaidLayout = function(newLayout)
    Profiles:WipeInDB({'UnitFrames', 'RaidLayout'})
    Themes["Default"].SetRaidProfile(newLayout)
    Profiles:UpdateDB()
end
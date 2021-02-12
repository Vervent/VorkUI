local V  = select(2, ...):unpack()

local Themes = V.Themes
local Profiles = V.Profiles

if not Themes["Default"] then
    Themes["Default"] = {}
end

Themes["Default"].RegisterModules = function(layout)
    Themes["Default"].SetPlayerProfile()
    Themes["Default"].SetPetProfile()
    Themes["Default"].SetTargetProfile()
    Themes["Default"].SetTargetTargetProfile()
    Themes["Default"].SetFocusProfile()
    Themes["Default"].SetFocusTargetProfile()
    Themes["Default"].SetPartyProfile(layout or 'Expanded')
    Themes["Default"].SetRaidProfile(layout or 'Compact')

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
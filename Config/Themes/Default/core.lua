local V  = select(2, ...):unpack()

local Themes = V.Themes

if not Themes["Default"] then
    Themes["Default"] = {}
end

Themes["Default"].RegisterModules = function(layout)
    print ("REGISTER THEMES MODULES")
    Themes["Default"].SetPlayerProfile()
    Themes["Default"].SetPetProfile()
    Themes["Default"].SetTargetProfile()
    Themes["Default"].SetTargetTargetProfile()
    Themes["Default"].SetFocusProfile()
    Themes["Default"].SetFocusTargetProfile()
    Themes["Default"].SetPartyProfile(layout or 'Expanded')
    Themes["Default"].SetRaidProfile(layout or 'Compact')
    V.Profiles:UpdateDB()
end

Themes["Default"].ChangePartyLayout = function(newLayout)
    V.Profiles:WipeInDB({'UnitFrames', 'PartyLayout'})
    Themes["Default"].SetPartyProfile(newLayout)
    V.Profiles:UpdateDB()
end

Themes["Default"].ChangeRaidLayout = function(newLayout)
    V.Profiles:WipeInDB({'UnitFrames', 'RaidLayout'})
    Themes["Default"].SetRaidProfile(newLayout)
    V.Profiles:UpdateDB()
end
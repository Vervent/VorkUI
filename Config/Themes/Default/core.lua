local V  = select(2, ...):unpack()

local Themes = V.Themes

if not Themes["Default"] then
    Themes["Default"] = {}
end

Themes["Default"].RegisterModules = function()
    print ("REGISTER THEMES MODULES")
    Themes["Default"].SetPlayerProfile()
end
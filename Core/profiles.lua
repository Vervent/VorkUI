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

local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()

local LibGUI = Plugin.LibGUI
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0")

local Profiles = CreateFrame("Frame")
local Install = V.Install

local isReady = false

local db = {}

local defaults = {
    profile = {}
}

local registry = {}

local function ApplyTheme()

    if db.Profile then
        for k, v in pairs(db.Profile) do
            C[k] = v
        end
    end

    if LibGUI then
        --Install.ConfigUI = LibGUI:NewContainer('frame',
        --        UIParent,
        --        'VorkuiConfig',
        --        { 500, 500 },
        --        { "CENTER" },
        --        'BaseBasicFrameTemplate'
        --)
        --
        --local dropdownData = {
        --    { text = "option1" },
        --    { text = "option2" },
        --    { text = "option3" },
        --    { text = "option4" },
        --    { text = "option5" },
        --    { text = "option6",
        --      menuList = {
        --          { text = "option6 suboption" },
        --      }
        --    },
        --    {
        --        text = "option7",
        --        menuList = {
        --            {
        --                text = "option7 suboption",
        --                menuList = {
        --                    {
        --                        text = "option7 suboption nested 2",
        --                        menuList = {
        --                            {
        --                                text = "option7 suboption nested 3",
        --                                menuList = {
        --                                    {
        --                                        text = "option7 suboption nested 4",
        --                                    },
        --                                }
        --                            },
        --                        }
        --                    },
        --                }
        --            },
        --        }
        --    },
        --}
        --
        --local child1 = LibGUI:NewContainer('tabframe', Install.ConfigUI, "VorkuiTabFrame", { 450, 450 }, { "TOPLEFT", 2, -10 })
        --for tabIdx = 1, 15 do
        --    local _, page = child1:AddEmptyPage('tab' .. tabIdx, { 100, 25 })
        --
        --    if tabIdx == 2 then
        --        local scroll = LibGUI:NewContainer('scrolluniformlist', page, nil, { 100, 300 }, { "TOPLEFT" })
        --        for i = 1, 10 do
        --            scroll:AddChild('widget', 'label', { 200, 20 },
        --                    {
        --                        'OVERLAY',
        --                        'GameFontNormal',
        --                        "Bonjour Vorkui Config " .. i
        --                    }
        --            )
        --        end
        --        scroll:CreateChilds()
        --    elseif tabIdx == 3 then
        --        local scroll = LibGUI:NewContainer('scrolluniformlist', page, nil, { 100, 300 }, { "TOPLEFT" })
        --        for i = 1, 10 do
        --            scroll:AddChild('widget', 'editbox', { 180, 20 },
        --                    {
        --                        i,
        --                        function(self)
        --                            print(self.text)
        --                        end
        --                    },
        --                    'InputBoxTemplate'
        --            )
        --        end
        --        scroll:CreateChilds()
        --    else
        --        local item
        --        local val
        --        for i = 1, 5 do
        --            val = math.random(0, 100)
        --            if val > 66 then
        --                item = child1:AddWidgetToPage(page, 'button', nil, { "TOPLEFT", 2, -2 - i * 25 }, { 200, 25 }, 'UIPanelButtonTemplate')
        --                item:ChangeText("page" .. tabIdx .. "button" .. i)
        --            elseif val > 33 then
        --                item = child1:AddWidgetToPage(page, 'dropdownmenu', 'VorkuiMenu', { "TOPLEFT", 2, -2 - i * 25 }, { 200, 0 }, dropdownData)
        --            else
        --                item = child1:AddWidgetToPage(page, 'label', nil, { "TOPLEFT", 2, -2 - i * 25 }, { 200, 25 }, 'OVERLAY', 'GameFontNormal')
        --                item:ChangeText("page" .. tabIdx .. "label" .. i)
        --            end
        --        end
        --    end
        --end


    end

end

--[[
    This function initialize profile if not existing or get saved var from AceDB
--]]
local function InitializeProfile(self)

    if not VorkuiDB then
        VorkuiDB = { }
        -- TODO Launch INSTALL SYSTEM
        --Install:Launch(VorkuiDB)
    else
        db = VorkuiDB
        isReady = true
        -- TODO PUSH CHANGES IN RIGHT THEMES BEFORE UF GENERATION
        ApplyTheme(VorkuiDB)

    end

    LibGUI:RegisterProfile(self)

end

local function GetOptionPath(option)
    local path = db.Profile
    if type(option) == 'table' then
        for i=1, #option-1 do
            path = path[option[i]]
        end
        return path, option[#option]
    else
        return path, option
    end
end

function Profiles:IsReady()
    return isReady
end

function Profiles:GetValue(optionName)
    --local val = db.Profile
    --if type(optionName) == 'table' then
    --    for i=1, #optionName do
    --        val = val[optionName[i]]
    --    end
    --    return val or nil
    --else
    --    return val[optionName] or nil
    --end

    local path, opt = GetOptionPath(optionName)
    return path[opt]

    --return db.Profile[optionName] or nil
end

function Profiles:UpdateOption(optionName, value)

    local path, opt = GetOptionPath(optionName)
    if path[opt] ~= nil then
        print ("|cFF10FF10Update|r", optionName, value)
        path[opt] = value
    else
        print ("|cFFFF1010ERROR|r", optionName, value, opt)
    end

    --if db.Profile[optionName] then
    --    print ("|cFF10FF10Update|r", optionName, value)
    --    db.Profile[optionName] = value
    --else
    --    print ("|cFFFF1010ERROR|r", optionName, value)
    --end
end

function Profiles:UpdateDB()
    VorkuiDB.Profile = defaults.profile
end

function Profiles:OnEvent(event, addonName)
    if event == "ADDON_LOADED" and addonName == AddOn then
        InitializeProfile(self)
    end
end

function Profiles:RegisterModule(db, name)
    if db[name] then
        return
    end

    db[name] = {
        ["Enable"] = false,
    }
    --registry[name] = {}
    --tinsert(registry[name], { ["Enable"] = false, } )
end

function Profiles:RegisterSubModule(db, moduleName, name)
    if db[moduleName] and db[moduleName][name] then
        return
    end

    if not db[moduleName] then
        self:RegisterModule(db, moduleName)
    end

    db[moduleName][name] = {
        ["Enable"] = false,
    }
    --registry[moduleName][name] = {}
    --tinsert(registry[moduleName][name], { ["Enable"] = false, } )
end

function Profiles:RegisterOption(module, submodule, object, component, optionName, ...)
    local sizeArg = select('#', ...)

    if sizeArg == 0 then
        return
    end

    local debug = ''
    local tab

    if submodule then
        self:RegisterSubModule(defaults.profile, module, submodule)
        tab = defaults.profile[module][submodule]
        debug = tostring(module)..'\\'..tostring(submodule)..'\\'
    elseif module then
        self:RegisterModule(defaults.profile, module)
        tab = defaults.profile[module]
        debug = tostring(module)..'\\'
    end

    if object then
        if not tab[object] then
            tab[object] = {}
        end
        tab = tab[object]
        debug = debug..tostring(object)..'\\'
    end

    if component then
        if not tab[component] then
            tab[component] = {}
        end
        tab = tab[component]
        debug = debug..tostring(component)..'\\'
    end
    --print("|cFFFFDD00".. debug.."|r", ...)

    local optionSize --manage manually the size instead of iterative call to #
    local va_arg
    if optionName ~= nil then
        if sizeArg == 1 then
            tab[optionName] = ...
            return
        elseif not tab[optionName] then
            tab[optionName] = {}
            optionSize = 0
        elseif type(tab[optionName]) ~= 'table' then
            tab[optionName] = { tab[optionName] }
            optionSize = 1
        else
            optionSize = #tab[optionName]
        end

        for i=1, sizeArg do
            va_arg = select(i, ...)
            tab[optionName][optionSize + 1] = va_arg
            optionSize = optionSize + 1
        end
    else
        if sizeArg == 1 then
            tab = ...
        else
            optionSize = #tab
            tinsert(tab, { ... })
        end
    end

end

function Profiles:PrintProfile()

    print ("|cFF00AFFF Print Profile|r")

    for moduleName, moduleTable in pairs(defaults.profile) do
        for internName, internTable in pairs(moduleTable) do
            if type(internTable) == 'table' then
                for fieldName, field in pairs(internTable) do
                    if type(field) == 'table' then
                        print (moduleName, internName, fieldName, unpack(field))
                    else
                        print (moduleName, internName, fieldName, field)
                    end

                end
            else
                print (moduleName, internName, internTable)
            end
        end
    end
end

Profiles:RegisterEvent("ADDON_LOADED")
Profiles:SetScript('OnEvent', Profiles.OnEvent)

V.Profiles = Profiles
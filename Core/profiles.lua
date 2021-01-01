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
    VorkuiDB.tmp = {}
    VorkuiDB.tmp = registry

    VorkuiDB.tmp2 = self:ShallowCopyTableRecursivelyIgnoring(registry, 1, 10, "type")
end

function Profiles:OnEvent(event, addonName)
    if event == "ADDON_LOADED" and addonName == AddOn then
        InitializeProfile(self)
    end
end

function Profiles:RegisterModule(name)
    if registry[name] then
        return
    end
    registry[name] = {
        ["Enable"] = false,
    }
    --registry[name] = {}
    --tinsert(registry[name], { ["Enable"] = false, } )
end

function Profiles:RegisterSubModule(moduleName, name)
    if registry[moduleName] and registry[moduleName][name] then
        return
    end

    if not registry[moduleName] then
        self:RegisterModule(moduleName)
    end

    registry[moduleName][name] = {
        ["Enable"] = false,
    }
    --registry[moduleName][name] = {}
    --tinsert(registry[moduleName][name], { ["Enable"] = false, } )
end

function Profiles:RegisterOption(module, submodule, object, component, typeOption, optionName, ...)

    if typeOption == nil or optionName == nil then
        return
    end

    print ("|cFF00AFFF Register Option|r")

    local field = {
        ['type'] = typeOption,
        [optionName] = ...,
    }

    local debug = ''
    local tab

    if submodule then
        self:RegisterSubModule(module, submodule)
        tab = registry[module][submodule]
        debug = tostring(module)..'\\'..tostring(submodule)..'\\'
    elseif module then
        self:RegisterModule(module)
        tab = registry[module]
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
    print("|cFFFFDD00".. debug.."|r", unpack(field))
    --tinsert(tab, field)

    if not tab[optionName] then
        tab[optionName] = {}
    end

    tab[optionName][#tab[optionName]+1] = {
        ['type'] = typeOption,
        ...
    }

    --self:RegisterProfileOption(module, submodule, object, optionName, defaultValue)
end

function Profiles:RegisterProfileOption(module, submodule, object, optionName, defaultValue)
    if not defaults.profile[module] then
        defaults.profile[module] =  {}
    end

    print ("|cFF00AFFF Register Profile Option|r")

    local debug = ''
    local tab

    if submodule then
        if not defaults.profile[module][submodule] then
            defaults.profile[module][submodule] = {}
        end
        tab = defaults.profile[module][submodule]
        debug = tostring(module)..'\\'..tostring(submodule)..'\\'
    else
        tab = defaults.profile[module]
        debug = tostring(module)..'\\'
    end

    if object and not tab[object] then
        tab[object] = {}
        tab = tab[object]
        debug = debug..tostring(object)..'\\'
    end

    print("|cFFFFDD00".. debug.."|r", optionName, defaultValue)

    if tab[optionName] then
        if type(tab[optionName]) == 'table' then
            tab[optionName][#tab[optionName]+1] = defaultValue
        else --if not table we need to push a table and insert old field then new field
            local field = tab[optionName]
            tab[optionName] = {
                field, defaultValue
            }
        end

    else
        tab[optionName] = defaultValue
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
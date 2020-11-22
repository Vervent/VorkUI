--[[
    This widget is a classic button

    Widget Data :
    .type as internal kind of frame
    .text

    Widget Methods :
    Update (self, dataTable)
        dataTable as table to update internal system
            text
            event handler
            texture
            font
    ChangeText (self, text)
        text as new text to show
    ChangeFont (self, normalFont, disabledFont, hightlightFont)
        font as table. Can be an existing FontObject or new Font
    ChangeFontColor (self, color)
        color as colortable
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {

    --TODO UPDATE THIS FUNC FOR MORE DATA
    Update = function(self, dataTable)

    end,
}

local function enable(self)
    if self.type ~= 'dropdownmenu' then
        return
    end

    for e, f in pairs(self.Scripts) do
        print(e, f)
    end
end

local function disable(self)
    if self.type ~= 'dropdownmenu' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function()
        end)
    end

end

local function setValue(button, arg1, arg2, checked)

    if checked then
        print(button:GetText())
    end

    local dropdown = button:GetParent().dropdown
    dropdown.value = button:GetText()
    UIDropDownMenu_SetSelectedValue(dropdown, button:GetText(), true)
    CloseDropDownMenus()
end

local function initialize(self, level, menuList)
    if (level == nil) then
        return
    end

    local info = UIDropDownMenu_CreateInfo()

    --local data = {
    --    "option1",
    --    "option2",
    --    "option3",
    --    "option4",
    --    "option5",
    --}
    --
    --for _,v in ipairs(data) do
    --    info.text = v
    --    info.checked = self.value == v
    --    info.func = setValue
    --    UIDropDownMenu_AddButton(info)
    --end

    --local data = {
    --    { text = "option1" },
    --    { text = "option2" },
    --    { text = "option3" },
    --    { text = "option4" },
    --    { text = "option5" },
    --    { text = "option6",
    --      menuList = {
    --          text = "option6 suboption",
    --      }
    --    },
    --}



    local data = menuList or self.Data

    for i, v in ipairs(data) do

        info.text = v.text
        if v.menuList == nil then
            info.checked = self.value == v
            info.arg1 = info
            info.hasArrow = false
            info.menuList = nil
            info.notCheckable = false
            info.func = setValue
        else
            info.notCheckable = true
            info.hasArrow = true
            info.menuList = v.menuList
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

local function create(parent, name, point, size, data)
    local menu = CreateFrame('Frame', name or "DropDown", parent, 'UIDropDownMenuTemplate')

    menu:SetScript("OnShow", enable)
    menu:SetScript("OnHide", disable)
    menu.Scripts = {}
    menu.Data = data

    if point then
        menu:SetPoint(unpack(point))
    end
    if size then
        UIDropDownMenu_SetWidth(menu, size[1])
    end

    print(menu:GetName())

    menu.value = "Choose option"

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(menu, { __index = setmetatable(Methods, getmetatable(menu)) })

    UIDropDownMenu_Initialize(menu, initialize)
    UIDropDownMenu_SetText(menu, menu.value)

    return menu
end

local function bindScript(self, event, fct)
    if self.type ~= 'dropdownmenu' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterWidget('dropdownmenu', create, enable, disable)
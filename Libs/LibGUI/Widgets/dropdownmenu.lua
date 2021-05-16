--[[
    This widget is a dropdownmenu

    Widget Data :
    .type as internal kind of frame
    .Data as menu descriptor

    Widget Methods :
    AddItem (self, data)
        data as entry of the menu
    AddNestedItem (self, parentKey, data)
        parentKey as table to iterate
            {
                level of nested add,
                index,
                menuList = {
                    index,
                    menuList = {...}
                }
            }
        data as entry of the menu
    RemoveItem (self,index)
        remove Data from index
    RemoveNestedItem (self, parentKey, index)
        parentKey as table to iterate
            {
                level of nested add,
                index,
                menuList = {
                    index,
                    menuList = {...}
                }
            }
        index of the nested item to remove
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {

    AddItem = function(self, data)
        if data then
            tinsert(self.Data, data)
        end
    end,

    AddNestedItem = function(self, parentKey, data)

        if parentKey == nil then
            return
        end

        --iterate through self.Data to find good parent
        local level = 1
        local iterator = parentKey
        local table = self.Data
        while level < parentKey.level do
            if table[iterator.index] then
                table = self.Data[interator.index]
                iterator = iterator.menuList
                if iterator == nil then
                    return
                end
                level = level + 1
            end
        end

        if table == nil then
            return
        else
            tinsert(table, data)
        end
    end,

    FindIndex = function(self, key)
        if key == nil then
            return -1
        end

        for i, v in ipairs(self.Data) do
            if v.text == tostring(key) then
                return i
            end
        end

        return -1
    end,

    RemoveItemByKey = function(self, key)
        self:RemoveItem( self:FindIndex(key) )
    end,

    RemoveItem = function (self, index)
        if index > 0 and index < #self.Data then
            tremove(self.Data, index)
        end
    end,

    RemoveNestedItem = function(self, parentKey, index)

        if parentKey == nil then
            return
        end

        --iterate through self.Data to find good parent
        local level = 1
        local iterator = parentKey
        local table = self.Data
        while level < parentKey.level do
            if table[iterator.index] then
                table = self.Data[iterator.index]
                iterator = iterator.menuList
                if iterator == nil then
                    return
                end
                level = level + 1
            end
        end

        if table == nil then
            return
        else
            tremove(table, index)
        end
    end,

    Update = function(self, dataTable, value)
        self.Data = dataTable
        if value then
            self.value = value
            UIDropDownMenu_SetSelectedValue(self, self.value, true)
            UIDropDownMenu_SetText(self, self.value)
        end
    end,

    CleanValue = function(self)
        self.value = ''
        UIDropDownMenu_SetSelectedValue(self, self.value, true)
        UIDropDownMenu_SetText(self, self.value)
        self.Subject:Notify({ 'OnUpdate', self,  self.value })
    end,

    GetValue = function (self)
        return self.selectedValue
    end,

    Enable = function(self)
        self.Button:Enable()
    end,

    Disable = function(self)
        self.Button:Disable()
    end,

    RegisterObserver = function(self, entity)
        self.Subject:RegisterObserver(entity)
    end,

    UnregisterObserver = function(self, entity)
        self.Subject:UnregisterObserver(entity)
    end
}

local function enable(self)
    if self.type ~= 'dropdownmenu' then
        return
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

    local dropdown = button:GetParent().dropdown
    dropdown.value = button:GetText()

    dropdown.Subject:Notify({ 'OnUpdate', dropdown,  dropdown.value })

    UIDropDownMenu_SetSelectedValue(dropdown, dropdown.value, true)
    CloseDropDownMenus()
end

local function initialize(self, level, menuList)
    if (level == nil) then
        return
    end

    local info = UIDropDownMenu_CreateInfo()
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
    --menu.DBOption = dboption

    if point then
        menu:SetPoint(unpack(point))
    end
    if size then
        UIDropDownMenu_SetWidth(menu, size[1])
    end

    --menu.value = "Choose option"

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(menu, { __index = setmetatable(Methods, getmetatable(menu)) })

    UIDropDownMenu_Initialize(menu, initialize)
    UIDropDownMenu_SetText(menu, menu.value)

    local LibObserver = LibStub:GetLibrary("LibObserver")
    menu.Subject = LibObserver:CreateSubject()

    return menu
end

local function bindScript(self, event, fct)
    if self.type ~= 'dropdownmenu' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterWidget('dropdownmenu', create, enable, disable)
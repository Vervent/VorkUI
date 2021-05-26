local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Changelist = CreateFrame("Frame")
local LibDiff = LibStub:GetLibrary('LibDiff')

local borderSettings = Editor.border
local diffColor = {
    ['in'] = 'FF04E261',
    ['out'] = 'FFFF8300',--'FFD81E13',
    ['same'] = 'FFFFE31E',
}

local changeList = {
    ["System"] = {},
    ["Module"] = {},
    ["Component"] = {},
    ["SubComponent"] = {},
    ["Key"] = {},
    ["SubKey"] = {},
    ["OldValue"] = {},
    ["NewValue"] = {},
}

--[[
    INSPECTOR FRAME CONFIG
]]--
local hierarchy = {
    root = {
        type = 'frame',
        params = {
            parent = UIParent,
            name = 'VorkuiEditorChangelist',
            title = 'Vorkui Changelist',
            size = {800, 400},
            point = { 'BOTTOM' },
        },
        childs = {
        }
    }
}

local checkboxConfig = {
    ['type'] = 'checkbox',
    ['name'] = 'ConfirmCheckbox',
    ['data'] = {
        nil, --point
        {20, 20}, --size
        'UICheckButtonTemplate', --template
    }
}

local labelConfig = {
    ['type'] = 'label',
    ['name'] = 'NormalLabel',
    ['data'] = {
        nil, --point
        {100, 20}, --size
        'ARTWORK',
        'Game11Font'
    }
}

local propertyLabelConfig = {
    ['type'] = 'label',
    ['name'] = 'PropertyLabel',
    ['data'] = {
        nil, --point
        {100, 20}, --size
        'ARTWORK',
        'Game11Font'
    }
}

local diffLabelConfig = {
    ['type'] = 'label',
    ['name'] = 'DiffLabel',
    ['data'] = {
        nil, --point
        {310, 20}, --size
        'ARTWORK',
        'Game10Font_o1'
    }
}

local headerData = {
    {
        ['text'] = 'System',
        ['width'] = 100
    },
    {
        ['text'] = 'Module',
        ['width'] = 100
    },
    {
        ['text'] = 'Component',
        ['width'] = 100
    },
    {
        ['text'] = 'Properties',
        ['width'] = 100
    },
    {
        ['text'] = 'Value',
        ['width'] = 310
    },
    {
        ['text'] = 'Apply',
        ['width'] = 50
    },
}

local function createHeader(self)

    local header = LibGUI:NewContainer(
            'empty',
            self,
            'HeaderFrame',
            {760, 30},
            {
                { 'TOPLEFT', self, 'TOPLEFT', 0, -30 },
                { 'TOPRIGHT', self, 'TOPRIGHT', -30, -30 }
            }
    )
    local point = { 'LEFT', header, 'LEFT' }
    local item
    for i, v in ipairs(headerData) do
        item = LibGUI:NewWidget('label', header, 'SystemHeaderLabel', point, { v.width, 20 })
        point[2] = item
        point[3] = 'RIGHT'
        item:ChangeFont('GameFontNormal')
        item:ChangeText(v.text)
    end

    return header
end

local function createSheet(self)

    local sheet = LibGUI:NewContainer(
            'sheet',
            self,
            'ChangelistSheetFrame',
            nil,
            {
                { 'TOPLEFT', self, 'TOPLEFT'},
                { 'TOPRIGHT', self, 'TOPRIGHT'}
            }
    )
    --sheet.enableAllChilds = true
    sheet:SetSize(760, 0)
    sheet.attributeCount = 0

    --System, Module, Component, Properties, value, apply
    sheet:SetConfiguration(labelConfig, labelConfig, labelConfig, propertyLabelConfig, diffLabelConfig, checkboxConfig)
    sheet:SetColumnCount(6)
    sheet:AddRows(20)

    print (sheet:GetRowCount(), #sheet.Childs)

end

--[[
    CORE FUNCTION
]]--

function Changelist:CreateGUI()
    local root = hierarchy.root

    local frame = LibGUI:NewContainer( root.type,
            root.params.parent,
            root.params.name,
            root.params.size,
            root.params.point,
            'BasicFrameTemplate'
    )

    frame.Header = createHeader(frame)

    frame.Scroll = LibGUI:NewContainer( 'scrollframe',
            frame,
            root.params.name..'ScrollFrame',
            { 770, 0 },
            {
                {'TOPLEFT', frame.Header, 'BOTTOMLEFT', 4, 0 },
                {'TOPRIGHT', frame.Header, 'BOTTOMRIGHT' },
                { 'BOTTOM', frame, 'BOTTOM', 0, 4 }
            }
    )
    --frame.Scroll.enableAllChilds = false
    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

    createSheet(frame.Scroll.ScrollChild)

    self.UI = frame;
    self:Hide()
end

local function getRow(self)
    local scroll = self.UI.Scroll.ScrollChild
    local sheet = scroll.Childs[1]
    local attributeCount = sheet.attributeCount
    local rowCount = sheet:GetRowCount()

    if attributeCount < rowCount then
        sheet.attributeCount = sheet.attributeCount + 1
        return sheet:GetRow(attributeCount + 1)
    else
        --add row
        sheet.attributeCount = sheet.attributeCount + 1
        local row = sheet:AddRow()
        if LibObserver then
            row.Observer = LibObserver:CreateObserver()
            row.Observer.OnNotify = function (...)
                local event, item, value = unpack(...)
                if value == true then
                    row.Widgets[7].redo()
                else
                    row.Widgets[7]:undo()
                end
            end
        end
        scroll:ResizeScrollChild()
        return row
    end
end

local function findRow(self, system, module, component, key, subkey)
    local scroll = self.UI.Scroll.ScrollChild
    local sheet = scroll.Childs[1]
    local attributeCount = sheet.attributeCount
    local widgets
    local row
    local tab = { system, module, component, key, subkey }
    local result = true

    for i=1, attributeCount do
        row = sheet:GetRow(i)
        widgets = row.Widgets
        --widgets = sheet:GetWidgetsByRow(i)
        for idx = 1, 6 do
            result = result and (widgets[idx].text == tab[idx])
        end
        if result == true then
            return row
        else
            result = true
        end
    end

    return nil
end

local function stringify(t)
    local str = '{'

    for k, v in pairs(t) do
        if type(v) == 'table' then
            str = str..k..': '..stringify(v)..' , '
        else
            str = str..k..': '..v..' , '
        end
    end
    str = str..' }'
    return str
end

local function formatDiff(tokens, preserve_same)
    local diff_buffer = ""
    local token, status
    local separator = '->'
    for i, token_record in ipairs(tokens) do
        token = token_record[1]
        status = token_record[2]
        if status == "in" then
            diff_buffer = diff_buffer..'|c'..diffColor['in']..token..'|r'..separator
            separator = ''
        elseif status == "out" then
            diff_buffer = diff_buffer..'|c'..diffColor['out']..token..'|r'..separator
            separator = ''
        elseif preserve_same == true then
            diff_buffer = diff_buffer..'|c'..diffColor['same']..token..'|r'
        end
    end
    return diff_buffer
end

local function getDiff(oldvalue, newvalue, preserve_same)
    if type(oldvalue) == 'table' then
        local list = LibDiff:Diff(stringify(oldvalue), stringify(newvalue))
        return formatDiff(list, preserve_same)
    else
        local list = LibDiff:Diff(tostring(oldvalue), tostring(newvalue))
        return formatDiff(list, preserve_same)
    end
end

local function findRowIndex(system, module, component, subcomponent, key, subkey)
    --check if system exists then get range
    for i=1, #changeList['System'] do
        if changeList['System'][i] == system and changeList['Module'][i] == module and
        changeList['Component'][i] == component and changeList['SubComponent'][i] == subcomponent and
        changeList['Key'][i] == key and changeList['SubKey'][i] == subkey then
            return i
        end
    end

    return -1
end

function Changelist:Test(system, module, component, subcomponent, key, subkey, oldvalue, newvalue)

    local rowIndex = findRowIndex(system, module, component, subcomponent, key, subkey)
    if rowIndex > 0 then
        oldvalue = changeList['OldValue'][rowIndex] or oldvalue --retrieve originalValue
        local diff = getDiff(oldvalue, newvalue, true)

        changeList['NewValue'][rowIndex] = newvalue
        local scroll = self.UI.Scroll.ScrollChild
        local sheet = scroll.Childs[1]
        local row = sheet:GetRow(rowIndex)
        row.Widgets[5]:ChangeText(diff)
        row.Widgets[6]:SetChecked(true)
    else
        local diff = getDiff(oldvalue, newvalue)
        if diff == '' then
            return
        end

        tinsert(changeList['System'], system)
        tinsert(changeList['Module'], module)
        tinsert(changeList['Component'], component)
        tinsert(changeList['SubComponent'], subcomponent)
        tinsert(changeList['Key'], key)
        tinsert(changeList['SubKey'], subkey)
        tinsert(changeList['OldValue'], oldvalue)
        tinsert(changeList['NewValue'], newvalue)
        self:AddChange(system, module, component, subcomponent, key, diff)
    end
end

function Changelist:UpdateChange(system, module, component, key, subkey, value, ...)

    local row = findRow(self, system, module, component, key, subkey)

    if row ~= nil then
        row.Widgets[6]:ChangeText(tostring(value))
        row.Widgets[7]:SetChecked(true)
    else
        self:AddChange(system, module, component, key, subkey, value, ...)
    end
end

function Changelist:AddChange(system, module, component, key, subkey, value, ...)

    local row = getRow(self)
    local undo, redo = ...

    local property
    if key == nil then
        property = subkey or 'nil'
    else
        property = key
        if subkey ~= nil then
            property = property..'['..subkey..']'
        end
    end

    row.Widgets[1]:ChangeText(system)
    row.Widgets[2]:ChangeText(module)
    row.Widgets[3]:ChangeText(component)
    row.Widgets[4]:ChangeText(property)
    row.Widgets[5]:ChangeText(tostring(value))
    row.Widgets[6]:SetChecked(true)
    --row.Widgets[7].undo = undo or function()  end
    --row.Widgets[7].redo = redo or function()  end
end

function Changelist:Enable()
    local scroll = self.UI.Scroll
    local scrollChild = scroll.ScrollChild
    local sheet = scrollChild.Childs[1]

    for i, r in ipairs(sheet:GetRows()) do
        r:Show()
    end
    sheet:Show()
    scroll:ShowScrollChild()
    scroll:ResizeScrollChild()
    self.UI:Show()
end

function Changelist:Disable()
    self:Hide()
end

Changelist:SetScript('OnShow', Changelist.Enable)
Changelist:SetScript('OnHide', Changelist.Disable)

Editor.Changelist = Changelist
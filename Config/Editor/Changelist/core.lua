local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Changelist = CreateFrame("Frame")

local borderSettings = Editor.border

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
    ['name'] = 'Label',
    ['data'] = {
        nil, --point
        {100, 20}, --size
        'ARTWORK',
        'Game11Font'
    }
}

local bigLabelConfig = {
    ['type'] = 'label',
    ['name'] = 'Label',
    ['data'] = {
        nil, --point
        {200, 20}, --size
        'ARTWORK',
        'Game11Font'
    }
}

local function createSheet(self)

    local header = LibGUI:NewContainer(
            'empty',
            self,
            'HeaderFrame',
            {800, 30},
            {
                { 'TOPLEFT', self, 'TOPLEFT', 4, 0 },
                { 'TOPRIGHT', self, 'TOPRIGHT', -4, 0 }
            }
    )
    local headItem = LibGUI:NewWidget('label', header, 'SystemHeaderLabel', { 100, 20 }, { 'LEFT', header, 'LEFT', 4, 0 })
    headItem:ChangeText('System')
    headItem = LibGUI:NewWidget('label', header, 'ModuleHeaderLabel', { 100, 20 }, { 'LEFT', headItem, 'RIGHT' })
    headItem:ChangeText('Module')
    headItem = LibGUI:NewWidget('label', header, 'ComponentHeaderLabel', { 100, 20 }, { 'LEFT', headItem, 'RIGHT' })
    headItem:ChangeText('Component')
    headItem = LibGUI:NewWidget('label', header, 'KeyHeaderLabel', { 100, 20 }, { 'LEFT', headItem, 'RIGHT' })
    headItem:ChangeText('Key')
    headItem = LibGUI:NewWidget('label', header, 'SubkeyHeaderLabel', { 100, 20 }, { 'LEFT', headItem, 'RIGHT' })
    headItem:ChangeText('Subkey')
    headItem = LibGUI:NewWidget('label', header, 'ValueHeaderLabel', { 200, 20 }, { 'LEFT', headItem, 'RIGHT' })
    headItem:ChangeText('Value')
    headItem = LibGUI:NewWidget('label', header, 'SaveHeaderLabel', { 92, 20 }, { 'LEFT', headItem, 'RIGHT' })
    headItem:ChangeText('Undo/Redo')

    local sheet = LibGUI:NewContainer(
            'sheet',
            self,
            'SheetFrame',
            nil,
            {
                { 'TOPLEFT', self, 'TOPLEFT', 4, 0 },
                { 'TOPRIGHT', self, 'TOPRIGHT', -4, 0 }
            }
    )
    sheet.enableAllChilds = false
    sheet:SetSize(800, 0)
    sheet.attributeCount = 0

    --System, Module, Component, key, subkey, value, confirm
    sheet:SetConfiguration(labelConfig, labelConfig, labelConfig, labelConfig, labelConfig, bigLabelConfig, checkboxConfig)
    sheet:SetColumnCount(7)
    sheet:AddRows(5)
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

    frame.Scroll = LibGUI:NewContainer( 'scrollframe',
            frame,
            root.params.name..'ScrollFrame',
            {root.params.size[1] -20, 0}
    )
    frame.Scroll.enableAllChilds = false
    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

    self.UI = frame;

    createSheet(frame.Scroll)

    self:Hide()
end

local function getRow(self)
    local scroll = self.UI.Scroll
    local sheet = scroll.Childs[1]
    local attributeCount = sheet.attributeCount
    local rowCount = sheet:GetRowCount()

    if attributeCount < rowCount then
        sheet.attributeCount = sheet.attributeCount + 1
        return self:GetRow(attributeCount + 1)
    else
        --add row
        sheet.attributeCount = sheet.attributeCount + 1
        local row = self:AddRow()
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
    local scroll = self.UI.Scroll
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

    row.Widgets[1]:ChangeText(system)
    row.Widgets[2]:ChangeText(module)
    row.Widgets[3]:ChangeText(component)
    row.Widgets[4]:ChangeText(key or 'nil')
    row.Widgets[5]:ChangeText(subkey or 'nil')
    row.Widgets[6]:ChangeText(tostring(value))
    row.Widgets[7]:SetChecked(true)
    row.Widgets[7].undo = undo or function()  end
    row.Widgets[7].redo = redo or function()  end
end

function Changelist:Enable()
    self.UI:Show()
end

function Changelist:Disable()
    self:Hide()
end

Changelist:SetScript('OnShow', Changelist.Enable)
Changelist:SetScript('OnHide', Changelist.Disable)

Editor.Changelist = Changelist
local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI
local LibObserver = LibStub:GetLibrary("LibObserver")

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local attributes = Editor.attributes
local tChecker = Editor.TypeChecker

local buttonConfig = {
    ['type'] = 'button',
    ['name'] = 'RemoveButton',
    ['data'] = {
        nil, --point
        {20, 20}, --size
    }
}

local labelConfig = {
    ['type'] = 'label',
    ['name'] = 'AttributeLabel',
    ['data'] = {
        nil, --point
        {125, 20}, --size
        'ARTWORK',
        'Game11Font'
    }
}

local editboxConfig = {
    ['type'] = 'editbox',
    ['name'] = 'AttributeValueEdit',
    ['data'] = {
        nil, --point
        {210, 20}, --size
    }
}

local dropdownConfig = {
    ['type'] = 'dropdownmenu',
    ['name'] = 'AttributeValueMenu',
    ['data'] = {
        nil, --point
        {175, 20}, --size
    }
}

local checkboxConfig = {
    ['type'] = 'checkbox',
    ['name'] = 'AttributeValueCheck',
    ['data'] = {
        nil, --point
        {20, 20}, --size
        'UICheckButtonTemplate', --template
    }
}

local function initRow(self, valueType, key, value)

    local check = LibGUI:GetWidgetsByType(self, 'checkbox')[1]
    check.key = key
    check:RegisterObserver(self.Observer)
    local menu = LibGUI:GetWidgetsByType(self, 'dropdownmenu')[1]
    menu.key = key
    menu:RegisterObserver(self.Observer)
    local edit =  LibGUI:GetWidgetsByType(self, 'editbox')[1]
    edit.key = key
    edit:RegisterObserver(self.Observer)
    local button = LibGUI:GetWidgetsByType(self, 'button')[1]
    button.key = key
    button:RegisterObserver(self.Observer)
    local label = LibGUI:GetWidgetsByType(self, 'label')[1]

    label:ChangeText( key )
    label:Show()
    button:Show()
    if valueType == 'boolean' then
        --checkbox
        if value == '' then
            check:SetChecked( false )
        else
            check:SetChecked( value )
        end
        check:Show()
        menu:Hide()
        edit:Hide()
    elseif valueType == 'number' or valueType == 'string' then
        check:Hide()
        menu:Hide()
        edit:ChangeText( tostring(value) )
        --edit:SetNumeric(valueType == 'number')
        edit:Show()
    else
        check:Hide()
        edit:Hide()
        menu:Update( valueType, value )
        menu:Show()
    end
end

local function updateOption(event, item, value)
    local val
    if tChecker['number'](value) == true then
        val = tonumber(value)
    else
        val = value
    end
    Inspector:SubmitUpdateValue(nil, 'Attributes', item.key, nil, val)
end

local function addRow(self)
    local row = self:AddRow()

    if LibObserver then
        row.Observer = LibObserver:CreateObserver()
        row.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            updateOption(event, item, value)
        end
    end

    return row
end

local function addAttribute(self, event, item, value)
    --remove attribute from dropdownmenu
    local attributeDropdown = self.Widgets[2]
    attributeDropdown:RemoveItemByKey(value)

    --add new row
    local sheet = self.Childs[1]
    local attributeList = attributes[ self.systemName ]

    local attributeCount = sheet.attributeCount
    local rowCount = sheet:GetRowCount()
    local row
    if attributeCount == rowCount then
        row = addRow(sheet)
    else
        row = sheet:GetRow(attributeCount + 1)
    end

    attributeCount = attributeCount + 1

    --init Row
    initRow(row, attributeList[ value ], value, '')
    sheet:ShowRow( attributeCount )
    sheet.attributeCount = attributeCount

    local h = attributeCount * sheet:GetRowHeight()
    sheet:SetHeight( h )
    self.frameHeight = h + 46
    self:SetHeight(h + 46)
end

local function update(self, config, _, name)

    local attributeDropdown = self.Widgets[2]
    local sheet = self.Childs[1]

    --UPDATE grid content with attribute already set
    local rowCount = sheet:GetRowCount()
    local attributeCount = 0
    for _, _ in pairs(config) do
        attributeCount = attributeCount + 1
    end

    --UPDATE attributeDropdown with remaining attribute
    self.systemName = strlower( name )
    local systemName = strlower( name )
    local attributeList = attributes[ systemName ]
    local menu = {}
    for k, v in pairs(attributeList) do
        if config[ k ] == nil then
            tinsert( menu, { text = k } )
        end
    end
    if #menu == 0 then
        attributeDropdown:Disable()
    else
        attributeDropdown:Enable()
        attributeDropdown:Update( menu )
    end

    local indexRow = 1
    if rowCount < attributeCount then
        local diffCount = attributeCount - rowCount
        for i=1, diffCount do
            addRow(sheet)
        end
    end

    local row
    for k, v in pairs(config) do
        row = sheet:GetRow( indexRow )
        initRow(row, attributeList[k], k, v)
        sheet:ShowRow( indexRow )
        indexRow = indexRow + 1
    end

    sheet.attributeCount = attributeCount
    local height = (attributeCount) * sheet:GetRowHeight()
    sheet:SetHeight(height)
    self:SetHeight( 46 + height )
    self.frameHeight = 46 + height
end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName)

    local pt
    if point then
        pt = point
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -16 },
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -16 }
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'AttributesFrame',
            nil,
            pt
    )

    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            addAttribute(frame, event, item, value)
        end
    end

    local attributeLabel = LibGUI:NewWidget('label', frame, 'AttributeLabel', { 'TOPLEFT', 0, -8 }, { 150, 30 }, nil, nil)
    attributeLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Attribute available' } )

    local attributeDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'AttributeDropdown', { 'LEFT', attributeLabel, 'RIGHT' }, { 150, 25 }, nil, nil)
    --attributeDropdown:Update()
    attributeDropdown.key='AddAttribute'
    attributeDropdown:RegisterObserver(frame.Observer)

    frame:SetSize(300, 46)

    local sheet = LibGUI:NewContainer(
            'sheet',
            frame,
            'SheetFrame',
            nil,
            {
                { 'TOPLEFT', attributeLabel, 'BOTTOMLEFT' },
                { 'RIGHT', parentPoint or parent, 'RIGHT' }
            }
    )
    sheet.enableAllChilds = false
    sheet:SetSize(300, 0)
    sheet.attributeCount = 0

    sheet:SetConfiguration(buttonConfig, labelConfig, checkboxConfig, editboxConfig, dropdownConfig)
    sheet:SetColumnCount(3)
    for i = 1, 20 do
        addRow(sheet)
    end

    if hasBorder then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, 'NameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

local function clean(self)
    local attributeDropdown = self.Widgets[2]
    attributeDropdown:Update(nil)

    local sheet = self.Childs[1]
    local row
    sheet.attributeCount = 0
    for i=1, sheet:GetRowCount() do
        row = sheet:GetRow(i)
        if row then
            for _, v in ipairs (row.Widgets) do
                if v.type ~= 'label' then
                    v:UnregisterObserver(row.Observer)
                end
            end
        end
        sheet:HideRow(i)
    end
end

Inspector:RegisterComponentGUI('Attributes', gui, update, clean)
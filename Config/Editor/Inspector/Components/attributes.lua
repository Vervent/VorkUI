local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

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
        {175, 30}, --size
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

local function update(self, config, _, name)

    local attributeDropdown = self.Widgets[2]
    local sheet = self.Childs[1]

    --UPDATE grid content with attribute already set
    local rowCount = sheet:GetRowCount()
    local attributeCount = 0
    for _, _ in pairs(config) do
        attributeCount = attributeCount + 1
    end

    local height = (attributeCount+1) * 30
    sheet:SetHeight(height)
    self:SetHeight( 46 + height )
    self.frameHeight = 46 + height

    --UPDATE attributeDropdown with remaining attribute
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
        sheet:AddRows(attributeCount - rowCount) --add missing row
    end

    local row
    local label
    local button
    local check
    local menu
    local edit
    for k, v in pairs(config) do
        row = sheet:GetRow( indexRow )


        check = LibGUI:GetWidgetsByType(row, 'checkbox')[1]
        menu = LibGUI:GetWidgetsByType(row, 'dropdownmenu')[1]
        edit =  LibGUI:GetWidgetsByType(row, 'editbox')[1]
        button = LibGUI:GetWidgetsByType(row, 'button')[1]
        label = LibGUI:GetWidgetsByType(row, 'label')[1]

        label:ChangeText( k )
        label:Show()
        button:Show()
        if attributeList[k] == 'boolean' then
            --checkbox
            check:SetChecked( v )
            check:Show()
            menu:Hide()
            edit:Hide()
        elseif attributeList[k] == 'number' or attributeList[k] == 'string' then
            check:Hide()
            menu:Hide()
            edit:ChangeText( tostring(v) )
            edit:Show()
        else
            check:Hide()
            edit:Hide()
            menu:Update( attributeList[k], v )
            menu:Show()
        end
        sheet:ShowRow( indexRow )

        indexRow = indexRow + 1
    end

    sheet.attributeCount = attributeCount

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

    local attributeLabel = LibGUI:NewWidget('label', frame, 'AttributeLabel', { 'TOPLEFT', 0, -8 }, { 150, 30 }, nil, nil)
    attributeLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Attribute available' } )

    local attributeDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'AttributeDropdown', { 'LEFT', attributeLabel, 'RIGHT' }, { 150, 25 }, nil, nil)
    --attributeDropdown:Update()

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
    sheet:AddRows(20)

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
    sheet.attributeCount = 0
    for i=1, sheet:GetRowCount() do
        sheet:HideRow(i)
    end
end

Inspector:RegisterComponentGUI('Attributes', gui, update, clean)
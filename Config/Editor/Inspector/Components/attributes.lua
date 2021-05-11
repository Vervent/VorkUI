local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local attributes = Editor.attributes
local tChecker = Editor.TypeChecker

local function getDropdownData(system, key)

    if attributes[system] == nil then
        return nil
    end

    local table = {}

    for k, v in pairs(attributes[system]) do
        if k ~= key then
            tinsert(table, { text = k, checker = v })
        end
    end

    return table

end

local function update(self, config, _, name)
    local nbRow = self:GetRowCount()
    local attribCount = 0
    local indexRow = 1
    local menu = getDropdownData( strlower( name ) )

    if menu == nil then
        return
    end

    --get attributes Count
    for _, _ in pairs(menu) do
        attribCount = attribCount + 1
    end

    print ('UPDATE', nbRow, attribCount)
    if nbRow < attribCount then
        self:AddRows(attribCount - nbRow) --add missing row
    end

    local row
    for k, v in pairs(config) do
        row = self:GetRow( indexRow )
        row.Widgets[1]:Update( menu, k )
        row.Widgets[2]:ChangeText( tostring(v) )
        row:Show()
        indexRow = indexRow + 1
    end

    for i = indexRow, attribCount do
        row = self:GetRow( i )
        row.Widgets[1]:Update( menu )
        row.Widgets[2]:ChangeText( nil )
        row:Show()
    end

    for i = attribCount, nbRow do
        self:HideRow(i) --hide overflow rows
    end

    self:SetHeight(16 + self:GetRowHeight() * attribCount)

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
            'sheet',
            parent,
            baseName..'AttributesFrame',
            nil,
            pt
    )
    frame:SetSize(300, 16)

    local dropdown = {
        ['type'] = 'dropdownmenu',
        ['name'] = 'dropdown',
        ['data'] = {
            nil, --point
            {150, 30}, --size
        }
    }
    local editbox = {
        ['type'] = 'editbox',
        ['name'] = 'editbox',
        ['data'] = {
            nil, --point
            {150, 25}, --size
        }
    }

    frame:SetConfiguration(dropdown, editbox)
    --frame:AddRows(20)

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
    for i, row in pairs(self:GetRows()) do
        row.Widgets[1]:Update()
        row.Widgets[2]:ChangeText('')
    end
end

Inspector:RegisterComponentGUI('Attributes', gui, update, clean)
local _, Plugin = ...

local select = select
local pairs = pairs
local type = type

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local changeList = {}

local function enable(config)

end

local function GetChange()
    return changeList
end

local function disable(frame)
    changeList = {}

    frame:ClearContent()

end

local function addCheckbox(frame, index)
    local checkbox = LibGUI:NewWidget('checkbox', frame, 'CheckboxEnable'..index, { 'TOPLEFT', 2, -2 }, nil, 'UICheckButtonTemplate', nil)
    checkbox:ChangeFont( 'GameFontNormal' )

    return checkbox
end

local function update(self, config)
    local widgets = LibGUI:GetWidgetsByType(self, 'checkbox')
    local checkboxIdx = 1
    local checkboxCount = #widgets

    for k, v in pairs(config) do
        if checkboxIdx > checkboxCount then
            tinsert(widgets, addCheckbox(self, checkboxIdx))
            checkboxCount = checkboxCount + 1
        end

        if type(k) == 'string' then
            widgets[checkboxIdx]:Update( { k } )
        else
            widgets[checkboxIdx]:Update( { v } )
        end
        widgets[checkboxIdx]:SetChecked(v)
        widgets[checkboxIdx]:Show()
        checkboxIdx = checkboxIdx + 1
    end

    for cIdx = checkboxCount, checkboxIdx, -1 do
        widgets[cIdx]:Hide()
    end

    local height = self:UpdateWidgetsByTypeLayout( 'checkbox', 10, 0 )
    self.frameHeight = height
    self:SetHeight(height)

 end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, count)
    local width = parent:GetWidth()
    local height = 0

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
            baseName..'SubmodulesFrame',
            nil,
            pt
    )

    for i=1,count do
        addCheckbox(frame, i)
    end

    frame:SetWidth(width)
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

Inspector:RegisterComponentGUI('Submodules', gui, update)
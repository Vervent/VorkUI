local _, Plugin = ...

--caching global func
local select = select
local pairs = pairs

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local function addButton(frame, index)
    return LibGUI:NewWidget('button', frame, 'Button'..index, { 'TOPLEFT', 2, -2 }, nil, 'UIPanelButtonTemplate', nil)
end

local function update(self, config)
    local widgets = LibGUI:GetWidgetsByTypeWithFilter(self, 'button', 'NameLabel')

    local buttonCount = #widgets

    for i=1, #config do
        if i > buttonCount then
            tinsert(widgets, addButton(self, i))
        end

        widgets[i]:Update( {config[i], function() Inspector:InspectComponent(config[i])  end } )
        widgets[i]:UpdateSize()
        widgets[i]:Show()
    end

    for cIdx = buttonCount, #config +1, -1 do
        widgets[cIdx]:Hide()
    end

    local height = self:UpdateFloatLayoutOnWidgets( widgets, 10, 4 )
    self.frameHeight = height
    self:SetHeight(height)
end

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, count)
    local width = parent:GetWidth() - 12
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
            baseName..'ComponentBlockFrame',
            nil,
            pt
    )
    frame.enableAllWidgets = false

    for i=1,count do
        addButton(frame, i)
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

Inspector:RegisterComponentGUI('ComponentBlock', gui, update)
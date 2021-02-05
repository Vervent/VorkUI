local _, Plugin = ...

--caching global func
local select = select
local pairs = pairs

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)
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
            baseName..'ComponentListLabelFrame',
            nil,
            pt
    )

    local button = LibGUI:NewWidget('button', frame, baseName..'ComponentBlockFrameCheckbox'..0, { 'TOPLEFT', 2, -2 }, nil, 'UIPanelButtonTemplate', nil)
    button:Update( { 'General' }, function(self) Inspector:InspectComponent(self:GetText())  end )
    button:UpdateSize()

    for k, _ in pairs(config) do
        button = LibGUI:NewWidget('button', frame, baseName..'ComponentBlockFrameCheckbox'..k, { 'TOPLEFT', 2, -2 }, nil, 'UIPanelButtonTemplate', nil)
        button:Update( { k }, function(self) Inspector:InspectComponent(self:GetText())  end )
        button:UpdateSize()
    end

    frame:SetWidth(width)
    height = frame:UpdateWidgetsFloatLayout( 1, 10, 4 )
    frame:SetHeight(height)

    if hasBorder then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'ComponentBlockFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('ComponentBlock', gui)
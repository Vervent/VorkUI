local _, Plugin = ...
local select = select
local pairs = pairs

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)

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
    frame:SetHeight(150)

    local scrollFrame = LibGUI:NewContainer(
            'scrolluniformlist',
            frame,
            baseName..'ComponentListFrame',
            { 200, 125 },
            { 'TOP', 0, -15 }
    )

    scrollFrame:AddWidget(
            'widget',
            'button',
            {200, 25},
            { 'General', function(self) Inspector:InspectComponent(self:GetText())  end },
            'UIPanelButtonTemplate'
    )

    for k, v in pairs(config) do
        scrollFrame:AddWidget(
                'widget',
                'button',
                {200, 25},
                { k, function(self) Inspector:InspectComponent(self:GetText())  end },
                'UIPanelButtonTemplate'
        )
    end
    scrollFrame:CreateWidgets()

    if hasBorder then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'ComponentListFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('ComponentList', gui)
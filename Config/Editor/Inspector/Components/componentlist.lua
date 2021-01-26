local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function gui(baseName, parent, parentPoint, componentName, componentConfig)

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'ComponentListLabelFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )
    frame:SetHeight(150)
    local name = LibGUI:NewWidget('button', frame, baseName..'ComponentListFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

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

    for k, v in pairs(componentConfig) do
        scrollFrame:AddWidget(
                'widget',
                'button',
                {200, 25},
                { k, function(self) Inspector:InspectComponent(self:GetText())  end },
                'UIPanelButtonTemplate'
        )
    end
    scrollFrame:CreateWidgets()
    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('ComponentList', gui)
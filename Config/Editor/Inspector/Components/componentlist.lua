local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function gui(baseName, parent, parentPoint, componentName, componentConfig)
    local height = 0

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
    frame:SetHeight(225)
    local name = LibGUI:NewWidget('label', frame, baseName..'EnableFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:Update( { 'OVERLAY', nil, componentName or '' } )

    local scrollFrame = LibGUI:NewContainer(
            'scrolluniformlist',
            frame,
            baseName..'ComponentListFrame',
            { 200, 200 },
            { 'TOP', 0, -15 }
    )
    --local name = LibGUI:NewWidget('label', frame, baseName..'ComponentListNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 80, 30 }, nil, nil)
    --name:Update( { 'OVERLAY', nil, componentName or '' } )

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

    return frame
end

Inspector:RegisterComponentGUI('ComponentList', gui)
local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

--local function collapse(container)
--    for i=2, #container.Widgets do
--        container.Widgets[i]:Hide()
--    end
--end
--
--local function expand(container)
--    for i=2, #container.Widgets do
--        container.Widgets[i]:Show()
--    end
--end

local function gui(baseName, parent, parentPoint, componentName, componentConfig)
    local width = parent:GetWidth()
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

    local name = LibGUI:NewWidget('button', frame, baseName..'ComponentBlockFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local button
    button = LibGUI:NewWidget('button', frame, baseName..'ComponentBlockFrameCheckbox'..0, { 'TOPLEFT', 2, -2 }, nil, 'UIPanelButtonTemplate', nil)
    button:Update( { 'General' }, function(self) Inspector:InspectComponent(self:GetText())  end )
    button:UpdateSize()

    for k, _ in pairs(componentConfig) do
        button = LibGUI:NewWidget('button', frame, baseName..'ComponentBlockFrameCheckbox'..k, { 'TOPLEFT', 2, -2 }, nil, 'UIPanelButtonTemplate', nil)
        button:Update( { k }, function(self) Inspector:InspectComponent(self:GetText())  end )
        button:UpdateSize()
    end

    frame:SetWidth(width)
    height = frame:UpdateWidgetsFloatLayout( 2, 10, 4 )
    frame:SetHeight(height)
    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('ComponentBlock', gui)
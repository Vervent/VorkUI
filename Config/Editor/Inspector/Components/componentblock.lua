local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function collapse(container)
    for i=2, #container.Widgets do
        container.Widgets[i]:Hide()
    end
end

local function expand(container)
    for i=2, #container.Widgets do
        container.Widgets[i]:Show()
    end
end

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
    name.Text = name:CreateFontString()
    name.Text:SetAllPoints()
    name.Text:SetFontObject('Game11Font')
    name.Text:SetText(componentName or '')

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

    name:Update( { '', function(self)
        if self.isCollapsed then
            --expand
            frame:SetHeight(self.frameHeight)
            expand(frame)
            --self.Text:SetText('-')
            self.isCollapsed = false
        else
            frame:SetHeight(10)
            collapse(frame)
            --self.Text:SetText('+')
            self.isCollapsed = true
        end
    end} )
    name.frameHeight = frame:GetHeight()
    name.isCollapsed = false

    return frame
end

Inspector:RegisterComponentGUI('ComponentBlock', gui)
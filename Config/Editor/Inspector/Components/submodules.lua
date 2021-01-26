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

local function gui(baseName, parent, parentPoint, componentName, subModuleConfig)
    local width = parent:GetWidth()
    local height = 0

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'SubmodulesFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )
    local name = LibGUI:NewWidget('button', frame, baseName..'SubmodulesFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name.Text = name:CreateFontString()
    name.Text:SetAllPoints()
    name.Text:SetFontObject('Game11Font')
    name.Text:SetText(componentName or '')

    local checkbox
    for k, _ in pairs(subModuleConfig) do
        checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'SubmodulesFrameCheckbox'..k, { 'TOPLEFT', 2, -2 }, nil, 'UICheckButtonTemplate', nil)
        checkbox:Update( { k } )
    end

    frame:SetWidth(width)
    height = frame:UpdateWidgetsLayout( 2, 10, 0 )
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

Inspector:RegisterComponentGUI('Submodules', gui)
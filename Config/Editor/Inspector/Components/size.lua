local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local minSize = 0
local maxSize = 500

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

local function gui(baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'SizeFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )
    frame:SetHeight(50)

    local name = LibGUI:NewWidget('button', frame, baseName..'SizeFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name.Text = name:CreateFontString()
    name.Text:SetAllPoints()
    name.Text:SetFontObject('Game11Font')
    name.Text:SetText(componentName or '')

    local width = LibGUI:NewWidget('label', frame, baseName..'SizeFrameWidthLabel', { 'TOP', -60, 0 }, { 80, 30 }, nil, nil)
    width:Update( { 'OVERLAY', GameFontNormal,'Width' } )
    local widthEdit = LibGUI:NewWidget('editbox', frame, baseName..'SizeFrameWidthEditbox', { 'TOPLEFT', width, 'BOTTOMLEFT', 20, 10 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    widthEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    local height = LibGUI:NewWidget('label', frame, baseName..'SizeFrameHeightLabel', { 'TOP', 60, 0 }, { 80, 30 }, nil, nil)
    height:Update( { 'OVERLAY', GameFontNormal,'Height' } )
    local heightEdit = LibGUI:NewWidget('editbox', frame, baseName..'SizeFrameHeightEditbox', { 'TOPLEFT', height, 'BOTTOMLEFT', 20, 10 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    heightEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    if hasBorder == true then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

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

Inspector:RegisterComponentGUI('Size', gui)

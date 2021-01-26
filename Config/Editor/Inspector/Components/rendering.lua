local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function collapse(container)
    for i=2, #container.Childs do
        container.Childs[i]:Hide()
    end
end

local function expand(container)
    for i=2, #container.Childs do
        container.Childs[i]:Show()
    end
end

local function gui(baseName, parent, parentPoint, componentName, renderingConfig)
    local height = 0

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'RenderingFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )

    local name = LibGUI:NewWidget('button', frame, baseName..'RenderingFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name.Text = name:CreateFontString()
    name.Text:SetAllPoints()
    name.Text:SetFontObject('Game11Font')
    name.Text:SetText(componentName or '')

    local it = frame
    local hasBorder
    for i, t in ipairs(renderingConfig) do
        if i == 1 or i == #renderingConfig then
            hasBorder = false
        else
            hasBorder = true
        end
        it = Inspector:CreateComponentGUI('Texture', 'InspectorRenderingTexture', frame, it, nil, i==1, hasBorder)
        height = height + it:GetHeight()
    end

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

Inspector:RegisterComponentGUI('Rendering', gui)
local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local fonts = {
    { text = 'Name Font' },
    { text = 'Normal Font' },
    { text = 'Duration Font' },
    { text = 'Stack Font' },
    { text = 'Value Font' },
    { text = 'Big Value Font' },
}

local layers = {
    { text = 'BACKGROUND' },
    { text = 'BORDER' },
    { text = 'ARTWORK' },
    { text = 'OVERLAY' },
    { text = 'HIGHLIGHT' },
}

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

    local pt
    if isFirstItem then
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'TOPLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'TOPRIGHT', 0 , 0 }
        }
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , 0}
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'FontFrame',
            nil,
            pt
    )
    frame:SetHeight(140)

    local name = LibGUI:NewWidget('button', frame, baseName..'TagFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name.Text = name:CreateFontString()
    name.Text:SetAllPoints()
    name.Text:SetFontObject('Game11Font')
    name.Text:SetText(componentName or '')

    local font = LibGUI:NewWidget('label', frame, baseName..'TagFramePathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    font:Update( { 'OVERLAY', GameFontNormal,'Font' } )
    local fontMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TagFramePathDropDownMenu', { 'LEFT', font, 'RIGHT' }, { 200, 25 }, nil, nil)
    fontMenu:Update( fonts )

    local layer = LibGUI:NewWidget('label', frame, baseName..'TagFrameLayerLabel', { 'TOPLEFT', font, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', GameFontNormal,'Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TagFrameLayerDropDownMenu', { 'TOPLEFT', fontMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    layerMenu:Update( layers )

    local tag = LibGUI:NewWidget('label', frame, baseName..'TagFrameSublayerLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    tag:Update( { 'OVERLAY', GameFontNormal,'Tag' } )
    local tagEdit = LibGUI:NewWidget('editbox', frame, baseName..'TagFrameSubLayerEditbox', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 20, -4 }, { 250, 0 }, nil, nil)
    tagEdit:Update( { '[Vorkui:HealthColor(true)][Vorkui:PerHP]', 'Game11Font', nil, nil } )
    tagEdit:SetMultiLine(true)
    tagEdit:SetPoint('BOTTOMRIGHT', layerMenu, 'BOTTOMRIGHT', 0, -50) --mandatory to size correctly the editbox
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

Inspector:RegisterComponentGUI('Tag', gui)

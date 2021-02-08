local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local fonts = Editor.menus.fonts
local layers = Editor.menus.layers

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, config)

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
            baseName..'TagFrame',
            nil,
            pt
    )
    frame:SetHeight(140)

    local font = LibGUI:NewWidget('label', frame, 'PathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    font:Update( { 'OVERLAY', 'GameFontNormal','Font' } )
    local fontMenu = LibGUI:NewWidget('dropdownmenu', frame, 'PathDropdown', { 'LEFT', font, 'RIGHT' }, { 200, 25 }, nil, nil)
    fontMenu:Update( fonts )

    local layer = LibGUI:NewWidget('label', frame, 'LayerLabel', { 'TOPLEFT', font, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LayerDropdown', { 'TOPLEFT', fontMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    layerMenu:Update( layers )

    local tag = LibGUI:NewWidget('label', frame, 'SublayerLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    tag:Update( { 'OVERLAY', 'GameFontNormal','Tag' } )
    local tagEdit = LibGUI:NewWidget('editbox', frame, 'SublayerEditbox', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 20, -4 }, { 250, 0 }, nil, nil)
    tagEdit:Update( { '[Vorkui:HealthColor(true)][Vorkui:PerHP]', 'Game11Font', nil, nil } ) -- TODO DEBUG PURPOSE
    tagEdit:SetMultiLine(true)
    tagEdit:SetPoint('BOTTOMRIGHT', layerMenu, 'BOTTOMRIGHT', 0, -50) --mandatory to size correctly the editbox
    if hasBorder == true then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, 'NameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Tag', gui)

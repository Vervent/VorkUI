local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
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
            baseName..'SlantingFrame',
            nil,
            pt
    )
    frame:SetHeight(160)

    local checkbox = LibGUI:NewWidget('checkbox', frame, 'CheckboxEnable', { 'TOPLEFT' }, nil, 'UICheckButtonTemplate', nil)
    checkbox:Update( { 'Enable' } )
    checkbox:ChangeFont( 'GameFontNormal' )

    local uniformSlanting = LibGUI:NewWidget('checkbox', frame, 'CheckboxUniformSlant', { 'TOPLEFT', checkbox, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    uniformSlanting:Update( { 'Uniform Slanting' } )
    uniformSlanting:ChangeFont( 'GameFontNormal' )

    local inverse = LibGUI:NewWidget('checkbox', frame, 'CheckboxInverse', { 'TOPLEFT', uniformSlanting, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    inverse:Update( { 'Inverse' } )
    inverse:ChangeFont( 'GameFontNormal' )

    local fillInverse = LibGUI:NewWidget('checkbox', frame, 'CheckboxFillInverse', { 'LEFT', inverse.text, 'RIGHT', 80, 0 }, nil, 'UICheckButtonTemplate', nil)
    fillInverse:Update( { 'Fill Inverse' } )
    fillInverse:ChangeFont( 'GameFontNormal' )

    local ignoreBackground = LibGUI:NewWidget('checkbox', frame, 'CheckboxIgnoreBG', { 'TOPLEFT', inverse, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    ignoreBackground:Update( { 'ignore Background' } )
    ignoreBackground:ChangeFont( 'GameFontNormal' )

    local staticLayer = LibGUI:NewWidget('label', frame, 'StaticLayerLabel', { 'TOPLEFT', ignoreBackground, 'BOTTOMLEFT' }, { 100, 30 }, nil, nil)
    staticLayer:Update( { 'OVERLAY', 'GameFontNormal','Static Layer' } )
    local staticLayerMenu = LibGUI:NewWidget('dropdownmenu', frame, 'StaticLayerDropdown', { 'LEFT', staticLayer, 'RIGHT' }, { 200, 25 }, nil, nil)
    staticLayerMenu:Update(layers)

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

Inspector:RegisterComponentGUI('Slanting', gui)

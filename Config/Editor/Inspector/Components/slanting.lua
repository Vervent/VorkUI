local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--[[
    Slant.IgnoreBackground = false
    Slant.StaticLayer
    Slant.UniformSlanting = true --use for uniform slant, it implies that all textures got same size
    Slant.Inverse = false --base slant is right-oriented, use this to inverse
    Enable
    Slant.FillInverse = false
]]--

local Inspector=V.Editor.Inspector
local layers = {
    { text = 'BACKGROUND' },
    { text = 'BORDER' },
    { text = 'ARTWORK' },
    { text = 'OVERLAY' },
    { text = 'HIGHLIGHT' },
}

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
            baseName..'TextureFrame',
            nil,
            pt
    )
    frame:SetHeight(160)

    local checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxEnable', { 'TOPLEFT' }, nil, 'UICheckButtonTemplate', nil)
    checkbox:Update( { 'Enable' } )
    checkbox:ChangeFont( 'GameFontNormal' )

    local uniformSlanting = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxUniformSlant', { 'TOPLEFT', checkbox, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    uniformSlanting:Update( { 'Uniform Slanting' } )
    uniformSlanting:ChangeFont( 'GameFontNormal' )

    local inverse = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxInverse', { 'TOPLEFT', uniformSlanting, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    inverse:Update( { 'Inverse' } )
    inverse:ChangeFont( 'GameFontNormal' )

    local fillInverse = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxFillInverse', { 'LEFT', inverse.text, 'RIGHT', 80, 0 }, nil, 'UICheckButtonTemplate', nil)
    fillInverse:Update( { 'Fill Inverse' } )
    fillInverse:ChangeFont( 'GameFontNormal' )

    local ignoreBackground = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxIgnoreBG', { 'TOPLEFT', inverse, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    ignoreBackground:Update( { 'ignore Background' } )
    ignoreBackground:ChangeFont( 'GameFontNormal' )

    local staticLayer = LibGUI:NewWidget('label', frame, baseName..'SlantingFrameStaticLayerLabel', { 'TOPLEFT', ignoreBackground, 'BOTTOMLEFT' }, { 100, 30 }, nil, nil)
    staticLayer:Update( { 'OVERLAY', GameFontNormal,'Static Layer' } )
    local staticLayerMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'SlantingFrameStaticLayerDropDownMenu', { 'LEFT', staticLayer, 'RIGHT' }, { 200, 25 }, nil, nil)
    staticLayerMenu:Update(layers)

    if hasBorder == true then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'SlantingFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Slanting', gui)

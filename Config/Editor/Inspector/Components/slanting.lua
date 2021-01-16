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

local function gui(baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'TextureFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10},
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10}
            }
    )
    frame:SetHeight(200)
    local name = LibGUI:NewWidget('label', frame, baseName..'SlantingFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 80, 30 }, nil, nil)
    name:Update( { 'OVERLAY', nil, componentName or '' } )

    local checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxEnable', { 'TOPLEFT' }, nil, 'UICheckButtonTemplate', nil)
    checkbox:Update( { 'Enable' } )

    local uniformSlanting = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxUniformSlant', { 'TOPLEFT', checkbox, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    uniformSlanting:Update( { 'Uniform Slanting' } )

    local inverse = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxInverse', { 'TOPLEFT', uniformSlanting, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    inverse:Update( { 'Inverse' } )

    local fillInverse = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxFillInverse', { 'LEFT', inverse.text, 'RIGHT', 80, 0 }, nil, 'UICheckButtonTemplate', nil)
    fillInverse:Update( { 'Fill Inverse' } )

    local ignoreBackground = LibGUI:NewWidget('checkbox', frame, baseName..'SlantingFrameCheckboxIgnoreBG', { 'TOPLEFT', inverse, 'BOTTOMLEFT' }, nil, 'UICheckButtonTemplate', nil)
    ignoreBackground:Update( { 'ignore Background' } )

    local staticLayer = LibGUI:NewWidget('label', frame, baseName..'SlantingFrameStaticLayerLabel', { 'TOPLEFT', ignoreBackground, 'BOTTOMLEFT' }, { 100, 30 }, nil, nil)
    staticLayer:Update( { 'OVERLAY', GameFontNormal,'Static Layer' } )
    local staticLayerMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'SlantingFrameStaticLayerDropDownMenu', { 'LEFT', staticLayer, 'RIGHT' }, { 200, 25 }, nil, nil)
    staticLayerMenu:Update(layers)

    if hasBorder == true then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    return frame
end

Inspector:RegisterComponentGUI('Slanting', gui)

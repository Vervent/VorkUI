local _, Plugin = ...
local select = select

local V = select(2, ...):unpack()
--load libgui lib
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local layers = Editor.menus.layers
local blendmode = Editor.menus.blendmode

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)

    local atlasDropDown = V.Medias:GetAtlasDropDown()
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
            baseName..'CastBarFrame',
            nil,
            pt
    )

    local layer = LibGUI:NewWidget('label', frame, baseName..'LayerLabel', { 'TOPLEFT', 0, -10 }, { 120, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'LayerDropDownMenu', { 'LEFT', layer, 'RIGHT' }, { 200, 25 }, nil, nil)
    layerMenu:Update(layers)

    local blend = LibGUI:NewWidget('label', frame, baseName..'BlendLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 120, 30 }, nil, nil)
    blend:Update( { 'OVERLAY', 'GameFontNormal','Blending Mode' } )
    local blendMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'BlendDropDownMenu', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    blendMenu:Update(blendmode)

    local size = Inspector:CreateComponentGUI('Size', '', frame, blendMenu, nil, {
        { 'TOPLEFT', 4, -80 }, { 'TOPRIGHT', -4, -80 }
    }, false, false, false, nil)

    local castPath = LibGUI:NewWidget('label', frame, baseName..'CastPathLabel', { 'TOPLEFT', size, 'BOTTOMLEFT', 0, -4 }, { 120, 30 }, nil, nil)
    castPath:Update( { 'OVERLAY', 'GameFontNormal','Casting Atlas' } )
    local castPathMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'CastPathDropDownMenu', { 'LEFT', castPath, 'RIGHT' }, { 200, 25 }, nil, nil)
    castPathMenu:Update( atlasDropDown )

    local channelPath = LibGUI:NewWidget('label', frame, baseName..'CastPathLabel', { 'TOPLEFT', castPath, 'BOTTOMLEFT', 0, -4 }, { 120, 30 }, nil, nil)
    channelPath:Update( { 'OVERLAY', 'GameFontNormal','Channeling Atlas' } )
    local channelPathMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'CastPathDropDownMenu', { 'LEFT', channelPath, 'RIGHT' }, { 200, 25 }, nil, nil)
    channelPathMenu:Update( atlasDropDown )

    local viewer = Inspector:CreateComponentGUI('Viewer', baseName..'ParticleFrame', frame, frame, nil, { {'TOPLEFT', channelPath, 'BOTTOMLEFT', 0, -4}, {'TOPRIGHT'} }, false, false, false, nil)

    viewer:SetPath('Spark')

    frame:SetHeight(330)

    if hasBorder then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'IndicatorFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Castbar', gui)
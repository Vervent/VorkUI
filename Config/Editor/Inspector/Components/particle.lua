local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local layers = Editor.menus.layers
local blendmode = Editor.menus.blendmode

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)

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
            baseName..'ParticleFrame',
            nil,
            pt
    )

    local path = LibGUI:NewWidget('label', frame, 'PathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', 'GameFontNormal','Atlas' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, 'PathDropdown', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    pathMenu:Update( V.Medias:GetAtlasDropDown() )

    local layer = LibGUI:NewWidget('label', frame, 'LayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LayerDropdown', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    layerMenu:Update(layers)

    local blend = LibGUI:NewWidget('label', frame, 'BlendLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    blend:Update( { 'OVERLAY', 'GameFontNormal','Blending Mode' } )
    local blendMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BlendDropdown', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    blendMenu:Update(blendmode)

    local size = Inspector:CreateComponentGUI('Size', '', frame, blendMenu, nil, {
        { 'TOPLEFT', 0, -110 }, { 'TOPRIGHT', 0, -110 }
    }, false, false, false, nil)

    local viewer = Inspector:CreateComponentGUI('Viewer', 'ParticleViewerFrame', frame, size, nil, { {'TOPLEFT', size, 'BOTTOMLEFT', 0, -4}, {'TOPRIGHT'} }, false, false, false, nil)

    --TODO DEBUG PURPOSE REMOVE THIS
    viewer:SetPath('Muzzle')

    frame:SetHeight(300)

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

Inspector:RegisterComponentGUI('Particle', gui)

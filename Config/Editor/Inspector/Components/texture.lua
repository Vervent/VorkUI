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

local minSubLayer = 0
local maxSubLayer = 10

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config, isBlended)

    local pt
    if point then
        pt = point
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , 0 }
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'TextureFrame',
            nil,
            pt
    )

    local path = LibGUI:NewWidget('label', frame, baseName..'TextureFramePathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', 'GameFontNormal','Texture' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TextureFramePathDropDownMenu', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    pathMenu:Update( V.Medias:GetLSMDropDown('statusbar') )

    local layer = LibGUI:NewWidget('label', frame, baseName..'TextureFrameLayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TextureFrameLayerDropDownMenu', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    layerMenu:Update(layers)

    local sublayer = LibGUI:NewWidget('label', frame, baseName..'TextureFrameSublayerLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    sublayer:Update( { 'OVERLAY', 'GameFontNormal','Sublayer' } )
    local sublayerEdit = LibGUI:NewWidget('editbox', frame, baseName..'TextureFrameSubLayerEditbox', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 42, -4 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    sublayerEdit:Update( { nil, nil, nil, {minSubLayer, maxSubLayer} } )

    if isBlended then
        local blend = LibGUI:NewWidget('label', frame, baseName..'TextureFrameLayerLabel', { 'TOPLEFT', sublayer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
        blend:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
        local blendMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TextureFrameLayerDropDownMenu', { 'TOPLEFT', sublayerEdit, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
        blendMenu:Update(blendmode)

        frame:SetHeight(140)
    else
        frame:SetHeight(110)
    end

    if hasBorder == true then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'TextureFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Texture', gui)

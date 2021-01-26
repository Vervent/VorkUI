local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector
local layers = {
    { text = 'BACKGROUND' },
    { text = 'BORDER' },
    { text = 'ARTWORK' },
    { text = 'OVERLAY' },
    { text = 'HIGHLIGHT' },
}

local minSubLayer = 0
local maxSubLayer = 10

local function gui(baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)

    local pt
    if isFirstItem then
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'TOPLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'TOPRIGHT', 0 , 0 }
        }
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0,0},
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , 0}
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'TextureFrame',
            nil,
            pt
    )
    frame:SetHeight(110)

    local name = LibGUI:NewWidget('button', frame, baseName..'TextureFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local path = LibGUI:NewWidget('label', frame, baseName..'TextureFramePathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', GameFontNormal,'Texture' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TextureFramePathDropDownMenu', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    pathMenu:Update( V.Medias:GetLSMDropDown('statusbar') )

    local layer = LibGUI:NewWidget('label', frame, baseName..'TextureFrameLayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', GameFontNormal,'Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'TextureFrameLayerDropDownMenu', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    layerMenu:Update(layers)

    local sublayer = LibGUI:NewWidget('label', frame, baseName..'TextureFrameSublayerLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    sublayer:Update( { 'OVERLAY', GameFontNormal,'Sublayer' } )
    local sublayerEdit = LibGUI:NewWidget('editbox', frame, baseName..'TextureFrameSubLayerEditbox', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 42, -4 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    sublayerEdit:Update( { nil, nil, nil, {minSubLayer, maxSubLayer} } )

    if hasBorder == true then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('Texture', gui)

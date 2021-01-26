local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local flags = {
    { text = 'NONE' },
    { text = 'OUTLINE' },
    { text = 'THICKOUTLINE' },
    { text = 'MONOCHROME' },
}

local minSize = 8
local maxSize = 100

local function gui(baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)

    local pt
    if isFirstItem then
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'TOPLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'TOPRIGHT', 0 , 0 }
        }
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, 0},
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
    frame:SetHeight(110)

    local name = LibGUI:NewWidget('button', frame, baseName..'FontFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local path = LibGUI:NewWidget('label', frame, baseName..'FontFramePathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', GameFontNormal,'Font' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'FontFramePathDropDownMenu', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    pathMenu:Update( V.Medias:GetLSMDropDown('font') )

    local flag = LibGUI:NewWidget('label', frame, baseName..'FontFrameLayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    flag:Update( { 'OVERLAY', GameFontNormal,'Layer' } )
    local flagMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'FontFrameLayerDropDownMenu', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    flagMenu:Update(flags)

    local size = LibGUI:NewWidget('label', frame, baseName..'FontFrameSublayerLabel', { 'TOPLEFT', flag, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    size:Update( { 'OVERLAY', GameFontNormal,'Size' } )
    local sizeEdit = LibGUI:NewWidget('editbox', frame, baseName..'FontFrameSubLayerEditbox', { 'TOPLEFT', flagMenu, 'BOTTOMLEFT', 42, -4 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    sizeEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    if hasBorder == true then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('Font', gui)

local _, Plugin = ...
local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local flags = Editor.menus.flags

local minSize = 8
local maxSize = 100

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
            baseName..'FontFrame',
            nil,
            pt
    )
    frame:SetHeight(110)

    local path = LibGUI:NewWidget('label', frame, baseName..'FontFramePathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', 'GameFontNormal','Font' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'FontFramePathDropDownMenu', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    pathMenu:Update( V.Medias:GetLSMDropDown('font') )

    local flag = LibGUI:NewWidget('label', frame, baseName..'FontFrameLayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    flag:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local flagMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'FontFrameLayerDropDownMenu', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    flagMenu:Update(flags)

    local size = LibGUI:NewWidget('label', frame, baseName..'FontFrameSublayerLabel', { 'TOPLEFT', flag, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    size:Update( { 'OVERLAY', 'GameFontNormal','Size' } )
    local sizeEdit = LibGUI:NewWidget('editbox', frame, baseName..'FontFrameSubLayerEditbox', { 'TOPLEFT', flagMenu, 'BOTTOMLEFT', 42, -4 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    sizeEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    if hasBorder == true then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'FontFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Font', gui)

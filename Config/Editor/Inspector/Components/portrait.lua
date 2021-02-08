local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local portraitMenu = Editor.menus.portrait

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
            baseName..'PortraitFrame',
            nil,
            pt
    )
    frame:SetHeight(70)

    local portraitTypeLabel = LibGUI:NewWidget('label', frame, 'PortraitLabel', { 'TOPLEFT' }, {200, 30}, nil, nil )
    portraitTypeLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Portrait type' } )

    local portraitTypeDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'PortraitDropdown', { 'LEFT', portraitTypeLabel, 'RIGHT' }, { 60, 25 }, nil, nil)
    portraitTypeDropdown:Update( portraitMenu )

    local rotationLabel = LibGUI:NewWidget('label', frame, 'RotationLabel', { 'TOPLEFT', portraitTypeLabel, 'BOTTOMLEFT', 0, -4 }, { 200, 30 }, nil, nil)
    rotationLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Rotation' } )
    local rotationEdit = LibGUI:NewWidget('editbox', frame, 'RotationEdit', { 'LEFT', rotationLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    rotationEdit:Update( { nil, nil, nil, { -180, 180} } ) --TODO CONVERT DEG TO RAD

    if hasBorder then
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

Inspector:RegisterComponentGUI('Portrait', gui)
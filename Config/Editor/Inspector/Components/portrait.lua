local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local portraitMenu = {
    { text = '2D' },
    { text = '3D' },
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
            baseName..'PortraitFrame',
            nil,
            pt
    )
    frame:SetHeight(70)

    local portraitTypeLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT' }, {200, 30}, nil, nil )
    portraitTypeLabel:Update( { 'OVERLAY', GameFontNormal, 'Portrait type' } )

    local portraitTypeDropdown =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', portraitTypeLabel, 'RIGHT' }, { 60, 25 }, nil, nil)
    portraitTypeDropdown:Update( portraitMenu )

    local rotationLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', portraitTypeLabel, 'BOTTOMLEFT', 0, -4 }, { 200, 30 }, nil, nil)
    rotationLabel:Update( { 'OVERLAY', GameFontNormal, 'Rotation' } )
    local rotationEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', rotationLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    rotationEdit:Update( { nil, nil, nil, { -180, 180} } ) --TODO CONVERT DEG TO RAD

    if hasBorder then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'PortraitFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Portrait', gui)
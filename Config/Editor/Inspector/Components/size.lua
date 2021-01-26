local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local minSize = 0
local maxSize = 500

local function gui(baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'SizeFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )
    frame:SetHeight(50)

    local name = LibGUI:NewWidget('button', frame, baseName..'SizeFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local width = LibGUI:NewWidget('label', frame, baseName..'SizeFrameWidthLabel', { 'TOP', -60, 0 }, { 80, 30 }, nil, nil)
    width:Update( { 'OVERLAY', GameFontNormal,'Width' } )
    local widthEdit = LibGUI:NewWidget('editbox', frame, baseName..'SizeFrameWidthEditbox', { 'TOPLEFT', width, 'BOTTOMLEFT', 20, 10 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    widthEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    local height = LibGUI:NewWidget('label', frame, baseName..'SizeFrameHeightLabel', { 'TOP', 60, 0 }, { 80, 30 }, nil, nil)
    height:Update( { 'OVERLAY', GameFontNormal,'Height' } )
    local heightEdit = LibGUI:NewWidget('editbox', frame, baseName..'SizeFrameHeightEditbox', { 'TOPLEFT', height, 'BOTTOMLEFT', 20, 10 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    heightEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    if hasBorder == true then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('Size', gui)

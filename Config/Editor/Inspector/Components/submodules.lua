local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local changeList = {}

local function enable(config)

end

local function GetChange()
    return changeList
end

local function disable(frame)
    changeList = {}

    frame:ClearContent()

end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, config)
    local width = parent:GetWidth()
    local height = 0

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
            baseName..'SubmodulesFrame',
            nil,
            pt
    )

    local checkbox
    for k, _ in pairs(config) do
        checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'SubmodulesFrameCheckbox'..k, { 'TOPLEFT', 2, -2 }, nil, 'UICheckButtonTemplate', nil)
        checkbox:Update( { k } )
        checkbox:ChangeFont( 'GameFontNormal' )
    end

    frame:SetWidth(width)
    height = frame:UpdateWidgetsLayout( 1, 10, 0 )
    frame:SetHeight(height)
    if hasBorder then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'SubmodulesFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Submodules', gui)
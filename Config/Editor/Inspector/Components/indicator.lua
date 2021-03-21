local _, Plugin = ...
local select = select
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

--[[
    TODO Debug Purpose
]]--

local indicatorDropdown = {
    { text = 'Fight'},
    { text = 'Resting'},
    { text = 'Class'},
    { text = 'Leader'},
}

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
            baseName..'IndicatorFrame',
            nil,
            pt
    )

    local indicator = LibGUI:NewWidget('label', frame, 'IndicatorLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    indicator:Update( { 'OVERLAY', 'GameFontNormal', 'Indicator' } )
    local indicatorMenu = LibGUI:NewWidget('dropdownmenu', frame, 'IndicatorDropdown', { 'LEFT', indicator, 'RIGHT' }, { 200, 25 }, nil, nil)
    indicatorMenu:Update( indicatorDropdown )

    local pointFrame = Inspector:CreateComponentGUI('Point',
            'IndicatorPoint',
            frame,
            indicatorMenu,
            nil,
            {
                {'TOPLEFT', 0, -30},
                {'TOPRIGHT', 0, -30},
            },
            false,
            false)

    print('INDICATOR POINT FRAME', pointFrame)

    frame:SetHeight(pointFrame:GetHeight() + 30)
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

Inspector:RegisterComponentGUI('Indicator', gui)
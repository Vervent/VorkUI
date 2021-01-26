local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

--[[
    Debug Purpose
]]--

local indicatorDropdown = {
    { text = 'Fight'},
    { text = 'Resting'},
    { text = 'Class'},
    { text = 'Leader'},
}

local function gui(baseName, parent, parentPoint, componentName, indicatorsConfig)

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'RenderingFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )

    local name = LibGUI:NewWidget('button', frame, baseName..'IndicatorFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local indicator = LibGUI:NewWidget('label', frame, baseName..'IndicatorFrameItemLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    indicator:Update( { 'OVERLAY', GameFontNormal, 'Indicator' } )
    local indicatorMenu = LibGUI:NewWidget('dropdownmenu', frame, baseName..'IndicatorFrameItemDropDownMenu', { 'LEFT', indicator, 'RIGHT' }, { 200, 25 }, nil, nil)
    indicatorMenu:Update( indicatorDropdown )

    local point = Inspector:CreateComponentGUI('Point', 'InspectorIndicatorPoint', frame, indicatorMenu, nil, nil, false, false)
    point:ClearAllPoints()
    point:SetPoint('TOPLEFT', 0, -30)
    point:SetPoint('TOPRIGHT', 0, -30)

    frame:SetHeight(point:GetHeight() + 30)
    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('Indicator', gui)
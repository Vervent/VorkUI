local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function gui(baseName, parent, parentPoint, componentName, subModuleConfig)
    local width = parent:GetWidth()
    local height = 0

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'SubmodulesFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )
    local name = LibGUI:NewWidget('button', frame, baseName..'SubmodulesFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local checkbox
    for k, _ in pairs(subModuleConfig) do
        checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'SubmodulesFrameCheckbox'..k, { 'TOPLEFT', 2, -2 }, nil, 'UICheckButtonTemplate', nil)
        checkbox:Update( { k } )
    end

    frame:SetWidth(width)
    height = frame:UpdateWidgetsLayout( 2, 10, 0 )
    frame:SetHeight(height)
    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('Submodules', gui)
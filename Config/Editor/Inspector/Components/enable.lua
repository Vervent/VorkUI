local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function gui(baseName, parent, parentPoint, componentName)
    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'EnableFrame',
            nil,
            {
                { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -10 },
                { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -10 }
            }
    )
    frame:SetHeight(30)

    local name = LibGUI:NewWidget('button', frame, baseName..'EnableFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    name:AddLabel(name, componentName)

    local checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'EnableFrameCheckbox', { 'TOPLEFT' }, nil, 'UICheckButtonTemplate', nil)
    checkbox:Update( { 'Enable' } )

    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)

    return frame
end

Inspector:RegisterComponentGUI('Enable', gui)
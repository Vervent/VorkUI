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
    local name = LibGUI:NewWidget('label', frame, baseName..'SubmodulesFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 80, 30 }, nil, nil)
    name:Update( { 'OVERLAY', nil, componentName or '' } )

    local checkbox
    for k, _ in pairs(subModuleConfig) do
        checkbox = LibGUI:NewWidget('checkbox', frame, baseName..'SubmodulesFrameCheckbox'..k, { 'TOPLEFT', 2, -2 }, nil, 'UICheckButtonTemplate', nil)
        checkbox:Update( { k } )
    end

    frame:SetWidth(width)
    height = frame:UpdateWidgetsLayout( 2 )
    frame:SetHeight(height)
    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    return frame
end

Inspector:RegisterComponentGUI('Submodules', gui)
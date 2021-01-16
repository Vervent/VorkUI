local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function gui(baseName, parent, parentPoint, componentName, renderingConfig)
    local height = 0

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
    local name = LibGUI:NewWidget('label', frame, baseName..'RenderingFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 80, 30 }, nil, nil)
    name:Update( { 'OVERLAY', nil, componentName or '' } )

    local it = frame
    local hasBorder
    for i, t in ipairs(renderingConfig) do
        if i == 1 or i == #renderingConfig then
            hasBorder = false
        else
            hasBorder = true
        end
        it = Inspector:CreateComponentGUI('Texture', 'InspectorRenderingTexture', frame, it, nil, i==1, hasBorder)
        height = height + it:GetHeight()
    end

    frame:SetHeight(height)

    frame:CreateBorder(1, { 1, 1, 1, 0.4 })

    return frame
end

Inspector:RegisterComponentGUI('Rendering', gui)
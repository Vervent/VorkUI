local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)
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
            baseName..'RenderingFrame',
            nil,
            pt
    )

    local it = frame
    for i, _ in ipairs(config) do
        if i == 1 then
            pt =  {
                {'TOPLEFT', 0, 0},
                {'TOPRIGHT', 0, 0},
            }
        else
            pt = nil
        end
        it = Inspector:CreateComponentGUI('Texture', 'InspectorRenderingTexture'..i, frame, it, nil, pt, (i%2 == 1), false, false, nil)
        height = height + it:GetHeight()
    end

    frame:SetHeight(height)
    if hasBorder then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'RenderingFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Rendering', gui)
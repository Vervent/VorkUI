local _, Plugin = ...

local select = select
local ipairs = ipairs

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local function update(self, config)

end


local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, count)
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
    for i=1, count do
        if i == 1 then
            pt =  {
                {'TOPLEFT', 0, 0},
                {'TOPRIGHT', 0, 0},
            }
        else
            pt = nil
        end
        it = Inspector:CreateComponentGUI('Texture', 'RenderingTexture'..i, frame, it, nil, pt, (i%2 == 1), false, false, nil)
        height = height + it:GetHeight()
    end

    frame:SetHeight(height)
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

Inspector:RegisterComponentGUI('Rendering', gui, update)
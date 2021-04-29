local _, Plugin = ...
local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local ipairs = ipairs
local unpack = unpack
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local function update(self, config)

    local idxConfig = 1
    local maxConfig = #config

    for i, c in ipairs(self.Childs) do
        if c.componentType == 'Font' and idxConfig <= maxConfig then
            c.Update(c, config[idxConfig])
            idxConfig = idxConfig + 1
        end
    end

end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, count)

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
            baseName..'FontFrame',
            nil,
            pt
    )

    local it = frame
    for i=1, count do
        if i == 1 then
            pt =  {
                {'TOPLEFT', 0, -16},
                {'TOPRIGHT', 0, -16},
            }
        else
            pt = nil
        end
        it = Inspector:CreateComponentGUI('Font', 'GeneralFont'..i, frame, it, nil, pt, false, false, true, nil)
        if it.Observer then
            it.Observer.OnNotify = function (...)
                local event, item, value = unpack(...)
                Inspector:SubmitUpdateValue(nil, 'Fonts', i, item.key, value)
            end
        end
        height = height + it:GetHeight()
    end

    frame:SetHeight(height + 8)

    if hasBorder == true then
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

Inspector:RegisterComponentGUI('Fonts', gui, update)

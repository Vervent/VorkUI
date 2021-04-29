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

local function update(self, config, parentDropdown)
    local pointFrame = self.Childs[1]
    pointFrame.Update(pointFrame, config.Point, parentDropdown)

    local sizeFrame = self.Childs[2]
    sizeFrame.Update(sizeFrame, config.Size)
end

local function clean(self)
    local pointFrame = self.Childs[1]
    pointFrame.Clean(pointFrame)
end

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
            baseName..'IndicatorFrame',
            nil,
            pt
    )
    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
        end
    end

    local pointFrame = Inspector:CreateComponentGUI('Point',
            'Indicator',
            frame,
            nil,
            'Point',
            {
                {'TOPLEFT', 0, -16},
                {'TOPRIGHT', 0, -16},
            },
            false,
            false,
            true)

    local pointTableFrame = pointFrame.Childs[2]
    if pointTableFrame.Observer then
        pointTableFrame.Observer.OnNotify = function(...)
            local event = select(1, ...)
            local value = select(2, ...)
            frame.Observer.OnNotify(event, 'Point', nil, value)
        end
    end
    height = height + pointFrame:GetHeight() + 16

    local sizeFrame = Inspector:CreateComponentGUI('Size', 'Indicator', frame, nil, 'Size', {
        {'TOPLEFT', pointFrame, 'BOTTOMLEFT', 0, 0},
        {'TOPRIGHT', pointFrame, 'BOTTOMRIGHT', 0, 0},
    }, false, false, true)
    if sizeFrame.Observer then
        sizeFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            frame.Observer.OnNotify(event, 'Size', item.key, value)
        end
    end
    height = height + sizeFrame:GetHeight() + 16

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

Inspector:RegisterComponentGUI('Indicator', gui, update, clean)
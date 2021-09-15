local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local function update(self, config)

end

local function clean(self)

end

--[[
    {
        ["Point"] = {
			"BOTTOMLEFT", -- [1]
			nil, -- [2]
			"BOTTOMRIGHT", -- [3]
			2, -- [4]
			0, -- [5]
		},
		["Size"] = {
			27, -- [1]
			27, -- [2]
		},
		["AuraCount"] = 4,
		["OffsetY"] = 2,
		["OffsetX"] = 0,
		["DisableMouse"] = false,
        ["HasTooltip"] = true,
		["TooltipAnchor"] = "ANCHOR_TOPLEFT",
		["GrowthAuraLimit"] = 2,
		["GrowthDirectionX"] = 0,
		["GrowthDirectionY"] = 1,
    },
]]--
local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName)
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
            baseName..'BackdropFrame',
            nil,
            pt
    )
    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            --print ('|cff33ff99 Backdrop |r', item.key, item.subkey or 'nil', value)
            --Inspector:SubmitUpdateValue(nil, 'Backdrop', item.key, item.subkey, value)
        end
    end

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

Inspector:RegisterComponentGUI('AuraSystem', gui, update, clean)
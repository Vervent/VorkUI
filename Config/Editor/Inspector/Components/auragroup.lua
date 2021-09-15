local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local ViragDevTool = _G['ViragDevTool']
local function log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    end
end

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local anchorPoint = Editor.menus.anchorPoint
local growDirectionX = Editor.menus.growDirectionX
local growDirectionY = Editor.menus.growDirectionY

local growDirection = function()
    local dir = {}
    for _, v in ipairs(growDirectionX) do
        tinsert(dir, v)
    end

    for _, v in ipairs(growDirectionY) do
        tinsert(dir, v)
    end

    return dir
end

local function update(self, config, parentDropdown)

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local groupChoice = dropdownWidgets[1]
    local groupDropdown = {}

    for i, v in ipairs(config) do
        tinsert(groupDropdown, { text = tostring(i) })
    end
    groupChoice:Update(groupDropdown)

    self.config = config
    self.parentDropdown = parentDropdown

end

local function getDrowdirection(dirX, dirY)
    if dirX == 1 then
        return 'RIGHT'
    elseif dirX == -1 then
        return 'LEFT'
    end

    if dirY == 1 then
        return 'UP'
    elseif dirY == -1 then
        return 'DOWN'
    end
end

local function updateGroup(self, index)
    if self.config == nil then
        return
    end
    local editboxWidgets = LibGUI:GetWidgetsByType(self, 'editbox')
    local checkboxWidgets = LibGUI:GetWidgetsByType(self, 'checkbox')
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')

    local groupConf = self.config[tonumber(index)]
    --log(groupConf, 'AuraGroup update')

    local ptFrame = self.Childs[1]
    local sizeFrame = self.Childs[2]
    ptFrame:Clean()
    ptFrame:Update(groupConf.Point, self.parentDropdown)
    sizeFrame:Update(groupConf.Size)

    local auraCountEdit = editboxWidgets[1]
    local offsetXEdit = editboxWidgets[2]
    local offsetYEdit = editboxWidgets[3]

    auraCountEdit:ChangeText(groupConf.AuraCount)
    offsetXEdit:ChangeText(groupConf.OffsetX)
    offsetYEdit:ChangeText(groupConf.OffsetY)

    local disableMouseCheckBox = checkboxWidgets[1]
    local hasTooltipCheckBox = checkboxWidgets[2]
    local tooltipAnchorMenu = dropdownWidgets[2]

    disableMouseCheckBox:SetChecked(groupConf.DisableMouse)
    hasTooltipCheckBox:SetChecked(groupConf.HasTooltip)
    tooltipAnchorMenu:Update(anchorPoint, groupConf.TooltipAnchor)

    local growthAuraLimitEdit = editboxWidgets[4]
    local growthDirectionMenu = dropdownWidgets[3]

    growthAuraLimitEdit:ChangeText(groupConf.GrowthAuraLimit)
    growthDirectionMenu:Update(growDirection, getDrowdirection(groupConf.GrowthDirectionX, groupConf.GrowthDirectionY))

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
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0, -16 }
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName .. 'AuraGroupFrame',
            nil,
            pt
    )
    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            updateGroup(frame, value)
            --print ('|cff33ff99 Backdrop |r', item.key, item.subkey or 'nil', value)
            --Inspector:SubmitUpdateValue(nil, 'Backdrop', item.key, item.subkey, value)
        end
    end

    local groupLabel = LibGUI:NewWidget('label', frame, 'TooltipAnchorLabel', { 'TOPLEFT', frame, 'TOPLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    groupLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Choose an Aura Group' })
    local groupMenu = LibGUI:NewWidget('dropdownmenu', frame, 'TooltipAnchorDropdown', { 'TOPRIGHT', frame, 'TOPRIGHT', 0, -4 }, { 200, 25 }, nil, nil)
    groupMenu.key = nil
    groupMenu:RegisterObserver(frame.Observer)

    local pointFrame = Inspector:CreateComponentGUI('Point',
            'AuraGroup',
            frame,
            nil,
            'Point',
            {
                { 'TOPLEFT', 0, -46 },
                { 'TOPRIGHT', 0, -46 },
            },
            true,
            true,
            true)

    local pointTableFrame = pointFrame.Childs[2]
    --inject an observer on this frame to handle OnUpdate point
    pointTableFrame.Observer = LibObserver:CreateObserver()
    pointTableFrame.Observer.OnNotify = function(...)
        local event = select(1, ...)
        local value = select(2, ...)
        --frame.Observer.OnNotify( { event, 'Point', nil, value } )
    end
    height = height + pointFrame:GetHeight() + 16

    local sizeFrame = Inspector:CreateComponentGUI('Size', 'AuraGroup', frame, nil, 'Size', {
        { 'TOPLEFT', pointFrame, 'BOTTOMLEFT', 0, -16 },
        { 'TOPRIGHT', pointFrame, 'BOTTOMRIGHT', 0, 0 },
    }, true, true, true)
    if sizeFrame.Observer then
        sizeFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            --frame.Observer.OnNotify( { event, 'Size', item.key, value } )
        end
    end
    height = height + sizeFrame:GetHeight() + 16

    local auraCountLabel = LibGUI:NewWidget('label', frame, 'AuraCountLabel', { 'TOPLEFT', sizeFrame, 'BOTTOMLEFT', 10, -4 }, { 100, 30 }, nil, nil)
    auraCountLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Aura Count' })
    local auraCountEdit = LibGUI:NewWidget('editbox', frame, 'AuraCountEditbox', { 'TOP', auraCountLabel, 'BOTTOM', 0, 10 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    auraCountEdit:Update({ nil, nil, nil, { 0, 40 } })

    local offsetXLabel = LibGUI:NewWidget('label', frame, 'WidthLabel', { 'TOP', sizeFrame, 'BOTTOM', 0, -4 }, { 80, 30 }, nil, nil)
    offsetXLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Offset X' })
    local offsetXEdit = LibGUI:NewWidget('editbox', frame, 'WidthEditbox', { 'TOP', offsetXLabel, 'BOTTOM', 0, 10 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    offsetXEdit:SetMinMax(-10, 10)

    local offsetYLabel = LibGUI:NewWidget('label', frame, 'HeightLabel', { 'TOPRIGHT', sizeFrame, 'BOTTOMRIGHT', -10, -4 }, { 80, 30 }, nil, nil)
    offsetYLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Offset Y' })
    local offsetYEdit = LibGUI:NewWidget('editbox', frame, 'HeightEditbox', { 'TOP', offsetYLabel, 'BOTTOM', 0, 10 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    offsetYEdit:SetMinMax(-10, 10)

    local disableMouseCheckBox = LibGUI:NewWidget('checkbox', frame, 'DisableMouseCheckBox', { 'TOPLEFT', sizeFrame, 'BOTTOMLEFT', 4, -60 }, nil, 'UICheckButtonTemplate', nil)
    disableMouseCheckBox:ChangeFont('GameFontNormal')
    disableMouseCheckBox:ChangeText('Disable Mouse')

    local hasTooltipCheckBox = LibGUI:NewWidget('checkbox', frame, 'HasTooltipCheckBox', { 'TOPLEFT', disableMouseCheckBox, 'BOTTOMLEFT', 0, -4 }, nil, 'UICheckButtonTemplate', nil)
    hasTooltipCheckBox:ChangeFont('GameFontNormal')
    hasTooltipCheckBox:ChangeText('Has Tooltip')

    local tooltipAnchorLabel = LibGUI:NewWidget('label', frame, 'TooltipAnchorLabel', { 'TOPLEFT', hasTooltipCheckBox, 'BOTTOMLEFT', 0, -4 }, { 150, 30 }, nil, nil)
    tooltipAnchorLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Tooltip Anchor' })
    local tooltipAnchorMenu = LibGUI:NewWidget('dropdownmenu', frame, 'TooltipAnchorDropdown', { 'LEFT', tooltipAnchorLabel, 'RIGHT', 4, 0 }, { 150, 25 }, nil, nil)

    local growthAuraLimitLabel = LibGUI:NewWidget('label', frame, 'GrowthAuraLimitLabel', { 'TOPLEFT', tooltipAnchorLabel, 'BOTTOMLEFT', 0, -4 }, { 150, 30 }, nil, nil)
    growthAuraLimitLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Growth Aura Limit' })
    local growthAuraLimitEdit = LibGUI:NewWidget('editbox', frame, 'GrowthAuraLimitEditbox', { 'LEFT', growthAuraLimitLabel, 'RIGHT', 48, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    growthAuraLimitEdit:SetMinMax(0, 40)

    local growthDirectionLabel = LibGUI:NewWidget('label', frame, 'GrowthDirectionLabel', { 'TOPLEFT', growthAuraLimitLabel, 'BOTTOMLEFT', 0, -4 }, { 150, 30 }, nil, nil)
    growthDirectionLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Growth Direction' })
    local growthDirectionMenu = LibGUI:NewWidget('dropdownmenu', frame, 'GrowthDirectionDropdown', { 'LEFT', growthDirectionLabel, 'RIGHT', 4, 0 }, { 150, 25 }, nil, nil)

    height = height + 280
    frame:SetHeight(height)

    if hasBorder then
        frame:CreateBorder(borderSettings.size, borderSettings.color)
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

Inspector:RegisterComponentGUI('AuraGroup', gui, update, clean)
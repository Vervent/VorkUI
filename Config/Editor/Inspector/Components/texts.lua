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

local currentId = nil

local function update(self, config, parentDropdown)

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local textChoice = dropdownWidgets[1]
    local textDropdown = {}

    for _, v in ipairs(config) do
        tinsert(textDropdown, { text = v.Name } )
    end
    textChoice:Update(textDropdown)

    self.config = config
    self.parentDropdown = parentDropdown

end

local function removeTextFromDropdown(self, name)
    local dropdown = {}
    for _, v in ipairs(self.parentDropdown) do
        if v.text ~= name then
            tinsert(dropdown, v)
        end
    end

    return dropdown
end

local function updateText(self, name)
    if self.config == nil then
        return
    end

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local textChoice = dropdownWidgets[1]

    local parentDropdown = removeTextFromDropdown(self, name)
    local point = self.Childs[1]
    local tag = self.Childs[2]

    for i, v in ipairs(self.config) do
        if v.Name == name then

            point.Clean(point)
            tag.Clean(tag)

            point.Update(point, v.Point, parentDropdown)
            tag.Update(tag, v)

            textChoice.key = i
            currentId = i
        end
    end
end

local function clean(self)
    --self.config = {}
    --self.Childs[1].Clean(self.Childs[1])
    --
    --local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    --local indicatorChoice = dropdownWidgets[1]
    --indicatorChoice.key = nil
    --indicatorChoice:Update(nil, '')
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

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            updateText(frame, value)
        end
    end

    local textLabel = LibGUI:NewWidget('label', frame, 'TextLabel', { 'TOPLEFT', 0, -10 }, { 100, 30 }, nil, nil)
    textLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Choose Text' } )
    local textMenu = LibGUI:NewWidget('dropdownmenu', frame, 'TextDropdown', { 'LEFT', textLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    --indicatorMenu:Update( indicatorDropdown )
    textMenu.key = nil
    textMenu:RegisterObserver(frame.Observer)

    local pointFrame = Inspector:CreateComponentGUI('Point',
            'Text',
            frame,
            textLabel,
            'Point',
            {
                {'TOPLEFT', 0, -60},
                {'TOPRIGHT'},
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
        Inspector:SubmitUpdateValue('Texts', currentId, 'Point', nil, value)
    end
    height = height + pointFrame:GetHeight() + 16

    local tagFrame = Inspector:CreateComponentGUI('Tag', 'Text', frame, nil, 'Tag', {
        {'TOPLEFT', pointFrame, 'BOTTOMLEFT', 0, -16},
        {'TOPRIGHT', pointFrame, 'BOTTOMRIGHT', 0, 0},
    }, true, true, true)
    if tagFrame.Observer then
        tagFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            print ('TEXTS', event, item.key, value)
            Inspector:SubmitUpdateValue('Texts', currentId, item.key, nil, value)
        end
    end
    height = height + tagFrame:GetHeight() + 16

    --local indicatorLabel = LibGUI:NewWidget('label', frame, 'IndicatorLabel', { 'TOPLEFT', 0, -10 }, { 100, 30 }, nil, nil)
    --indicatorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Choose Indicator' } )
    --local indicatorMenu = LibGUI:NewWidget('dropdownmenu', frame, 'IndicatorDropdown', { 'LEFT', indicatorLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    ----indicatorMenu:Update( indicatorDropdown )
    --indicatorMenu.key = nil
    --indicatorMenu:RegisterObserver(frame.Observer)
    --
    --local indicator = Inspector:CreateComponentGUI('Indicator', 'Indicator', frame, indicatorLabel, nil, {
    --    {'TOPLEFT', 0, -45},
    --    {'TOPRIGHT', 0, 0},
    --}, false, false, true, nil)
    --
    --if indicator.Observer then
    --    indicator.Observer.OnNotify = function (...)
    --        local event, item, subkey, value = unpack(...)
    --        if type(item) == 'string' then
    --            --print ('INDICATORS', event, item, subkey, value)
    --            Inspector:SubmitUpdateValue('Indicators', currentId, item, subkey, value)
    --        else
    --            --print ('INDICATORS', event, item.key, 'nil', subkey)
    --            Inspector:SubmitUpdateValue('Indicators', currentId, item.key, item.subkey or nil, subkey)
    --        end
    --    end
    --end

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

Inspector:RegisterComponentGUI('Texts', gui, update, clean)

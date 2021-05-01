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
    local indicatorChoice = dropdownWidgets[1]
    local indicatorsDropdown = {}

    for _, v in ipairs(config) do
        tinsert(indicatorsDropdown, { text = v.Name } )
    end
    indicatorChoice:Update(indicatorsDropdown)

    self.config = config
    self.parentDropdown = parentDropdown

end

local function removeIndicatorFromDropdown(self, name)
    local dropdown = {}
    for _, v in ipairs(self.parentDropdown) do
        if v.text ~= name then
            tinsert(dropdown, v)
        end
    end

    return dropdown
end

local function updateIndicator(self, name)
    if self.config == nil then
        return
    end

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local indicatorChoice = dropdownWidgets[1]

    local parentDropdown = removeIndicatorFromDropdown(self, name)

    for i, v in ipairs(self.config) do
        if v.Name == name then
            local indicator = self.Childs[1]
            indicator.Clean(indicator) --clean old data before update
            indicator.Update(indicator, v, parentDropdown)
            indicatorChoice.key = i
            currentId = i
        end
    end
end

local function clean(self)
    self.config = {}
    self.Childs[1].Clean(self.Childs[1])

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local indicatorChoice = dropdownWidgets[1]
    indicatorChoice.key = nil
    indicatorChoice:Update(nil, '')
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
            updateIndicator(frame, value)
        end
    end

    local indicatorLabel = LibGUI:NewWidget('label', frame, 'IndicatorLabel', { 'TOPLEFT', 0, -10 }, { 100, 30 }, nil, nil)
    indicatorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Choose Indicator' } )
    local indicatorMenu = LibGUI:NewWidget('dropdownmenu', frame, 'IndicatorDropdown', { 'LEFT', indicatorLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    --indicatorMenu:Update( indicatorDropdown )
    indicatorMenu.key = nil
    indicatorMenu:RegisterObserver(frame.Observer)

    local indicator = Inspector:CreateComponentGUI('Indicator', 'Indicator', frame, indicatorLabel, nil, {
        {'TOPLEFT', 0, -45},
        {'TOPRIGHT', 0, 0},
    }, false, false, true, nil)
    if indicator.Observer then
        indicator.Observer.OnNotify = function (...)
            local event = select(1, ...)
            local key = select(2, ...)
            local subkey = select(3, ...)
            local value = select(4, ...)
            print (event, 'Indicators', currentId, key, subkey, value)
            Inspector:SubmitUpdateValue('Indicators', currentId, key, subkey, value)
        end
    end

    frame:SetHeight(indicator:GetHeight() + 30 + 8)

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

Inspector:RegisterComponentGUI('Indicators', gui, update, clean)

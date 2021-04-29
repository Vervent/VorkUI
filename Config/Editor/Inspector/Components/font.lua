local _, Plugin = ...
local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local flags = Editor.menus.flags

local minSize = 8
local maxSize = 100

local function update(self, config)
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editboxWidgets = LibGUI:GetWidgetsByType(self, 'editbox')
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')

    local pathMenu = dropdownWidgets[1]
    pathMenu:Update( V.Medias:GetLSMDropDown('font'), config[2] )

    local flagMenu = dropdownWidgets[2]
    flagMenu:Update(flags, config[4])

    local sizeEdit = editboxWidgets[1]
    sizeEdit:ChangeText(config[3])

    local nameButton = buttonWidgets[1]
    nameButton:ChangeFont('GameFontNormal')
    nameButton:ChangeText(config[1])
end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName)

    local pt
    if point then
        pt = point
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , 0 }
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
            Inspector:SubmitUpdateValue(nil, 'Font', item.key, nil, value)
        end
    end

    local path = LibGUI:NewWidget('label', frame, 'PathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', 'GameFontNormal','Font' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, 'PathDropdown', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    pathMenu.key = 2
    pathMenu:RegisterObserver(frame.Observer)
    --pathMenu:Update( V.Medias:GetLSMDropDown('font') )

    local flag = LibGUI:NewWidget('label', frame, 'LayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    flag:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local flagMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LayerDropdown', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    flagMenu.key = 4
    flagMenu:RegisterObserver(frame.Observer)
    --flagMenu:Update(flags)

    local size = LibGUI:NewWidget('label', frame, 'SublayerLabel', { 'TOPLEFT', flag, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    size:Update( { 'OVERLAY', 'GameFontNormal','Size' } )
    local sizeEdit = LibGUI:NewWidget('editbox', frame, 'SublayerEditbox', { 'TOPLEFT', flagMenu, 'BOTTOMLEFT', 42, -4 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    sizeEdit:Update( { nil, nil, nil, {minSize, maxSize} } )
    sizeEdit.key = 3
    sizeEdit:RegisterObserver(frame.Observer)

    frame:SetHeight(130)

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

Inspector:RegisterComponentGUI('Font', gui, update)

local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local minSize = 0
local maxSize = 1000

local function update(self, config)
    local widgets = LibGUI:GetWidgetsByType(self, 'editbox')

    widgets[1]:ChangeText( config[1] )
    widgets[2]:ChangeText( config[2] )

end

local function clean(self)
    local widgets = LibGUI:GetWidgetsByType(self, 'editbox')

    widgets[1]:ChangeText( '' )
    widgets[2]:ChangeText( '' )

end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, config)

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
            baseName..'SizeFrame',
            nil,
            pt
    )
    frame:SetHeight(50)

    local width = LibGUI:NewWidget('label', frame, 'WidthLabel', { 'TOP', -60, 0 }, { 80, 30 }, nil, nil)
    width:Update( { 'OVERLAY', 'GameFontNormal','Width' } )
    local widthEdit = LibGUI:NewWidget('editbox', frame, 'WidthEditbox', { 'TOPLEFT', width, 'BOTTOMLEFT', 20, 10 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    widthEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    local height = LibGUI:NewWidget('label', frame, 'HeightLabel', { 'TOP', 60, 0 }, { 80, 30 }, nil, nil)
    height:Update( { 'OVERLAY', 'GameFontNormal','Height' } )
    local heightEdit = LibGUI:NewWidget('editbox', frame, 'HeightEditbox', { 'TOPLEFT', height, 'BOTTOMLEFT', 20, 10 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    heightEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

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

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            Inspector:SubmitUpdateValue(nil, 'Size', item.key, nil, value)
        end

        widthEdit.key = 1
        widthEdit:RegisterObserver(frame.Observer)
        heightEdit.key = 2
        heightEdit:RegisterObserver(frame.Observer)
    end

    return frame
end

Inspector:RegisterComponentGUI('Size', gui, update, clean)

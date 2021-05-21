local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local fonts = Editor.menus.fonts
local layers = Editor.menus.layers

local function update(self, config)
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editboxWidgets = LibGUI:GetWidgetsByType(self, 'editbox')

    local fontMenu = dropdownWidgets[1]
    local layerMenu = dropdownWidgets[2]
    local tag = editboxWidgets[1]

    fontMenu:Update( fonts, config.Font )
    layerMenu:Update( layers, config.Layer )
    tag:ChangeText( config.Tag )

end

local function clean(self)

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editboxWidgets = LibGUI:GetWidgetsByType(self, 'editbox')

    local fontMenu = dropdownWidgets[1]
    local layerMenu = dropdownWidgets[2]
    local tag = editboxWidgets[1]

    fontMenu:Update( fonts, '' )
    layerMenu:Update( layers, '' )
    tag:ChangeText( '' )

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
            baseName..'TagFrame',
            nil,
            pt
    )

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
        end
    end

    frame:SetHeight(140)

    local font = LibGUI:NewWidget('label', frame, 'PathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    font:Update( { 'OVERLAY', 'GameFontNormal','Font' } )
    local fontMenu = LibGUI:NewWidget('dropdownmenu', frame, 'PathDropdown', { 'LEFT', font, 'RIGHT' }, { 200, 25 }, nil, nil)
    fontMenu:Update( fonts )
    fontMenu.key = 'Font'
    fontMenu:RegisterObserver(frame.Observer)

    local layer = LibGUI:NewWidget('label', frame, 'LayerLabel', { 'TOPLEFT', font, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LayerDropdown', { 'TOPLEFT', fontMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    layerMenu:Update( layers )
    layerMenu.key = 'Layer'
    layerMenu:RegisterObserver(frame.Observer)

    local tag = LibGUI:NewWidget('label', frame, 'SublayerLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    tag:Update( { 'OVERLAY', 'GameFontNormal','Tag' } )
    local tagEdit = LibGUI:NewWidget('editbox', frame, 'SublayerEditbox', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 0, -4 }, { 300, 0 })
    tagEdit:ChangeFont( 'Game11Font' )
    tagEdit:SetMultiLine(true)
    tagEdit:SetPoint('BOTTOMRIGHT', layerMenu, 'BOTTOMRIGHT', 30, -50) --mandatory to size correctly the editbox
    tagEdit.key = 'Tag'
    tagEdit:RegisterObserver(frame.Observer)
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

Inspector:RegisterComponentGUI('Tag', gui, update, clean)

local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local insetTextArray = Editor.insetTextArray

local function update(self, config)

    print ('|cff33ff99 Update Backdrop|r')

    local checkboxes = LibGUI:GetWidgetsByType(self, 'checkbox')
    local dropdowns = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local edits = LibGUI:GetWidgetsByType(self, 'editbox')
    local colors = LibGUI:GetWidgetsByType(self, 'color')

    local bgPathMenu = dropdowns[1]
    local borderPathMenu = dropdowns[2]
    local enableCheck = checkboxes[1]
    local size = edits[1]

    enableCheck:SetChecked(config.Enable or false)
    bgPathMenu:Update ( V.Medias:GetLSMDropDown('background'), config.Background.Texture or '' )
    borderPathMenu:Update ( V.Medias:GetLSMDropDown('border'), config.Border.Texture or '' )
    edits[1]:ChangeText( config.Border.Size or 0 )
    colors[1]:ChangeColor( config.Background.Color or { 0,0,0,1 } )
    colors[2]:ChangeColor( config.Border.Color or { 0,0,0,1 } )

    for i=2, #edits do
        edits[i]:ChangeText(config.Insets[i-1] or 0)
    end

end

local function clean(self)
    local checkboxes = LibGUI:GetWidgetsByType(self, 'checkbox')
    local dropdowns = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local insets = LibGUI:GetWidgetsByType(self, 'editbox')

    local bgPathMenu = dropdowns[1]
    local borderPathMenu = dropdowns[2]
    local enableCheck = checkboxes[1]

    enableCheck:SetChecked(false)
    bgPathMenu:Update ( nil, '' )
    borderPathMenu:Update (nil, '' )

    for i=1, #insets do
        insets[1]:ChangeText(0)
    end
end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName)

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
            Inspector:SubmitUpdateValue(nil, 'Backdrop', item.key, item.subkey, value)
        end
    end

    frame:SetHeight(300)

    local checkbox = LibGUI:NewWidget('checkbox', frame, 'EnableCheckbox', { 'TOPLEFT', 20, -10 }, nil, 'UICheckButtonTemplate', nil)
    checkbox:Update( { 'Enable' } )
    checkbox:ChangeFont( 'GameFontNormal' )
    checkbox.key = 'Enable'
    checkbox:RegisterObserver(frame.Observer)

    --[[
        Background :
            Texture dropdown
            Color Widget
    ]]--
    local bgTitle = LibGUI:NewWidget('label', frame, 'BgTitle', { 'TOPLEFT', checkbox, 'BOTTOMLEFT' }, { 100, 25 }, nil, nil)
    bgTitle:Update( { 'OVERLAY', 'Game13Font', 'Background' } )
    bgTitle:JustifyH('LEFT')

    local bgPath = LibGUI:NewWidget('label', frame, 'BgPathLabel', { 'TOPLEFT', bgTitle, 'BOTTOMLEFT' }, { 150, 30 }, nil, nil)
    bgPath:Update( { 'OVERLAY', 'GameFontNormal','Texture' } )
    local bgPathMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BgPathDropdown', { 'TOP', bgPath, 'BOTTOM' }, { 150, 25 }, nil, nil)
    bgPathMenu:Update( V.Medias:GetLSMDropDown('background') )
    bgPathMenu.key = 'Background'
    bgPathMenu.subkey = 'Texture'
    bgPathMenu:RegisterObserver(frame.Observer)

    local bgColorLabel = LibGUI:NewWidget('label', frame, 'BorderColorLabel', { 'LEFT', bgPath, 'RIGHT' }, { 150, 30 }, nil, nil)
    bgColorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Color' } )
    local bgColorwatch = LibGUI:NewWidget('color', frame, 'BorderColorwatch', { 'TOP', bgColorLabel, 'BOTTOM', 0, 0 }, { 25, 25 })
    bgColorwatch:CreateBorder( 1, { 1, 1, 1, 1 } )
    bgColorwatch.key = 'Background'
    bgColorwatch.subkey = 'Color'
    bgColorwatch:RegisterObserver(frame.Observer)

    --[[
        Border :
            Texture dropdown
            Color Widget
    ]]--
    local borderTitle = LibGUI:NewWidget('label', frame, 'BorderTitle', { 'TOPLEFT', bgPath, 'BOTTOMLEFT', 0, -30 }, { 100, 25 }, nil, nil)
    borderTitle:Update( { 'OVERLAY', 'Game13Font','Border' } )
    borderTitle:JustifyH('LEFT')

    local borderPath = LibGUI:NewWidget('label', frame, 'BorderPathLabel', { 'TOPLEFT', borderTitle, 'BOTTOMLEFT' }, { 150, 30 }, nil, nil)
    borderPath:Update( { 'OVERLAY', 'GameFontNormal','Texture' } )
    local borderPathMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BorderPathDropdown', { 'TOP', borderPath, 'BOTTOM' }, { 150, 25 }, nil, nil)
    borderPathMenu:Update( V.Medias:GetLSMDropDown('border') )
    borderPathMenu.key = 'Border'
    borderPathMenu.subkey = 'Texture'
    borderPathMenu:RegisterObserver(frame.Observer)

    local borderColorLabel = LibGUI:NewWidget('label', frame, 'BorderColorLabel', { 'LEFT', borderPath, 'RIGHT' }, { 100, 30 }, nil, nil)
    borderColorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Color' } )
    local borderColorwatch = LibGUI:NewWidget('color', frame, 'BorderColorwatch', { 'TOP', borderColorLabel, 'BOTTOM' }, { 25, 25 })
    borderColorwatch:CreateBorder( 1, { 1, 1, 1, 1 } )
    borderColorwatch.key = 'Border'
    borderColorwatch.subkey = 'Color'
    borderColorwatch:RegisterObserver(frame.Observer)

    local borderSizeLabel = LibGUI:NewWidget('label', frame, 'BorderSizeLabel', { 'LEFT', borderColorLabel, 'RIGHT' }, { 100, 30 }, nil, nil)
    borderSizeLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Size' } )
    local borderSizeEdit = LibGUI:NewWidget('editbox', frame, 'BorderSizeEditbox', { 'TOP', borderSizeLabel, 'BOTTOM' }, { 25, 25 }, 'NumericInputSpinnerTemplate', nil)
    borderSizeEdit:Update( { nil, nil, nil, {0, 10} } )
    borderSizeEdit.key = 'Border'
    borderSizeEdit.subkey = 'Size'
    borderSizeEdit:RegisterObserver(frame.Observer)

    --[[
        Insets :
            value array left, top, right, bottom
    ]]--
    local insetTitle = LibGUI:NewWidget('label', frame, 'InsetLabel', { 'TOPLEFT', borderPath, 'BOTTOMLEFT', 0, -30 }, { 100, 25 }, nil, nil)
    insetTitle:Update( { 'OVERLAY', 'Game13Font','Insets' } )
    insetTitle:JustifyH('LEFT')

    local l, e = nil, nil
    local txt
    local insetPt = { 'TOPLEFT', insetTitle, 'BOTTOMLEFT' }
    for i = 1, 4 do
        txt = insetTextArray[i]

        l = LibGUI:NewWidget('label', frame, 'InsetLabel'..txt, insetPt, { 70, 30 }, nil, nil)
        l:Update( { 'OVERLAY', 'GameFontNormal', txt } )

        e = LibGUI:NewWidget('editbox', frame, 'InsetEditbox'..txt, { 'TOPLEFT', l, 'BOTTOMLEFT', 20, 10 }, { 25, 25 }, 'NumericInputSpinnerTemplate', nil)
        e:Update( { nil, nil, nil, {0, 20} } )
        e.key = 'Insets'
        e.subkey = i
        e:RegisterObserver(frame.Observer)

        insetPt = { 'LEFT', l, 'RIGHT', 20, 0 }
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

Inspector:RegisterComponentGUI('Backdrop', gui, update, clean)
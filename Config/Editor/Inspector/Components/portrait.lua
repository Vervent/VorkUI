local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local portraitMenu = Editor.menus.portrait
local pi = math.pi

local position = {}

local function degToRad(deg)
    return deg * pi / 180
end

local function radToDeg(rad)
    return rad * 180 / pi
end

local function update(self, config)
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editWidgets = LibGUI:GetWidgetsByType(self, 'editbox')

    local typeWidget = dropdownWidgets[1]
    local rotationEdit = editWidgets[1]
    local distanceEdit = editWidgets[2]
    local xOffsetEdit = editWidgets[3]
    local yOffsetEdit = editWidgets[4]
    local zOffsetEdit = editWidgets[5]

    position[1] = math.floor( config.PostUpdate.Position[1] * 100 )
    position[2] = math.floor( config.PostUpdate.Position[2] * 100 )
    position[3] = math.floor(config.PostUpdate.Position[3] * 100 )

    typeWidget:Update( portraitMenu, config.Type )
    rotationEdit:ChangeText( radToDeg( config.PostUpdate.Rotation) )
    distanceEdit:ChangeText(config.PostUpdate.CamDistance)
    xOffsetEdit:ChangeText(position[1])
    yOffsetEdit:ChangeText(position[2])
    zOffsetEdit:ChangeText(position[3])

end

local function clean(self)
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editWidgets = LibGUI:GetWidgetsByType(self, 'editbox')

    local typeWidget = dropdownWidgets[1]
    local rotationEdit = editWidgets[1]
    local distanceEdit = editWidgets[2]
    local xOffsetEdit = editWidgets[3]
    local yOffsetEdit = editWidgets[4]
    local zOffsetEdit = editWidgets[5]

    typeWidget:Update( portraitMenu, '' )
    rotationEdit:ChangeText( 0 )
    distanceEdit:ChangeText( 0 )
    xOffsetEdit:ChangeText( 0 )
    yOffsetEdit:ChangeText( 0 )
    zOffsetEdit:ChangeText( 0 )

    position[1] = 0
    position[2] = 0
    position[3] = 0
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
            baseName..'PortraitFrame',
            nil,
            pt
    )
    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            if item.subkey == 'Rotation' then
                Inspector:SubmitUpdateValue (nil, 'Portrait', item.key, item.subkey, degToRad(value))
            elseif item.subkey == 'Position' then
                local pos = {}
                if item.field == 1 then
                    pos[1] = value /100
                    pos[2] = position[2] / 100
                    pos[3] = position[3] / 100
                elseif item.field == 2 then
                    pos[1] = position[1] /100
                    pos[2] = value / 100
                    pos[3] = position[3] / 100
                else
                    pos[1] = position[1] /100
                    pos[2] = position[2] / 100
                    pos[3] = value / 100
                end
                Inspector:SubmitUpdateValue (nil, 'Portrait', item.key, item.subkey, pos)
            else
                Inspector:SubmitUpdateValue (nil, 'Portrait', item.key, item.subkey, value)
            end
        end
    end

    frame:SetHeight(180)

    local portraitTypeLabel = LibGUI:NewWidget('label', frame, 'PortraitLabel', { 'TOPLEFT', 0, -20 }, { 80, 30}, nil, nil )
    portraitTypeLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Type' } )

    local portraitTypeDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'PortraitDropdown', { 'LEFT', portraitTypeLabel, 'RIGHT' }, { 100, 25 }, nil, nil)
    portraitTypeDropdown:Update( portraitMenu )
    portraitTypeDropdown.key = 'Type'
    portraitTypeDropdown:RegisterObserver(frame.Observer)

    local rotationLabel = LibGUI:NewWidget('label', frame, 'RotationLabel', { 'TOPLEFT', portraitTypeLabel, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    rotationLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Rotation' } )
    local rotationEdit = LibGUI:NewWidget('editbox', frame, 'RotationEdit', { 'LEFT', rotationLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    rotationEdit:Update( { nil, nil, nil, { -180, 180} } ) --TODO CONVERT DEG TO RAD
    rotationEdit.key = 'PostUpdate'
    rotationEdit.subkey = 'Rotation'
    rotationEdit:RegisterObserver(frame.Observer)

    local distanceLabel = LibGUI:NewWidget('label', frame, 'DistanceLabel', { 'LEFT', rotationEdit, 'RIGHT', 20, 0 }, { 100, 30 }, nil, nil)
    distanceLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Camera Distance' } )
    local distanceEdit = LibGUI:NewWidget('editbox', frame, 'DistanceEdit', { 'LEFT', distanceLabel, 'RIGHT', 20, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    distanceEdit:Update( { nil, nil, nil, { 0, 10 } } )
    distanceEdit.key = 'PostUpdate'
    distanceEdit.subkey = 'CamDistance'
    distanceEdit:RegisterObserver(frame.Observer)

    local offsetLabel = LibGUI:NewWidget('label', frame, 'OffsetLabel', {
        { 'TOPLEFT', rotationLabel, 'BOTTOMLEFT', 0, -4 },
        { 'RIGHT', frame }
    }, { 0, 25 }, nil, nil)
    offsetLabel:Update( { 'OVERLAY', 'Game11Font', 'Offset Settings' } )

    local OffsetXLabel = LibGUI:NewWidget('label', frame, 'OffsetXLabel', { 'TOPLEFT', offsetLabel, 'BOTTOMLEFT', 0, 0 },
            { 100, 30 }, nil, nil)
    OffsetXLabel:Update( { 'OVERLAY', 'GameFontNormal', 'X' } )

    local OffsetYLabel = LibGUI:NewWidget('label', frame, 'OffsetYLabel', { 'TOP', offsetLabel, 'BOTTOM', 0, 0 },
            { 100, 30 }, nil, nil)
    OffsetYLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Y' } )

    local OffsetZLabel = LibGUI:NewWidget('label', frame, 'OffsetZLabel', { 'TOPRIGHT', offsetLabel, 'BOTTOMRIGHT' },
            { 100, 30 }, nil, nil)
    OffsetZLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Z' } )

    local xOffsetEdit = LibGUI:NewWidget('editbox', frame, 'XOffsetEdit', { 'TOP', OffsetXLabel, 'BOTTOM' }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    xOffsetEdit:Update( { nil, nil, nil, {-10, 10} } )
    xOffsetEdit.key = 'PostUpdate'
    xOffsetEdit.subkey = 'Position'
    xOffsetEdit.field = 1
    xOffsetEdit:RegisterObserver(frame.Observer)

    local yOffsetEdit = LibGUI:NewWidget('editbox', frame, 'YOffsetEdit', { 'TOP', OffsetYLabel, 'BOTTOM' }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    yOffsetEdit:Update( { nil, nil, nil,  {-10, 10} } )
    yOffsetEdit.key = 'PostUpdate'
    yOffsetEdit.subkey = 'Position'
    yOffsetEdit.field = 2
    yOffsetEdit:RegisterObserver(frame.Observer)

    local zOffsetEdit = LibGUI:NewWidget('editbox', frame, 'ZOffsetEdit', { 'TOP', OffsetZLabel, 'BOTTOM' }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    zOffsetEdit:Update( { nil, nil, nil,  {-10, 10} } )
    zOffsetEdit.key = 'PostUpdate'
    zOffsetEdit.subkey = 'Position'
    zOffsetEdit.field = 3
    zOffsetEdit:RegisterObserver(frame.Observer)

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

Inspector:RegisterComponentGUI('Portrait', gui, update, clean)
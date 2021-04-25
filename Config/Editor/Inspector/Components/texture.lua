local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local layers = Editor.menus.layers
local blendmode = Editor.menus.blendmode

local minSubLayer = -8
local maxSubLayer = 7

local function update(self, config)
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editboxWidgets = LibGUI:GetWidgetsByType(self, 'editbox')
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')

    if type(config[1]) == 'string' then
        local texture = dropdownWidgets[1]
        texture:Update( V.Medias:GetLSMDropDown('statusbar'), config[1] )
        texture:Show()
    else
        local colorTexture = buttonWidgets[2]
        if colorTexture ~= nil then
            colorTexture.colors = colorTexture:ShallowCopyTable(config[1])
            colorTexture.texture:SetColorTexture( unpack(config[1]) )
        end
        --colortable
    end
    local layerMenu = dropdownWidgets[2]
    layerMenu:Update(layers, config[2])

    local blendingMenu = dropdownWidgets[3]
    if blendingMenu ~= nil then
        blendingMenu:Update(blendmode, config[4])
    end

    local sublayer = editboxWidgets[1]
    sublayer:ChangeText( config[3] or 0)
end

local function clean(self)

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local editboxWidgets = LibGUI:GetWidgetsByType(self, 'editbox')
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')

    local texture = dropdownWidgets[1]
    texture:Update( V.Medias:GetLSMDropDown('statusbar'), '' )
    local layerMenu = dropdownWidgets[2]
    layerMenu:Update(layers, '')

    local blendingMenu = dropdownWidgets[3]
    if blendingMenu ~= nil then
        blendingMenu:Update(blendmode, '')
    end

    local sublayer = editboxWidgets[1]
    sublayer:ChangeText( 0)

    local colorTexture = buttonWidgets[2]
    if colorTexture ~= nil then
        colorTexture.colors = { 0, 0, 0, 1 }
        colorTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    end

end

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config, isBlended)

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
            baseName..'TextureFrame',
            nil,
            pt
    )

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            Inspector:SubmitUpdateValue(nil, 'Texture', item.key, nil, value)
        end
    end

    local path = LibGUI:NewWidget('label', frame, 'PathLabel', { 'TOPLEFT', 20, 0 }, { 150, 30 }, nil, nil)
    path:Update( { 'OVERLAY', 'GameFontNormal','Texture' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, 'PathDropdown', { 'TOP', path, 'BOTTOM' }, { 150, 25 }, nil, nil)
    pathMenu:Update( V.Medias:GetLSMDropDown('statusbar') )
    pathMenu.key = 1
    pathMenu:RegisterObserver(frame.Observer)

    local btnRemove = LibGUI:NewWidget('button', frame, 'RemoveButton', { 'LEFT', path, 'LEFT', -10, 0 }, { 20, 20 }, 'UIPanelButtonTemplate')
    btnRemove:Update( { '-', function()
        pathMenu:CleanValue()
    end } )

    local colorLabel = LibGUI:NewWidget('label', frame, 'ColorLabel', { 'TOPRIGHT', -20, 0 }, { 150, 30 })
    colorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Color Texture' } )

    local colorTexture = LibGUI:NewWidget('button', frame, 'ColorButton', { 'TOP', colorLabel, 'BOTTOM', 0, 0 }, { 25 , 25} )
    colorTexture.texture = colorTexture:AddTexture()
    colorTexture.colors = { 0, 0, 0, 1 }
    colorTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    colorTexture:CreateBorder(borderSettings.size, borderSettings.color)
    colorTexture:Bind('OnClick', function(self)
        local r, g, b, a = unpack(self.colors)
        ColorPickerFrame.hasOpacity = true
        ColorPickerFrame.opacity = 1-a
        ColorPickerFrame.previousValues = self.colors
        ColorPickerFrame.func = function()
            local newR, newG, newB = ColorPickerFrame:GetColorRGB();
            self.colors[1] = newR
            self.colors[2] = newG
            self.colors[3] = newB
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify({ 'OnUpdate', self, self.colors })
        end
        ColorPickerFrame.opacityFunc = function()
            local newA = 1-OpacitySliderFrame:GetValue()
            self.colors[4] = newA
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify({ 'OnUpdate', self, self.colors })
        end
        ColorPickerFrame.cancelFunc = function(previousValues)
            self.colors = previousValues
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify({ 'OnUpdate', self, self.colors })
        end
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
        ColorPickerFrame:Show();
    end)
    colorTexture.key = 1
    colorTexture:RegisterObserver(frame.Observer)

    local layer = LibGUI:NewWidget('label', frame, 'LayerLabel', { 'TOP', pathMenu, 'BOTTOM' }, { 115, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LayerDropdown', { 'TOP', layer, 'BOTTOM' }, { 150, 25 }, nil, nil)
    layerMenu:Update(layers)
    layerMenu.key = 2
    layerMenu:RegisterObserver(frame.Observer)

    local sublayer = LibGUI:NewWidget('label', frame, 'SublayerLabel', { 'TOP', colorTexture, 'BOTTOM', 0, -5 }, { 80, 30 }, nil, nil)
    sublayer:Update( { 'OVERLAY', 'GameFontNormal','Sublayer' } )
    local sublayerEdit = LibGUI:NewWidget('editbox', frame, 'SublayerEditbox', { 'TOP', sublayer, 'BOTTOM', 0, -2 }, { 50, 25 }, 'NumericInputSpinnerTemplate', nil)
    sublayerEdit:Update( { nil, nil, nil, {minSubLayer, maxSubLayer} } )
    sublayerEdit.key = 3
    sublayerEdit:RegisterObserver(frame.Observer)

    if isBlended then
        local blend = LibGUI:NewWidget('label', frame, 'BlendLabel', { 'TOPLEFT', sublayer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
        blend:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
        local blendMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BlendDropdown', { 'TOPLEFT', sublayerEdit, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
        blendMenu:Update(blendmode)
        blendMenu.key = 4
        blendMenu:RegisterObserver(frame.Observer)

        frame:SetHeight(160)
    else
        frame:SetHeight(130)
    end

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

Inspector:RegisterComponentGUI('Texture', gui, update, clean)

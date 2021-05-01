local _, Plugin = ...
local select = select
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local blendmode = Editor.menus.blendmode
local orientation = Editor.menus.orientation

--[[
    TODO Debug Purpose
]]--

local function update(self, config, parentDropdown)
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')

    local pointFrame = self.Childs[1]
    pointFrame.Update(pointFrame, config.Point, parentDropdown)

    local sizeFrame = self.Childs[2]
    sizeFrame.Update(sizeFrame, config.Size)

    local atlasFrame = self.Childs[3]
    atlasFrame.Update(atlasFrame, config.Texture, config.TexCoord, config.VertexColor, config.BlendMode, config.GradientAlpha)

    local colorTexture = buttonWidgets[1]
    if colorTexture ~= nil and config.VertexColor ~= nil then
        colorTexture.colors = colorTexture:ShallowCopyTable(config.VertexColor)
        colorTexture.texture:SetColorTexture( unpack(config.VertexColor) )
    end

    local blendMenu = dropdownWidgets[1]
    if blendMenu~= nil then
        blendMenu:Update(blendmode, config.BlendMode or '')
    end

    local gradientMenu = dropdownWidgets[2]
    if config.GradientAlpha ~= nil then
        local array = config.GradientAlpha
        gradientMenu:Update(orientation, array[1])

        local gradientStartTexture = buttonWidgets[2]
        if gradientStartTexture ~= nil then
            gradientStartTexture.colors = { array[2], array[3], array[4], array[5] }
            gradientStartTexture.texture:SetColorTexture( array[2], array[3], array[4], array[5] )
        end

        local gradientEndTexture = buttonWidgets[3]
        if gradientEndTexture ~= nil then
            gradientEndTexture.colors = { array[6], array[7], array[8], array[9] }
            gradientEndTexture.texture:SetColorTexture( array[6], array[7], array[8], array[9] )
        end
    else
        gradientMenu:Update(orientation, '')
    end

end

local function clean(self)
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')

    local pointFrame = self.Childs[1]
    pointFrame.Clean(pointFrame)

    local atlasFrame = self.Childs[3]
    atlasFrame.Clean(atlasFrame)

    local colorTexture = buttonWidgets[1]
    if colorTexture ~= nil then
        colorTexture.colors = { 0, 0, 0, 1 }
        colorTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    end

    local blendMenu = dropdownWidgets[1]
    if blendMenu~= nil then
        blendMenu:Update(blendmode, '')
    end

    local gradientMenu = dropdownWidgets[2]
    if gradientMenu~= nil then
        gradientMenu:Update(orientation, '')
    end

    local gradientStartTexture = buttonWidgets[2]
    if gradientStartTexture ~= nil then
        gradientStartTexture.colors = { 0, 0, 0, 1 }
        gradientStartTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    end

    local gradientEndTexture = buttonWidgets[3]
    if gradientEndTexture ~= nil then
        gradientEndTexture.colors = { 0, 0, 0, 1 }
        gradientEndTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    end

end

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)

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
            baseName..'IndicatorFrame',
            nil,
            pt
    )
    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
        end
    end

    local pointFrame = Inspector:CreateComponentGUI('Point',
            'Indicator',
            frame,
            nil,
            'Point',
            {
                {'TOPLEFT', 0, -16},
                {'TOPRIGHT', 0, -16},
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
        frame.Observer.OnNotify( { event, 'Point', nil, value } )
    end
    height = height + pointFrame:GetHeight() + 16

    local sizeFrame = Inspector:CreateComponentGUI('Size', 'Indicator', frame, nil, 'Size', {
        {'TOPLEFT', pointFrame, 'BOTTOMLEFT', 0, -16},
        {'TOPRIGHT', pointFrame, 'BOTTOMRIGHT', 0, 0},
    }, true, true, true)
    if sizeFrame.Observer then
        sizeFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            frame.Observer.OnNotify( { event, 'Size', item.key, value } )
        end
    end
    height = height + sizeFrame:GetHeight() + 16

    local atlasFrame = Inspector:CreateComponentGUI('Atlas', 'Indicator', frame, sizeFrame, 'Atlas', nil,
            true, true, true)
    if atlasFrame.Observer then
        atlasFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            if item.key == 'Texture' then
                atlasFrame.Update(atlasFrame, value)
            else
                local texture, texCoord = unpack(value)
                frame.Observer.OnNotify( { event, 'Texture', nil, texture })
                frame.Observer.OnNotify( { event, 'TexCoord', nil, texCoord })
            end
        end
    end
    height = height + atlasFrame:GetHeight() + 16

    --[[
    --  VertexColor
    ]]--
    local colorLabel = LibGUI:NewWidget('label', frame, 'ColorLabel', { 'TOPLEFT', atlasFrame, 'BOTTOMLEFT', 0, -10 }, { 110, 30 })
    colorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Vertex Color' } )

    local colorTexture = LibGUI:NewWidget('button', frame, 'ColorButton', { 'LEFT', colorLabel, 'RIGHT', 0, 0 }, { 25 , 25} )
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
            self.Subject:Notify( { 'OnUpdate', self.key, nil, self.colors } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame.opacityFunc = function()
            local newA = 1-OpacitySliderFrame:GetValue()
            self.colors[4] = newA
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify( { 'OnUpdate', self.key, nil, self.colors } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame.cancelFunc = function(previousValues)
            self.colors = previousValues
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify( { 'OnUpdate', self.key, nil, self.colors } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
        ColorPickerFrame:Show();
    end)
    colorTexture.key = 'VertexColor'
    colorTexture:RegisterObserver(frame.Observer)
    height = height + 30

    --[[
    --  Blend Mode
    ]]--
    local blendLabel = LibGUI:NewWidget('label', frame, 'BlendLabel', { 'TOP', atlasFrame, 'BOTTOM', 0, -10 }, { 80, 30 }, nil, nil)
    blendLabel:Update( { 'OVERLAY', 'GameFontNormal','Blending Mode' } )
    local blendMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BlendDropdown', { 'LEFT', blendLabel, 'RIGHT' }, { 100, 25 }, nil, nil)
    blendMenu.key = 'BlendMode'
    blendMenu:RegisterObserver(frame.Observer)

    --[[
    --  GradientAlpha
    ]]--
    local gradientLabel = LibGUI:NewWidget('label', frame, 'BlendLabel', {
        { 'TOPLEFT', colorLabel, 'BOTTOMLEFT', 0, -10 },
        { 'RIGHT', frame, 'RIGHT'}
    } , { 100, 30 }, nil, nil)
    gradientLabel:Update( { 'OVERLAY', 'Game11Font','Gradient' } )
    local orientationLabel = LibGUI:NewWidget('label', frame, 'BlendLabel', { 'TOPLEFT', gradientLabel, 'BOTTOMLEFT' }, { 140, 30 }, nil, nil)
    orientationLabel:Update( { 'OVERLAY', 'GameFontNormal','Orientation' } )
    local orientationMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BlendDropdown', { 'TOP', orientationLabel, 'BOTTOM' }, { 100, 25 }, nil, nil)
    orientationMenu.key = 'GradientAlpha'
    orientationMenu.subkey = 1
    orientationMenu:RegisterObserver(frame.Observer)

    local gradientStartLabel = LibGUI:NewWidget('label', frame, 'GradientStartLabel', { 'LEFT', orientationLabel, 'RIGHT' }, { 100, 30 })
    gradientStartLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Starting Color' } )

    local gradientStartTexture = LibGUI:NewWidget('button', frame, 'GradientStartButton', { 'TOP', gradientStartLabel, 'BOTTOM' }, { 25 , 25} )
    gradientStartTexture.texture = gradientStartTexture:AddTexture()
    gradientStartTexture.colors = { 0, 0, 0, 1 }
    gradientStartTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    gradientStartTexture:CreateBorder(borderSettings.size, borderSettings.color)
    gradientStartTexture:Bind('OnClick', function(self)
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
            self.Subject:Notify( { 'OnUpdate', self.key, 2, self.colors[1] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 3, self.colors[2] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 4, self.colors[3] } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame.opacityFunc = function()
            local newA = 1-OpacitySliderFrame:GetValue()
            self.colors[4] = newA
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify( { 'OnUpdate', self.key, 5, self.colors[4] } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame.cancelFunc = function(previousValues)
            self.colors = previousValues
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify( { 'OnUpdate', self.key, 2, self.colors[1] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 3, self.colors[2] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 4, self.colors[3] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 5, self.colors[4] } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
        ColorPickerFrame:Show();
    end)
    gradientStartTexture.key = 'GradientAlpha'
    gradientStartTexture:RegisterObserver(frame.Observer)

    local gradientEndLabel = LibGUI:NewWidget('label', frame, 'GradientEndLabel', { 'LEFT', gradientStartLabel, 'RIGHT', 20, 0 }, { 100, 30 })
    gradientEndLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Ending Color' } )

    local gradientEndTexture = LibGUI:NewWidget('button', frame, 'GradientEndButton', { 'TOP', gradientEndLabel, 'BOTTOM' }, { 25 , 25} )
    gradientEndTexture.texture = gradientEndTexture:AddTexture()
    gradientEndTexture.colors = { 0, 0, 0, 1 }
    gradientEndTexture.texture:SetColorTexture( 0, 0, 0, 1 )
    gradientEndTexture:CreateBorder(borderSettings.size, borderSettings.color)
    gradientEndTexture:Bind('OnClick', function(self)
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
            self.Subject:Notify( { 'OnUpdate', self.key, 6, self.colors[1] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 7, self.colors[2] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 8, self.colors[3] } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame.opacityFunc = function()
            local newA = 1-OpacitySliderFrame:GetValue()
            self.colors[4] = newA
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify( { 'OnUpdate', self.key, 9, self.colors[4] } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame.cancelFunc = function(previousValues)
            self.colors = previousValues
            self.texture:SetColorTexture(unpack(self.colors))
            self.Subject:Notify( { 'OnUpdate', self.key, 6, self.colors[1] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 7, self.colors[2] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 8, self.colors[3] } )
            self.Subject:Notify( { 'OnUpdate', self.key, 9, self.colors[4] } )
            --frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
        end
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
        ColorPickerFrame:Show();
    end)
    gradientEndTexture.key = 'GradientAlpha'
    gradientEndTexture:RegisterObserver(frame.Observer)

    height = height + 120
    frame:SetHeight(height)
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

Inspector:RegisterComponentGUI('Indicator', gui, update, clean)
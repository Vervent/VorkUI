local _, Plugin = ...
local select = select
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

--[[
    TODO Debug Purpose
]]--

local function update(self, config, parentDropdown)
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')

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
end

local function clean(self)
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')

    local pointFrame = self.Childs[1]
    pointFrame.Clean(pointFrame)

    local atlasFrame = self.Childs[3]
    atlasFrame.Clean(atlasFrame)

    local colorTexture = buttonWidgets[1]
    if colorTexture ~= nil then
        colorTexture.colors = { 0, 0, 0, 1 }
        colorTexture.texture:SetColorTexture( 0, 0, 0, 1 )
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
            false,
            false,
            true)

    local pointTableFrame = pointFrame.Childs[2]
    --inject an observer on this frame to handle OnUpdate point
    pointTableFrame.Observer = LibObserver:CreateObserver()
    pointTableFrame.Observer.OnNotify = function(...)
        local event = select(1, ...)
        local value = select(2, ...)
        frame.Observer.OnNotify(event, 'Point', nil, value)
    end
    height = height + pointFrame:GetHeight() + 16

    local sizeFrame = Inspector:CreateComponentGUI('Size', 'Indicator', frame, nil, 'Size', {
        {'TOPLEFT', pointFrame, 'BOTTOMLEFT', 0, 0},
        {'TOPRIGHT', pointFrame, 'BOTTOMRIGHT', 0, 0},
    }, false, false, true)
    if sizeFrame.Observer then
        sizeFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            frame.Observer.OnNotify(event, 'Size', item.key, value)
        end
    end
    height = height + sizeFrame:GetHeight() + 16

    local atlasFrame = Inspector:CreateComponentGUI('Atlas', 'Indicator', frame, sizeFrame, 'Atlas', nil,
            false, false, true)
    if atlasFrame.Observer then
        atlasFrame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            if item.key == 'Texture' then
                atlasFrame.Update(atlasFrame, value)
            else
                local texture, texCoord = unpack(value)
                frame.Observer.OnNotify(event, 'Texture', nil, texture)
                frame.Observer.OnNotify(event, 'TexCoord', nil, texCoord)
            end
        end
    end
    height = height + atlasFrame:GetHeight() + 16

    --[[
    --  VertexColor
    ]]--

    local colorLabel = LibGUI:NewWidget('label', frame, 'ColorLabel', { 'TOPLEFT', atlasFrame, 'BOTTOMLEFT' }, { 100, 30 })
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
            frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
            --self.Subject:Notify({ 'OnUpdate', self.key, self.colors })
        end
        ColorPickerFrame.opacityFunc = function()
            local newA = 1-OpacitySliderFrame:GetValue()
            self.colors[4] = newA
            self.texture:SetColorTexture(unpack(self.colors))
            frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
            --self.Subject:Notify({ 'OnUpdate', self, self.colors })
        end
        ColorPickerFrame.cancelFunc = function(previousValues)
            self.colors = previousValues
            self.texture:SetColorTexture(unpack(self.colors))
            frame.Observer.OnNotify('OnUpdate', 'VertexColor', nil, self.colors)
            --self.Subject:Notify({ 'OnUpdate', self, self.colors })
        end
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
        ColorPickerFrame:Show();
    end)
    --colorTexture.key = 'VertexColor'
    --colorTexture:RegisterObserver(frame.Observer)

    height = height + 30

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
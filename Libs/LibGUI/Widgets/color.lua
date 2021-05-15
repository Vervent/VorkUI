--[[
    This widget is a classic button

    Widget Data :
    .type as internal kind of frame
    .text

    Widget Methods :
    Update (self, dataTable)
        dataTable as table to update internal system
            text
            event handler
            texture
            font
    ChangeText (self, text)
        text as new text to show
    ChangeFont (self, normalFont, disabledFont, hightlightFont)
        font as table. Can be an existing FontObject or new Font
    ChangeFontColor (self, color)
        color as colortable
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {


    ChangeColor = function(self, color)
        self.colors = color
        self.texture:SetColorTexture(unpack(color))
    end,

    RegisterObserver = function(self, entity)
        self.Subject:RegisterObserver(entity)
    end,

    UnregisterObserver = function(self, entity)
        self.Subject:UnregisterObserver(entity)
    end
}

local function enable(self)
    if self.type ~= 'color' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end

end

local function disable(self)
    if self.type ~= 'color' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function() end)
    end

end

local function openColorPicker(self)
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
end

local function bindScript(self, event, fct)
    if self.type ~= 'color' then
        return
    end
    self.Scripts[event] = fct
end

local function create(parent, name, point, size)
    local button = CreateFrame('Button', name, parent)

    button:SetScript("OnShow", enable)
    button:SetScript("OnHide", disable)
    button.Scripts = {}
    button.autoResize = false
    button.texture = button:CreateTexture('Texture', 'BACKGROUND')
    button.texture:SetAllPoints()
    button.colors = { 0, 0, 0, 1 }
    button.texture:SetColorTexture( unpack(button.colors) )

    bindScript(button, 'OnClick', openColorPicker)

    if point then
        if type(point[1]) == 'table' then
            for _, p in pairs(point) do
                button:SetPoint(unpack(p))
            end
        else
            button:SetPoint( unpack(point) )
        end
    end
    if size then
        button:SetSize(unpack(size))
    end

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(button, { __index = setmetatable(Methods, getmetatable(button))})

    local LibObserver = LibStub:GetLibrary("LibObserver")
    button.Subject = LibObserver:CreateSubject()

    return button
end

LibGUI:RegisterWidget('color', create, enable, disable)
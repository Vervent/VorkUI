--[[
    This widget embed just a label

    Widget Data :
    .type as internal kind of frame
    .text

    Widget Methods :
    ChangeText (self, text)
        text as new text to show
    ChangeFont (self, font)
        font as table. Can be an existing FontObject or new Font
    ChangeFontColor (self, color)
        color as colortable
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {

    ChangeText = function(self, text)
        self.text = text
        self:SetText(text)
    end,

    ChangeFont = function(self, font)
        if type(font) == 'table' then
            if font.GetObjectType and font:GetObjectType() == 'Font' then
                self:SetFontObject(font)
            else
                self:SetFont(unpack(font))
            end
        end
    end,

    ChangeFontColor = function(self, color)
        self:SetTextColor(unpack(color))
    end
}

local function create(container, point, name, layer, ...)
   local label = container:CreateFontString(name, layer, ...)

    if point then
        label:SetPoint( unpack(point) )
    end

    label:SetSize(200, 20)
    label.text = ""

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(label, { __index = setmetatable(Methods, getmetatable(label))})

    return label
end

local function update(self, text, font)

    if self.type ~= 'label' then
        return
    end

    if font and self:GetFont() ~= font[1] then
        self.SetFont(unpack(font))
    end

    self.SetText(text)

end

local function enable(self)

end

local function disable(self)

end

LibGUI:RegisterWidget('label', create, enable, disable, update )
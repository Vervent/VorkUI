--[[
    This widget embed just a label

    Widget Data :
    .type as internal kind of frame
    .text

    Widget Methods :
    Update (self, dataTable)
        dataTable as table to update internal system
            layer
            text
            font
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

    --TODO UPDATE THIS FUNC FOR MORE DATA
    Update = function (self, dataTable)
        local layer, font, text = unpack(dataTable)
        self:SetDrawLayer(layer or 'ARTWORK')
        self:ChangeFont(font)
        self:ChangeText(text or '')
    end,

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
        elseif type(font) == 'string' then
            self:SetFontObject(font)
        end
    end,

    ChangeFontColor = function(self, color)
        self:SetTextColor(unpack(color))
    end
}

local function create(container, name, point, size, layer, ...)
   local label = container:CreateFontString(name, layer, ...)

    if point then
        label:SetPoint( unpack(point) )
    end

    if size then
        label:SetSize( unpack(size) )
    end

    label.text = ""

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(label, { __index = setmetatable(Methods, getmetatable(label))})

    return label
end

local function enable(self)

end

local function disable(self)

end

LibGUI:RegisterWidget('label', create, enable, disable )
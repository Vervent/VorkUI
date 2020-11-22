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

    Bind = function(self, event, fct)
        self:SetScript(event, fct)
    end,

    Update = function(self, dataTable)

        local text = unpack(dataTable)
        self:ChangeText(text)
    end,

    ChangeText = function(self, text)
        self.text:SetText(text)
    end,

    ChangeTexture = function(self, normalTexture, disabledTexture, highlightTexture, pushedTexture)
        self:SetNormalTexture(normalTexture)
        self:SetHighlightTexture(highlightTexture or normalTexture)
        self:SetPushedTexture(pushedTexture or normalTexture)
        --CheckedTexture
        --DisabledCheckedTexture
    end,

    ChangeFont = function(self, font)
        if type(font) == 'table' then
            if font.GetObjectType and font:GetObjectType() == 'Font' then
                self.text:SetFontObject(font)
            else
                self.text:SetFont(unpack(font))
            end
        elseif type(font) == 'string' then
            self.text:SetFontObject(font)
        end
    end,

    ChangeFontColor = function(self, color)
        self.text:SetTextColor(unpack(color))
    end
}

local function enable(self)
    if self.type ~= 'checkbox' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end

end

local function disable(self)
    if self.type ~= 'checkbox' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function() end)
    end

end

local function onClick(self)
    self.isChecked = self:GetChecked()
end

local function create(parent, name, point, size, template)
    local checkbutton = CreateFrame('CheckButton', name, parent, template)

    checkbutton:SetScript("OnShow", enable)
    checkbutton:SetScript("OnHide", disable)
    checkbutton:SetScript("OnClick", onClick)
    checkbutton.Scripts = {}
    checkbutton.isChecked = false


    if point then
        checkbutton:SetPoint(unpack(point))
    end

    if size then
       checkbutton:SetSize(unpack(size))
    end

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(checkbutton, { __index = setmetatable(Methods, getmetatable(checkbutton))})

    return checkbutton
end

LibGUI:RegisterWidget('checkbox', create, enable, disable)
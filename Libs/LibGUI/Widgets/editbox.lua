--[[
    This widget is an editbox

    Widget Data :
    .type as internal kind of frame

    Widget Methods :
    Update (self, dataTable)
        dataTable as table to update internal system
            text
    ChangeText (self, text)
        text as new text to show
    TextChanged (self)
        modify self.text to be edited text
    ChangeFont (self, normalFont, disabledFont, hightlightFont)
        font as table. Can be an existing FontObject or new Font
    ChangeFontColor (self, color)
        color as colortable
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {

    --TODO UPDATE THIS FUNC FOR MORE DATA
    Update = function (self, dataTable)
        local text, font, color, minmax = unpack(dataTable)
        if text then
            self:ChangeText(text)
        end

        self:ChangeFont(font)

        if color then
            self:ChangeFontColor(color)
        end

        if self.SetMinMaxValues then
            self:SetMinMax(unpack(minmax))
        end
    end,

    SetMinMax = function(self, min, max)
        if self.SetMinMaxValues then
            self:SetMinMaxValues(min, max)
        end
    end,

    ChangeText = function(self, text)

        if text == nil then
            if self.SetValue then
                text = 0
            else
                text = ''
            end
        end
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
    end,

    RegisterObserver = function(self, entity)
        self.Subject:RegisterObserver(entity)
    end,

    UnregisterObserver = function(self, entity)
        self.Subject:UnregisterObserver(entity)
    end
}

local function enable(self)
    if self.type ~= 'editbox' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end

end

local function disable(self)
    if self.type ~= 'editbox' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function() end)
    end

end

local function bindScript(self, event, fct)
    if self.type ~= 'editbox' then
        return
    end
    self.Scripts[event] = fct
end

local function create(parent, name, point, size, template)

    local edit = CreateFrame('Editbox', name, parent, template)

    edit:SetScript("OnShow", enable)
    edit:SetScript("OnHide", disable)
    edit.Scripts = {}

    if point then
        edit:SetPoint(unpack(point))
    end
    if size then
        edit:SetSize(unpack(size))
    end

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(edit, { __index = setmetatable(Methods, getmetatable(edit))})

    edit:HookScript('OnTextChanged', function(self)

        if edit.SetValue then
            self.Subject:Notify({ 'OnUpdate', self,  self:GetValue() })
        else
            self.Subject:Notify({ 'OnUpdate', self,  self:GetText() })
        end
    end)

    if edit.SetValue then
        edit:SetNumeric(false)
        edit:SetMaxLetters(8)
        edit:SetValue(0)
    else
        edit:ChangeText('')
    end

    if template == nil then
        --add background
        edit.bg = edit:CreateTexture(nil, "BACKGROUND")
        edit.bg:SetAllPoints()
        edit.bg:SetColorTexture(0, 0, 0, 0.5)

        edit:SetAutoFocus(false)
        edit:ClearFocus()
        edit:SetTextInsets(2, 2, 2, 2)
        edit.Scripts['OnEnterPressed'] = edit.ClearFocus
        edit.Scripts['OnEscapePressed'] = edit.ClearFocus
    end

    local LibObserver = LibStub:GetLibrary("LibObserver")
    edit.Subject = LibObserver:CreateSubject()

    return edit
end

LibGUI:RegisterWidget('editbox', create, enable, disable)
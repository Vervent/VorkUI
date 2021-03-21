--[[
    This widget is an editbox

    Widget Data :
    .type as internal kind of frame
    .text

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
local profile

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
            self:SetMinMaxValues(unpack(minmax))
        end
    end,

    ChangeText = function(self, text)
        self.text = text
        self:SetText(text)
    end,

    TextChanged = function(self, userinput)

        if self:HasFocus() == false then
            return
        end

        if self.SetValue then
            self.text = self:GetNumber()
            self:SetValue( tonumber( self.text ) or 0)
        else
            self.text = self:GetText()
        end

        self.Subject:Notify({ 'OnUpdate', self, self.text })

        --if self.DBOption then
        --    profile:UpdateOption( self.DBOption, self.text )
        --end

        self:ChangeText(self.text)

        return self.text
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

local function create(parent, name, point, size, template, dboption)

    profile = LibGUI:GetProfile()
    local edit = CreateFrame('Editbox', name, parent, template)

    edit:SetScript("OnShow", enable)
    edit:SetScript("OnHide", disable)
    edit:SetAutoFocus(false)
    edit:ClearFocus()
    edit:SetTextInsets(2, 2, 2, 2)
    edit.Scripts = {}
    --edit.DBOption = dboption

    if point then
        edit:SetPoint(unpack(point))
    end
    if size then
        edit:SetSize(unpack(size))
    end

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(edit, { __index = setmetatable(Methods, getmetatable(edit))})

    edit.Scripts['OnTextChanged'] = edit.TextChanged
    edit.Scripts['OnEnterPressed'] = edit.TextChanged
    edit.Scripts['OnEscapePressed'] = edit.ClearFocus

    local initialVal = ''

    if edit.SetValue then
        edit:SetNumeric(false)
        edit:SetMaxLetters(5)

        edit:SetValue(tonumber(initialVal) or 0)
    else
        edit:SetMaxLetters(255)
        edit:ChangeText( initialVal )
    end

    if template == nil then
        --add background
        edit.bg = edit:CreateTexture(nil, "BACKGROUND")
        edit.bg:SetAllPoints()
        edit.bg:SetColorTexture(0, 0, 0, 0.5)
    end

    local LibObserver = LibStub:GetLibrary("LibObserver")
    edit.Subject = LibObserver:CreateSubject()

    return edit
end

LibGUI:RegisterWidget('editbox', create, enable, disable)
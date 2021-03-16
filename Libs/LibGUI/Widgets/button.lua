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

    --TODO UPDATE THIS FUNC FOR MORE DATA
    Update = function (self, dataTable)
        local text, onClick = unpack(dataTable)
        self:ChangeText(text)
        self:SetScript('OnClick', onClick)
    end,

    UpdateSize = function(self, xPadding, yPadding)
        self:SetSize(self:GetFontString():GetWrappedWidth() + (xPadding or 10)*2, self:GetFontString():GetStringHeight() + (yPadding or 4)*2)
    end,

    ChangeText = function(self, text)
        self.text = text
        self:SetText(text)
        if self.autoResize then
            self:UpdateSize()
        end
    end,

    ChangeColor = function(self, color)
        if self.icon then
            if self.icon:GetTexture() ~= nil then
                self.icon:SetVertexColor(unpack(color))
            else
                self.icon:SetColorTexture(unpack(color))
            end
        end
    end,

    ChangeTexture = function(self, normalTexture, disabledTexture, highlightTexture, pushedTexture)
        self:SetNormalTexture(normalTexture)
        self:SetDisabledTexture(disabledTexture or normalTexture)
        self:SetHighlightTexture(highlightTexture or normalTexture)
        self:SetPushedTexture(pushedTexture or normalTexture)
    end,

    ChangeFont = function(self, normalFont,  disabledFont, highlightFont)

        if type(normalFont) == 'table' then
            if normalFont.GetObjectType and normalFont:GetObjectType() == 'Font' then
                self:SetNormalFontObject(normalFont)
            end
        end

        if type(disabledFont) == 'table' then
            if disabledFont.GetObjectType and disabledFont:GetObjectType() == 'Font' then
                self:SetDisabledFontObject(disabledFont)
            end
        end

        if type(normalFont) == 'table' then
            if normalFont.GetObjectType and normalFont:GetObjectType() == 'Font' then
                self:SetHighlightFontObject(highlightFont)
            end
        end
    end,

    ChangeFontColor = function(self, color)
        self:SetTextColor(unpack(color))
    end,

    AddLabel = function(self, frame, text)
        if self.Text then
            return
        end

        self.Text = frame:CreateFontString()
        self.Text:SetAllPoints()
        self.Text:SetFontObject('Game11Font')
        self.Text:SetText(text or '')

    end,

    HasCollapseSystem = function(self)
        return self.isCollapsed ~= nil
    end,

    AddCollapseSystem = function(self, frame, collapseFct, expandFct)
        if frame == nil then
            return
        end
        self.isCollapsed = false
        frame.frameHeight = frame:GetHeight()
        self:SetScript('OnClick', function(self)
            if self.isCollapsed then
                frame:SetHeight(frame.frameHeight)
                expandFct(frame)
                self.isCollapsed = false
            else
                frame:SetHeight(10)
                collapseFct(frame)
                self.isCollapsed = true
            end
        end)
    end
}

local function enable(self)
    if self.type ~= 'button' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end

end

local function disable(self)
    if self.type ~= 'button' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function() end)
    end

end

local function create(parent, name, point, size, template)
    local button = CreateFrame('Button', name, parent, template)

    button:SetScript("OnShow", enable)
    button:SetScript("OnHide", disable)
    button.Scripts = {}
    button.autoResize = false

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

    return button
end

local function bindScript(self, event, fct)
        if self.type ~= 'button' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterWidget('button', create, enable, disable)
--[[
    This container is just a Frame with a background if no backdrop
        - can use Blizz Template

    Frame Data :
    .type as internal kind of frame
    .Childs as table of child container
    .Widgets as table of widgets
    .Events as table of event binded

    Skin Data :
    .bg as texture if not BackdropTemplate
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local function create(parent, name, size, point, template)

    local frame = CreateFrame('Frame', name, parent, template)

    if template ~= 'BackdropTemplate' then
        frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
        frame.bg:SetAllPoints()
        frame.bg:SetColorTexture(0, 0, 0, 0.25)
    else
        frame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        frame:SetBackdropColor(0, 0, 1, 1)
    end

    frame.Childs = {}
    frame.Widgets = {}
    frame.Scripts = {}

    if point then
        frame:SetPoint(unpack(point))
    end
    if size then
        frame:SetSize(unpack(size))
    end

    return frame
end

local function enable(self)
    if self.type ~= 'frame' then
        return
    end

    for e, f in pairs(self.Scripts) do
        print (e, f)
        self:SetScript(e, f)
    end

    for _, c in ipairs(self.Widgets) do
        c:Show()
    end

    for _, c in ipairs(self.Childs) do
        c:Show()
    end
end

local function disable(self)
    if self.type ~= 'frame' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function() end)
    end

    for i, c in pairs(self.Widgets) do
        c:Hide()
    end

    for i, c in pairs(self.Childs) do
        c:Hide()
    end
end

local function bindScript(self, event, fct)
    print (self.type, event, fct)

    if self.type ~= 'frame' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterContainer('frame', create, enable, disable, bindScript)
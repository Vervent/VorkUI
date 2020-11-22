--[[
    This container is just an empty Frame without graphics, it's just an empty container

    Frame Data :
    .type as internal kind of frame
    .Childs as table of child container
    .Widgets as table of widgets
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local function create(parent, name, size, point)

    local frame = CreateFrame('Frame', name, parent)
    frame.Childs = {}
    frame.Widgets = {}
    frame.enableAllChilds = true

    if point then
        frame:SetPoint(unpack(point))
    end
    if size then
        frame:SetSize(unpack(size))
    end
    return frame
end

local function enable(self)
    if self.type ~= 'empty' then
        return
    end

    for _, w in ipairs(self.Widgets) do
        w:Show()
    end

    if self.enableAllChilds then
        for _, c in ipairs(self.Childs) do
            c:Show()
        end
    end
end

local function disable(self)
    if self.type ~= 'empty' then
        return
    end

    for i, c in pairs(self.Widgets) do
        c:Hide()
    end

    for i, c in pairs(self.Childs) do
        c:Hide()
    end
end

LibGUI:RegisterContainer('empty', create, enable, disable)
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
        if type(point) == 'table' then
            if type(point[1]) == 'table' then
                --tricks to manage multi pointing anchor
                for _, p in pairs(point) do
                    frame:SetPoint(unpack(p))
                end
            else
                frame:SetPoint(unpack(point))
            end

        else
            frame:SetAllPoints()
        end
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

    if self.AfterEnable then
        self:AfterEnable()
    end
end

local function disable(self)
    if self.type ~= 'empty' then
        return
    end

    if self.BeforeDisable then
        self:BeforeDisable()
    end

    for i, c in pairs(self.Widgets) do
        c:Hide()
    end

    for i, c in pairs(self.Childs) do
        c:Hide()
    end
end

LibGUI:RegisterContainer('empty', create, enable, disable)
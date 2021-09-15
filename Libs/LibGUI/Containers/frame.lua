--[[
    This container is just a Frame with a background if no backdrop
        - can use Blizz Template

    Frame Data :
    .type as internal kind of frame
    .Childs as table of child container
    .Widgets as table of widgets
    .Events as table of event binded

]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local function create(parent, name, size, point, template)

    local frame = CreateFrame('Frame', name, parent, template)

    frame.Childs = {}
    frame.Widgets = {}
    frame.Scripts = {}
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
    if self.type ~= 'frame' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
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
    if self.type ~= 'frame' then
        return
    end

    if self.BeforeDisable then
        self:BeforeDisable()
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

    if self.type ~= 'frame' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterContainer('frame', create, enable, disable, bindScript)
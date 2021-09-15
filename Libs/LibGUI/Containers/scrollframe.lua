--[[
    This container is just an empty Frame without graphics, it's just an empty container

    Frame Data :
    .type as internal kind of frame
    .Childs as table of child container
    .Widgets as table of widgets
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI


local Methods = {

    UpdateSize = function(self, size)
        if not size then
            return
        end
        if type(size) == 'table' then
            local w, h = unpack(size)
            w = w - self.ScrollUpButton:GetWidth()
            self:SetSize(w, h)
            self.ScrollChild:SetSize(w, h*2)
        elseif type(size) == 'number' then
            self:SetSize(size - self.ScrollUpButton:GetWidth(), size)
            self.ScrollChild:SetSize(size - self.ScrollUpButton:GetWidth(), size*2)
        end
    end,

    ResizeScrollChild = function(self, offsetY)
        local height = 0

        for i, c in ipairs(self.ScrollChild.Childs) do
            if c:IsShown() then
                height = height + c:GetHeight() + (offsetY or 0)
            end
        end

        for i, c in ipairs(self.ScrollChild.Widgets) do
            if c:IsShown() then
                height = height + c:GetHeight() + (offsetY or 0)
            end
        end

        self.ScrollChild:SetHeight(height + 16)
    end,

    ShowScrollChild = function (self)
        self.ScrollChild:Show()
    end,

    HideScrollChild = function (self)
        self.ScrollChild:Hide()
    end,
}


local function create(parent, name, size, point)

    local frame = CreateFrame('ScrollFrame', name, parent, 'UIPanelScrollFrameTemplate')
    frame.Childs = {}
    frame.Widgets = {}
    frame.enableAllChilds = true
    frame.enableAllWidgets = true

    local scrollChild = LibGUI:NewContainer('empty', frame, name..'ScrollChildFrame')

    local scrollbar = frame.ScrollBar
    local scrollup = scrollbar.ScrollUpButton
    local scrolldown = scrollbar.ScrollDownButton
    local thumbTexture = scrollbar.ThumbTexture

    scrollup:ClearAllPoints()
    scrollup:SetPoint('TOPLEFT', frame, 'TOPRIGHT', 2, -2)

    scrolldown:ClearAllPoints()
    scrolldown:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT', 2, 2)

    scrollbar:ClearAllPoints()
    scrollbar:SetPoint('TOP', scrollup, 'BOTTOM', 0, -2)
    scrollbar:SetPoint('BOTTOM', scrolldown, 'TOP', 0, 2)

    frame:SetScrollChild(scrollChild)

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
        local w, h = unpack(size)
        w = w - scrollup:GetWidth()
        frame:SetSize(w, h)
        scrollChild:SetSize(w, h*2)
    end

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(frame, { __index = setmetatable(Methods, getmetatable(frame)) })

    frame.ScrollChild = scrollChild
    return frame
end

local function enable(self)
    if self.type ~= 'scrollframe' then
        return
    end

    if self.enableAllWidgets then
        for _, w in ipairs(self.Widgets) do
            w:Show()
        end
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
    if self.type ~= 'scrollframe' then
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

LibGUI:RegisterContainer('scrollframe', create, enable, disable)
--[[
    This container is an uniform scrolling list system. It works only with uniform widgets/childs
    It used the blizzard 'FauxScrollFrameTemplate'
    It doesn't scroll frame, it fakes every scroll with :
        - scrollbar
        - uniform restricted number of widgets with internal update for content

    Frame Data :
    .type as internal kind of frame
    .Childs as table of childs. Can be other containers like button or widgets like label
    .ChildData as table of data to show for every childs. Will be use to call the update func on childs
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local function scrollUpdate(self)
    local offset = FauxScrollFrame_GetOffset(self)

    if (#self.WidgetData > #self.Widgets) then
        FauxScrollFrame_Update(self, #self.WidgetData, #self.Widgets, self.WidgetHeight)
    end

    for line = 1, #self.Widgets do
        self.Widgets[line]:Update(self.WidgetData[line + offset])
        self.Widgets[line]:Show()
    end
end

local function onVerticalScroll(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, self.WidgetHeight, scrollUpdate)
end

local Methods = {
    AddWidget = function(self, type, subtype, size, widgetData, ...)
        if #self.Widgets > 0 and self.WidgetType ~= type and self.WidgetSubType ~= subtype then
            print("YOU CAN'T ADD NON UNIFORM CHILD IN THE 'scrollUniformList'")
            return
        end
        self.WidgetType = type
        self.WidgetSubType = subtype
        if size[1] > self.WidgetWidth then
            self.WidgetWidth = size[1]
        end
        if size[2] > self.WidgetHeight then
            self.WidgetHeight = size[2]
        end

        tinsert(self.WidgetData, widgetData)

        self.Data = ...
    end,

    RemoveWidget = function(self, index)
        tremove(self.ChildData, index)
    end,

    CreateWidgets = function(self)
        local wHeight = self.WidgetHeight
        local wCount = math.min(math.floor(self:GetHeight() / wHeight + 0.5) - 1, #self.WidgetData)
        local t = self.WidgetType
        local name = (self:GetName() or '') .. self.WidgetSubType

        local w
        for i = 0, wCount do
            if t == 'widget' then
                w = LibGUI:NewWidget(
                        self.WidgetSubType,
                        self,
                        name .. i,
                        { "TOPLEFT", 0, -i * wHeight },
                        {self.WidgetWidth, self.WidgetHeight},
                        self.Data
                )
            elseif t == 'container' then
                print ("scrolluniformlist.lua want to add container as widget")
                --LibGUI:NewContainer(self.WidgetSubType, self, name .. i, { self.WidgetWidth, wHeight }, { "TOPLEFT", 0, -i * wHeight }, self.Data)
            end
        end
    end
}

local function create(parent, name, size, point)

    local scrollframe = CreateFrame('ScrollFrame', name, parent, 'FauxScrollFrameTemplate')
    scrollframe.WidgetData = {}
    scrollframe.Widgets = {}
    scrollframe.WidgetType = ''
    scrollframe.WidgetSubType = ''
    scrollframe.WidgetWidth = 0
    scrollframe.WidgetHeight = 0

    scrollframe.Scripts = {}
    scrollframe.Scripts['OnVerticalScroll'] = onVerticalScroll

    scrollframe.enableAllWidgets = true

    if point then
        if type(point) == 'table' then
            if type(point[1]) == 'table' then
                --tricks to manage multi pointing anchor
                for _, p in pairs(point) do
                    scrollframe:SetPoint(unpack(p))
                end
            else
                scrollframe:SetPoint(unpack(point))
            end

        else
            scrollframe:SetAllPoints()
        end
    end
    if size then
        scrollframe:SetSize(unpack(size))
    end

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(scrollframe, { __index = setmetatable(Methods, getmetatable(scrollframe)) })

    return scrollframe
end

local function bindScript(self, event, fct)
    if self.type ~= 'scrolluniformlist' then
        return
    end
    --print(event, fct)
    self.Scripts[event] = fct
end

local function enable(self)
    if self.type ~= 'scrolluniformlist' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end

    if self.enableAllWidgets then
        for _, c in ipairs(self.Widgets) do
            c:Show()
        end
    end

    scrollUpdate(self)

end

local function disable(self)
    if self.type ~= 'scrolluniformlist' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function()
        end)
    end

    for i, c in ipairs(self.Widgets) do
        c:Hide()
    end
end

LibGUI:RegisterContainer('scrolluniformlist', create, enable, disable, bindScript)
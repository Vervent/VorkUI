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

    if (#self.ChildData > #self.Childs) then
        FauxScrollFrame_Update(self, #self.ChildData, #self.Childs, self.ChildHeight)
    end

    for line = 1, #self.Childs do
        self.Childs[line]:Update(self.ChildData[line + offset])
        self.Childs[line]:Show()
    end
end

local function onVerticalScroll(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, self.ChildHeight, scrollUpdate)
end

local Methods = {
    AddChild = function(self, type, subtype, size, childData, ...)
        if #self.Childs > 0 and self.ChildType ~= type and self.ChildSubType ~= subtype then
            print("YOU CAN'T ADD NON UNIFORM CHILD IN THE 'scrollUniformList'")
            return
        end
        self.ChildType = type
        self.ChildSubType = subtype
        if size[1] > self.ChildWidth then
            self.ChildWidth = size[1]
        end
        if size[2] > self.ChildHeight then
            self.ChildHeight = size[2]
        end
        tinsert(self.ChildData, childData)

        self.Others = ...
    end,

    RemoveChild = function(self, index)
        tremove(self.ChildData, index)
    end,

    CreateChilds = function(self)
        local childHeight = self.ChildHeight
        local childCount = math.min(math.floor(self:GetHeight() / childHeight + 0.5) - 1, #self.ChildData)
        local t = self.ChildType
        local name = (self:GetName() or "") .. self.ChildSubType

        local w
        for i = 1, childCount do
            if t == 'widget' then
                w = LibGUI:NewWidget(
                        self.ChildSubType,
                        self,
                        name .. i,
                        { "TOPLEFT", 0, -i * childHeight },
                        {self.ChildWidth, self.ChildHeight},
                        self.Others
                )
                tinsert(self.Childs, w)
            elseif t == 'container' then
                LibGUI:NewContainer(self.ChildSubType, self, name .. i, {self.ChildWidth, childHeight}, { "TOPLEFT", 0, -i * childHeight }, self.Others)
            end
        end
    end
}

local function create(parent, name, size, point)

    local scrollframe = CreateFrame('ScrollFrame', name, parent, 'FauxScrollFrameTemplate')
    scrollframe.ChildData = {}
    scrollframe.Childs = {}
    scrollframe.ChildType = ''
    scrollframe.ChildSubType = ''
    scrollframe.ChildWidth = 0
    scrollframe.ChildHeight = 0

    scrollframe.Scripts = {}
    scrollframe.Scripts['OnVerticalScroll'] = onVerticalScroll

    scrollframe.enableAllChilds = true

    if point then
        scrollframe:SetPoint(unpack(point))
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
    print(event, fct)
    self.Scripts[event] = fct
end

local function enable(self)
    if self.type ~= 'scrolluniformlist' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end

    if self.enableAllChilds then
        for _, c in ipairs(self.Childs) do
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

    for i, c in pairs(self.Childs) do
        c:Hide()
    end
end

LibGUI:RegisterContainer('scrolluniformlist', create, enable, disable, bindScript)
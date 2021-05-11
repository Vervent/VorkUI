--[[
    This container is just an empty Frame without graphics, it's just an empty container

    Frame Data :
    .type as internal kind of frame
    .Childs as table of child container
    .Widgets as table of widgets
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI
local pairs = pairs
local ipairs = ipairs
local unpack = unpack
local select = select
local tinsert = tinsert
local type = type
local CreateFrame = CreateFrame
local setmetatable = setmetatable
local getmetatable = getmetatable

local colors = {
    { 1, 1, 1, 0.3 },
    { 1, 1, 1, 0 },
}

local Methods = {

    SetConfiguration = function(self, ...)
        local w
        for i=1, select('#', ...) do
            w = select(i, ...)
            tinsert(self.configuration, w)
        end
    end,

    AddConfiguration = function(self, ...)
        local type, name, data = unpack(...)
        local config = {
            ['type'] = type,
            ['name'] = name,
            ['data'] = data
        }
        tinsert(self.configuration, config)
    end,

    AddRow = function(self)
        local width, height = self:GetSize()
        local wHeight = 0

        local nbRow = #self.Childs + 1
        local pt
        if nbRow == 1 then
            pt = {
                {'TOPLEFT', self:GetName(), 'TOPLEFT', 4, -8},
                {'TOPRIGHT', self:GetName(), 'TOPRIGHT', -4, -8}
            }
        else
            pt = {
                {'TOPLEFT', 'row'..nbRow-1, 'BOTTOMLEFT'},
                {'TOPRIGHT', 'row'..nbRow-1, 'BOTTOMRIGHT'}
            }
        end
        local row = LibGUI:NewContainer('empty', self, 'row'..nbRow, nil, pt)
        row.bg = row:CreateTexture('BACKGROUND')
        row.bg:SetAllPoints()
        if self.alternateColor == true then
            row.bg:SetColorTexture( unpack( colors[nbRow % 2 + 1] ) )
        end

        local anchor = row
        local w
        local h
        for i, v in ipairs(self.configuration) do
            w = LibGUI:NewWidget(v.type, row, v.name, unpack(v.data))

            if i == 1 then
                w:SetPoint( 'LEFT', anchor, 'LEFT')
            else
                w:SetPoint( 'LEFT', anchor, 'RIGHT')
            end
            if v.type == 'editbox' then
                w:ChangeFont( 'Game11Font' )

            end

            h = w:GetHeight()
            if h > wHeight then
                wHeight = h
            end

            anchor = w
        end

        row:SetSize(width - 8, wHeight)
        self:SetHeight(height + wHeight)
    end,

    GetRowCount = function(self)
        return #self.Childs
    end,

    AddRows = function (self, nbRow)
        for i=1, nbRow do
            self:AddRow()
        end
    end,

    HideRow = function (self, id)
        if self.Childs[id] ~= nil then
            self.Childs[id]:Hide()
        end
    end,

    ShowRow = function (self, id)
        if self.Childs[id] ~= nil then
            self.Childs[id]:Show()
        end
    end,

    HideRows = function (self, rows)
        for i, v in ipairs(rows) do
            if type(v) == 'number' then
                self:HideRow( v )
            end
        end
    end,

    ShowRows = function (self, rows)
        for i, v in ipairs(rows) do
            if type(v) == 'number' then
                self:ShowRow( v )
            end
        end
    end

}

local function create(parent, name, size, point)

    local frame = CreateFrame('Frame', name, parent)
    frame.Childs = {}
    frame.Widgets = {}
    frame.Scripts = {}
    frame.enableAllChilds = true
    frame.configuration = {}
    frame.alternateColor = true

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

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(frame, { __index = setmetatable(Methods, getmetatable(frame))})

    return frame
end

local function enable(self)
    if self.type ~= 'sheet' then
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
    if self.type ~= 'sheet' then
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

    if self.type ~= 'sheet' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterContainer('sheet', create, enable, disable, bindScript)
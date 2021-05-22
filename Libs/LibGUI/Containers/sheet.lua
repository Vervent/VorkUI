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


local function createWidget(self, config, pt)
    local w = LibGUI:NewWidget(config.type, self, config.name, unpack(config.data))
    w:SetPoint( unpack( pt ) )
    if config.type == 'editbox' then
        w:ChangeFont( 'Game11Font' )
    elseif config.type == 'checkbox' then
        w:ChangeFont( 'GameFontNormal' )
    elseif config.type == 'label' then
        w:JustifyH('LEFT')
    end
    return w
end

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

    ResetConfiguration = function(self)
        self.configuration = {}
    end,

    ResetConfigurationByRow = function(self, r)
        local row = self.GetRow( r )
        if row.configuration ~= nil then
            row.configuration = {}
        end
    end,

    AddConfigurationToRowByTable = function(self, r, ...)
        local w
        local row = self:GetRow(r)
        if row.configuration ~= nil then
            for i=1, select('#', ...) do
                w = select(i, ...)
                tinsert(row.configuration, w)
            end
        end
    end,

    AddConfigurationToRow = function(self, r, ...)
        local type, name, data = unpack(...)
        local config = {
            ['type'] = type,
            ['name'] = name,
            ['data'] = data
        }
        local row = self:GetRow( r )
        if row.configuration ~= nil then
            tinsert(row.configuration, config)
        end
    end,

    GenerateWidgetsByRow = function(self, r)
        local width = self:GetWidth()
        local row = self:GetRow(r)
        local wHeight = 0
        if row.configuration ~= nil and #row.configuration > 0 then
            local anchor = row
            local w
            local h
            for i, v in ipairs(row.configuration) do
                if i == 1 then
                    w = createWidget(row, v, { 'LEFT', anchor, 'LEFT' })
                else
                    w = createWidget(row, v, { 'LEFT', anchor, 'RIGHT' })
                end

                h = w:GetHeight()
                if h > wHeight then
                    wHeight = h
                end

                --anchor = w
                --use this hack to overlap all remaining widget in the 3rd column
                if i < 3 then
                    anchor = w
                end
            end
        end

        row:SetSize(width - 8, wHeight)
    end,

    AddRow = function(self)
        local width, height = self:GetSize()
        local wHeight = 0
        local colCount = self.columnCount

        local nbRow = #self.Childs + 1
        local pt
        if nbRow == 1 then
            pt = {
                {'TOPLEFT', self:GetName(), 'TOPLEFT', 4, 0},
                {'TOPRIGHT', self:GetName(), 'TOPRIGHT', -4, 0}
            }
        else
            pt = {
                {'TOPLEFT', 'row'..nbRow-1, 'BOTTOMLEFT'},
                {'TOPRIGHT', 'row'..nbRow-1, 'BOTTOMRIGHT'}
            }
        end
        local row = LibGUI:NewContainer('empty', self, 'row'..nbRow, nil, pt)
        row.enableAllWidgets = false
        row.bg = row:CreateTexture('BACKGROUND')
        row.bg:SetAllPoints()
        if self.alternateColor == true then
            row.bg:SetColorTexture( unpack( colors[nbRow % 2 + 1] ) )
        end

        if #self.configuration > 0 then
            local anchor
            local w
            local h
            for i, v in ipairs(self.configuration) do
                if i == 1 then
                    w = createWidget(row, v, { 'LEFT', row, 'LEFT' })
                elseif i >= colCount then
                    if v.type == 'checkbox' then
                        w = createWidget(row, v, { 'RIGHT', row, 'RIGHT', -190 - 4, 0 })
                    else
                        w = createWidget(row, v, { 'RIGHT', row, 'RIGHT', -4, 0 })
                    end
                else
                    w = createWidget(row, v, { 'LEFT', w, 'RIGHT' })
                end

                h = w:GetHeight()
                if h > wHeight then
                    wHeight = h
                end

                --anchor = w
                if i < colCount then
                    anchor = w
                end
            end
        else
            row.configuration = {}
        end

        row:SetSize(width - 8, wHeight)
        self:SetHeight(height + wHeight)

        return row
    end,

    GetWidgetsByRow = function(self, id)
        local row = self:GetRow(id)
        if row then
            return row.Widgets
        end
    end,

    SetColumnCount = function(self, count)
        self.columnCount = count
    end,

    GetRowCount = function(self)
        return #self.Childs
    end,

    GetRowHeight = function(self)
        if #self.Childs == 0 then
            return 0
        else
            return self.Childs[1]:GetHeight()
        end
    end,

    AddRows = function (self, nbRow)
        local rows = {}
        for i=1, nbRow do
            tinsert(rows, self:AddRow())
        end

        return rows
    end,

    HideRow = function (self, id)
        if self.Childs[id] ~= nil then
            self.Childs[id]:Hide()
        end
    end,

    ShowRow = function (self, id)
        if self.Childs[id] ~= nil then
            self.Childs[id]:Show()
            --if self.alternateColor == true and self.enableAllChilds == false then
            --    self.Childs[id].bg:Show()
            --end
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
    end,

    GetRow = function (self, id)
        return self.Childs[id]
    end,

    GetRows = function(self)
        return self.Childs
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
local AddOn, Plugin = ...

local LibGUI = {}

--local LibGUI = LibStub:NewLibrary("LibGUI", 1)
--
--if not LibGUI then
--    return
--end

LibGUI.CreateWidget = {}

local debug = true
local colors = {
    red = "FFFF0000",
    green = "FF00FF00",
    blue = "FF0050FF",
    white = "FFFFFFFF"
}

local function Print(self, msg, color)
    print("|c"..(color or colors.white), msg, "|r")
end

local function GetData(self)
    return self.data
end

local function AddChild(self, child)
    tinsert(self.widgets, child)
    if debug then
        self:Print("--- ADD CHILD ---", colors.green)
        self:Print("pos: "..#self.widgets)
        self:Print(child)
    end
end

local function Release(self)
    if debug then
        self:Print("--- RELEASE " .. self .. " ---", colors.red)
    end

    --TODO release the widget, clean all data, unbind all callback
    for i, v in ipairs(self.widgets) do
        if debug then
            self:Print("--- CHILD " .. i .. " ---", colors.blue)
        end
        v:Release()
    end

    for k, v in pairs(self.callbacks) do
        if debug then
            self:Print("--- UNBIND Callback " .. k .. " ---", colors.blue)
        end
        v = Noop
    end

    for k,v in pairs(self.data) do
        if debug then
            self:Print("--- Clean Data " .. k .. " ---", colors.blue)
        end
        if type(v) == 'table' then
            wipe(v)
        end
        v = nil
    end
end

local function RemoveChild(self, table)
    --TODO search child widget from key ID, release it then remove from widget table
    if not table then
        return false
    end

    for i, v in ipairs(self.widgets) do
        if v == table then
            v:Release()
            tremove(self.widgets, i)
            return true
        end
    end

    return false
end

local ElementMetatable = {
    --[[
        DATA
    --]]
    widgets = {},
    callbacks = {},
    data = {},
    frame = nil,

    Print = function(self, msg, color)
        print("|c"..(color or colors.white), msg, "|r")
    end,

    GetData = function(self)
        return self.data
    end,

    SetData = nil,

    AddChild = function (self, child)
        tinsert(self.widgets, child)
        if debug then
            self:Print("--- ADD CHILD ---", colors.green)
            self:Print("pos: "..#self.widgets)
            self:Print(child)
        end
    end,

    Release = function (self)
        if debug then
            self:Print("--- RELEASE " .. self .. " ---", colors.red)
        end

        --TODO release the widget, clean all data, unbind all callback
        for i, v in ipairs(self.widgets) do
            if debug then
                self:Print("--- CHILD " .. i .. " ---", colors.blue)
            end
            v:Release()
        end

        for k, v in pairs(self.callbacks) do
            if debug then
                self:Print("--- UNBIND Callback " .. k .. " ---", colors.blue)
            end
            v = Noop
        end

        for k,v in pairs(self.data) do
            if debug then
                self:Print("--- Clean Data " .. k .. " ---", colors.blue)
            end
            if type(v) == 'table' then
                wipe(v)
            end
            v = nil
        end
    end,

    RemoveChild = function (self, table)
        --TODO search child widget from key ID, release it then remove from widget table
        if not table then
            return false
        end

        for i, v in ipairs(self.widgets) do
            if v == table then
                v:Release()
                tremove(self.widgets, i)
                return true
            end
        end

        return false
    end
}

function LibGUI:AddWidget(parent, type, data)

    local widget = {
        widgets = {},
        callbacks = {},
        data = data,
        frame = nil,
        RemoveChild = RemoveChild,
        Release = Release,
        AddChild = AddChild,
        GetData = GetData,
        Print = Print,
    }

    --widget.RemoveChild = RemoveChild
    --widget.Release = Release
    --widget.AddChild = AddChild
    --widget.GetData = GetData
    --widget.Print = Print

    --setmetatable(widget, { __index = ElementMetatable })

    self.CreateWidget[type](widget, parent, data)

    if not parent then
        -- NEW WIDGET
        return widget
    else
        if widget then
            parent:AddChild(widget)
        end
    end

    return widget
end

Plugin.LibGUI = LibGUI
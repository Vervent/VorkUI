local AddOn, Plugin = ...

local LibGUI = {}

local widgets = {}
local containers = {}

local debug = true
local colors = {
    red = "FFFF0000",
    green = "FF00FF00",
    blue = "FF0050FF",
    white = "FFFFFFFF"
}

local profile = nil

function LibGUI:GetProfile()
    return profile
end

function LibGUI:RegisterProfile(p)
    profile = p
end

function LibGUI:RegisterContainer(t, createFct, enableFct, disableFct, bindFct)
    if containers[t] then
        print ("A CONTAINER WITH THIS TYPE EXISTS")
        return
    end

    containers[t] = {
        Create = createFct or function() end,
        Enable = enableFct or function() end,
        Disable = disableFct or function() end,
        Bind = bindFct or function() end
    }
end

function LibGUI:RegisterWidget(t, createFct, enableFct, disableFct, updateFct)
    if widgets[t] then
        print ("A WIDGET WITH THIS TYPE EXISTS")
        return
    end

    widgets[t] = {
        Create = createFct or function() end,
        Enable = enableFct or function() end,
        Disable = disableFct or function() end,
        Update = updateFct or function() end
    }
end

local function isValidWidget(w)
    return w and widgets[w.type]
end

local function isValidContainer(c)
    return c and containers[c.type]
end

local function checkBound(self, deltaX, deltaY)
    if self.rect[1] < self.parentRect[1] then
        deltaX = deltaX + self.parentRect[1]-self.rect[1]
    elseif self.rect[1]+self.rect[3] > self.parentRect[1]+self.parentRect[3] then
        deltaX = deltaX + (self.parentRect[1]+self.parentRect[3] - self.rect[1]-self.rect[3])
    end

    if self.rect[2] < self.parentRect[2] then
        deltaY = deltaY + self.parentRect[2]-self.rect[2]
    elseif self.rect[2]+self.rect[4] > self.parentRect[2]+self.parentRect[4] then
        deltaY = deltaY + (self.parentRect[2]+self.parentRect[4] - self.rect[2]-self.rect[4])
    end

    return deltaX, deltaY
end

local function onDragStart(self, ...)
    local x,y =  GetCursorPosition()
    self.onDrag = true
    self.point = { self:GetPoint() }
    self.parentRect = { self.point[2]:GetScaledRect() }
    self.uiScale = UIParent:GetEffectiveScale()
    self.cursorPosition = { x / self.uiScale, y / self.uiScale } --init
end

local function onDragStop(self, ...)
    self.onDrag = false

    local deltaX, deltaY = checkBound(self, 0, 0)

    self.point[4] = self.point[4] + deltaX
    self.point[5] = self.point[5] + deltaY

    self:ClearAllPoints()
    self:SetPoint(unpack(self.point))
end

local function onDragUpdate(self, timestep)
    if self.onDrag == true then
        self.rect = { self:GetScaledRect() }

        local x, y = GetCursorPosition()
        local uiScale = self.uiScale
        local cursorPosition = self.cursorPosition
        x = x / uiScale
        y = y / uiScale

        local deltaX, deltaY = checkBound(self,
                x - cursorPosition[1],
                y - cursorPosition[2])

        self.point[4] = self.point[4] + deltaX
        self.point[5] = self.point[5] + deltaY

        self:ClearAllPoints()
        self:SetPoint(unpack(self.point))

        self.cursorPosition[1] = x
        self.cursorPosition[2] = y

    end
end

--[[
    This function bind a script handler to the container
        container to handle the script
        event the script event to handle ( 'OnEvent', 'OnClick', ...), take care to bind a supported script
        fct the callback to execute
]]--
function LibGUI:BindScript(container, event, fct)
    if isValidContainer(container) and containers[container.type].Bind then
        containers[container.type].Bind(container, event, fct)
    else
        print ("INVALID CONTAINER, CANNOT BIND SCRIPT ", event)
    end
end

--[[
    This function bind a script handler to the container
        container to handle the script
        event the script event to handle ( 'OnEvent', 'OnClick', ...), take care to bind a supported script
        fct the callback to execute
]]--
function LibGUI:SetMovableContainer(container, isClampToScreen)
    if isValidContainer(container) and containers[container.type].Bind then
        print ('SetMovableContainer', container)
        container:SetMovable(true)
        container:EnableMouse(true)
        container:RegisterForDrag("LeftButton")
        if isClampToScreen then
            container:SetClampedToScreen(true)
            containers[container.type].Bind(container, 'OnDragStart', container.StartMoving)
            containers[container.type].Bind(container, 'OnDragStop', container.StopMovingOrSizing)
        else
            containers[container.type].Bind(container, 'OnDragStart', onDragStart)
            containers[container.type].Bind(container, 'OnUpdate', onDragUpdate)
            containers[container.type].Bind(container, 'OnDragStop', onDragStop)
        end
    else
        print ("INVALID CONTAINER, CANNOT BE MOVABLE ")
    end
end

--[[
    This function create a new container
        t type of container
        parent the parent of the container. The parent can be UIParent, nil, or Another Frame. If
parent is a frame created by LibGUI, the system will handle it and add the new container as a child of parent
        name the name of the frame
        ... contains data used by the container for initiatlisation. For more information look directly on
the right container code
]]--
function LibGUI:NewContainer(t, parent, name, ...)
    if containers[t] then

        local frame = containers[t].Create(parent, name, ...)
        frame.type = t
        frame:SetScript("OnShow", containers[t].Enable)
        frame:SetScript("OnHide", containers[t].Disable)
        frame:Hide()

        if isValidContainer(parent) and parent.Childs then
            tinsert(parent.Childs, frame)
        end

        return frame
    end

    return nil
end

function LibGUI:NewWidget(t, container, name, point, ...)
    if widgets[t] then
        local w = widgets[t].Create(container, name, point,...)
        w.type = t

        if isValidContainer(container) and container.Widgets then
            tinsert(container.Widgets, w)
        end

        return w
    end

    return nil
end

Plugin.LibGUI = LibGUI
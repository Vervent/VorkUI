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
function LibGUI:SetMovableContainer(container)
    if isValidContainer(container) and containers[container.type].Bind then
        container:SetMovable(true)
        container:EnableMouse(true)
        container:RegisterForDrag("LeftButton")
        container:SetClampedToScreen(true)
        containers[container.type].Bind(container, 'OnDragStart', container.StartMoving)
        containers[container.type].Bind(container, 'OnDragStop', container.StopMovingOrSizing)
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
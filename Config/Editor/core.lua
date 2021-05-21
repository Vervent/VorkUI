local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = CreateFrame("Frame")
local registry = {}

--[[
    LOCAL FUNCTION
]]--
local function HookRegisteredFrameClick(self)

    for _, v in pairs(registry) do
        v[1]:HookScript('OnClick', function()
            --print ('HookRegisteredFrameClick')
            self.Inspector:Inspect(v[1])
        end )
    end

end


--[[
    CORE FUNCTION
]]--

function Editor:RegisterFrame(frame, config, module, submodule)
    if frame == nil then
        print ("|cFFFF1010 REGISTER FRAME ERROR|r")
        return
    end

    local name = frame:GetName()
    if name == nil then
        tinsert(registry, { frame, config, module, submodule })
    else
        registry[name] = { frame, config, module, submodule }
    end
end

function Editor:GetFrameOptions(id)
    local item = self:GetFrameTable(id)

    if item == nil or item[2] == nil then
        print ("|cFFFF1010 GET FRAME OPTIONS NOT FOUND OR NO OPTIONS|r", id)
        return
    end

    --self:PrintFrameOptions(item) --debug purpose
    return item

end

function Editor:PrintFrameOptions(item)
    if item == nil then
        print ('|cFFFF1010PRINT FRAME OPTIONS ERROR|r')
        return
    end
    print ('FRAME ID', item[1])
    for k,v in pairs(item[2]) do
        print (k, v)
    end
end

function Editor:GetSystems()
    local data = {}

    local system
    local module
    for i, v in ipairs(registry) do
        system = v[3]
        module = v[4]
        if data[system] == nil then
            data[system] = {}
            tinsert(data[system], module)
        elseif data[system][module] == nil then
            tinsert(data[system], module)
        end
    end

    for k, v in pairs(registry) do
        system = v[3]
        module = v[4]
        if data[system] == nil then
            data[system] = {}
            tinsert(data[system], module)
        elseif data[system][module] == nil then
            tinsert(data[system], module)
        end
    end

    return data
end

function Editor:GetFrameBySystemAndModule(system, module)
    for i, v in ipairs(registry) do
        if v[3] == system and v[4] == module then
            return v[1]
        end
    end

    for k, v in pairs(registry) do
        if v[3] == system and v[4] == module then
            return v[1]
        end
    end
end

function Editor:GetFrameTable(id)

    if id == nil then
        print ("|cFFFF1010 GET FRAME ERROR|r")
        return nil
    end

    if type(id) == 'string' then
        return registry[id] or nil
    elseif type(id) == 'table' then
        for _, v in pairs (registry) do
            if v[1] == id then
                return v
            end
        end
    end

    return nil
end

function Editor:CreateGUI()
    self.Inspector:CreateGUI()
    self.Hierarchy:CreateGUI()
    self:Hide()
end

function Editor:Enable()
    HookRegisteredFrameClick(self)
    self.Inspector:Show()
    self.Hierarchy:Show()
end

function Editor:Disable()
    self.Inspector:Hide()
    self.Hierarchy:Hide()
end

Editor:HookScript('OnShow', Editor.Enable)
Editor:HookScript('OnHide', Editor.Disable)

V.Editor = Editor

--[[
    EDITOR MAIN FRAME CONFIG
]]--
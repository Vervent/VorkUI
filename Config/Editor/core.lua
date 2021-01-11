local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = CreateFrame("Frame")
local registry = {}

--[[
    CORE FUNCTION
]]--

function Editor:RegisterFrame(frame, config)
    if frame == nil then
        print ("|cFFFF1010 REGISTER FRAME ERROR|r")
        return
    end

    local name = frame:GetName()
    if name == nil then
        tinsert(registry, { frame, config })
    else
        registry[name] = { frame, config }
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
    print ('FRAME ID', item[1])
    for k,v in pairs(item[2]) do
        print (k, v)
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
            if v[2] == id then
                return v
            end
        end
    end

    return nil
end

function Editor:CreateGUI()
    Editor.Inspector:CreateGUI()

    self:Hide()
end

function Editor:Enable()
    self.Inspector:Show()
end

function Editor:Disable()
    self.Inspector:Hide()
end

Editor:HookScript('OnShow', Editor.Enable)
Editor:HookScript('OnHide', Editor.Disable)

V.Editor = Editor

--[[
    EDITOR MAIN FRAME CONFIG
]]--
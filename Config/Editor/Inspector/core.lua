local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = CreateFrame("Frame")

ComponentsGUI = {}

local currentFrame = nil
local currentItem = nil

--[[
    INSPECTOR FRAME CONFIG
]]--
local inspector = {
    root = {
        type = 'frame',
        params = {
            parent = UIParent,
            name = 'VorkuiEditorInspector',
            title = 'Vorkui Inspector',
            size = {400, 1000},
            point = { 'TOPRIGHT' },
        },
        childs = {
        }
    }
}

--local function setInspectorBaseStructure()
--    tinsert(inspector.root.childs, ComponentsGUI['Enable']('Inspector', Inspector.UI))
--end

local function parseItemConfig(item)

    print ("|cff33ff99PARSE ITEM CONFIG|r", item, item.Enable)

    local frame = item[1] --useless for now
    local config = item[2]
    local baseName = item[4] or frame:GetName()

    if config.Enable ~= nil then
        --tinsert(inspector.root.childs, ComponentsGUI['Enable']('Inspector', Inspector.UI))
        local enable = ComponentsGUI['Enable']('InspectorModule', Inspector.UI, Inspector.UI.TitleBg, baseName..' Settings')
        --local it1 = ComponentsGUI['Texture']('InspectorTexture1', Inspector.UI, enable, 'Background')
        --local it2 = ComponentsGUI['Texture']('InspectorTexture2', Inspector.UI, it1, 'Main')
        --local it3 = ComponentsGUI['Texture']('InspectorTexture3', Inspector.UI, it2, 'Overlay')
        local it1 = ComponentsGUI['Rendering']('InspectorHealth', Inspector.UI, enable, 'Rendering', config.Health.Rendering)
        local it2 = ComponentsGUI['Size']('InspectorModule', Inspector.UI, it1, 'Size', nil, true)
        local it3 = ComponentsGUI['Submodules']('InspectorModule', Inspector.UI, it2, 'Submodules', config.Submodules)
        --local it4 = ComponentsGUI['Slanting']('InspectorHealth', Inspector.UI, it3, 'Slanting', nil, true)
        --local it5 = ComponentsGUI['Tag']('InspectorModule', Inspector.UI, it3, 'Tag', nil, true)
        local it6 = ComponentsGUI['ComponentList']('InspectorModule', Inspector.UI, it3, 'Components', config.Submodules)


        for _, c in ipairs(Inspector.UI.Childs) do
            c:Show()
        end
        --Inspector.UI.Childs[1]:Show()
    end

    --if item.Enable ~= nil then
    --    print("ITEM CONFIG", item.__key)
    --    --tinsert(inspector.root.childs, ComponentsGUI["Enable"]()
    --end

end

function Inspector:CreateComponentGUI(t, baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)
    if ComponentsGUI[t] then
        return ComponentsGUI[t](baseName, parent, parentPoint, componentName, isFirstItem, hasBorder)
    end
end

function Inspector:RegisterComponentGUI(name, fct)
    if name == nil or type(name)~= 'string' or name == '' then
        print("|cFFFF1010 REGISTER COMPONENT GUI ERROR|r")
        return
    end

    if ComponentsGUI[name] then
        print("|cff33ff99 A FONCTION FOR "..name.." COMPONENT EXISTS YET|r")
    end

    ComponentsGUI[name] = fct

    print ("|cFF10FF10Register gui for "..name.." component|r")
end

--[[
    CORE FUNCTION
]]--

function Inspector:CreateGUI()
    local root = inspector.root

    local frame = LibGUI:NewContainer( root.type,
            root.params.parent,
            root.params.name,
            root.params.size,
            root.params.point,
            'BasicFrameTemplate'
    )

    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame)

    self.UI = frame;
    self:Hide()
end

function Inspector:Enable()
    self.UI:Show()

end

function Inspector:Disable()
    self:Hide()
end

function Inspector:Refresh()

end

function Inspector:LockItem(item)
    currentFrame = item
    currentItem = Editor:GetFrameOptions(item)

    print ("|cFF10FF10 LockItem |r")
    Editor:PrintFrameOptions(currentItem)
    parseItemConfig(currentItem)
end

function Inspector:ReleaseItem()
    --release all widgets
    currentFrame = nil
    currentItem = nil
end

function Inspector:Inspect(item)
    if item == currentFrame then
        return
    end

    self:ReleaseItem()
    self:LockItem(item)
end

Inspector:SetScript('OnShow', Inspector.Enable)
Inspector:SetScript('OnHide', Inspector.Disable)

Editor.Inspector = Inspector
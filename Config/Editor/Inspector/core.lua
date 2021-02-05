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
            size = {420, 1024},
            point = { 'TOPRIGHT' },
        },
        childs = {
        }
    }
}

--local function setInspectorBaseStructure()
--    tinsert(inspector.root.childs, ComponentsGUI['Enable']('Inspector', Inspector.UI))
--end

local componentBaseConfig = {
    nil, -- point
    true, --hasBorder
    true, --isCollapsable
    true, --hasName
    nil --config
}

local function parseItemConfig(item)

    print ("|cff33ff99PARSE ITEM CONFIG|r", item, item.Enable)

    local frame = item[1] --useless for now
    local config = item[2]
    local baseName = item[4] or frame:GetName()

    local scrollParent = Inspector.UI.Scroll

    if config.Enable ~= nil then
        --tinsert(inspector.root.childs, ComponentsGUI['Enable']('Inspector', Inspector.UI))
        local enableComponent = ComponentsGUI['Enable']('InspectorModule', scrollParent.ScrollChild, scrollParent.ScrollChild,
                baseName..' Settings', {
                    {'TOPLEFT', scrollParent.ScrollChild, 'TOPLEFT', 4, -16}, {'TOPRIGHT', scrollParent.ScrollBar, 'TOPLEFT', -6, -16}
                },
                select(2, unpack(componentBaseConfig))
        )
        --local cListComponent = ComponentsGUI['ComponentList']('InspectorModule', Inspector.UI, enableComponent, 'Components', nil, config.Submodules, true)
        local cBlockComponent = ComponentsGUI['ComponentBlock']('InspectorModule', scrollParent.ScrollChild, enableComponent, 'Components', nil, true, true, true, config.Submodules)
        local pointComponent = ComponentsGUI['Point']('InspectorModule', scrollParent.ScrollChild, cBlockComponent, 'Point', unpack(componentBaseConfig))
        local sizeComponent = ComponentsGUI['Size']('InspectorModule', scrollParent.ScrollChild, pointComponent, 'Size', unpack(componentBaseConfig))
        local submoduleComponent = ComponentsGUI['Submodules']('InspectorModule', scrollParent.ScrollChild, sizeComponent, 'Submodules', nil, true, true, true, config.Submodules)
        local indicatorComponent = ComponentsGUI['Indicator']('InspectorModule', scrollParent.ScrollChild, submoduleComponent, 'Indicators', unpack(componentBaseConfig))
        local renderingComponent = ComponentsGUI['Rendering']('InspectorHealth', scrollParent.ScrollChild, indicatorComponent, 'Rendering', nil, true, true, true, config.Health.Rendering)
        local slantingComponent = ComponentsGUI['Slanting']('InspectorHealth', scrollParent.ScrollChild, renderingComponent, 'Slanting', unpack(componentBaseConfig))
        local TagComponent = ComponentsGUI['Tag']('InspectorModule', scrollParent.ScrollChild, slantingComponent, 'Tag', unpack(componentBaseConfig))
        local FontComponent = ComponentsGUI['Font']('InspectorModule', scrollParent.ScrollChild, TagComponent, 'Font', unpack(componentBaseConfig))
        local ParticleComponent = ComponentsGUI['Particle']('InspectorModule', scrollParent.ScrollChild, FontComponent, 'Particle', unpack(componentBaseConfig))
        local CastBarComponent = ComponentsGUI['Castbar']('InspectorModule', scrollParent.ScrollChild, ParticleComponent, 'Castbar', unpack(componentBaseConfig))
        local BuffsComponent = ComponentsGUI['Aura']('InspectorModule', scrollParent.ScrollChild, CastBarComponent, 'Buffs', unpack(componentBaseConfig))
        local DebuffsComponent = ComponentsGUI['Aura']('InspectorModule', scrollParent.ScrollChild, BuffsComponent, 'Debuffs', unpack(componentBaseConfig))
        local AttributesComponent = ComponentsGUI['Attribute']('InspectorModule', scrollParent.ScrollChild, DebuffsComponent, 'Attribute', unpack(componentBaseConfig))
        --local it1 = ComponentsGUI['Texture']('InspectorTexture1', Inspector.UI, enable, 'Background')
        --local it2 = ComponentsGUI['Texture']('InspectorTexture2', Inspector.UI, it1, 'Main')
        --local it3 = ComponentsGUI['Texture']('InspectorTexture3', Inspector.UI, it2, 'Overlay')
        --local it1 = ComponentsGUI['Rendering']('InspectorHealth', Inspector.UI, enable, 'Rendering', config.Health.Rendering)
        --local it2 = ComponentsGUI['Size']('InspectorModule', Inspector.UI, it1, 'Size', nil, true)
        --local it3 = ComponentsGUI['Submodules']('InspectorModule', Inspector.UI, it2, 'Submodules', config.Submodules)
        --local it4 = ComponentsGUI['Slanting']('InspectorHealth', Inspector.UI, it3, 'Slanting', nil, true)
        --local it5 = ComponentsGUI['Tag']('InspectorModule', Inspector.UI, it3, 'Tag', nil, true)
        --local it7 = ComponentsGUI['Point']('InspectorModule', Inspector.UI, it2, 'Point', nil, true)

        for _, c in ipairs(scrollParent.Childs) do
            c:Show()
        end
        scrollParent:ResizeScrollChild()
        scrollParent:ShowScrollChild()
        --Inspector.UI.Childs[1]:Show()
    end

    --if item.Enable ~= nil then
    --    print("ITEM CONFIG", item.__key)
    --    --tinsert(inspector.root.childs, ComponentsGUI["Enable"]()
    --end

end

function Inspector:Collapse()
    for i=1, #self.Widgets-1 do
        self.Widgets[i]:Hide()
    end

    for _, c in ipairs(self.Childs) do
        c:Hide()
    end

    Inspector.UI.Scroll:ResizeScrollChild()
end

function Inspector:Expand()
    for i=1, #self.Widgets-1 do
        self.Widgets[i]:Show()
    end

    for _, c in ipairs(self.Childs) do
        c:Show()
    end

    Inspector.UI.Scroll:ResizeScrollChild()
end

function Inspector:CreateComponentGUI(t, baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)
    if ComponentsGUI[t] then
        return ComponentsGUI[t](baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)
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

    frame.Scroll = LibGUI:NewContainer( 'scrollframe',
            frame,
            root.params.name..'ScrollFrame',
            { root.params.size[1] - 10, root.params.size[2] - 50},
            {
                {'TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 0, -10},
                --{'BOTTOMRIGHT', frame, 'BOTTOMRIGHT'}
            }
    )

    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

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

function Inspector:InspectComponent(name)
    if name == 'General' then
        --root inspect
        print ('|cFF10FF10 General Option|r')
    else
        --component inspect
        print ('|cFF10FF10 Component Option|r:', name)
    end
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
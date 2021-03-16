local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = CreateFrame("Frame")

ComponentsGUI = {}
local scrollableComponents = {}
local fixedComponents = {}
local visibleComponentIndex = {}

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

local componentBaseConfig = {
    nil, -- point
    true, --hasBorder
    true, --isCollapsable
    true, --hasName
    nil --config
}

local function componentPoint(component, isFirst, ...)
    component:ClearAllPoints()
    local parent1 = select(1, ...)
    local parent2 = select(2, ...)
    if isFirst then
        component:SetPoint('TOPLEFT', parent1, 'BOTTOMLEFT', 2, -16)
        if parent2 then
            component:SetPoint('TOPRIGHT', parent2, 'BOTTOMRIGHT', -10, -16)
        else
            component:SetPoint('TOPRIGHT', parent1, 'BOTTOMRIGHT', -10, -16)
        end
    else
        component:SetPoint('TOPLEFT', parent1, 'BOTTOMLEFT', 0, -16)
        component:SetPoint('TOPRIGHT', parent1, 'BOTTOMRIGHT', 0, -16)
    end
end

local function initializeComponent(component, data, ...)
    if component.Update then
        component.Update(component, data)
    end
    componentPoint(component, ...)
    component:Show()
end

local function initializeComponents(tab, config, ...)

    local isFirst = true
    local lastIndex = 1

    local t
    for i,v in ipairs(tab) do
        t = v.componentType
        if config[t] then
            if isFirst == true then
                initializeComponent(v, config[t], isFirst, ...)
                isFirst = false
            else
                initializeComponent(v, config[t], isFirst, tab[lastIndex])
            end
            lastIndex = i
            tinsert(visibleComponentIndex, lastIndex)
        else
            v:Hide()
        end
    end

end

local function getComponentBlockData(config)
    local blockName = {}

    local order = {
        'General',
        'Health',
        'HealthPrediction',
        'Absorb',
        'Power',
        'PowerPrediction',
        'Portrait',
        'Indicators',
        'Castbar',
        'Buffs',
        'Debuffs',
        'Texts'
    }

    local item
    for i=1, #order do
        item = config[order[i]]
        if item ~= nil then
            tinsert(blockName, order[i])
        end
    end

    return blockName
end

local function parseComponentConfig(config)
    local scrollParent = Inspector.UI.Scroll

    print ('PARSE COMPONENT CONFIG')

    scrollParent:ShowScrollChild()
    initializeComponents(scrollableComponents, config, scrollParent.ScrollChild, scrollParent.ScrollBar)
    scrollParent:ResizeScrollChild()
end

local function parseItemConfig(item)
    local frame = item[1]
    local config = item[2]
    local baseName = item[4] or frame:GetName()
    local scrollParent = Inspector.UI.Scroll

    local enable = fixedComponents[1]
    local submodule = fixedComponents[2]
    local blocks = fixedComponents[3]

    initializeComponent(enable, config.Enable, true, Inspector.UI.TitleBg, Inspector.UI)
    initializeComponent(submodule, config.Submodules, false, fixedComponents[1])
    initializeComponent(blocks, getComponentBlockData(config), false, fixedComponents[2])

    scrollParent:SetHeight(inspector.root.params.size[2] -
            enable:GetHeight() -
            submodule:GetHeight() -
            blocks:GetHeight() -
            4*16 - --spacing Y between component
            20) --title

    --scrollParent:ShowScrollChild()
    --initializeComponents(scrollableComponents, config, scrollParent.ScrollChild, scrollParent.ScrollBar)
    --scrollParent:ResizeScrollChild()
end

local function createInspectorComponent(self)

    local frameParent = self.UI.TitleBg
    local scrollParent = self.UI.Scroll
    tinsert(fixedComponents, self:CreateComponentGUI('Enable', 'InspectorModule', self.UI, scrollParent.ScrollChild,
            'Settings', {
                {'TOPLEFT', frameParent, 'BOTTOMLEFT', 0, -16}, {'TOPRIGHT', frameParent, 'BOTTOMRIGHT'}
            },
            select(2, unpack(componentBaseConfig))
    ))
    tinsert(fixedComponents, self:CreateComponentGUI('Submodules', 'InspectorModule', self.UI,  scrollableComponents['Enable'], 'Submodules', nil, true, true, true, 10))
    tinsert(fixedComponents, self:CreateComponentGUI('ComponentBlock', 'InspectorModule', self.UI, scrollableComponents['Submodules'], 'Components', nil, true, true, true, 20))
    scrollParent:SetPoint('TOPLEFT', fixedComponents[3], 'BOTTOMLEFT', 0, -10)

    tinsert(scrollableComponents, self:CreateComponentGUI('Point', 'InspectorModule', scrollParent.ScrollChild, scrollableComponents['Components'], 'Point', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Size', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Point'], 'Size', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Indicator', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Submodules'], 'Indicators', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Rendering', 'InspectorHealth', scrollParent.ScrollChild,  scrollableComponents['Indicator'], 'Rendering', nil, true, true, true, 3))
    tinsert(scrollableComponents, self:CreateComponentGUI('Slanting', 'InspectorHealth', scrollParent.ScrollChild,  scrollableComponents['Rendering'], 'Slanting', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Tag', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Slanting'], 'Tag', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Font', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Tag'], 'Font', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Particle', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Font'], 'Particle', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Castbar', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Particle'], 'Castbar', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Aura', 'InspectorModule', scrollParent.ScrollChild,   scrollableComponents['Castbar'], 'Buffs', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Aura', 'InspectorModule', scrollParent.ScrollChild,     scrollableComponents['Buffs'], 'Debuffs', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Attribute', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Debuffs'], 'Attribute', unpack(componentBaseConfig)))
end

--local function parseItemConfig(self, item)
--
--    print ("|cff33ff99PARSE ITEM CONFIG|r", item, item.Enable)
--
--    local frame = item[1] --useless for now
--    local config = item[2]
--    local baseName = item[4] or frame:GetName()
--
--    local scrollParent = Inspector.UI.Scroll
--
--    if config.Enable ~= nil then
--        local enableComponent = self:CreateComponentGUI('Enable', 'InspectorModule', scrollParent.ScrollChild, scrollParent.ScrollChild,
--                baseName..' Settings', {
--                    {'TOPLEFT', scrollParent.ScrollChild, 'TOPLEFT', 4, -16}, {'TOPRIGHT', scrollParent.ScrollBar, 'TOPLEFT', -6, -16}
--                },
--                select(2, unpack(componentBaseConfig))
--        )
--
--        local cBlockComponent =     self:CreateComponentGUI('ComponentBlock', 'InspectorModule', scrollParent.ScrollChild, enableComponent, 'Components', nil, true, true, true, 20)
--        local pointComponent =      self:CreateComponentGUI('Point', 'InspectorModule', scrollParent.ScrollChild, cBlockComponent, 'Point', unpack(componentBaseConfig))
--        local sizeComponent =       self:CreateComponentGUI('Size', 'InspectorModule', scrollParent.ScrollChild, pointComponent, 'Size', unpack(componentBaseConfig))
--        local submoduleComponent =  self:CreateComponentGUI('Submodules', 'InspectorModule', scrollParent.ScrollChild, sizeComponent, 'Submodules', nil, true, true, true, 10)
--        local indicatorComponent =  self:CreateComponentGUI('Indicator', 'InspectorModule', scrollParent.ScrollChild, submoduleComponent, 'Indicators', unpack(componentBaseConfig))
--        local renderingComponent =  self:CreateComponentGUI('Rendering', 'InspectorHealth', scrollParent.ScrollChild, indicatorComponent, 'Rendering', nil, true, true, true, config.Health.Rendering)
--        local slantingComponent =   self:CreateComponentGUI('Slanting', 'InspectorHealth', scrollParent.ScrollChild, renderingComponent, 'Slanting', unpack(componentBaseConfig))
--        local TagComponent =        self:CreateComponentGUI('Tag', 'InspectorModule', scrollParent.ScrollChild, slantingComponent, 'Tag', unpack(componentBaseConfig))
--        local FontComponent =       self:CreateComponentGUI('Font', 'InspectorModule', scrollParent.ScrollChild, TagComponent, 'Font', unpack(componentBaseConfig))
--        local ParticleComponent =   self:CreateComponentGUI('Particle', 'InspectorModule', scrollParent.ScrollChild, FontComponent, 'Particle', unpack(componentBaseConfig))
--        local CastBarComponent =    self:CreateComponentGUI('Castbar', 'InspectorModule', scrollParent.ScrollChild, ParticleComponent, 'Castbar', unpack(componentBaseConfig))
--        local BuffsComponent =      self:CreateComponentGUI('Aura', 'InspectorModule', scrollParent.ScrollChild, CastBarComponent, 'Buffs', unpack(componentBaseConfig))
--        local DebuffsComponent =    self:CreateComponentGUI('Aura', 'InspectorModule', scrollParent.ScrollChild, BuffsComponent, 'Debuffs', unpack(componentBaseConfig))
--        local AttributesComponent = self:CreateComponentGUI('Attribute', 'InspectorModule', scrollParent.ScrollChild, DebuffsComponent, 'Attribute', unpack(componentBaseConfig))
--
--        scrollParent:ShowScrollChild()
--        scrollParent:ResizeScrollChild()
--        scrollParent:ShowScrollChild()
--        --Inspector.UI.Childs[1]:Show()
--    end
--
--    --if item.Enable ~= nil then
--    --    print("ITEM CONFIG", item.__key)
--    --    --tinsert(inspector.root.childs, ComponentsGUI["Enable"]()
--    --end
--
--end

function Inspector:Collapse()

    for i=1, #self.Widgets do
        if self.Widgets[i].HasCollapseSystem == nil or self.Widgets[i]:HasCollapseSystem() == false then
            self.Widgets[i]:Hide()
        end
    end

    for _, c in ipairs(self.Childs) do
        c:Hide()
    end

    Inspector.UI.Scroll:ResizeScrollChild()
end

function Inspector:Expand()
    for i=1, #self.Widgets do
        if self.Widgets[i].HasCollapseSystem == nil or self.Widgets[i]:HasCollapseSystem() == false then
            self.Widgets[i]:Show()
        end
    end

    for _, c in ipairs(self.Childs) do
        c:Show()
    end

    Inspector.UI.Scroll:ResizeScrollChild()
end

function Inspector:CreateComponentGUI(t, baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)
    if ComponentsGUI[t] then
        local component = ComponentsGUI[t].Create(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)
        component.componentType = t
        component.Update = ComponentsGUI[t].Update
        return component
    end
end

function Inspector:RegisterComponentGUI(name, create, update)
    if name == nil or type(name)~= 'string' or name == '' then
        print("|cFFFF1010 REGISTER COMPONENT GUI ERROR|r")
        return
    end

    if ComponentsGUI[name] then
        print("|cff33ff99 A FONCTION FOR "..name.." COMPONENT EXISTS YET|r")
    else
        ComponentsGUI[name] = {
            Create = create,
            Update = update,
        }
    end

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
            { root.params.size[1] - 15, 0}
    )
    frame.Scroll.enableAllChilds = false

    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

    self.UI = frame;

    createInspectorComponent(self)

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

    parseItemConfig(currentItem)
end

function Inspector:InspectComponent(name)

    --local frame = currentItem[1]
    local config = currentItem[2]

    parseComponentConfig(config[name])

    --if name == 'General' then
    --    --root inspect
    --    print ('|cFF10FF10 General Option|r')
    --else
    --    --component inspect
    --    print ('|cFF10FF10 Component Option|r:', name)
    --end
end

function Inspector:ReleaseItem()
    --release all widgets
    currentFrame = nil
    currentItem = nil
    wipe(visibleComponentIndex)
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
local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = CreateFrame("Frame")

local ComponentsGUI = {}
local scrollableComponents = {}
local fixedComponents = {}
local visibleComponentIndex = {}

local currentFrame = nil
local currentItem = nil
local currentComponent = nil
local parentDropdown = nil

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
        component:SetPoint('TOPLEFT', parent1, 'TOPLEFT', 4, -16)
        if parent2 then
            component:SetPoint('TOPRIGHT', parent2, 'TOPRIGHT', -4, -16)
        else
            component:SetPoint('TOPRIGHT', parent1, 'TOPRIGHT', -4, -16)
        end
    else
        component:SetPoint('TOPLEFT', parent1, 'BOTTOMLEFT', 0, -16)
        component:SetPoint('TOPRIGHT', parent1, 'BOTTOMRIGHT', 0, -16)
    end
end

local function initializeComponent(component, data, ...)
    if component.Update then
        component.Update(component, data, parentDropdown, currentComponent)
    end
    componentPoint(component, ...)
    component:Show()
end

local function initializeComponents(tab, config, ...)

    local isFirst = true
    local lastIndex = 1

    local t
    for i, v in ipairs(tab) do
        t = v.componentType
        print ('|cFFFFFF00initializeComponents|r', t)
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
        'Header',
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

local function iterativeParseComponentConfig(config, name)

    if config == nil then
        return
    end

    local scrollParent = Inspector.UI.Scroll
    scrollParent:ShowScrollChild()

    for i, v in ipairs(scrollableComponents) do
        if v.componentType == name then
            initializeComponent(v, config, true, scrollParent.ScrollChild, scrollParent.ScrollChild)
            tinsert(visibleComponentIndex, i)
        else
            v:Hide()
        end
    end
    scrollParent:ResizeScrollChild()

end

local function parseComponentConfig(config)
    if config == nil then
        return
    end

    local scrollParent = Inspector.UI.Scroll
    scrollParent:ShowScrollChild()
    initializeComponents(scrollableComponents, config, scrollParent.ScrollChild, scrollParent.ScrollChild)
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
    local parent =

    initializeComponent(enable, config.Enable, true, Inspector.UI.Bg, Inspector.UI.Bg)
    if config.Submodules ~= nil then
        initializeComponent(submodule, config.Submodules, false, enable)
        parent = submodule
    else
        parent = enable
    end
    initializeComponent(blocks, getComponentBlockData(config), false, parent)

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
    tinsert(fixedComponents, self:CreateComponentGUI('Enable', 'InspectorModule', self.UI, self.UI,
            'Settings', {
                {'TOPLEFT', frameParent, 'BOTTOMLEFT', 0, -16}, {'TOPRIGHT', frameParent, 'BOTTOMRIGHT'}
            },
            select(2, unpack(componentBaseConfig))
    ))
    tinsert(fixedComponents, self:CreateComponentGUI('Submodules', 'InspectorModule', self.UI,  fixedComponents['Enable'], 'Submodules', nil, true, true, true, 10))
    tinsert(fixedComponents, self:CreateComponentGUI('ComponentBlock', 'InspectorModule', self.UI, fixedComponents['Submodules'], 'Components', nil, true, false, true, 20))
    scrollParent:SetPoint('TOPLEFT', fixedComponents[3], 'BOTTOMLEFT', 0, 0)

    tinsert(scrollableComponents, self:CreateComponentGUI('Point', 'InspectorModule', scrollParent.ScrollChild, scrollableComponents['Components'], 'Point', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Size', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Point'], 'Size', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Indicators', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Submodules'], 'Indicators', nil, false, false, true))
    tinsert(scrollableComponents, self:CreateComponentGUI('Rendering', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Indicators'], 'Rendering', nil, true, true, true, 3))
    tinsert(scrollableComponents, self:CreateComponentGUI('Slanting', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Rendering'], 'Slanting', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Tag', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Slanting'], 'Tag', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Fonts', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Tag'], 'Fonts', nil, true, true, true, 6))
    tinsert(scrollableComponents, self:CreateComponentGUI('Particle', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Fonts'], 'Particle', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Castbar', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Particle'], 'Castbar', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Aura', 'InspectorModule', scrollParent.ScrollChild,   scrollableComponents['Castbar'], 'Buffs', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Aura', 'InspectorModule', scrollParent.ScrollChild,     scrollableComponents['Buffs'], 'Debuffs', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Attribute', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Debuffs'], 'Attribute', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Texts', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Attribute'], 'Texts', nil, false, false, true))
    tinsert(scrollableComponents, self:CreateComponentGUI('Portrait', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Texts'], 'Portrait', unpack(componentBaseConfig)))
    tinsert(scrollableComponents, self:CreateComponentGUI('Attributes', 'InspectorModule', scrollParent.ScrollChild,  scrollableComponents['Portrait'], 'Attributes', unpack(componentBaseConfig)))
end

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
        component.Clean = ComponentsGUI[t].Clean
        return component
    end
end

function Inspector:RegisterComponentGUI(name, create, update, clean)
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
            Clean = clean,
        }
    end

    print (ComponentsGUI[name])
    print ("|cFF10FF10Register gui for "..name.." component|r")
end

--[[
    CORE FUNCTION
]]--

function Inspector:CreateGUI()
    local root = inspector.root
    local borderSettings = Editor.border

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
            { root.params.size[1] - 20, 0}
    )
    frame.Scroll.enableAllChilds = false
    frame.Scroll:CreateBorder(borderSettings.size, borderSettings.color )

    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)


    local debugArea = LibGUI:NewWidget( 'button', frame, 'DebugFrameArea' )
    debugArea:CreateBorder( 2, {1, 0, 0, 1})
    debugArea.Texture = debugArea:AddTexture()
    debugArea.Texture:SetColorTexture(0.25, 0.25, 0.25, 0.5)
    debugArea.Label = debugArea:AddLabel(debugArea, '', nil, 'Game12Font_o1')
    self.DebugFrameArea = debugArea
    self.UI = frame

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

function Inspector:ShowArea()
    local frame = currentItem[1]
    local layout = currentItem[4]
    local width, height

    if layout:match('Party') then
        local attrib = currentItem[2].Header.Attributes
        width = attrib['initial-width']
        height = attrib['initial-height'] * 5
        local yOffset = math.abs(attrib['yOffset'])
        height = height + yOffset * 4
    elseif layout:match('Raid') then
        local attrib = currentItem[2].Header.Attributes
        local unitsPerColumn = attrib['unitsPerColumn'] or 1
        local maxColumn = attrib['maxColumns']
        width = attrib['initial-width'] * maxColumn
        height = attrib['initial-height'] * unitsPerColumn
        local yOffset = math.abs(attrib['yOffset'])
        local xOffset = math.abs(attrib['xOffset'])
        local columnSpacing = math.abs(attrib['columnSpacing'])
        height = height + yOffset * (unitsPerColumn-1)
        width = width + columnSpacing * (maxColumn-1)
    else
        width, height = frame:GetSize()
    end

    self.DebugFrameArea:ChangeText(layout)
    self.DebugFrameArea:SetSize(width, height)
    self.DebugFrameArea:Point(currentItem[2].General.Point)

    self.DebugFrameArea:Show()
end

function Inspector:HideArea()
    self.DebugFrameArea:ClearAllPoints()
    self.DebugFrameArea:Hide()
end

function Inspector:LockItem(item)
    currentFrame = item
    currentItem = Editor:GetFrameOptions(item)

    parseItemConfig(currentItem)
    self:InspectComponent('General')
    self:ShowArea()
end

local function clone(data)
    if type(data) ~= 'table' then
        return data
    else
        return Inspector:DeepCopyTable(data)
    end
end



function Inspector:SubmitUpdateValue(component, subcomponent, key, subkey, value)
    local config = currentItem[2]
    component = currentComponent or component

    local cloneValue = clone(value)
    local oldvalue

    if subcomponent ~= nil then
        if key ~= nil then
            if subkey ~= nil then
                if config[component][subcomponent][key] == nil then
                    return
                end
                if config[component][subcomponent][key][subkey] ~= nil then
                    oldvalue = clone ( config[component][subcomponent][key][subkey] )
                    config[component][subcomponent][key][subkey] = cloneValue
                end
            else
                if type(key) == 'number' then
                    oldvalue = clone ( config[component][subcomponent][key] )
                    tremove(config[component][subcomponent], key)
                    tinsert(config[component][subcomponent], key, cloneValue)
                else
                    oldvalue = clone ( config[component][subcomponent][key] )
                    config[component][subcomponent][key] = cloneValue
                end
            end
        else
            oldvalue = clone ( config[component][subcomponent] )
            config[component][subcomponent] = cloneValue
        end
    elseif key ~= nil then
        oldvalue = clone ( config[component][key] )
        config[component][key] = cloneValue
    else
        oldvalue = clone ( config[component] )
        config[component] = cloneValue
    end

    Editor:NotifyChangelist(currentFrame, component, subcomponent, key, subkey, oldvalue, cloneValue)
end

function Inspector:InspectComponent(name)

    --local frame = currentItem[1]
    local component
    for idx=1, #visibleComponentIndex do
        component = scrollableComponents[visibleComponentIndex[idx]]
        if component.Clean then
            component.Clean(component)
        end
    end
    --replace scroll to top
    self.UI.Scroll:SetVerticalScroll(0)

    local config = currentItem[2]
    currentComponent = name

    parentDropdown = {}
    if name == 'General' then
        tinsert(parentDropdown, { text = 'UIParent'})
    else
        for k, v in pairs(currentItem[1]) do
            if type(v) == 'table' and v.GetObjectType then
                tinsert(parentDropdown, { text = k})
            end
        end
    end

    if name == 'Indicators' or name == 'Texts' then
        iterativeParseComponentConfig(config[name], name)
    else
        parseComponentConfig(config[name])
    end

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
    local component
    for idx=1, #visibleComponentIndex do
        component = scrollableComponents[visibleComponentIndex[idx]]
        print ('|cff33ff99Release '..component:GetName()..'|r')
        if component.Clean then
            component.Clean(component)
        end
        component:Hide()
    end

    for i, v in ipairs(fixedComponents) do
        if v.Clean then
            v.Clean(v)
        end
        v:Hide()
    end

    --replace scroll to top
    self.UI.Scroll:SetVerticalScroll(0)
    wipe(visibleComponentIndex)

    self:HideArea()
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
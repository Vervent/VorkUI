local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local layers = Editor.menus.layers
local blendmode = Editor.menus.blendmode

local currentId = nil

local function update(self, config)

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local particleChoice = dropdownWidgets[1]
    local particleDropdown = {}

    for k, _ in pairs(config) do
        tinsert(particleDropdown, { text = k } )
    end
    particleChoice:Update(particleDropdown)

    self.config = config
end

local function updateParticle(self, name)
    if self.config == nil then
        return
    end

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local indicatorChoice = dropdownWidgets[1]

    --local parentDropdown = removeIndicatorFromDropdown(self, name)
    local particle = self.Childs[1]

    for k, v in pairs(self.config) do
        if k == name then
            particle:Clean() --clean old data before update
            particle:Update(v)
            indicatorChoice.key = k
            currentId = k
        end
    end
end

local function clean(self)
    self.config = {}
    self.Childs[1]:Clean()

    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local indicatorChoice = dropdownWidgets[1]
    indicatorChoice.key = nil
    indicatorChoice:Update(nil, '')
end

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)

    local pt
    if point then
        pt = point
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, -16 },
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , -16 }
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'ParticleFrame',
            nil,
            pt
    )

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            updateParticle(frame, value)
        end
    end

    local particleLabel = LibGUI:NewWidget('label', frame, 'IndicatorLabel', { 'TOPLEFT', 0, -10 }, { 100, 30 }, nil, nil)
    particleLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Choose Particle' } )
    local particleMenu = LibGUI:NewWidget('dropdownmenu', frame, 'IndicatorDropdown', { 'LEFT', particleLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    particleMenu.key = nil
    particleMenu:RegisterObserver(frame.Observer)

    local particle = Inspector:CreateComponentGUI('Particle', 'Particle', frame, particleLabel, nil, {
        {'TOPLEFT', 0, -45},
        {'TOPRIGHT', 0, 0},
    }, false, false, true, nil)

    if particle.Observer then
        particle.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            if item.key == 'AtlasName' then
                particle:UpdateView(value)
            end
            Inspector:SubmitUpdateValue(nil, 'Particles', currentId, item.key, value)
            --print ('PARTICLES', event, currentId, item.key, value)
        end
    end

    frame:SetHeight(particle:GetHeight() + 30 + 8)

    if hasBorder == true then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, 'NameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Particles', gui, update, clean)

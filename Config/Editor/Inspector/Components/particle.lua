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

local function update(self, config)
    local viewer = self.Childs[1]
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local path = dropdownWidgets[1]
    local layer = dropdownWidgets[2]
    local blend = dropdownWidgets[3]

    path:Update(  V.Medias:GetParticleDropDown(), config.AtlasName )
    layer:Update( layers, config.Layer )
    blend:Update( blendmode, config.BlendMode )
    viewer:SetPath(config.AtlasName)
end

local function updateParticle(self, key, value)

    if key == 'AtlasName' then
        self.Childs[1]:SetPath(value)
    end

    print ('TODO UpdateParticle -> particle.lua l34')
end

local function updateView(self, path)
    if path and type(path) == 'string' and path ~= '' then
        self.Childs[1]:SetPath(path)
    end
end

local function clean(self)
    local viewer = self.Childs[1]
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local path = dropdownWidgets[1]
    local layer = dropdownWidgets[2]
    local blend = dropdownWidgets[3]

    path:Update(  nil,'' )
    layer:Update( nil,'' )
    blend:Update( nil,'' )
    viewer:SetPath('')
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
            updateParticle(frame, item.key, value)
        end
    end

    local path = LibGUI:NewWidget('label', frame, 'PathLabel', { 'TOPLEFT', 0, -10 }, { 80, 30 }, nil, nil)
    path:Update( { 'OVERLAY', 'GameFontNormal','Atlas' } )
    local pathMenu = LibGUI:NewWidget('dropdownmenu', frame, 'PathDropdown', { 'LEFT', path, 'RIGHT' }, { 200, 25 }, nil, nil)
    --pathMenu:Update( V.Medias:GetParticleDropDown() )
    pathMenu.key = 'AtlasName'
    pathMenu:RegisterObserver(frame.Observer)

    local layer = LibGUI:NewWidget('label', frame, 'LayerLabel', { 'TOPLEFT', path, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    layer:Update( { 'OVERLAY', 'GameFontNormal','Layer' } )
    local layerMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LayerDropdown', { 'TOPLEFT', pathMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    --layerMenu:Update(layers)
    layerMenu.key = 'Layer'
    layerMenu:RegisterObserver(frame.Observer)

    local blend = LibGUI:NewWidget('label', frame, 'BlendLabel', { 'TOPLEFT', layer, 'BOTTOMLEFT', 0, -4 }, { 80, 30 }, nil, nil)
    blend:Update( { 'OVERLAY', 'GameFontNormal','Blending Mode' } )
    local blendMenu = LibGUI:NewWidget('dropdownmenu', frame, 'BlendDropdown', { 'TOPLEFT', layerMenu, 'BOTTOMLEFT', 0, -4 }, { 200, 25 }, nil, nil)
    --blendMenu:Update(blendmode)
    blendMenu.key = 'BlendMode'
    blendMenu:RegisterObserver(frame.Observer)

    local viewer = Inspector:CreateComponentGUI('Viewer', 'ViewerFrame', frame, blendMenu, nil, {
        {'TOPLEFT', 0, -120}, {'TOPRIGHT'}
    }, false, false, false, nil)

    --TODO DEBUG PURPOSE REMOVE THIS
    --viewer:SetPath('Muzzle')

    frame.UpdateView = updateView
    frame:SetHeight(250)

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

Inspector:RegisterComponentGUI('Particle', gui, update, clean)

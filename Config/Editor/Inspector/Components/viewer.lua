local _, Plugin = ...

local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local LibAtlas

local function setIcon(self)
    self.Widgets[1]:ChangeIcon( LibAtlas:GetPath(self.path))
    self.Widgets[1]:SetTexCoord(LibAtlas:GetTexCoord(self.path, 1))
end

local function updateIcon(self)
    self.Widgets[1]:SetTexCoord(LibAtlas:GetTexCoord(self.path, self.sprite, false))
end

local function play(self)
    local frame = self:GetParent()
    frame.onPlay = true
end

local function onUpdate(self, elapsed)
    if self.onPlay == false then
        return
    end

    if self.elapsed >= self.frequency then
        self.elapsed = 0
        self.sprite = self.sprite + 1
        if self.sprite > self.spriteCount then
            self.sprite = 1
        end
        updateIcon(self)
    else
        self.elapsed = self.elapsed + elapsed
    end
end

local function step(self)
    local frame = self:GetParent()
    frame.onPlay = false
    frame.elapsed = 0

    frame.sprite = frame.sprite + 1
    if frame.sprite > frame.spriteCount then
        frame.sprite = 1
    end
    updateIcon(frame)
end

local function stop(self)
    local frame = self:GetParent()
    frame.onPlay = false

    frame.elapsed = 0
    frame.sprite = 1
    frame.frequency = 1/30
    updateIcon(frame)
end

local function setPath(self, path)
    if path and path ~= '' then
        self.path = path
        self.spriteCount = LibAtlas:GetSpriteCount(path)
        setIcon(self)
    end
end

local function onClickFPSButton(self, ...)
    self:Disable()
    self:GetParent().frequency = self.frequency
    local b
    for i = 1, select('#', ...) do
        b = select(i, ...)
        b:Enable()
    end
end

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config, isBlended)

    LibAtlas = V.Medias:GetLibAtlas()
    local pt
    if point then
        pt = point
    else
        pt = {
            { 'TOPLEFT', parentPoint or parent, 'BOTTOMLEFT', 0, 0 },
            { 'TOPRIGHT', parentPoint or parent, 'BOTTOMRIGHT', 0 , 0 }
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            baseName..'ViewerFrame',
            nil,
            pt
    )

    frame.SetPath = setPath

    --[[
   ANIMATION VIEWER
   --]]
    local viewerTexture = LibGUI:NewWidget('icon', frame, baseName..'ViewerIcon', { 'TOP', 0, -4 }, { 100, 100 }, nil, nil)

    viewerTexture.bg = frame:CreateTexture(nil, 'BACKGROUND')
    viewerTexture.bg:SetPoint('TOPLEFT', viewerTexture)
    viewerTexture.bg:SetPoint('BOTTOMRIGHT', viewerTexture)
    viewerTexture.bg:SetColorTexture( 0, 0, 0, 0.66 )

    frame.sprite = 1
    frame.frequency = 1/30
    frame.elapsed = 0
    frame.spriteCount = 0
    frame.onPlay = false

    local viewerPlay = LibGUI:NewWidget('button', frame, 'ViewerPlay', { 'TOPRIGHT', viewerTexture, 'TOPLEFT', -10, 0 }, {30, 30}, 'UIPanelButtonTemplate')
    viewerPlay:Update( {'>', play })
    local viewerStep = LibGUI:NewWidget('button', frame, 'ViewerStep', { 'TOPLEFT', viewerPlay, 'BOTTOMLEFT', 0, -4 }, {30, 30}, 'UIPanelButtonTemplate')
    viewerStep:Update( {'>||', step })
    local viewerStop = LibGUI:NewWidget('button', frame, 'ViewerStop', { 'TOPLEFT', viewerStep, 'BOTTOMLEFT', 0, -4 }, {30, 30}, 'UIPanelButtonTemplate')
    viewerStop:Update( {'=', stop })

    local viewerFPS10 = LibGUI:NewWidget('button', frame, 'ViewerFPS10', { 'TOPLEFT', viewerTexture, 'TOPRIGHT', 10, 0 }, {60, 30}, 'UIPanelButtonTemplate')
    viewerFPS10.frequency = 1/10
    local viewerFPS20 = LibGUI:NewWidget('button', frame, 'ViewerFPS20', { 'TOPLEFT', viewerFPS10, 'BOTTOMLEFT', 0, -4 }, {60, 30}, 'UIPanelButtonTemplate')
    viewerFPS20.frequency = 1/20
    local viewerFPS30 = LibGUI:NewWidget('button', frame, 'ViewerFPS30', { 'TOPLEFT', viewerFPS20, 'BOTTOMLEFT', 0, -4 }, {60, 30}, 'UIPanelButtonTemplate')
    viewerFPS30.frequency = 1/30

    viewerFPS10:Update( {'10 FPS', function(self)
       onClickFPSButton(self, viewerFPS20, viewerFPS30)
    end })


    viewerFPS20:Update( {'20 FPS', function(self)
        onClickFPSButton(self, viewerFPS10, viewerFPS30)
    end })

    viewerFPS30:Update( {'30 FPS', function(self)
        onClickFPSButton(self, viewerFPS20, viewerFPS10)
    end })

    frame:SetScript('OnUpdate', onUpdate)
    frame:SetHeight(90)

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

Inspector:RegisterComponentGUI('Viewer', gui)

local _, Plugin = ...
local select = select

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI
local LibAtlas

local mmath = math.max
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border

local colors = {
    ["Default"] =  {0.77, 0.12, 0.23, 1},
    ["Hover"] = { 1, 0.96, 0.41, 1 },
    ["Selected"] = { 0, 1, 0.59, 1 }
}
local atlasDropdown

local size = 340

local initialized = false

local function updateAtlas(self, name, texCoord)
    local iconWidgets = LibGUI:GetWidgetsByType(self, 'icon')
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')
    local viewerAtlas = iconWidgets[1]

    local width, height = viewerAtlas:GetSize()
    local atlasWidth, atlasHeight = LibAtlas:GetSize(name)
    local texture = LibAtlas:GetPath(name)
    local factor = mmath(width, height) / mmath(atlasWidth, atlasHeight)
    local newHeight = atlasHeight*factor
    viewerAtlas:SetSize(atlasWidth * factor, newHeight)

    local atlas = LibAtlas:GetAtlas(name)
    local name = texCoord or ''

    local i = 1
    local btn
    for k, v in pairs(atlas.Sprites) do
        if k ~= 'width' and k ~= 'height' then
            btn = buttonWidgets[i]
            btn:SetSize( (v[2]-v[1]) * factor, (v[4]-v[3]) * factor)
            btn:SetPoint("TOPLEFT", viewerAtlas, "TOPLEFT", v[1]*factor, -v[3]*factor)
            btn.text = k
            if k == name then
                btn.color = colors["Selected"]
            else
                btn.color = colors['Default']
            end
            btn:SetBorderColor( btn.color )
            btn:Show()
            i = i + 1
        end
    end
    while i < 20 do
        buttonWidgets[i]:Hide()
        i = i + 1
    end

    viewerAtlas:ChangeIcon(texture)

    self:SetHeight(400 - (height-newHeight))
end

local function update(self, texture, texCoord, vertexColor, blendMode, gradientAlpha)
    local dropdownWidgets = LibGUI:GetWidgetsByType(self, 'dropdownmenu')
    local chooseAtlas = dropdownWidgets[1]

    updateAtlas(self, texture, texCoord)

    if initialized == false then
        chooseAtlas:Update( atlasDropdown, texture )
        initialized = true
    end
end

local function clean(self)
    local iconWidgets = LibGUI:GetWidgetsByType(self, 'icon')
    local buttonWidgets = LibGUI:GetWidgetsByType(self, 'button')
    local viewerAtlas = iconWidgets[1]

    viewerAtlas:SetSize(size, size)
    viewerAtlas:ChangeIcon( '' )

    local btn
    for i=1, 20 do
        btn = buttonWidgets[i]
        btn:SetBorderColor( colors["Default"] )
        btn.color = colors["Default"]
        btn:ClearAllPoints()
        btn:Hide()
    end

    self:SetHeight(400)

    initialized = false
end

local function gui(baseName, parent, parentPoint, componentName, point, hasBorder, isCollapsable, hasName, config)

    LibAtlas = V.Medias:GetLibAtlas()
    atlasDropdown = V.Medias:GetAtlasDropDown()
    local height = 0
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
            baseName..'Atlas',
            nil,
            pt
    )
    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            if item.key == 'Texture' then
                updateAtlas(frame, value)
            else
                print (event, item.key, unpack(value))
            end
        end
    end

    local atlasLabel = LibGUI:NewWidget('label', frame, 'AtlasLabel', { 'TOPLEFT', 0, -10 }, { 100, 30 }, nil, nil)
    atlasLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Choose Atlas' } )
    local atlasMenu = LibGUI:NewWidget('dropdownmenu', frame, 'AtlasDropdown', { 'LEFT', atlasLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    --indicatorMenu:Update( indicatorDropdown )
    atlasMenu.key = 'Texture'
    atlasMenu:RegisterObserver(frame.Observer)

    --[[
    --  Atlas Viewer
    ]]--
    local viewerAtlas = LibGUI:NewWidget('icon', frame, baseName..'ViewerAtlas', { 'TOP', 0, -50 }, { size, size }, nil, nil)
    viewerAtlas.bg = frame:CreateTexture(nil, 'BACKGROUND')
    viewerAtlas.bg:SetPoint('TOPLEFT', viewerAtlas)
    viewerAtlas.bg:SetPoint('BOTTOMRIGHT', viewerAtlas)
    viewerAtlas.bg:SetColorTexture( 0, 0, 0, 0.66 )

    local btn, r, g, b
    for i=1, 20 do
        btn = LibGUI:NewWidget('button', frame, baseName..'ViewerAtlasButton'..i, nil, { 20, 20 }, nil, nil)
        btn:CreateBorder( 2, colors["Default"] )
        btn:Bind('OnClick', function(self)
            local name = atlasMenu:GetValue()
            local txt = self.text
            updateAtlas(frame, name, txt)
            self.Subject:Notify({ 'OnClick', self, { name, txt } })
        end)
        btn:Bind('OnEnter', function(self)
            self:SetBorderColor( colors["Hover"] )
        end)
        btn:Bind('OnLeave', function(self)
            self:SetBorderColor( self.color )
        end)
        btn:Hide()
        btn:ClearAllPoints()
        btn.key = i
        btn:RegisterObserver(frame.Observer)
        --btn:Raise() --mandatory to avoid issue with button
    end

    frame:SetHeight(400)
    if hasBorder then
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

Inspector:RegisterComponentGUI('Atlas', gui, update, clean)
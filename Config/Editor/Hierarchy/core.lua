local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Hierarchy = CreateFrame("Frame")

local borderSettings = Editor.border
local textureExpand = [[interface/buttons/ui-panel-expandbutton-up.blp]]
local textureCollapse = [[interface/buttons/ui-panel-collapsebutton-up.blp]]

--[[
    INSPECTOR FRAME CONFIG
]]--
local hierarchy = {
    root = {
        type = 'frame',
        params = {
            parent = UIParent,
            name = 'VorkuiEditorHierarchy',
            title = 'Vorkui Hierarchy',
            size = {300, 400},
            point = { 'TOP' },
        },
        childs = {
        }
    }
}

local function expand(frame)
    for i=1, #frame.Widgets do
        if frame.Widgets[i].HasCollapseSystem == nil or frame.Widgets[i]:HasCollapseSystem() == false then
            frame.Widgets[i]:Show()
        end
    end

    for _, c in ipairs(frame.Childs) do
        c:Show()
    end

    frame.Widgets[1].Texture:SetTexture(textureExpand)
    frame:GetParent():GetParent():ResizeScrollChild()
end

local function collapse(frame)
    for i=1, #frame.Widgets do
        if frame.Widgets[i].HasCollapseSystem == nil or frame.Widgets[i]:HasCollapseSystem() == false then
            frame.Widgets[i]:Hide()
        end
    end

    for _, c in ipairs(frame.Childs) do
        c:Hide()
    end

    frame.Widgets[1].Texture:SetTexture(textureCollapse)
    frame:GetParent():GetParent():ResizeScrollChild()
end

local function createModule(name, parent, point)

    local btn = LibGUI:NewWidget('button', parent, name, point, { 0, 25 }, 'UIPanelButtonTemplate')

    return btn
end

local function createSystem(name, parent, point)
    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            name,
            nil,
            point
    )
    frame:CreateBorder(borderSettings.size, borderSettings.color)

    local sectionName = LibGUI:NewWidget('button', frame, 'NameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    local collapseTexture = sectionName:AddTexture({ 'LEFT', 0, 10})
    collapseTexture:SetSize(30, 30)
    sectionName:AddLabel(sectionName, nil, { 'LEFT', collapseTexture, 'RIGHT', 5, 0}, 'Game15Font_o1')
    sectionName.Text:SetSize( 150, 30 )
    sectionName.Text:SetJustifyH('LEFT')
    sectionName.Texture = collapseTexture
    sectionName:AddCollapseSystem(frame, collapse, expand)
    return frame
end

local function createSystemOutliner(self)
    local frameParent = self.UI.TitleBg
    local scrollParent = self.UI.Scroll

    local searchLabel = LibGUI:NewWidget('label',
            self.UI,
            'SearchLabel',
            { 'TOPLEFT', frameParent, 'BOTTOMLEFT', 2, -16 },
            { 130, 30 },
            nil,
            nil)
    searchLabel:Update( { 'ARTWORK', 'GameFontNormal', 'Select a system' } )
    searchLabel:JustifyH('LEFT')
    local searchEdit = LibGUI:NewWidget('editbox', self.UI, 'SearchEdit', { 'LEFT', searchLabel, 'RIGHT' }, { 155, 30 }, 'SearchBoxTemplate')
    searchEdit:ChangeFont( 'Game11Font' )

    scrollParent:SetPoint('TOPLEFT', searchLabel, 'BOTTOMLEFT')
    scrollParent:SetPoint('RIGHT', frameParent, 'RIGHT', -2, 0)
    scrollParent:SetPoint('BOTTOM', self.UI, 'BOTTOM', 0, 4)

end

--[[
    CORE FUNCTION
]]--

function Hierarchy:CreateGUI()
    local root = hierarchy.root

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
            {root.params.size[1] -20, 0}
    )
    frame.Scroll.enableAllChilds = false
    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

    self.UI = frame;

    createSystemOutliner(self)

    self:Hide()
end

local function getModule(system, idx)
    local moduleCount = #system.Widgets
    --be careful because system frame got 1 widget for collapseButton
    local point

    if moduleCount == 1 then
        point = {
            { 'TOPLEFT', system, 'TOPLEFT', 4, 0 },
            { 'TOPRIGHT', system, 'TOPRIGHT', -4, 0 },
        }
    else
        point = {
            { 'TOPLEFT', system.Widgets[moduleCount], 'BOTTOMLEFT' },
            { 'TOPRIGHT', system.Widgets[moduleCount], 'BOTTOMRIGHT' },
        }
    end

    --we need to offset by one cause NameLabel Widget
    if idx + 1 > moduleCount then
        return createModule('module'..idx, system, point)
    else
        return system.Widgets[idx]
    end

end

local function getSystem(self, idx)
    local sectionCount = #self.Childs
    local point

    if sectionCount == 0 then
        point = {
            { 'TOPLEFT', self, 'TOPLEFT', 4, -20 },
            { 'TOPRIGHT', self, 'TOPRIGHT', 4, -20 },
        }
    else
        point = {
            { 'TOPLEFT', self.Childs[sectionCount], 'BOTTOMLEFT', 0, -20 },
            { 'TOPRIGHT', self.Childs[sectionCount], 'BOTTOMRIGHT', 0, -20 },
        }
    end

    if idx > sectionCount then
        return createSystem('System'..idx, self, point)
    else
        return self.Childs[idx]
    end
end

local function updateContent(self)
    local systems = Editor:GetSystems()
    local scroll = self.UI.Scroll
    local buttonParent = scroll.ScrollChild

    local iSystem = 1
    local parent = scroll
    local height = 0
    local btn
    local h
    local collapseButton
    for k, v in pairs(systems) do
        h = 0
        parent = getSystem(buttonParent, iSystem)
        collapseButton = parent.Widgets[1]
        for i, m in ipairs(v) do
            btn = getModule(parent, i)
            btn:ChangeText(m)
            btn:Bind('OnClick', function(self)
                Editor.Inspector:Inspect( Editor:GetFrameBySystemAndModule(k, m) )
            end)
            h = h + btn:GetHeight()
        end
        collapseButton:ChangeText(k)
        collapseButton.Texture:SetTexture(textureExpand)
        parent.frameHeight = h + 2
        parent:SetHeight(h + 2)
        parent:Show()
        height = height + h + 2
        iSystem = iSystem + 1
    end
    scroll.ScrollChild:SetHeight(height)
    scroll:ShowScrollChild()
end

function Hierarchy:Enable()
    updateContent(self)

    self.UI:Show()
end

function Hierarchy:Disable()
    self:Hide()
end

function Hierarchy:Refresh()
end

Hierarchy:SetScript('OnShow', Hierarchy.Enable)
Hierarchy:SetScript('OnHide', Hierarchy.Disable)

Editor.Hierarchy = Hierarchy
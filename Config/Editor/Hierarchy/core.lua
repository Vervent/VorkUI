local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Hierarchy = CreateFrame("Frame")

local scrollableComponents = {}
local fixedComponents = {}
local visibleComponentIndex = {}

local currentFrame = nil
local currentItem = nil
local currentComponent = nil
local parentDropdown = nil

local borderSettings = Editor.border

--	interface/talentframe/ui-talentarrows.blp
-- interface/glues/common/glue-rightarrow-button-up.blp
-- interface/glues/common/glue-rightarrow-button-highlight.blp
-- interface/glues/common/glue-rightarrow-button-down.blp

--interface/buttons/ui-panel-collapsebutton-up.blp
--252128	interface/buttons/ui-panel-expandbutton-up.blp
--252127	interface/buttons/ui-panel-expandbutton-down.blp
--252126	interface/buttons/ui-panel-expandbutton-disabled.blp

local textureExpand = [[interface/buttons/ui-panel-expandbutton-up.blp]]
local textureCollapse = [[interface/buttons/ui-panel-collapsebutton-up.blp]]

local texturePath = {
    ["expand"] = {
        [[interface/buttons/ui-panel-expandbutton-up.blp]],
        [[interface/buttons/ui-panel-expandbutton-disabled.blp]],
        [[interface/buttons/ui-panel-expandbutton-up.blp]],
        [[interface/buttons/ui-panel-expandbutton-down.blp]],
    },
    ["collapse"] = {
        [[interface/buttons/ui-panel-collapsebutton-up.blp]],
        [[interface/buttons/ui-panel-collapsebutton-disabled.blp]],
        [[interface/buttons/ui-panel-collapsebutton-up.blp]],
        [[interface/buttons/ui-panel-collapsebutton-down.blp]],
    }
}

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
            point = { 'TOPLEFT' },
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

local function createSubsection(name, parent, point)
    local btn = LibGUI:NewWidget('button', parent, name, point, { 200, 25 }, 'UIPanelButtonTemplate')

    return btn
end

local function createSection(name, parent, point)
    local frame = LibGUI:NewContainer(
            'empty',
            parent,
            name,
            nil,
            point
    )
    --frame:SetHeight(30)
    frame:CreateBorder(borderSettings.size, borderSettings.color)
    local name = LibGUI:NewWidget('button', frame, 'NameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 30 }, nil, nil)
    local texture = name:AddTexture({'LEFT', 0, 10})
    texture:SetSize(30,30)
    name:AddLabel(name, nil, {'LEFT', texture, 'RIGHT', 5, 0}, 'Game15Font_o1')
    name.Text:SetSize( 150, 30 )
    name.Text:SetJustifyH('LEFT')
    name.Texture = texture
    name:AddCollapseSystem(frame, collapse, expand)

    return frame
end

local function createSystemOutliner(self)
    local frameParent = self.UI.TitleBg
    local scrollParent = self.UI.Scroll
    local inspector = Editor.Inspector

    local searchLabel = LibGUI:NewWidget('label', self.UI, 'SearchLabel',
            { 'TOPLEFT', frameParent, 'BOTTOMLEFT', 2, -16 }, { 130, 30 }, nil, nil)
    searchLabel:Update( { 'ARTWORK', 'GameFontNormal', 'Select a system' } )
    searchLabel:JustifyH('LEFT')
    local searchEdit = LibGUI:NewWidget('editbox', self.UI, 'SearchEdit', { 'LEFT', searchLabel, 'RIGHT' }, { 155, 30 }, 'SearchBoxTemplate')
    searchEdit:ChangeFont( 'Game11Font' )

    scrollParent:SetPoint('TOPLEFT', searchLabel, 'BOTTOMLEFT')
    scrollParent:SetPoint('RIGHT', frameParent, 'RIGHT', -2, 0)
    scrollParent:SetPoint('BOTTOM', self.UI, 'BOTTOM', 0, 4)

    --local scrollChild = scrollParent.ScrollChild
    --local pt
    --for i=1, 10 do
    --    if i == 1 then
    --        pt = {
    --            { 'TOPLEFT', scrollChild, 'TOPLEFT', 0, -16 },
    --            { 'TOPRIGHT', scrollChild, 'TOPRIGHT', 0 , -16 }
    --        }
    --    else
    --        pt =   {
    --            { 'TOPLEFT', scrollChild.Widgets[i-1], 'BOTTOMLEFT' },
    --            { 'TOPRIGHT', scrollChild.Widgets[i-1], 'BOTTOMRIGHT' }
    --        }
    --    end
    --    --local frame = LibGUI:NewContainer(
    --    --        'empty',
    --    --        scrollChild,
    --    --        'scrollChild'..i,
    --    --        nil,
    --    --        pt
    --    --)
    --    --frame:SetHeight(30)
    --    --frame:CreateBorder(2, { 1, 1, 1, 1 })
    --
    --    local btn = LibGUI:NewWidget('button', scrollChild, 'button'..i, pt, { 200, 30 }, 'UIPanelButtonTemplate')
    --end

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
    --frame.Scroll:CreateBorder(borderSettings.size, borderSettings.color )

    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

    self.UI = frame;

    createSystemOutliner(self)

    self:Hide()
end

local function updateContent(self)
    local systems = Editor:GetSystems()
    local scroll = self.UI.Scroll
    local buttonParent = scroll.ScrollChild

    scroll:ShowScrollChild()
    --for k, v in pairs(buttonParent.Childs) do
    --    v:Show()
    --    print ('show', v:GetName())
    --end
    local point
    local pt
    local iSystem = 1
    local parent = scroll
    local btn
    local h
    local collapseButton
    for k, v in pairs(systems) do
        h = 0
        if iSystem == 1 then
            point = {
                { 'TOPLEFT', parent, 'TOPLEFT', 4, -20 },
                { 'TOPRIGHT', parent, 'TOPRIGHT', -4, -20 }
            }
        else
            point = {
                { 'TOPLEFT', parent, 'BOTTOMLEFT', 0, -20 },
                { 'TOPRIGHT', parent, 'BOTTOMRIGHT', 0, -20 }
            }
        end
        parent = createSection(k, buttonParent, point)
        collapseButton = parent.Widgets[1]
        btn = parent
        for i, m in ipairs(v) do
            if i==1 then
                pt = {
                    {'TOPLEFT', btn, 'TOPLEFT', 4, 0},
                    {'TOPRIGHT', btn, 'TOPRIGHT', -4, 0}
                }
            else
                pt = {
                    {'TOPLEFT', btn, 'BOTTOMLEFT'},
                    {'TOPRIGHT', btn, 'BOTTOMRIGHT'}
                }
            end
            btn = createSubsection(m, parent, pt)
            btn:ChangeText(m)
            btn:Bind('OnClick', function(self)
                Editor.Inspector:Inspect( Editor:GetFrameBySystemAndModule(k, m) )
            end)
            h = h + btn:GetHeight()
        end

        collapseButton:ChangeText(k)
        collapseButton.Texture:SetTexture(textureExpand)

        parent:SetHeight(h + 2)
        parent.frameHeight = h + 2
        parent:Show()
        iSystem = iSystem + 1
    end


    scroll:ResizeScrollChild()
    --local parent, relativeTo = buttonParent, 'TOPLEFT'
    --local idx = 1
    --for k, v in pairs(systems) do
    --    parent = LibGUI:NewContainer( 'empty', buttonParent, 'button'..idx, {100, 30}, { 'TOPLEFT', parent, relativeTo })
    --    parent:CreateBorder(2, { 1, 1, 1, 1 })
    --    --parent = LibGUI:NewWidget('button', buttonParent, 'button'..idx, { 'TOPLEFT', parent, relativeTo }, {100, 30}, 'UIPanelButtonTemplate')
    --    relativeTo = 'BOTTOMLEFT'
    --    --parent:SetID(idx)
    --    --parent:ChangeText(k)
    --    idx = idx + 1
    --end

    --scroll:ShowScrollChild()
    --scroll:ResizeScrollChild()

    --local list = ComponentsGUI[1]
    --
    --list:Update(systems)

    print ('update content')
    for k, v in pairs(systems) do
        print (k,':')
        for i, m in ipairs(v) do
            print (m)
        end
    end

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
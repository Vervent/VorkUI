local _, Plugin = ...

local select = select
local unpack = unpack
local pairs = pairs
local type = type
local tinsert = tinsert

local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local anchors = Editor.menus.anchors

local pointColor = {
    { 1, 0.85, 0, 1 },
    { 0.25, 1, 0.25, 1 },
    { 0, 0.5, 1, 1 },
}

--[[
    Debug Purpose
]]--
local pointConfig = {
}

local minOffset = -500
local maxOffset = 500

local initialized = false

local function export(container, event)

    local val
    if next(pointConfig) == nil then
        val = nil
    else
        val = pointConfig
    end

    if container.Observer then
        --print ('|cFF10FF10 POINT CONTAINER EXPORT|r')
        container.Observer.OnNotify(event, val)
    else
        --print ('|cFFFF1010 POINT DIRECT EXPORT |r')
        Inspector:SubmitUpdateValue(nil, 'Point', nil, nil, val)
    end
end

local function updatePointConfig(index, key, value)

    if pointConfig[index] == nil then
        return
    end

    if key == 5 and pointConfig[index][4] == nil then
        pointConfig[index][4] = 0
    elseif key == 4 and pointConfig[index][5] == nil then
        pointConfig[index][5] = 0
    end

    if pointConfig[index] then
        pointConfig[index][key] = value
    end
end

local function viewMustClearAllPoints(parent, realparent, child)
    local _, p = child:GetPoint()
    if p == realparent then
        return false
    elseif p == parent or nil then
        return true
    end

end

local function getAnchorIdx(point)
    for i=1, #anchors do
        if anchors[i] == point then
            return i
        end
    end
    return 0
end

local function resetWidgets(self, i)

    local anchorChild, _, relativeTo = unpack(pointConfig[i])
    local countPoint = 0

    local btnChildIdx = getAnchorIdx(anchorChild)
    local btnParentIdx = getAnchorIdx(relativeTo)
    local btn

    local anchorView = self.Childs[1]
    if btnChildIdx > 0 then
        btn = anchorView.Childs[2].Widgets[btnChildIdx]
        btn:ChangeColor({ 1, 1, 1, 1 })
    end

    if btnParentIdx > 0 then
        btn = anchorView.Childs[1].Widgets[btnParentIdx]
        btn:ChangeColor({ 1, 1, 1, 1 })
    end
    anchorView.Childs[2]:ClearAllPoints()

    for idx, p in ipairs(pointConfig) do
        if idx ~= i and p ~= nil and type(p) == 'table' then
            countPoint = countPoint + 1
            anchorView.Childs[2]:SetPoint(p[1], anchorView.Childs[1], p[3])
        end
    end

    if countPoint == 0 then
        anchorView.Childs[2]:SetPoint('CENTER')
        anchorView.Childs[2]:SetSize(40, 40)
        LibGUI:SetMovableContainer(anchorView.Childs[2], false)
    elseif countPoint == 1 then
        --resize child to original size
        anchorView.Childs[2]:SetSize(40, 40)
    end

    local offsetContainer = self.Childs[2]
    offsetContainer.Childs[i].isUsed = false
    offsetContainer.Childs[i]:DisableChilds()
    offsetContainer.Childs[i].Widgets[2]:ChangeText(0)
    offsetContainer.Childs[i].Widgets[3]:ChangeText(0)
    offsetContainer.Childs[i].Widgets[4]:Update(self.parentDropdown, '')
end

local function removePoint(self, i)

    resetWidgets(self, i)
    pointConfig[i] = nil

end

local function addPoint(table, container, anchorChild, relativeTo)
    if table and #table == 3 then
        return
    end
    tinsert(table, {anchorChild, nil, relativeTo})

    for i = 1, 3 do
        if not container.Childs[i].isUsed then
            container.Childs[i].isUsed = true
            container.Childs[i]:EnableChilds()
            if initialized == true then
                export(container, 'OnCreate')
            end
            return i
        end
    end
    --Inspector:SubmitUpdateValue(nil, 'Point', nil, nil, pointConfig)
end

local function snap(frame)
    local btn1, btn2 = unpack(frame.anchorPairs)
    local setter = frame.Childs[1]
    local p1 = btn1:GetParent()
    local p2 = btn2:GetParent()
    local pt1, pt2

    if p1 == setter.Childs[1] then
        --snap btn2 to btn1
        if viewMustClearAllPoints(setter, p1, p2) then
            p2:ClearAllPoints()
            LibGUI:UnsetMovableContainer(p2)
        end
        p2:SetPoint( anchors[btn2:GetID()], p1, anchors[btn1:GetID()] )
        pt1 = anchors[btn2:GetID()]
        pt2 = anchors[btn1:GetID()]
    else
        --snap btn1 to btn2
        if viewMustClearAllPoints(setter, p2, p1) then
            p1:ClearAllPoints()
            LibGUI:UnsetMovableContainer(p1)
        end
        p1:SetPoint( anchors[btn1:GetID()], p2, anchors[btn2:GetID()] )

        pt1 = anchors[btn1:GetID()]
        pt2 = anchors[btn2:GetID()]
    end

    local colorIdx = addPoint(pointConfig, frame.Childs[2], pt1, pt2)
    btn1:ChangeColor( pointColor[colorIdx] )
    btn2:ChangeColor( pointColor[colorIdx] )

    frame.anchorPairs={}

    return colorIdx
end

local function clickSnapButton(self)
    if self.componentParent ~= nil then
        local parent = self.componentParent
        self:ChangeColor( { 1, 0.25, 0.25, 1 } )
        if parent.anchorPairs[1] == nil then
            parent.anchorPairs[1] = self
        elseif parent.anchorPairs[1]:GetParent() == self:GetParent() then
            parent.anchorPairs[1]:ChangeColor( {1, 1, 1, 1} )
            parent.anchorPairs[1] = self
        else
            parent.anchorPairs[2] = self
            return snap(parent)
        end
    end

end

local function addSnapButton(container, color, frame)

    local item
    for i=1, 9 do
        item = LibGUI:NewWidget('button',
                container,
                container:GetName()..'AnchorButton'..i,
                { 'CENTER', container, anchors[i] },
                {6, 6})
        item:SetID(i)
        item:ChangeColor()
        item.icon = item:CreateTexture(nil, 'BACKGROUND')
        item.icon:SetAllPoints()
        if type(color) == 'table' then
            item:ChangeColor(color)
            --item.icon:SetColorTexture(unpack(color))
        end
        item:Update({ '', clickSnapButton })
        item.componentParent = frame
    end

end

local function addOffsetSetter(container, index)

    local name = container:GetName()
    local point

    if index > 1 then
        point = {
            { 'TOPLEFT', container.Childs[index -1], 'BOTTOMLEFT', 0, -10 },
            { 'TOPRIGHT', container.Childs[index -1], 'BOTTOMRIGHT', 0 , -10 }
        }
    else
        point = {
            { 'TOPLEFT', container, 'TOPLEFT', 0, -30 },
            { 'TOPRIGHT', container, 'TOPRIGHT', 0 , -30 }
        }
    end

    local frame = LibGUI:NewContainer(
            'empty',
            container,
            name..'OffsetFrame'..index,
            { 0, 30 },
            point
    )

    frame.isUsed = false

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function (...)
            local event, item, value = unpack(...)
            updatePointConfig(index, item.key, value)
            export(container, event)
        end
    end

    local icon = LibGUI:NewWidget('icon', frame, 'ColorIcon'..index, { 'LEFT', 10, 0 }, { 10, 10 }, 'ARTWORK')
    icon:ChangeColorTexture( pointColor[index] )

    local xOffsetEdit = LibGUI:NewWidget('editbox', frame, 'XOffsetEdit'..index, { 'LEFT', icon, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    xOffsetEdit:SetMinMax( minOffset, maxOffset )
    xOffsetEdit.key = 4
    xOffsetEdit:RegisterObserver(frame.Observer)

    local yOffsetEdit = LibGUI:NewWidget('editbox', frame, 'YOffsetEdit'..index, { 'LEFT', xOffsetEdit, 'RIGHT', 60, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    yOffsetEdit:SetMinMax( minOffset, maxOffset )
    yOffsetEdit.key = 5
    yOffsetEdit:RegisterObserver(frame.Observer)

    local parentMenu = LibGUI:NewWidget('dropdownmenu', frame, 'ParentDropdown'..index, { 'LEFT', yOffsetEdit, 'RIGHT', 10, -2 }, { 80, 20 }, nil, nil)
    parentMenu.key = 2
    parentMenu:RegisterObserver(frame.Observer)

    local btnRemove = LibGUI:NewWidget('button', frame, 'RemoveButton'..index, { 'RIGHT', -10, 0}, { 20, 20 }, 'UIPanelButtonTemplate')
    btnRemove:SetID(index)
    btnRemove:Update( { ' -', function(self)
        removePoint(container:GetParent(), self:GetID())
        export(container, 'OnDestroy')
        --Inspector:SubmitUpdateValue(nil, 'Point', nil, nil, pointConfig)
    end } )

    frame.DisableChilds = function()
        xOffsetEdit:Disable()
        yOffsetEdit:Disable()
        btnRemove:Disable()
        parentMenu:Disable()
    end

    frame.EnableChilds = function()
        xOffsetEdit:Enable()
        yOffsetEdit:Enable()
        btnRemove:Enable()
        parentMenu:Enable()
    end

    frame:DisableChilds()

    return frame
end

local function updateWidgets(self, anchor, parent, relativeTo, x, y)

    local anchorId = getAnchorIdx(anchor)
    local relativeToId = getAnchorIdx(relativeTo)
    local setterFrame = self.Childs[1]
    local parentFrame = setterFrame.Childs[1]
    local childFrame = setterFrame.Childs[2]
    local tableFrame = self.Childs[2]

    anchor = anchor or 'CENTER'
    relativeTo = relativeTo or 'CENTER'

    anchorId = getAnchorIdx(anchor)
    relativeToId = getAnchorIdx(relativeTo)

    local parentButtons = LibGUI:GetWidgetsByType(parentFrame, 'button')
    local childButtons = LibGUI:GetWidgetsByType(childFrame, 'button')

    clickSnapButton(childButtons[anchorId])
    local idx = clickSnapButton(parentButtons[relativeToId])

    tableFrame.Childs[idx].Widgets[2]:ChangeText( x )
    tableFrame.Childs[idx].Widgets[3]:ChangeText( y )
    tableFrame.Childs[idx].Widgets[4]:Update( self.parentDropdown, parent )

    return idx
end

local function update(self, config, parentDropdown)

    --print ('|cff33ff99 Update Point|r')

    local idx
    local anchor, parent, relativeTo, x, y

    local setterFrame = self.Childs[1]
    local tableFrame = self.Childs[2]

    self.parentDropdown = parentDropdown
    for i=1, 3 do
        tableFrame.Childs[i].Widgets[4]:Update( parentDropdown )
    end
    if config == nil then
        return
    end

    if type(config[1]) == 'table' then
        --complex table point
        for i, v in ipairs(config) do
            anchor, parent, relativeTo, x, y = unpack(v)
            idx = updateWidgets(self, anchor, parent, relativeTo, x, y)
            pointConfig[idx][2] = parent
            pointConfig[idx][4] = x
            pointConfig[idx][5] = y
        end
    else
        --tinsert(pointConfig, config)
        anchor, parent, relativeTo, x, y = unpack(config)
        idx = updateWidgets(self, anchor, parent, relativeTo, x, y)
        pointConfig[idx][2] = parent
        pointConfig[idx][4] = x
        pointConfig[idx][5] = y
    end

    initialized = true
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
            baseName..'PointFrame',
            nil,
            pt
    )
    frame:SetHeight(400)
    frame.anchorPairs = {}

    --[[
        The Anchor Snap Item
    ]]--
   local setterFrame = LibGUI:NewContainer(
           'empty',
           frame,
           'SetterFrame',
           { 200, 190 },
           { 'TOP', 0, -30 }
   )

    setterFrame:CreateBorder(2, { 1, 1, 1, 0.75 })
    setterFrame.bg = setterFrame:CreateTexture(nil, 'BACKGROUND', 0)
    setterFrame.bg:SetAllPoints()
    setterFrame.bg:SetColorTexture(0, 0, 0, 1)

    local setterAnchorLabel = LibGUI:NewWidget('label', setterFrame, 'AnchorLabel', { { 'TOPLEFT', 0, 25 }, { 'TOPRIGHT', 0, 25 } }, { 0, 30 }, nil, nil)
    setterAnchorLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Anchors View' } )

    local parentFrame = LibGUI:NewContainer(
            'empty',
            setterFrame,
            'ParentFrame',
            { 100, 100 },
            { 'CENTER' }
    )

    parentFrame:CreateBorder(2, { 0, 0.5, 1, 1 })
    parentFrame.bg = parentFrame:CreateTexture(nil, 'BACKGROUND', 0)
    parentFrame.bg:SetAllPoints()
    parentFrame.bg:SetColorTexture(1, 1, 1, 0.2)

    addSnapButton(parentFrame, { 1, 1, 1 }, frame)

    local childFrame = LibGUI:NewContainer(
            'frame',
            setterFrame,
            'ChildFrame',
            { 40, 40 },
            { 'CENTER' }
    )

    childFrame:CreateBorder(2, { 0.5, 0.5, 0, 1 })
    childFrame.bg = childFrame:CreateTexture(nil, 'BACKGROUND', 0)
    childFrame.bg:SetAllPoints()
    childFrame.bg:SetColorTexture(0.75, 0.75, 0, 0.2)
    LibGUI:SetMovableContainer(childFrame, false)

    addSnapButton(childFrame, { 1, 1, 1 }, frame)

    if hasBorder then
        frame:CreateBorder(borderSettings.size, borderSettings.color )
    end

    frame.pointConfig = pointConfig

    --
    local pointTableFrame = LibGUI:NewContainer(
            'empty',
            frame,
            'TableFrame',
            { 0, 150 },
            {
                { 'BOTTOMLEFT', 5, 10 },
                { 'BOTTOMRIGHT', -5, 10 },
            }
    )
    --local LibObserver = LibStub:GetLibrary("LibObserver")
    --if LibObserver then
    --    pointTableFrame.Observer = LibObserver:CreateObserver()
    --    pointTableFrame.Observer.OnNotify = function (...)
    --    end
    --end

    --pointTableFrame:CreateBorder(1, { 1, 1, 1, 1 })

    local pointTableLabel = LibGUI:NewWidget('label', pointTableFrame, 'TableLabel', { { 'TOPLEFT', 0, 25 }, { 'TOPRIGHT', 0, 25 } }, { 0, 30 }, nil, nil)
    pointTableLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Offset Settings' } )

    local pointTableOffsetXLabel = LibGUI:NewWidget('label', pointTableFrame, 'TableOffsetXLabel', { 'TOPLEFT', 45, 0 }, { 60, 30 }, nil, nil)
    pointTableOffsetXLabel:Update( { 'OVERLAY', 'GameFontNormal', 'X' } )

    local pointTableOffsetYLabel = LibGUI:NewWidget('label', pointTableFrame, 'TableOffsetYLabel', { 'TOPLEFT', 145, 0 }, { 60, 30 }, nil, nil)
    pointTableOffsetYLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Y' } )

    local pointTableParentLabel = LibGUI:NewWidget('label', pointTableFrame, 'TableParentLabel', { 'TOPLEFT', 245, 0 }, { 60, 30 }, nil, nil)
    pointTableParentLabel:Update( { 'OVERLAY', 'GameFontNormal', 'Parent' } )

    for i = 1, 3 do
        addOffsetSetter(pointTableFrame, i)
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

local function clean(self)

    for i=1, #pointConfig do
        --removePoint(self, i)
        resetWidgets(self, i)
    end

    pointConfig = {}
    initialized = false

    print ('|cFFFF1010 CLEAN POINT |r')
end

Inspector:RegisterComponentGUI('Point', gui, update, clean)
local _, Plugin = ...
local select = select

local V = select(2, ...):unpack()
--load libgui lib
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local helpfulFilter = Editor.menus.helpfulFilter
local harmfulFilter = Editor.menus.harmfulFilter
local sortingDropdown = Editor.menus.auraFilter
local directionX = Editor.menus.growDirectionX
local directionY = Editor.menus.growDirectionY

local minSize = 12
local maxSize = 50

local minSpacing = 0
local maxSpacing = 10

local labelFont = 'GameFontNormal'
local layer = 'OVERLAY'

local changeList = {}

local function enable(config)
end

local function GetChange()
    return changeList
end

local function disable(frame)
    changeList = {}
end

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, config, isHelpful)

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
            baseName..'AuraFrame',
            nil,
            pt
    )

    frame:SetSize(parent:GetWidth(), 500)

    local filters = nil
    if isHelpful then
        filters = helpfulFilter
    else
        filters = harmfulFilter
    end

    local filterFrame = Inspector:CreateComponentGUI('Submodules', baseName..'AuraFrameFilterFrame', frame, frame, 'Filters', {
        { 'TOPLEFT', 4, -20 },
        { 'TOPRIGHT', -4, -20 }
    }, false, false, true, filters)

    local sortingLabel = LibGUI:NewWidget('label', frame, 'SortingLabel', { 'TOPLEFT', filterFrame, 'BOTTOMLEFT', 0, 10 }, {120, 30}, nil, nil )
    sortingLabel:Update( { layer, labelFont, 'Sorting Method' } )

    local sortingMenu =  LibGUI:NewWidget('dropdownmenu', frame, 'SortingDropdown', { 'LEFT', sortingLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    sortingMenu:Update( sortingDropdown )

    local countLabel = LibGUI:NewWidget('label', frame, 'CountLabel', { 'TOPLEFT', sortingLabel, 'BOTTOMLEFT', 22, -4 }, { 50, 30 }, nil, nil)
    countLabel:Update( { layer, labelFont,'Count' } )
    local CountEdit = LibGUI:NewWidget('editbox', frame, 'CountEdit', { 'TOPLEFT', countLabel, 'BOTTOMLEFT', 8, -4 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    CountEdit:Update( { nil, nil, nil, {1, 40} } )

    local sizeLabel = LibGUI:NewWidget('label', frame, 'SizeLabel', { 'LEFT', countLabel, 'RIGHT', 48, 0 }, { 40, 30 }, nil, nil)
    sizeLabel:Update( { layer, labelFont,'Size' } )
    local sizeEdit = LibGUI:NewWidget('editbox', frame, 'SizeEdit', { 'LEFT', CountEdit, 'RIGHT', 54, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    sizeEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    local spacingXLabel = LibGUI:NewWidget('label', frame, 'SpacingXLabel', { 'LEFT', sizeLabel, 'RIGHT', 44, 0 }, { 65, 30 }, nil, nil)
    spacingXLabel:Update( { layer, labelFont, 'Spacing X' } )
    local spacingXEdit = LibGUI:NewWidget('editbox', frame, 'SpacingXEdit', { 'LEFT', sizeEdit, 'RIGHT', 54, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingXEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    local spacingYLabel = LibGUI:NewWidget('label', frame, 'SpacingYLabel', { 'LEFT', spacingXLabel, 'RIGHT', 26, 0 }, { 65, 30 }, nil, nil)
    spacingYLabel:Update( { layer, labelFont, 'Spacing Y' } )
    local spacingYEdit = LibGUI:NewWidget('editbox', frame, 'SpacingYEdit', { 'LEFT', spacingXEdit, 'RIGHT', 54, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingYEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    local onlyPlayerCheckbox = LibGUI:NewWidget('checkbox', frame, 'ShowPlayerCheckbox', {'TOPLEFT', countLabel, 'BOTTOMLEFT', -22, -34}, {30, 30}, 'UICheckButtonTemplate', nil)
    onlyPlayerCheckbox:Update( { 'OnlyShowPlayer' } )
    onlyPlayerCheckbox:ChangeFont( labelFont )

    local growXLabel = LibGUI:NewWidget('label', frame, 'GrowXLabel', { 'TOPLEFT', onlyPlayerCheckbox, 'BOTTOMLEFT', 0, -4 }, { 120, 30}, nil, nil )
    growXLabel:Update( { layer, labelFont, 'Grow Direction on X' } )

    local growXMenu =  LibGUI:NewWidget('dropdownmenu', frame, 'GrowXDropdown', { 'LEFT', growXLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    growXMenu:Update( directionX )

    local growYLabel = LibGUI:NewWidget('label', frame, 'GrowYLabel', { 'TOPLEFT', growXLabel, 'BOTTOMLEFT', 0, -4 }, { 120, 30}, nil, nil )
    growYLabel:Update( { layer, labelFont, 'Grow Direction on Y' } )

    local growthYMenu =  LibGUI:NewWidget('dropdownmenu', frame, 'GrowYDropdown', { 'LEFT', growYLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    growthYMenu:Update( directionY )

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

Inspector:RegisterComponentGUI('Aura', gui)
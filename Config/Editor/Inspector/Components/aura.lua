local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local changeList = {}

local function enable(config)

end

local function GetChange()
    return changeList
end

local function disable(frame)
    changeList = {}

    frame:ClearContent()

end

local helpfulFilter = {
    'HELPFUL',
    'PLAYER',
    'RAID',
    'CANCELABLE',
    'NOT_CANCELABLE',
    'MAW',
    'INCLUDE_NAME_PLATE_ONLY'
}

local harmfulFilter = {
    'HARMFUL',
    'PLAYER',
    'RAID',
    'CANCELABLE',
    'NOT_CANCELABLE',
    'MAW',
    'INCLUDE_NAME_PLATE_ONLY'
}

--DEBUG
local sortingDropdown = {
    { text='REMAINING' },
    { text='DURATION' },
    { text='PLAYER' },
}

local directionX = {
    {text = 'LEFT'},
    {text = 'RIGHT'},
}

local directionY = {
    {text = 'UP'},
    {text = 'BOTTOM'},
}

local minSize = 12
local maxSize = 50

local minSpacing = 0
local maxSpacing = 10

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, config, isHelpful)

    print (componentName, hasBorder, isCollapsable, hasName, config, isHelpful)

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

    local filterFrame = Inspector:CreateComponentGUI('Submodules', baseName..'Filters', frame, frame, 'Filters', {
        { 'TOPLEFT', 4, -20 },
        { 'TOPRIGHT', -4, -20 }
    }, false, false, true, filters)

    local sortingLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', filterFrame, 'BOTTOMLEFT', 0, 10 }, {120, 30}, nil, nil )
    sortingLabel:Update( { 'OVERLAY', GameFontNormal, 'Sorting Method' } )

    local sortingMenu =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', sortingLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    sortingMenu:Update( sortingDropdown )

    local countLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', sortingLabel, 'BOTTOMLEFT', 22, -4 }, { 50, 30 }, nil, nil)
    countLabel:Update( { 'OVERLAY', GameFontNormal,'Count' } )
    local CountEdit = LibGUI:NewWidget('editbox', frame, '', { 'TOPLEFT', countLabel, 'BOTTOMLEFT', 8, -4 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    CountEdit:Update( { nil, nil, nil, {1, 40} } )

    local sizeLabel = LibGUI:NewWidget('label', frame, '', { 'LEFT', countLabel, 'RIGHT', 48, 0 }, { 40, 30 }, nil, nil)
    sizeLabel:Update( { 'OVERLAY', GameFontNormal,'Size' } )
    local sizeEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', CountEdit, 'RIGHT', 54, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    sizeEdit:Update( { nil, nil, nil, {minSize, maxSize} } )

    local spacingXLabel = LibGUI:NewWidget('label', frame, '', { 'LEFT', sizeLabel, 'RIGHT', 44, 0 }, { 65, 30 }, nil, nil)
    spacingXLabel:Update( { 'OVERLAY', GameFontNormal, 'Spacing X' } )
    local spacingXEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', sizeEdit, 'RIGHT', 54, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingXEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    local spacingYLabel = LibGUI:NewWidget('label', frame, '', { 'LEFT', spacingXLabel, 'RIGHT', 26, 0 }, { 65, 30 }, nil, nil)
    spacingYLabel:Update( { 'OVERLAY', GameFontNormal, 'Spacing Y' } )
    local spacingYEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', spacingXEdit, 'RIGHT', 54, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingYEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    local onlyPlayerCheckbox = LibGUI:NewWidget('checkbox', frame, '', {'TOPLEFT', countLabel, 'BOTTOMLEFT', -22, -34}, {30, 30}, 'UICheckButtonTemplate', nil)
    onlyPlayerCheckbox:Update( { 'OnlyShowPlayer' } )
    onlyPlayerCheckbox:ChangeFont( 'GameFontNormal' )

    local growthXLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', onlyPlayerCheckbox, 'BOTTOMLEFT', 0, -4 }, {120, 30}, nil, nil )
    growthXLabel:Update( { 'OVERLAY', GameFontNormal, 'Grow Direction on X' } )

    local growthXMenu =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', growthXLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    growthXMenu:Update( directionX )

    local growthYLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', growthXLabel, 'BOTTOMLEFT', 0, -4 }, {120, 30}, nil, nil )
    growthYLabel:Update( { 'OVERLAY', GameFontNormal, 'Grow Direction on Y' } )

    local growthYMenu =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', growthYLabel, 'RIGHT' }, { 200, 25 }, nil, nil)
    growthYMenu:Update( directionY )

    if hasBorder then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'SubmodulesFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Aura', gui)
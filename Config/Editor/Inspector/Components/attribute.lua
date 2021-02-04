local _, Plugin = ...
local V = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Inspector=V.Editor.Inspector

local groupingMenu = {
    { text='NONE' },
    { text='GROUP' },
    { text='CLASS' },
    { text='ROLE' },
    { text='ASSIGNEDROLE' },
}

local sortingMenu = {
    { text='INDEX' },
    { text='NAME' },
    { text='NAMELIST' },
}

local sortingDirectionMenu = {
    { text='ASC' },
    { text='DESC' },
}

local growDirectionMenu = {
    { text='RIGHT' },
    { text='LEFT' },
}

local roleFilterMenu = {
    { text='MT, MA, Tank, Healer, DPS' },
    { text='MT, Tank, MA, Healer, DPS' },
    { text='MA, MT, Tank, Healer, DPS' },
    { text='MA, Healer, MT, Tank, DPS' },
}

local minSpacing = -30
local maxSpacing = 30

local minPlayer = 0
local maxPlayer = 40

local function gui(baseName, parent, parentPoint, componentName, point,  hasBorder, isCollapsable, hasName, config)

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
            baseName..'AttributeFrame',
            nil,
            pt
    )
    frame:SetHeight(430)

    local showSolo = LibGUI:NewWidget('checkbox', frame, baseName..'AttributeFrameShowSoloCheckbox', { 'TOPLEFT' }, { 30, 30 }, 'UICheckButtonTemplate', nil)
    showSolo:Update( { 'Show when solo' } )
    showSolo:ChangeFont( 'GameFontNormal' )

    local showPlayer = LibGUI:NewWidget('checkbox', frame, baseName..'AttributeFrameShowPlayerCheckbox',
            { 'TOP' }
    , { 30, 30 }, 'UICheckButtonTemplate', nil)
    showPlayer:Update( { 'Show player' } )
    showPlayer:ChangeFont( 'GameFontNormal' )

    local showParty = LibGUI:NewWidget('checkbox', frame, baseName..'AttributeFrameShowPartyCheckbox', { 'TOPLEFT', showSolo, 'BOTTOMLEFT', 0, -4 }, { 30, 30 }, 'UICheckButtonTemplate', nil)
    showParty:Update( { 'Show the party' } )
    showParty:ChangeFont( 'GameFontNormal' )

    local showRaid = LibGUI:NewWidget('checkbox', frame, baseName..'AttributeFrameShowRaidCheckbox', { 'TOPLEFT', showPlayer, 'BOTTOMLEFT', 0, -4 }, { 30, 30 }, 'UICheckButtonTemplate', nil)
    showRaid:Update( { 'Show while in raid' } )
    showRaid:ChangeFont( 'GameFontNormal' )

    local spacingXLabel = LibGUI:NewWidget('label', frame, '', {
        { 'TOP', showRaid, 'BOTTOM' },
        { 'RIGHT', frame, 'CENTER', -20, 0 }
    }, { 80, 30 }, nil, nil)
    spacingXLabel:Update( { 'OVERLAY', GameFontNormal, 'Spacing X' } )
    local spacingXEdit = LibGUI:NewWidget('editbox', frame, '', { 'TOP', spacingXLabel, 'BOTTOM', 0, -4 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingXEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    local spacingYLabel = LibGUI:NewWidget('label', frame, '', {
        { 'TOP', showRaid, 'BOTTOM' } ,
        { 'LEFT', frame, 'CENTER', 20, 0 }
    }, { 80, 30 }, nil, nil)
    spacingYLabel:Update( { 'OVERLAY', GameFontNormal, 'Spacing Y' } )
    local spacingYEdit = LibGUI:NewWidget('editbox', frame, '', { 'TOP', spacingYLabel, 'BOTTOM', 0, -4 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingYEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    --TODO ADD maxColumns, unitsPerColumn, columnSpacing
    local maxColumnsLabel = LibGUI:NewWidget('label', frame, '', {
        { 'TOP', spacingXEdit, 'BOTTOM', 0, -4 },
        { 'LEFT', frame, 'LEFT' }
    }, {150, 30}, nil, nil )
    maxColumnsLabel:Update( { 'OVERLAY', GameFontNormal, 'Max columns' } )

    local maxColumnsEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', maxColumnsLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    maxColumnsEdit:Update( { nil, nil, nil, { minPlayer, maxPlayer} } )

    local unitsPerColumnLabel = LibGUI:NewWidget('label', frame, '', {
        { 'TOP', maxColumnsLabel, 'BOTTOM', 0, -4 },
    }, {150, 30}, nil, nil )
    unitsPerColumnLabel:Update( { 'OVERLAY', GameFontNormal, 'Units per column' } )

    local unitsPerColumnEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', unitsPerColumnLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    unitsPerColumnEdit:Update( { nil, nil, nil, { minPlayer, maxPlayer} } )

    local columnSpacingLabel = LibGUI:NewWidget('label', frame, '', {
        { 'TOP', unitsPerColumnLabel, 'BOTTOM', 0, -4 },
    }, {150, 30}, nil, nil )
    columnSpacingLabel:Update( { 'OVERLAY', GameFontNormal, 'Column Spacing' } )

    local columnSpacingEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', columnSpacingLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    columnSpacingEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    --GROUPING METHOD
    local groupingLabel = LibGUI:NewWidget('label', frame, '', {
        { 'TOP', columnSpacingLabel, 'BOTTOM', 0, -4 },
        { 'LEFT', frame, 'LEFT' }
    }, {160, 30}, nil, nil )
    groupingLabel:Update( { 'OVERLAY', GameFontNormal, 'Group by' } )

    local groupingDropdown =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', groupingLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    groupingDropdown:Update( groupingMenu )

    --SORTING METHOD
    local sortingLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', groupingLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    sortingLabel:Update( { 'OVERLAY', GameFontNormal, 'Sorting by' } )

    local sortingDropdown =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', sortingLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    sortingDropdown:Update( sortingMenu )

    local sortingDirLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', sortingLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    sortingDirLabel:Update( { 'OVERLAY', GameFontNormal, 'Sorting classification' } )

    local sortingDirDropdown =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', sortingDirLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    sortingDirDropdown:Update( sortingDirectionMenu )

    --FILTER
    local growDirLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', sortingDirLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    growDirLabel:Update( { 'OVERLAY', GameFontNormal, 'Grow direction' } )

    local growDirDropdown =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', growDirLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    growDirDropdown:Update( growDirectionMenu )

    local filterLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', growDirLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    filterLabel:Update( { 'OVERLAY', GameFontNormal, 'Role filtering' } )

    local filterDropdown =  LibGUI:NewWidget('dropdownmenu', frame, '', { 'LEFT', filterLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    filterDropdown:Update( roleFilterMenu )

    --VISIBILITY
    local visibilityLabel = LibGUI:NewWidget('label', frame, '', { 'TOPLEFT', filterLabel, 'BOTTOMLEFT', 0, -4 }, { 200, 30 }, nil, nil)
    visibilityLabel:Update( { 'OVERLAY', GameFontNormal, 'Player count before hide' } )
    local visibilityEdit = LibGUI:NewWidget('editbox', frame, '', { 'LEFT', visibilityLabel, 'RIGHT', 44, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    visibilityEdit:Update( { nil, nil, nil, { minPlayer, maxPlayer} } )


    if hasBorder then
        frame:CreateBorder(1, { 1, 1, 1, 0.4 })
    end

    if hasName then
        local name = LibGUI:NewWidget('button', frame, baseName..'EnableFrameNameLabel', { { 'TOPLEFT', 0, 15 }, { 'TOPRIGHT', 0, 15 } }, { 0, 20 }, nil, nil)
        name:AddLabel(name, componentName)
        if isCollapsable then
            name:AddCollapseSystem(frame, Inspector.Collapse, Inspector.Expand)
        end
    end

    return frame
end

Inspector:RegisterComponentGUI('Attribute', gui)
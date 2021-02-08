local _, Plugin = ...

--caching global func
local select = select

local V = select(2, ...):unpack()
--load libgui lib
local LibGUI = Plugin.LibGUI

--local constant in local cache
local Editor = V.Editor
local Inspector = Editor.Inspector
local borderSettings = Editor.border
local groupingMenu = Editor.menus.groupingOrder
local sortingMenu = Editor.menus.sortingOrder
local sortingDirectionMenu = Editor.menus.sortingDirection
local growDirectionMenu = Editor.menus.growDirectionX
local roleFilterMenu = Editor.menus.roleFilter

--local var
local minSpacing = -30
local maxSpacing = 30

local minPlayer = 0
local maxPlayer = 40

local labelFont = 'GameFontNormal'
local layer = 'OVERLAY'

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

    local showSolo = LibGUI:NewWidget('checkbox', frame, 'ShowSoloCheckbox', { 'TOPLEFT' }, { 30, 30 }, 'UICheckButtonTemplate', nil)
    showSolo:Update( { 'Show when solo' } )
    showSolo:ChangeFont( labelFont )

    local showPlayer = LibGUI:NewWidget('checkbox', frame, 'ShowPlayerCheckbox',
            { 'TOP' }
    , { 30, 30 }, 'UICheckButtonTemplate', nil)
    showPlayer:Update( { 'Show player' } )
    showPlayer:ChangeFont( labelFont )

    local showParty = LibGUI:NewWidget('checkbox', frame, 'ShowPartyCheckbox', { 'TOPLEFT', showSolo, 'BOTTOMLEFT', 0, -4 }, { 30, 30 }, 'UICheckButtonTemplate', nil)
    showParty:Update( { 'Show the party' } )
    showParty:ChangeFont( labelFont )

    local showRaid = LibGUI:NewWidget('checkbox', frame, 'ShowRaidCheckbox', { 'TOPLEFT', showPlayer, 'BOTTOMLEFT', 0, -4 }, { 30, 30 }, 'UICheckButtonTemplate', nil)
    showRaid:Update( { 'Show while in raid' } )
    showRaid:ChangeFont( labelFont )

    local spacingXLabel = LibGUI:NewWidget('label', frame, 'SpacingXLabel', {
        { 'TOP', showRaid, 'BOTTOM' },
        { 'RIGHT', frame, 'CENTER', -20, 0 }
    }, { 80, 30 }, nil, nil)
    spacingXLabel:Update( { layer, labelFont, 'Spacing X' } )
    local spacingXEdit = LibGUI:NewWidget('editbox', frame, 'SpacingXEdit', { 'TOP', spacingXLabel, 'BOTTOM', 0, -4 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingXEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    local spacingYLabel = LibGUI:NewWidget('label', frame, 'SpacingYLabel', {
        { 'TOP', showRaid, 'BOTTOM' } ,
        { 'LEFT', frame, 'CENTER', 20, 0 }
    }, { 80, 30 }, nil, nil)
    spacingYLabel:Update( { layer, labelFont, 'Spacing Y' } )
    local spacingYEdit = LibGUI:NewWidget('editbox', frame, 'SpacingYEdit', { 'TOP', spacingYLabel, 'BOTTOM', 0, -4 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    spacingYEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    --TODO ADD maxColumns, unitsPerColumn, columnSpacing
    local maxColumnsLabel = LibGUI:NewWidget('label', frame, 'MaxColumnsLabel', {
        { 'TOP', spacingXEdit, 'BOTTOM', 0, -4 },
        { 'LEFT', frame, 'LEFT' }
    }, {150, 30}, nil, nil )
    maxColumnsLabel:Update( { layer, labelFont, 'Max columns' } )

    local maxColumnsEdit = LibGUI:NewWidget('editbox', frame, 'MaxColumnsEdit', { 'LEFT', maxColumnsLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    maxColumnsEdit:Update( { nil, nil, nil, { minPlayer, maxPlayer} } )

    local unitsPerColumnLabel = LibGUI:NewWidget('label', frame, 'UnitsPerColumnLabel', { 'TOP', maxColumnsLabel, 'BOTTOM', 0, -4 }, {150, 30}, nil, nil )
    unitsPerColumnLabel:Update( { layer, labelFont, 'Units per column' } )

    local unitsPerColumnEdit = LibGUI:NewWidget('editbox', frame, 'UnitsPerColumnEdit', { 'LEFT', unitsPerColumnLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    unitsPerColumnEdit:Update( { nil, nil, nil, { minPlayer, maxPlayer} } )

    local columnSpacingLabel = LibGUI:NewWidget('label', frame, 'ColumSpacingLabel', { 'TOP', unitsPerColumnLabel, 'BOTTOM', 0, -4 }, {150, 30}, nil, nil )
    columnSpacingLabel:Update( { layer, labelFont, 'Column Spacing' } )

    local columnSpacingEdit = LibGUI:NewWidget('editbox', frame, 'ColumSpacingEdit', { 'LEFT', columnSpacingLabel, 'RIGHT', 40, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    columnSpacingEdit:Update( { nil, nil, nil, { minSpacing, maxSpacing} } )

    --GROUPING METHOD
    local groupingLabel = LibGUI:NewWidget('label', frame, 'GroupingLabel', {
        { 'TOP', columnSpacingLabel, 'BOTTOM', 0, -4 },
        { 'LEFT', frame, 'LEFT' }
    }, {160, 30}, nil, nil )
    groupingLabel:Update( { layer, labelFont, 'Group by' } )

    local groupingDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'GroupingDropdown', { 'LEFT', groupingLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    groupingDropdown:Update( groupingMenu )

    --SORTING METHOD
    local sortingLabel = LibGUI:NewWidget('label', frame, 'SortingLabel', { 'TOPLEFT', groupingLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    sortingLabel:Update( { layer, labelFont, 'Sorting by' } )

    local sortingDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'SortingDropdown', { 'LEFT', sortingLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    sortingDropdown:Update( sortingMenu )

    local sortingDirLabel = LibGUI:NewWidget('label', frame, 'SortingDirectionLabel', { 'TOPLEFT', sortingLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    sortingDirLabel:Update( { layer, labelFont, 'Sorting classification' } )

    local sortingDirDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'SortingDirectionDropdown', { 'LEFT', sortingDirLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    sortingDirDropdown:Update( sortingDirectionMenu )

    --FILTER
    local growDirLabel = LibGUI:NewWidget('label', frame, 'GrowDirectionLabel', { 'TOPLEFT', sortingDirLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    growDirLabel:Update( { layer, labelFont, 'Grow direction' } )

    local growDirDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'GrowDirectionDropdown', { 'LEFT', growDirLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    growDirDropdown:Update( growDirectionMenu )

    local filterLabel = LibGUI:NewWidget('label', frame, 'FilterLabel', { 'TOPLEFT', growDirLabel, 'BOTTOMLEFT', 0, -4 }, {160, 30}, nil, nil )
    filterLabel:Update( { layer, labelFont, 'Role filtering' } )

    local filterDropdown =  LibGUI:NewWidget('dropdownmenu', frame, 'FilterDropdown', { 'LEFT', filterLabel, 'RIGHT' }, { 180, 25 }, nil, nil)
    filterDropdown:Update( roleFilterMenu )

    --VISIBILITY
    local visibilityLabel = LibGUI:NewWidget('label', frame, 'VisibilityLabel', { 'TOPLEFT', filterLabel, 'BOTTOMLEFT', 0, -4 }, { 200, 30 }, nil, nil)
    visibilityLabel:Update( { layer, labelFont, 'Player count before hide' } )
    local visibilityEdit = LibGUI:NewWidget('editbox', frame, 'VisibilityEdit', { 'LEFT', visibilityLabel, 'RIGHT', 44, 0 }, { 40, 25 }, 'NumericInputSpinnerTemplate', nil)
    visibilityEdit:Update( { nil, nil, nil, { minPlayer, maxPlayer} } )

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

Inspector:RegisterComponentGUI('Attribute', gui)
local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local ViragDevTool = _G['ViragDevTool']
local function log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    end
end

local Editor = V.Editor
local AuraFilter = CreateFrame("Frame")

local borderSettings = Editor.border

local tmp = {
    {
        text = 'a',
        menuList = {
            {
                text = 'ab',
                editable = true
            },
        }
    },
    {
        text = 'b',
        editable = true
    },
    {
        text = 'c',
        editable = true
    },
    {
        text = 'd',
        editable = true
    },
    {
        text = 'e',
        editable = true
    },
    {
        text = 'f',
        editable = true
    },
}

--[[
    INSPECTOR FRAME CONFIG
]]--
local auraFilter = {
    root = {
        type = 'frame',
        params = {
            parent = UIParent,
            name = 'VorkuiEditorAuraFilter',
            title = 'Vorkui Aura Filter',
            size = { 600, 600 },
            point = { 'CENTER' },
        },
        childs = {
        }
    },
}

local iconConfig = {
    ['type'] = 'icon',
    ['name'] = 'SpellIcon',
    ['data'] = {
        nil, --point
        { 25, 25 }, --size
        'ARTWORK', --layer
        --sublayer
    }
}

local spellIDConfig = {
    ['type'] = 'label',
    ['name'] = 'SpellID',
    ['data'] = {
        nil, --point
        { 50, 25 }, --size
        'ARTWORK',
        'Game11Font'
    }
}

local spellNameConfig = {
    ['type'] = 'label',
    ['name'] = 'SpellName',
    ['data'] = {
        nil, --point
        { 205, 25 }, --size
        'ARTWORK',
        'Game11Font'
    }
}

local editConfig = {
    ['type'] = 'editbox',
    ['name'] = 'SpellEditbox',
    ['data'] = {
        nil, --point
        { 25, 25 }, --size
        'NumericInputSpinnerTemplate', --template
    },
    ['offsetX'] = 40,
}

local checkboxConfig = {
    ['type'] = 'checkbox',
    ['name'] = 'TexturedCheckbox',
    ['data'] = {
        nil, --point
        { 25, 25 }, --size
        'UICheckButtonTemplate', --template
    },
    ['offsetX'] = 50,
}

local colorConfig = {
    ['type'] = 'color',
    ['name'] = 'Color',
    ['data'] = {
        nil, --point
        { 20, 20 }, --size
    },
    ['offsetX'] = 30,
}

local blizzardFilter = {
    'HELPFUL',
    'HARMFUL',
    'PLAYER',
    'RAID',
    'CANCELABLE',
    'NOT_CANCELABLE',
    'INCLUDE_NAME_PLATE_ONLY',
    'MAW'
}

--TODO REMOVE THIS TEXT BY LOCA TEXT
local blizzardFilterDescription = {
    'Buffs',
    'Debuffs',
    'Auras applied by the player',
    'Buffs the player can apply and debuffs the player can dispell',
    'Buffs removable using /cancelaura',
    'Buffs not removable',
    'Auras shown on default nameplates',
    'Torghast Anima Powers'
}

local blizzardFilterExplanation = [[You can combine filters between them. The result will be the intersection of each.
|cFFFF0000Be careful about mutually-exclusive filters|r]]

local auraListExplanation = [[You can define specific list to regroup aura and specify :
    - priority
    - fixed position
This group will be used as |cFFFF0000Ignore List|r or |cFFFF0000Exclusive List|r
]]

----
local BaseList = {}
local dropdownList = {}
local sortOption = 'Position'

local function createBlizzardFilterFrame(frame)

    local sectionName = LibGUI:NewWidget('label', frame, 'BlizzardSectionLabel',
            {
                { 'TOPLEFT', frame, 'TOPLEFT', 10, -4 },
                { 'TOPRIGHT', frame, 'TOPRIGHT', -10, -4 }
            }, { 300, 30 }, nil, nil)
    sectionName:Update({ 'OVERLAY', 'GameFontNormal', 'Blizzard Filter' })

    local pt = { 'TOPLEFT', sectionName, 'BOTTOMLEFT', 0, -4 }

    local filterName, filterDesc
    for i, v in ipairs(blizzardFilter) do
        filterName = LibGUI:NewWidget('label', frame, 'FilterNameLabel' .. i, pt, { 220, 30 }, nil, nil)
        filterName:Update({ 'OVERLAY', 'Game13Font', v })
        filterName:SetJustifyH('LEFT')
        filterDesc = LibGUI:NewWidget('label', frame, 'FilterDescriptionLabel' .. i,
                { 'LEFT', filterName, 'RIGHT', 4, 0 }, { 260, 30 }, nil, nil)
        --TODO UPDATE BY LOCA TEXT
        filterDesc:Update({ 'OVERLAY', 'Game11Font', blizzardFilterDescription[i] })
        filterDesc:SetJustifyH('LEFT')

        pt[2] = filterName
    end

    local explanationLabel = LibGUI:NewWidget('label', frame, 'FilterExplanationLabel', pt, { 480, 60 }, nil, nil)
    explanationLabel:Update({ 'OVERLAY', 'GameFontNormal', blizzardFilterExplanation })
    explanationLabel:SetJustifyH('LEFT')

    return frame
end

local function updateAuraListContent(frame, listName, spellTable)
    local scroll = frame.Scroll
    local sheet = scroll.ScrollChild.Childs[1]

    if listName ~= nil and listName ~= '' then
        sheet.listName = listName
    end
    if listName == nil and sheet.listName == nil then
        return
    end

    --sheet:clean
    --get new data
    local data = BaseList[listName or sheet.listName] or {}
    local rows = {}
    local sortedData = spellTable or AuraFilter:GetSortedSpellID(data, sortOption)

    --feed sheet with
    local widgets, row
    local name, icon, properties
    local rowIndex = 1
    local sheetRowCount = sheet:GetRowCount()
    local rowHeight = sheet:GetRowHeight()

    --for spellID, properties in pairs(data) do
    for _, spellID in ipairs(sortedData) do
        properties = data[spellID]
        name, _, icon = GetSpellInfo(spellID)
        if name ~= '' then
            if rowIndex > sheetRowCount then
                row = sheet:AddRow()
                --row.enableAllWidgets = true
                sheetRowCount = sheetRowCount + 1
            end
            widgets = sheet:GetWidgetsByRow(rowIndex)
            --Icon, SpellID, Name, Priority, Position, TexturedIcon, Color
            widgets[1]:ChangeIcon(icon)
            widgets[2]:ChangeText(spellID)
            widgets[3]:ChangeText(name)
            if type(properties) == 'table' then
                widgets[4]:ChangeText(properties.Priority)
                widgets[4]:SetMinMax(-10, 10)
                widgets[4]:Show()
                widgets[5]:ChangeText(properties.Position)
                widgets[5]:SetMinMax(1, 40)
                widgets[5]:Show()
                widgets[6]:SetChecked(properties.TexturedIcon)
                widgets[6]:Show()
                if properties.Color then
                    widgets[7]:ChangeColor(properties.Color)
                    widgets[7]:Show()
                else
                    widgets[7]:Hide()
                end
            else
                widgets[4]:Hide()
                widgets[5]:Hide()
                widgets[6]:Hide()
                widgets[7]:Hide()
            end
        end
        tinsert(rows, rowIndex)
        rowIndex = rowIndex + 1
    end
    sheet:ShowRows(rows)
    for i = sheetRowCount, rowIndex, -1 do
        sheet:HideRow(i)
    end
    sheet:Show()
    sheet:SetHeight(rowHeight * (rowIndex - 1))
    scroll:ShowScrollChild()
    scroll:ResizeScrollChild()
end

local function searchAuraListContent(frame, spellID)
    local scroll = frame.Scroll
    local sheet = scroll.ScrollChild.Childs[1]

    updateAuraListContent(frame, _, sheet:Match(2, spellID))

end

local function addSpellsToList(frame, spells)
    local scroll = frame.Scroll
    local sheet = scroll.ScrollChild.Childs[1]
    if sheet.listName == nil then
        return
    end

    local matches = spells:match('(%d+[^a-zA-Z]),')
    log(matches, 'parse regex')

end

local function createSheet(self, rowCount)
    local sheet = LibGUI:NewContainer(
            'sheet',
            self,
            'AuralistSheetFrame',
            nil,
            {
                { 'TOPLEFT' },
                { 'TOPRIGHT' }
            }
    )

    sheet:SetSize(500, 0)
    sheet:SetOffset(5, -2)
    sheet.attributeCount = 0

    --Icon, SpellID, Name, Priority, Position
    sheet:SetConfiguration(iconConfig, spellIDConfig, spellNameConfig, editConfig, editConfig, checkboxConfig, colorConfig)
    sheet:SetColumnCount(7)
    local rows = sheet:AddRows(rowCount or 0)
    for _, r in ipairs(rows) do
        r.enableAllWidgets = true
    end
end

local function createAuraListFrame(self, frame)

    local LibObserver = LibStub:GetLibrary("LibObserver")
    if LibObserver then
        frame.Observer = LibObserver:CreateObserver()
        frame.Observer.OnNotify = function(...)
            local event, item, value = unpack(...)
            if item.key == 'list' then
                updateAuraListContent(frame, value)
            elseif item.key == 'search' then
                searchAuraListContent(frame, value)
            end
        end
    end

    local explanationLabel = LibGUI:NewWidget('label', frame, 'AuraListExplanationLabel',
            {
                { 'TOPLEFT', frame, 'TOPLEFT', 2, -4 },
                { 'TOPRIGHT', frame, 'TOPRIGHT', -2, -4 }
            }, { 480, 50 }, nil, nil)
    explanationLabel:Update({ 'OVERLAY', 'Game11Font', auraListExplanation })
    explanationLabel:SetJustifyH('LEFT')

    local searchLabel = LibGUI:NewWidget('label', frame, 'AuraListSearchLabel',
            { 'TOPLEFT', explanationLabel, 'BOTTOMLEFT', 0, -8 }, { 200, 20 })
    searchLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Search a spellId in the list' })
    searchLabel:SetJustifyH('LEFT')

    local searchEdit = LibGUI:NewWidget('editbox', frame, 'AuraListSearchEditbox',
            { 'LEFT', searchLabel, 'RIGHT', 26, 0 }, { 200, 20 }, 'SearchBoxTemplate')
    searchEdit:ChangeFont('Game11Font')
    searchEdit.key = 'search'
    searchEdit:RegisterObserver(frame.Observer)

    --[[
        Section to control List
    --]]

    --local listSectionLabel = LibGUI:NewWidget('label', frame, 'AuraListSpellSectionLabel',
    --        { 'TOPLEFT', searchLabel, 'BOTTOMLEFT', 0, -8 }, { 190, 20 })
    --listSectionLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Alterate list' })
    --listSectionLabel:SetJustifyH('LEFT')


    BaseList = self:GetBaseAuraList()
    for k, _ in pairs(BaseList) do
        tinsert(dropdownList, { text = k })
    end

    local addListBtn = LibGUI:NewWidget('button', frame, 'AuraListAddListBtn', { 'TOPLEFT', searchLabel, 'BOTTOMLEFT', 0, -8 },
            { 190, 25 }, 'UIPanelButtonTemplate')
    addListBtn:ChangeText('Add a list')
    local addListEdit = LibGUI:NewWidget('editbox', frame, 'AuraListAddListEditbox', { 'LEFT', addListBtn, 'RIGHT', 8, 0 },
            { 370, 25 })
    addListEdit:ChangeFont('Game11Font')

    local removeListBtn = LibGUI:NewWidget('button', frame, 'AuraListRemoveListBtn', { 'TOP', addListBtn, 'BOTTOM', 0, -8 },
            { 190, 25 }, 'UIPanelButtonTemplate')
    removeListBtn:ChangeText('Delete a list')
    local removeListEdit = LibGUI:NewWidget('editbox', frame, 'AuraListRemoveListEditbox', { 'LEFT', removeListBtn, 'RIGHT', 8, 0 },
            { 370, 25 })
    removeListEdit:ChangeFont('Game11Font')

    local copyListBtn = LibGUI:NewWidget('button', frame, 'AuraListCopyListBtn', { 'TOP', removeListBtn, 'BOTTOM', 0, -8 },
            { 190, 25 }, 'UIPanelButtonTemplate')
    copyListBtn:ChangeText('Copy a list')
    local copyListMenu = LibGUI:NewWidget('dropdown', frame, 'CopyListDropdown',
            { 'LEFT', copyListBtn, 'RIGHT', 8, 0 }, { 180, 25 })
    copyListMenu:AddEditSystem()
    copyListMenu:UpdateContent( tmp )
    copyListMenu:Select('ab')
    copyListMenu:AddNewItemSystem(true)

    local copyListEdit = LibGUI:NewWidget('editbox', frame, 'AuraListCopyListEditbox', { 'LEFT', copyListMenu, 'RIGHT', 8, 0 },
            { 170, 25 })
    copyListEdit:ChangeFont('Game11Font')

    local renameListBtn = LibGUI:NewWidget('button', frame, 'AuraListRenameListBtn', { 'TOP', copyListBtn, 'BOTTOM', 0, -8 },
            { 190, 25 }, 'UIPanelButtonTemplate')
    renameListBtn:ChangeText('Rename a list')
    local renameListEdit = LibGUI:NewWidget('editbox', frame, 'AuraListRenameListEditbox', { 'LEFT', renameListBtn, 'RIGHT', 8, 0 },
            { 370, 25 })
    renameListEdit:ChangeFont('Game11Font')

    local lookListLabel = LibGUI:NewWidget('label', frame, 'LookListLabel',
            { 'TOPLEFT', renameListBtn, 'BOTTOMLEFT', 0, -8 }, { 200, 25 }, nil, nil)
    lookListLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Choose an existing list' })
    lookListLabel:SetJustifyH('LEFT')

    local lookListMenu = LibGUI:NewWidget('dropdownmenu', frame, 'LookListDropdown',
            { 'LEFT', lookListLabel, 'RIGHT', 4, 0 }, { 250, 25 })
    lookListMenu:Update(dropdownList)
    lookListMenu.key = 'list'
    lookListMenu:RegisterObserver(frame.Observer)

    --[[
        Section to control Spell over a list
    --]]
    local spellSectionLabel = LibGUI:NewWidget('label', frame, 'AuraListSpellSectionLabel',
            { 'TOPLEFT', lookListLabel, 'BOTTOMLEFT', 0, -8 }, { 190, 20 })
    spellSectionLabel:Update({ 'OVERLAY', 'GameFontNormal', 'Control spell(s) in the list' })
    spellSectionLabel:SetJustifyH('LEFT')

    local infoAddLabel = LibGUI:NewWidget('label', frame, 'AuraListAddSpellLabel',
            { 'TOPLEFT', spellSectionLabel, 'BOTTOMLEFT' }, { 0, 20 })
    infoAddLabel:Update({ 'OVERLAY', 'Game11Font', 'use "," as separator' })
    infoAddLabel:SetJustifyH('LEFT')

    local addSpellBtn = LibGUI:NewWidget('button', frame, 'AuraListAddSpellBtn', { 'TOPLEFT', spellSectionLabel, 'TOPRIGHT', 0, 0 }, { 25, 20 }, 'UIPanelButtonTemplate')
    addSpellBtn:ChangeText('+')

    local removeSpellBtn = LibGUI:NewWidget('button', frame, 'AuraListRemoveSpellBtn', { 'TOP', addSpellBtn, 'BOTTOM', 0, -2 }, { 25, 20 }, 'UIPanelButtonTemplate')
    removeSpellBtn:ChangeText('-')

    local spellEdit = LibGUI:NewWidget('editbox', frame, 'AuraListSpellEditbox', { 'TOPLEFT', addSpellBtn, 'TOPRIGHT', 8, 0 }, { 340, 0 })
    spellEdit:ChangeFont('Game11Font')
    spellEdit:SetMultiLine(true)
    spellEdit:SetPoint('BOTTOMLEFT', spellSectionLabel, 'BOTTOMRIGHT', 0, -20)

    --[[
        Header of the Sheet
    --]]

    local spellLabel = LibGUI:NewWidget('label', frame, 'SpellLabel',
            { 'TOPLEFT', spellSectionLabel, 'BOTTOMLEFT', 0, -28 }, { 300, 20 }, nil, nil)
    spellLabel:Update({ 'OVERLAY', 'Game13Font', 'Spell' })

    local priorityLabel = LibGUI:NewWidget('button', frame, 'PriorityLabel',
            { 'LEFT', spellLabel, 'RIGHT', 0, 0 }, { 80, 20 }, 'UIPanelButtonTemplate')
    local positionLabel = LibGUI:NewWidget('button', frame, 'PositionLabel',
            { 'LEFT', priorityLabel, 'RIGHT', 0, 0 }, { 80, 20 }, 'UIPanelButtonTemplate')
    positionLabel:Update({ 'Position', function(self)
        sortOption = 'Position'
        self:Disable()
        priorityLabel:Enable()
        updateAuraListContent(frame)
    end })
    priorityLabel:Update({ 'Priority', function(self)
        sortOption = 'Priority'
        self:Disable()
        positionLabel:Enable()
        updateAuraListContent(frame)
    end })

    local iconLabel = LibGUI:NewWidget('label', frame, 'TexturedLabel',
            { 'LEFT', positionLabel, 'RIGHT', 0, 0 }, { 50, 20 }, nil, nil)
    iconLabel:Update({ 'OVERLAY', 'Game13Font', 'Icon' })

    local colorLabel = LibGUI:NewWidget('label', frame, 'ColorLabel',
            { 'LEFT', iconLabel, 'RIGHT', 0, 0 }, { 50, 20 }, nil, nil)
    colorLabel:Update({ 'OVERLAY', 'Game13Font', 'Color' })

    frame.Scroll = LibGUI:NewContainer('scrollframe',
            frame,
            'AuraListFrameScrollFrame',
            { 600, 0 },
            {
                { 'TOPLEFT', spellLabel, 'BOTTOMLEFT' },
                { 'RIGHT', frame, 'RIGHT', -25, 0 },
                { 'BOTTOM', frame, 'BOTTOM', 0, 4 }
            }
    )

    createSheet(frame.Scroll.ScrollChild, self:GetMaxItem(BaseList))

end

--[[
    CORE FUNCTION
]]--

local function createTableFrame(self, parent, width, height)
    local frame = LibGUI:NewContainer('tabframe',
            parent,
            'AuraFilterTableFrame',
            { width, height },
            {
                { 'TOPLEFT', 0, -30 },
                { 'TOPRIGHT', 0, -30 },
                { 'BOTTOM', 0, 30 }
            }
    )

    local header, page = frame:AddEmptyPage('BlizzardFilter', { 150, 25 })
    header:ChangeText('Blizzard Filter')
    createBlizzardFilterFrame(page)

    header, page = frame:AddEmptyPage('AuraListFilter', { 150, 25 })
    header:ChangeText('Aura List Filter')
    createAuraListFrame(self, page)

    frame:UpdateHeaderLayout()

end

function AuraFilter:CreateGUI()
    local root = auraFilter.root
    local w, h = unpack(root.params.size)

    local frame = LibGUI:NewContainer(root.type,
            root.params.parent,
            root.params.name,
            root.params.size,
            root.params.point,
            'BasicFrameTemplate'
    )

    frame.TitleText:SetText(root.params.title)

    frame.TableFrame = createTableFrame(self, frame, w, h - 40)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame, true)

    self.UI = frame;

    self:Hide()
end

function AuraFilter:Enable()
    self.UI:Show()
end

function AuraFilter:Disable()
    self:Hide()
end

AuraFilter:SetScript('OnShow', AuraFilter.Enable)
AuraFilter:SetScript('OnHide', AuraFilter.Disable)

Editor.AuraFilter = AuraFilter
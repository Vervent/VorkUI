--[[

]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local ViragDevTool = _G['ViragDevTool']
local function log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    end
end

local toggleTexture = {
    [[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]],
    [[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]],
    [[Interface\Buttons\UI-Common-MouseHilight]],
    [[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]],
}

--[[
    Local function
]]--

---------- Item Management

local function navigateToItem(content, path)

    for i = 1, #path - 1 do
        content = content[i].menuList
    end

    return content
end

local function selectItem(self)

    local selection = self:GetParent()
    local dropdown = selection:GetParent()

    if dropdown.selectedInfo then
        dropdown.selectedInfo.checked = false
        dropdown.selectedBtn.checked:Hide()
        dropdown.selectedBtn.selected:Hide()
    end

    dropdown.navigationPath[selection.level] = self:GetID()

    self.checked:Show()
    self.selected:Show()
    self.info.checked = true
    dropdown.selectedInfo = self.info
    dropdown.selectedBtn = self
    dropdown.label:SetText(self.info.text)

    dropdown.Subject:Notify({ 'OnUpdate', dropdown, self.info })

end

local function clickToggle(self)
    local dropdown = self:GetParent()

    if self.IsExpand == false then
        self.IsExpand = true
        dropdown:ShowMenu(1)
    else
        self.IsExpand = false
        dropdown:HideContent(1)
    end

end

local function showEditFrame(self, btn)
    local editFrame = self.editFrame

    local button = btn:GetParent()
    local id = button:GetID()
    local info = button.info
    local level = button:GetParent().level

    editFrame.id = id
    editFrame.itemEdit:ChangeText(info.text)
    editFrame.level = level
    --editFrame.infos = navigateToItem(self.content, self.navigationPath)
    editFrame.info = info

    editFrame:Show()
    clickToggle(self.downButton)
end

local function clearEditFrame(frame)
    frame.id = nil
    frame.itemEdit:ChangeText('')

    frame:Hide()
end

local function renameItem(self)
    local editFrame = self.editFrame
    local id = editFrame.id
    local newText = editFrame.itemEdit:GetText()
    local lvl = editFrame.level
    --local infos = editFrame.infos
    local info = editFrame.info

    if self.selectedBtn == self.buttons[lvl][id] and self.selectedInfo == info then
        self.label:ChangeText(newText)
    end
    info.text = newText

    self.Subject:Notify({ 'OnEdit', self, self.navigationPath, info.text })

    clearEditFrame(editFrame)
end

local function removeItem(self)
    local editFrame = self.editFrame
    local id = editFrame.id

    local lvl = self.navigationPath[#self.navigationPath - 1] or 1

    if self.selectedBtn == self.buttons[lvl][id] and self.selectedInfo == self.content[id] then
        self.label:ChangeText('')
        self.checked:Hide()
        self.selected:Hide()
        self.info.checked = false
    end

    self.Subject:Notify({ 'OnRemove', self, self.navigationPath })
    local infos = navigateToItem(self.content, self.navigationPath)
    tremove(infos, editFrame.id)
    clearEditFrame(editFrame)
end

local function showMenuList(self, level, id)
    local button = self.buttons[level][id]
    self.navigationPath[level] = id

    local selection = self.selections[level + 1]
    selection:ClearAllPoints()
    selection:SetPoint('TOPLEFT', button, 'TOPRIGHT')

    self:ShowMenu(level + 1, button.info.menuList)
end

local function clearAddFrame(frame)
    frame.path = nil
    frame.info = nil
    frame.itemEdit:ChangeText('')

    frame:Hide()
end

local function addItem(self)
    local addFrame = self.addFrame

    addFrame.info.text = addFrame.itemEdit:GetText()

    self:AddField(addFrame.path, addFrame.info)
    self:UpdateContent(self.content)
    clearAddFrame(addFrame)
end

local function showAddFrame(self, level)
    local addFrame = self.addFrame

    addFrame.path = self:DeepCopyTable(self.navigationPath)
    addFrame.info = {
        text = '',
        editable = false,
        hasArrow = false,
        notCheckable = false,
        menuList = nil,
        checked = false,
    }

    addFrame:Show()
    clickToggle(self.downButton)
end

---------- Creation of frames/items

local function createSelectionContainer(self, level)
    local selectionTemplate = self.selectionTemplate
    local w, h = self:GetSize()
    local selection
    --Manage the frame which holds menu buttons
    if selectionTemplate == nil then
        selection = LibGUI:NewContainer('frame', self, 'Dropdown', { w, h }, {
            { 'TOPLEFT', self, 'BOTTOMLEFT' },
            { 'TOPRIGHT', self, 'BOTTOMRIGHT' }
        }, BackdropTemplateMixin and 'BackdropTemplate')

        selection:SetBackdrop({
            bgFile = [[Interface\FrameGeneral\UI-Background-Marble]],
            edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
            edgeSize = 2,
            insets = { left = 0, right = 0, top = 0, bottom = 0 },
        })
    else
        selection = LibGUI:NewContainer('frame', self, 'Dropdown', { w, h }, {
            { 'TOPLEFT' },
            { 'TOPRIGHT' }
        }, selectionTemplate)
    end
    --disable mouse on it to avoid event overlapping
    selection:EnableMouse(false)
    --set the level of the current menu
    selection.level = level

    return selection
end

local function createAddButton(self, parent, name)
    local btn = LibGUI:NewWidget('button', parent, name, { 'BOTTOM' }, { parent:GetWidth(), 25 })

    btn:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])

    btn.icon = LibGUI:NewWidget('icon', btn, name .. 'Icon', { 'LEFT', 2, 0 }, { 15, 15 })
    btn.icon:ChangeIcon([[Interface\PaperDollInfoFrame\Character-Plus]])

    btn:AddLabel(btn, nil, nil, 'GameFontNormal')
    btn.Text:SetPoint('LEFT', 25, 0)
    btn.Text:SetPoint('RIGHT')
    btn.Text:SetText('Add new list')

    btn:Bind('OnClick', function(b)
        showAddFrame(self, parent.level)
    end)

    return btn
end

local function createAddFrame(self)
    local frame = LibGUI:NewContainer('frame', self, 'DropdownAddFrame', { 200, 150 }, { 'CENTER', 'UIParent', 'CENTER', 0, 200 }, 'BasicFrameTemplate')

    frame.itemEdit = LibGUI:NewWidget('editbox', frame, 'AddFrameItemEdit', { 'TOPLEFT', 10, -30 }, { 180, 25 })
    frame.itemEdit:ChangeFont('Game11Font')

    frame.acceptButton = LibGUI:NewWidget('button', frame, 'EditFrameRenameButton', { 'RIGHT', frame, 'CENTER', 0, 0 }, { 80, 30 }, 'UIPanelButtonTemplate')
    frame.acceptButton:Bind('OnClick', function()
        addItem(self)
    end)
    frame.acceptButton:ChangeText('Accept')

    frame.cancelButton = LibGUI:NewWidget('button', frame, 'EditFrameRenameButton', { 'LEFT', frame, 'CENTER', 0, 0 }, { 80, 30 }, 'UIPanelButtonTemplate')
    frame.cancelButton:Bind('OnClick', function()
        clearAddFrame(frame)
    end)
    frame.cancelButton:ChangeText('Cancel')

    return frame
end

local function createEditFrame(self)
    local frame = LibGUI:NewContainer('frame', self, 'DropdownEditFrame', { 200, 150 }, { 'CENTER', 'UIParent', 'CENTER', 0, 200 }, 'BasicFrameTemplate')

    frame.itemEdit = LibGUI:NewWidget('editbox', frame, 'EditFrameItemEdit', { 'TOPLEFT', 10, -30 }, { 180, 25 })
    frame.itemEdit:ChangeFont('Game11Font')

    frame.renameButton = LibGUI:NewWidget('button', frame, 'EditFrameRenameButton', { 'RIGHT', frame, 'CENTER', 0, 0 }, { 80, 30 }, 'UIPanelButtonTemplate')
    frame.renameButton:Bind('OnClick', function()
        renameItem(self)
    end)
    frame.renameButton:ChangeText('Accept')
    frame.cancelButton = LibGUI:NewWidget('button', frame, 'EditFrameRenameButton', { 'LEFT', frame, 'CENTER', 0, 0 }, { 80, 30 }, 'UIPanelButtonTemplate')
    frame.cancelButton:Bind('OnClick', function()
        clearEditFrame(frame)
    end)
    frame.cancelButton:ChangeText('Cancel')
    frame.removeButton = LibGUI:NewWidget('button', frame, 'EditFrameRenameButton', { 'BOTTOM', frame, 'BOTTOM', 0, 0 }, { 80, 30 }, 'UIPanelButtonTemplate')
    frame.removeButton:Bind('OnClick', function()
        removeItem(self)
    end)
    frame.removeButton:ChangeText('Delete')

    return frame
end

local function createButton(parent, template, width, level, id)
    local name = 'Level' .. level .. 'Field' .. id
    local btn = nil
    if template == nil then
        local height = 25
        btn = LibGUI:NewWidget('button', parent, name, { 'TOPLEFT', parent, 'TOPLEFT', 0, (id - 1) * -height }, { width, height })

        btn.selected = btn:CreateTexture(nil, 'BACKGROUND')
        btn.selected:SetAllPoints()
        btn.selected:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
        btn.selected:SetDesaturated(true)
        btn.selected:SetBlendMode('ADD')
        btn.selected:Hide()

        btn:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])

        btn.checked = LibGUI:NewWidget('icon', btn, name .. 'Checked', { 'LEFT', 2, 0 }, { 15, 15 })
        btn.checked:ChangeIcon([[Interface\RaidFrame\ReadyCheck-Ready]])
        btn.checked:Hide()

        btn:AddLabel(btn, nil, nil, 'Game10Font_o1')
        btn.Text:SetPoint('TOPLEFT', 25, 0)
        btn.Text:SetPoint('BOTTOMRIGHT', -25, 0)

        btn:Bind('OnClick', selectItem)

        btn.arrow = LibGUI:NewWidget('icon', btn, name .. 'Arrow', { 'RIGHT', -2, 0 }, { 15, 15 })
        btn.arrow:ChangeIcon([[Interface\Glues\Login\UI-BackArrow]])
        btn.arrow:SetRotation(math.pi)
        btn.arrow:Hide()

        btn.edit = LibGUI:NewWidget('button', btn, name .. 'Edit', { 'RIGHT', -2, 0 }, { 20, 20 })
        btn.edit.texture = btn.edit:AddTexture()
        btn.edit.texture:SetTexture([[Interface\WorldMap\Gear_64Grey]])
        btn.edit:Hide()
        btn.edit:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])

        btn.edit:Bind('OnClick', function(b)
            showEditFrame(parent:GetParent(), b)
        end)

        btn:CreateOneBorder('bottom', 1, { 0.66, 0.66, 0.66, 0.1 })
    else
        btn = LibGUI:NewWidget('button', parent, name, { 'TOPLEFT', parent, 'TOPLEFT', 0, (id - 1) * -25 }, { width, 25 }, template)

    end
    btn:SetID(id)

    return btn
end

local function checkConfiguration(self, level, infos)
    if self.buttons[level] == nil then
        self.buttons[level] = {}
    end
    local buttons = self.buttons[level]

    --self.navigationPath[level] = 0

    if #buttons < #infos then
        for i = #buttons + 1, #infos do
            tinsert(buttons, createButton(self.selections[level], self.buttonTemplate, self:GetWidth(), level, i))
        end
    end

    for _, info in ipairs(infos) do
        if info.menuList then
            if self.selections[level + 1] == nil then
                tinsert(self.selections, createSelectionContainer(self, level + 1))
            end
            checkConfiguration(self, level + 1, info.menuList)
        end
    end

end

local Methods = {

    --TODO UPDATE THIS FUNC FOR MORE DATA
    Update = function(self, dataTable, value)
    end,

    UpdateContent = function(self, content)
        self.content = content
        checkConfiguration(self, 1, content)
    end,

    HideContent = function(self, level)
        local selections = self.selections

        for i = level, #selections do
            tremove(self.navigationPath, i)
            selections[i]:Hide()
        end
    end,

    Select = function(self, value, infos)
        self.label:SetText(value)
        for _, info in ipairs(infos or self.content) do
            if info.text == tostring(value) then
                info.checked = true
                return
            elseif info.menuList then
                self:Select(value, info.menuList)
            end
        end
    end,

    ShowMenu = function(self, level, infos)
        if level == nil then
            return
        end

        if self.selections[level] == nil or self.buttons[level] == nil then
            return
        end
        local selection = self.selections[level]
        local buttons = self.buttons[level]

        --self.navigationPath[level] = 0
        selection:Show()
        local btn
        local count = 0
        for i, v in ipairs(infos or self.content) do
            btn = buttons[i]
            btn.info = v
            btn:ChangeText(v.text)
            if v.checked == true then
                selectItem(btn)
            else
                btn.checked:Hide()
                btn.selected:Hide()
            end
            btn:SetEnabled(v.notCheckable or true)
            btn.arrow:SetShown(v.menuList ~= nil)
            btn.edit:SetShown(v.editable or false)
            if v.menuList ~= nil then
                btn.arrow:Show()
                btn:Bind('OnEnter', function()
                    showMenuList(self, level, i)
                end)
            else
                btn:Bind('OnEnter', function()
                    self:HideContent(level + 1)
                end)
                btn.arrow:Hide()
            end

            btn:Show()
            count = count + 1
        end
        for i = count + 1, #buttons do
            buttons[i]:Hide()
        end

        self:HideContent(level + 1)

        if self.extraButtons ~= nil then
            if #self.extraButtons == 1  and level == #self.selections then
                count = count + 1
            elseif #self.extraButtons == #self.selections then
                count = count + 1
            end
        end
        selection:SetHeight(count * 25)
    end,

    AddField = function(self, path, data)
        local info = {}
        info.text = data.text
        info.checked = data.checked
        info.editable = data.editable
        info.menuList = data.menuList
        info.hasArrow = data.hasArrow
        info.notCheckable = data.notCheckable

        tinsert(navigateToItem(self.content, path), info)

        log(self.content)
    end,

    --[[
    parentKey is a table of successive parent to add data
    ]]--
    AddNestedField = function(self, parentKey, data)
        if parentKey == nil then
            return
        end

        local table = self.content
        for _, v in pairs(parentKey) do
            if table[v] == nil or table[v].menuList == nil then
                return
            else
                table = table[v].menuList
            end
        end

        self:AddField(table, data)
    end,

    RegisterObserver = function(self, entity)
        self.Subject:RegisterObserver(entity)
    end,

    UnregisterObserver = function(self, entity)
        self.Subject:UnregisterObserver(entity)
    end,

    Enable = function(self)
        self.downButton:Enable()
    end,

    Disable = function(self)
        self.downButton:Disable()
    end,

    AddEditSystem = function(self)
        --the popup to manage rename/delete item
        self.editFrame = createEditFrame(self)
        self.navigationPath = {}
    end,

    AddNewItemSystem = function(self, allLevel)

        self.extraButtons = {}
        local selections = self.selections
        if allLevel == true then
            for i=1, #selections do
                tinsert(self.extraButtons, createAddButton(self, self.selections[i], 'AddItem'..i))
            end
        else
            tinsert(self.extraButtons, createAddButton(self, self.selections[#self.selections], 'AddItem'))
        end
        self.addFrame = createAddFrame(self)
    end

}

local function create(container, name, point, size, selectorTemplate, selectionTemplate, buttonTemplate, data)

    local frame
    local w, h = unpack(size or { 200, 25 })

    --main frame of the dropdown
    if selectorTemplate == nil then
        frame = LibGUI:NewContainer('frame', container, name, size, point, BackdropTemplateMixin and 'BackdropTemplate')
        frame:SetBackdrop({
            bgFile = [[Interface\FrameGeneral\UI-Background-Marble]],
            edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
            edgeSize = 2,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        --the label to represents the current choice
        frame.label = LibGUI:NewWidget('label', frame, 'Text', { 'LEFT', frame, 'LEFT' }, { w - 25, h })
        frame.label:ChangeFont('GameFontNormal')

        --the button to draw menu
        frame.downButton = LibGUI:NewWidget('button', frame, 'ToggleBtn', { 'RIGHT', frame, 'RIGHT' },
                { 25, 25 })
        frame.downButton:ChangeTexture(unpack(toggleTexture))
        frame.downButton:Bind('OnClick', clickToggle)
        --to manage if we need to expand or not
        frame.downButton.IsExpand = false
    else
        frame = LibGUI:NewContainer('frame', container, name, size, point, selectorTemplate)
        frame.downButton:Bind('OnClick', clickToggle)
        frame.downButton.IsExpand = false
    end

    frame.selectionTemplate = selectionTemplate
    frame.buttonTemplate = buttonTemplate
    frame.buttons = {}
    frame.selections = {}
    tinsert(frame.selections, createSelectionContainer(frame, 1))

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(frame, { __index = setmetatable(Methods, getmetatable(frame)) })

    if data then
        frame:UpdateContent(data)
    end

    local LibObserver = LibStub:GetLibrary("LibObserver")
    frame.Subject = LibObserver:CreateSubject()

    return frame
end

local function enable(self)
    if self.type ~= 'dropdown' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, f)
    end
end

local function disable(self)
    if self.type ~= 'dropdown' then
        return
    end

    for e, f in pairs(self.Scripts) do
        self:SetScript(e, function()
        end)
    end
end

LibGUI:RegisterWidget('dropdown', create, enable, disable)
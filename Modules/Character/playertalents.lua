local select = select

local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local PlayerTalents = Module:RegisterModule('PlayerTalents', false, 'Medias')
local Medias, LibAtlas

local roleTexCoord = {}
local specs = {
    ["spec1"] = {
        name = SPECIALIZATION_PRIMARY,
        nameActive = TALENT_SPEC_PRIMARY_ACTIVE,
        specName = SPECIALIZATION_PRIMARY,
        specNameActive = SPECIALIZATION_PRIMARY_ACTIVE,
        talentGroup = 1,
        tooltip = SPECIALIZATION_PRIMARY,
        defaultSpecTexture = "Interface\\Icons\\Ability_Marksmanship",
    },
    ["spec2"] = {
        name = SPECIALIZATION_SECONDARY,
        nameActive = TALENT_SPEC_SECONDARY_ACTIVE,
        specName = SPECIALIZATION_SECONDARY,
        specNameActive = SPECIALIZATION_SECONDARY_ACTIVE,
        talentGroup = 2,
        tooltip = SPECIALIZATION_SECONDARY,
        defaultSpecTexture = "Interface\\Icons\\Ability_Marksmanship",
    },
}
local specCount

local function createCircleBoard(parent, idx)
    local frame = CreateFrame('Frame', parent:GetName() .. 'CircleBoard', parent)

    frame:SetSize(parent:GetWidth() / 3 - 13, 400)
    --frame:SetPoint('LEFT', parent, 'LEFT')

    frame.Background = frame:CreateBackground({ 0.2, 0.6, 0.4, 0.75 })

    --local specButton = CreateFrame('Button', frame:GetName() .. 'SpecializationButton', frame)
    --specButton:SetSize(50, 50)
    --specButton:SetPoint('CENTER')
    --
    --local specIcon = specButton:CreateTexture(nil, 'OVERLAY')
    --specIcon:SetAllPoints()
    --specIcon:SetTexture([[Interface\Icons\Ability_Marksmanship]])
    --
    --local specName = specButton:CreateFontString(nil, 'OVERLAY', 'Game12Font')
    --specName:SetPoint('TOP', specIcon, 'BOTTOM')
    --specName:SetText('SPECIALIZATION_PRIMARY')

    --specButton.Icon = specIcon
    --specButton.Name = specName

    frame.Talents = {}

    local ability, abilityIcon, abilityName
    local angle = math.pi / 3
    local distance = 125

    local alpha
    for i = 1, 6 do
        alpha = i * angle
        ability = CreateFrame('Button', nil, frame)
        ability:SetSize(30, 30)
        ability:SetPoint('CENTER', frame, 'CENTER', math.cos(alpha + idx % 2 * math.pi / 6) * distance, math.sin(alpha + idx % 2 * math.pi / 6) * distance)

        abilityIcon = ability:CreateTexture(nil, 'OVERLAY')
        abilityIcon:SetAllPoints()
        abilityIcon:SetTexture([[Interface\Icons\Ability_Marksmanship]])

        abilityName = ability:CreateFontString(nil, 'OVERLAY', 'Game12Font')
        abilityName:SetPoint('TOP', abilityIcon, 'BOTTOM', 0, -2)
        abilityName:SetText('Ability' .. i)

        ability.Icon = abilityIcon
        ability.Name = abilityName

        frame.Talents[i] = ability
    end

    return frame
end

local function createTalentButton(parent, width, height)
    local btn = CreateFrame('Button', nil, parent)
    btn:SetSize(width or 30, height or 30)

    btnIcon = btn:CreateTexture(nil, 'OVERLAY')
    btnIcon:SetAllPoints()
    --btnIcon:SetTexture([[Interface\Icons\Ability_Marksmanship]])

    btnName = btn:CreateFontString(nil, 'OVERLAY', 'Game12Font')
    btnName:SetPoint('TOP', btnIcon, 'BOTTOM', 0, -2)

    btn.Icon = btnIcon
    btn.Name = btnName

    return btn
end

local function createTalentGroup(parent, groupPoint, initialAngle)
    local row = CreateFrame('frame', nil, parent)
    row:SetSize(50, 50)
    row:SetPoint(unpack(groupPoint))
    --row:CreateBorder(10, { math.random(0, 1), math.random(0, 1), math.random(0, 1), 0.75})

    row.Level = row:CreateFontString(nil, 'OVERLAY', 'Game18Font')
    row.Level:SetPoint('CENTER')
    row.Talents = {}

    local btn
    local angle = 2 * math.pi / NUM_TALENT_COLUMNS
    local distance = 35
    local alpha
    for i = 1, NUM_TALENT_COLUMNS do
        alpha = initialAngle + (i-1) * angle
        btn = createTalentButton(row, 30, 30)
        btn:SetPoint('CENTER', row, 'CENTER', math.cos(alpha) * distance, math.sin(alpha) * distance)
        --btn.Name:SetText(i)
        row.Talents[i] = btn
    end

    return row
end

local function createTalentBoard(parent)

    local frame = CreateFrame('Frame', parent:GetName() .. 'TalentBoard', parent)

    frame:SetSize(1000, 500)
    frame:SetPoint('TOP', parent, 'TOP', 0, -300)

    --frame.Background = frame:CreateBackground({ 0.2, 0.4, 0.6, 0.75 })
    frame.Rows = {}

    local row
    local angle = 2 * math.pi / MAX_TALENT_TIERS
    local distance = 200

    local alpha
    for i = 1, MAX_TALENT_TIERS do
        alpha = -math.pi - i * angle
        row = createTalentGroup(frame, {'CENTER', frame, 'CENTER', math.cos(alpha) * distance, math.sin(alpha) * distance}, alpha)
        frame.Rows[i] = row
    end

    parent.TalentBoard = frame

end

local function createTitle(parent)
    local title = parent:CreateFontString(nil, 'OVERLAY', 'Game18Font')
    title:SetPoint('TOP', parent, 'TOP', 0, -4)
    title:SetHeight(40)
    title:SetText(UnitClass('player'))

    local icon = parent:CreateTexture(nil, 'OVERLAY', nil, 1)
    icon:SetSize(40, 40)
    icon:SetPoint('RIGHT', title, 'LEFT', -4, 0)
    icon:SetTexture(LibAtlas:GetPath('ClassIcon'))
    icon:SetTexCoord(LibAtlas:GetTexCoord('ClassIcon', V.MyClass))

    local iconBG = parent:CreateTexture(nil, 'OVERLAY', nil, 0)
    iconBG:SetAllPoints(icon)
    iconBG:SetColorTexture(0, 0, 0, 1)

    parent.Title = title
    parent.ClassIcon = icon
    parent.ClassIconBackground = iconBG
end

local function unselectSpec(self)
    self.SpecIcon:SetDesaturated(true)
    self.SelectedTexture:SetDesaturated(true)
end

local function selectSpec(self)
    self.SpecIcon:SetDesaturated(false)
    self.SelectedTexture:SetDesaturated(false)
end

local function specButtonOnClick(btn)
    local parent = btn:GetParent()
    local id = btn:GetID()

    if parent.currentSpec then
        unselectSpec(parent.Headers[parent.currentSpec])
    end
    selectSpec(btn)
    parent.currentSpec = id

    local primarySpecID = GetPrimarySpecialization();
    parent.previewSpecCost = (id ~= primarySpecID) and GetSpecChangeCost() or nil;
    if (parent.previewSpecCost and parent.previewSpecCost > 0) then
        StaticPopup_Show("CONFIRM_LEARN_SPEC", nil, nil, parent);
    else
        for i = 1, specCount do
            parent.Headers[i]:Disable()
        end
        SetSpecialization(id);

        --parent.playLearnAnim = true;
    end
end

local function createHeader(parent, width)

    local frame, icon, name, role, roleName, primaryStat, description
    local headers = {}
    local height = 190

    for i = 1, specCount do
        frame = CreateFrame('Button', parent:GetName() .. 'SpecButton' .. i, parent)
        frame:SetSize(width, height)
        frame:SetID(i)

        --Setup button texture

        frame.SelectedTexture = frame:CreateTexture(nil, 'BORDER')
        frame.SelectedTexture:SetSize(width, height)
        frame.SelectedTexture:SetTexture([[Interface\Common\bluemenu-main]])
        frame.SelectedTexture:SetTexCoord(0.026, 0.85, 0.60, 0.6615) --left="0.00390625" right="0.87890625" top="0.59179688" bottom="0.66992188
        frame.SelectedTexture:SetPoint('CENTER')

        frame:SetHighlightTexture([[Interface\Common\bluemenu-main]])
        local highlight = frame:GetHighlightTexture()
        highlight:SetTexCoord(0.026, 0.85, 0.76, 0.82) --left="0.00390625" right="0.87890625" top="0.75195313" bottom="0.83007813"/>
        highlight:SetBlendMode('ADD')
        highlight:SetAlpha(0.8)
        highlight:SetSize(width, height) --thx blizzard texture
        highlight:ClearAllPoints()
        highlight:SetPoint('CENTER')

        local glow = frame:CreateTexture(nil, 'ARTWORK', 1)
        glow:SetTexture([[Interface\Common\bluemenu-main]])
        glow:SetAlpha(0)
        glow:SetTexCoord(0.00390625, 0.87890625, 0.83203125, 0.91015625) --left="0.00390625" right="0.87890625" top="0.83203125" bottom="0.91015625"/>
        glow:SetSize(width, height)
        glow:SetAllPoints()
        frame.Glow = glow

        --Setup glow anim on spec update

        local animationGroup = frame:CreateAnimationGroup()
        animationGroup.FadeIn = animationGroup:CreateAnimation("Alpha")
        animationGroup.FadeIn:SetFromAlpha(0)
        animationGroup.FadeIn:SetToAlpha(1)
        animationGroup.FadeIn:SetDuration(.5)
        animationGroup.FadeIn:SetSmoothing("IN_OUT")
        animationGroup.FadeIn:SetOrder(1)
        animationGroup.FadeIn:SetTarget(glow)

        animationGroup.FadeOut = animationGroup:CreateAnimation("Alpha")
        animationGroup.FadeOut:SetFromAlpha(1)
        animationGroup.FadeOut:SetToAlpha(0)
        animationGroup.FadeOut:SetDuration(.5)
        animationGroup.FadeOut:SetSmoothing("IN_OUT")
        animationGroup.FadeOut:SetOrder(2)
        animationGroup.FadeOut:SetTarget(glow)

        frame.AnimationGroup = animationGroup

        --position the frame from each other

        if i == 1 then
            frame:SetPoint('TOPLEFT', parent, 'TOPLEFT', 10, -50)
        else
            frame:SetPoint('TOPLEFT', headers[i - 1], 'TOPRIGHT', 10, 0)
        end

        --create data

        name = frame:CreateFontString(nil, 'OVERLAY', 'Game18Font')
        name:SetPoint('TOP', frame, 'TOP', 0, -20)
        name:SetJustifyH('LEFT')

        icon = frame:CreateTexture(nil, 'OVERLAY')
        icon:SetSize(30, 30)
        icon:SetPoint('RIGHT', name, 'LEFT', -4, 0)

        role = frame:CreateTexture(nil, 'OVERLAY')
        role:SetSize(30, 30)
        role:SetPoint('TOPLEFT', frame, 'TOPLEFT', 30, -44)
        role:SetTexture(LibAtlas:GetPath('GlobalIcon'))

        roleName = frame:CreateFontString(nil, 'OVERLAY', 'Game12Font')
        roleName:SetPoint('LEFT', role, 'RIGHT', 10, 0)
        --roleName:SetJustifyH('LEFT')

        primaryStat = frame:CreateFontString(nil, 'OVERLAY', 'Game12Font')
        primaryStat:SetPoint('LEFT', roleName, 'RIGHT', 10, 0)
        --primaryStat:SetJustifyH('LEFT')

        description = frame:CreateFontString(nil, 'OVERLAY', 'Game12Font')
        description:SetPoint('BOTTOM', frame, 'BOTTOM', 0, 30)
        description:SetWidth(width - 40)
        --description:SetJustifyH('LEFT')

        local abilities = {}
        local ability
        for idxSpell = 1, 6 do
            --Create Iconic spell Button
            ability = CreateFrame('Button', frame:GetName() .. 'Ability' .. idxSpell, frame)
            ability:SetSize(30, 30)
            if idxSpell == 1 then
                ability:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 40, -10)
            else
                ability:SetPoint('LEFT', abilities[idxSpell - 1], 'RIGHT', 10, 0)
            end
            ability:SetNormalTexture([[Interface\Icons\Ability_Marksmanship]])
            abilities[idxSpell] = ability
            ability.Level = ability:CreateFontString(nil, 'OVERLAY', 'Number12Font_o1')
            ability.Level:SetPoint('TOP', ability, 'BOTTOM', 0, -4)
            --PlayerSpecSpellTemplate
        end

        frame.Abilities = abilities
        frame.SpecIcon = icon
        frame.RoleIcon = role
        frame.RoleName = roleName
        frame.SpecName = name
        frame.PrimaryStat = primaryStat
        frame.Description = description

        frame:SetScript('OnClick', specButtonOnClick)

        headers[i] = frame
    end

    parent.Headers = headers

end

local function updateTalents(self)

    local rows = self.TalentBoard.Rows
    local row, btn

    for t=1, MAX_TALENT_TIERS do
        row = rows[t]
        local tierAvailable, selectedTalent, tierUnlockLevel = GetTalentTierInfo(t, 1)
        row.Level:SetText(tierUnlockLevel)
        for column=1, NUM_TALENT_COLUMNS do
            -- Set the button info
            local talentID, name, iconTexture, selected, available, _, _, _, _, _, grantedByAura = GetTalentInfo(t, column, 1)
            local btn = row.Talents[column]

            --btn.Name:SetText(name)
            btn.Icon:SetTexture(iconTexture)
            if selected then
                btn.Icon:SetDesaturated(false)
            else
                btn.Icon:SetDesaturated(true)
            end
        end

        --local _, name, iconTexture = GetTalentInfo(t, selectedTalent, 1)
        --if iconTexture then
        --    talents[t].Icon:SetTexture(iconTexture)
        --    talents[t].Name:SetText(name)
        --else
        --    talents[t].Icon:SetColorTexture(1,1,0,0.5)
        --    talents[t].Name:SetText('NO TALENT')
        --end

        --for column=1, NUM_TALENT_COLUMNS do
        --    -- Set the button info
        --    local talentID, name, iconTexture, selected, available, _, _, _, _, _, grantedByAura = GetTalentInfo(tier, column, 1)
        --    local button = talentRow["talent"..column];
        --
        --end
    end
end

local function updateHeader(self)

    local headers = self.Headers

    local spells
    local id, name, desc, icon, level, pStat, role
    for i = 1, specCount do
        id, name, desc, icon, _, pStat = GetSpecializationInfo(i, false, false, false, UnitSex('player'))
        spells = C_SpecializationInfo.GetSpellsDisplay(id)

        role = GetSpecializationRole(i)

        headers[i].SpecIcon:SetTexture(icon)
        headers[i].RoleIcon:SetTexCoord(unpack(roleTexCoord[role]))
        headers[i].RoleName:SetText(_G[role])
        headers[i].SpecName:SetText(name)
        headers[i].PrimaryStat:SetText(SPEC_FRAME_PRIMARY_STAT:format(SPEC_STAT_STRINGS[pStat]))
        headers[i].Description:SetText(desc)

        for idxAbility = 1, #headers[i].Abilities do
            level = GetSpellLevelLearned(spells[idxAbility])
            if level > UnitLevel('player') then
                headers[i].Abilities[idxAbility].Level:SetText(level)
                headers[i].Abilities[idxAbility].Level:SetTextColor(1, 0, 0)
            end
            headers[i].Abilities[idxAbility]:SetNormalTexture(GetSpellTexture(spells[idxAbility]))
        end

        if i == self.currentSpec then
            selectSpec(headers[i])
        else
            unselectSpec(headers[i])
        end
    end
end

local function initFrame(self)

    local activeSpec = GetActiveSpecGroup(false)
    self.currentSpec = GetSpecialization(false, false, activeSpec)
    self.activeSpec = activeSpec

    updateHeader(self)
    updateTalents(self)

    self:SetScript('OnShow', nil)
end

function PlayerTalents:Enable()

    local width = 1000
    local spacing = 10

    Medias = Module:GetModule('Medias')
    LibAtlas = Medias:GetLibAtlas()
    roleTexCoord['TANK'] = { LibAtlas:GetTexCoord('GlobalIcon', 'DEFENSE') }
    roleTexCoord['HEALER'] = { LibAtlas:GetTexCoord('GlobalIcon', 'STAMINA') }
    roleTexCoord['DAMAGER'] = { LibAtlas:GetTexCoord('GlobalIcon', 'CRITICAL') }

    specCount = GetNumSpecializations()

    local mainFrame = CreateFrame('Frame', 'VorkuiPlayerTalentFrame', UIParent)
    mainFrame:SetSize(width, 800)
    mainFrame:SetPoint('CENTER', UIParent, 'CENTER')

    mainFrame.Background = mainFrame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    mainFrame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    local closeButton = CreateFrame('Button', nil, mainFrame, 'UIPanelCloseButton')
    closeButton:SetPoint('TOPRIGHT', mainFrame, 'TOPRIGHT')
    mainFrame.CloseButton = closeButton

    createTitle(mainFrame)
    createHeader(mainFrame, (width - 40) / 3)
    createTalentBoard(mainFrame)

    mainFrame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
    mainFrame:RegisterEvent('UNIT_SPELLCAST_STOP')
    mainFrame:SetScript('OnEvent', function(f, e)

        if InCombatLockdown() then
            return
        end

        for i = 1, specCount do
            f.Headers[i]:Enable()
        end
        if not f.Headers[f.currentSpec].AnimationGroup:IsPlaying() then
            f.Headers[f.currentSpec].AnimationGroup:Play()
        end


    end)
    initFrame(mainFrame)

    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript('OnMouseDown', function(f, btn)
        if not f.isMoving then
            f:StartMoving()
            f.isMoving = true
        end
    end)

    mainFrame:SetScript('OnMouseUp', function(f, btn)
        if f.isMoving then
            f:StopMovingOrSizing()
            f.isMoving = false
        end
    end)

    self.TalentFrame = mainFrame

end

function PlayerTalents:Disable()
    self.TalentFrame:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')
    self.TalentFrame:SetScript('OnEvent', nil)
end
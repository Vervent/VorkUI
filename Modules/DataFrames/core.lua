local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local DebugFrames = V['DebugFrames']
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local LibSlant = LibStub:GetLibrary("LibSlant")
local LibUnitStat = LibStub:GetLibrary('LibUnitStat')
local LibObserver = LibStub:GetLibrary('LibObserver')

local class = UnitClass('player')
local r, g, b = GetClassColor(strupper(class))

DataFrames.LibUnitStat = LibUnitStat
DataFrames.Frames = {}

local elements = {}

--local ViragDevTool = _G['ViragDevTool']
--local function log(data, str)
--
--    if ViragDevTool then
--        ViragDevTool:ViragDevTool_AddData(data, str)
--    end
--end

--TODO REMOVE THIS DEBUG PURPOSE USING PROFILES
local stats = {
    'HEALTH',
    'POWER',
    'ALTERNATE_MANA',
    'ITEM_LEVEL',
    'MOVE_SPEED',
    'STRENGTH',
    'AGILITY',
    'INTELLECT',
    'STAMINA',
    'CRIT_CHANCE',
    'HASTE',
    'MASTERY',
    'VERSATILITY',
    'LIFESTEAL',
    'AVOIDANCE',
    'SPEED',
    'ATTACK_DAMAGE',
    'SPELL_POWER',
    'ATTACK_POWER',
    'RANGED_ATTACK_POWER',
    'ATTACK_ATTACKSPEED',
    'ENERGY_REGEN',
    'RUNE_REGEN',
    'FOCUS_REGEN',
    'MANA_REGEN',
    'ARMOR',
    'DODGE',
    'PARRY',
    'BLOCK',
    'STAGGER',
    'GLOBAL_COOLDOWN'
}

local frames = {
    {
        ['Point'] = {
            { 'TOP' },
            { 'LEFT' },
            { 'RIGHT' },
        },
        ['Count'] = 15,
        ['Distribution'] = 'CENTER',
        ['Spacing'] = { 10, 0 },
        ['HasBorder'] = true,
        ['BorderClassColor'] = true,
        ['Size'] = { 125, 30 },
    },
    {
        ['Point'] = { 'TOPLEFT', 0, -30 },
        ['Count'] = 11,
        ['Distribution'] = 'BOTTOM',
        ['Spacing'] = { 0, -5 },
        ['HasBorder'] = false,
        ['StatusBarClassColor'] = true,
        ['BorderClassColor'] = true,
        ['Size'] = { 100, 30 },
    },
    --{
    --    ['Point'] = { 'CENTER', 0, -50 },
    --    ['Count'] = 9,
    --    ['Distribution'] = 'RIGHT',
    --    ['Size'] = { 100, 30 },
    --},
    ['Stats'] = {
        ['health'] = { 2, 1, true, true, false, true },
        ['stamina'] = { 2, 2, true, true, false, true },
        ['power'] = { 2, 3, true, true, true, true },
        --['spell_power'] = { 2, 5, true, true, false },
        ['mastery'] = { 2, 5, true, true, true, true },
        ['haste'] = { 2, 6, true, true, true, true },
        ['crit_chance'] = { 2, 7, true, true, true, true },
        ['versatility'] = { 2, 8, true, true, true, true },
        ['lifesteal'] = { 2, 9, true, true, true, true },
        ['speed'] = { 2, 10, true, true, true, true },
        ['avoidance'] = { 2, 11, true, true, true, true },
        --['armor'] = { 2, 12, true, true, true },
        --['dodge'] = { 2, 13, true, true, true },
        --['parry'] = { 2, 14, true, true, true },
        --['block'] = { 2, 15, true, true, true },
        --['attack_speed'] = { 2, 16, true, true, true },
        --['attack_power'] = { 2, 18, true, true, false },
        ['item_level'] = { 1, 13, true, true, false, false },
        --['NAME'] = { frameId, itemId, hasIcon, hasText, HasStatusBar, hasTooltip, hasBorder
    },
    ['Datas'] = {
        ['framerate'] = { 1, 1, true, true, false, true },
        ['ping'] = { 1, 2, true, true, false, true },
        ['money'] = { 1, 4, false, true, false, true },
        ['currencies'] = { 1, 6 },
        ['bag'] = { 1, 8, true, true, false, true },
        ['vault'] = { 1, 10, true, true, false, true },
        ['micromenu'] = { 1, 12 },
        ['professions'] = { 1, 14, true, true, false, false },
        ['time'] = { 1, 3, true, true, false, true },
        ['durability'] = { 1, 5, true, true, false, true },
        ['covenant'] = { 1, 7, true, true, false, false },
        ['specialization'] = { 1, 9, true, true, false, false },
        ['legendary'] = { 1, 11, true, true, false, false },
        ['equipmentset'] = { 1, 15, true, true, false, false },
        ['primary'] = { 2, 4, true, true, false, true, true },
    },
}

local function getPoint(direction, oldOffset)
    if direction == 'CENTER' then
        if (not oldOffset) then
            oldOffset = 1
        end
        if oldOffset == -1 then
            --previous was left expansion
            return -oldOffset, 'LEFT', 'RIGHT'
        else
            return -oldOffset, 'RIGHT', 'LEFT'
        end
    elseif direction == 'LEFT' then
        --we expand left side
        return -1, 'RIGHT', 'LEFT'
    elseif direction == 'RIGHT' then
        --we expand right side
        return 1, 'LEFT', 'RIGHT'
    elseif direction == 'BOTTOM' then
        return -1, 'TOP', 'BOTTOM'
    end
end

local function createStatusBar(self, isClassColored)

    local statusBar = CreateFrame('StatusBar', nil, self)
    statusBar:SetStatusBarTexture(Medias:GetStatusBar('VorkuiDefault'))

    if isClassColored then
        statusBar:SetStatusBarColor(r, g, b)
    end

    statusBar.bg = statusBar:CreateTexture(nil, "BACKGROUND")
    statusBar.bg:SetTexture(Medias:GetStatusBar('VorkuiBackground'))
    statusBar.bg:SetAllPoints()

    self.StatusBar = statusBar
end

local function createText(self)
    local txt = self:CreateFontString(nil, 'OVERLAY', 'NumberFont_OutlineThick_Mono_Small')
    local h = self:GetHeight() - 4
    local w = self:GetWidth() - 4

    self.Text = txt
end

local function createIcon(self)
    local icon = self:CreateTexture(nil, 'OVERLAY')
    --local w, h = self:GetSize()
    --h = min(h, w)
    --h = min(h, 30) - 4
    --icon:SetSize(h, h)
    self.Icon = icon
end

local function createDataFrames(conf)
    local frame = CreateFrame('Frame', 'VorkuiDataFrames', UIParent)
    frame.elements = {}
    if conf.Point then
        if type(conf.Point[1]) == 'table' then
            for _, p in ipairs(conf.Point) do
                frame:SetPoint(unpack(p))
            end
        else
            frame:SetPoint(unpack(conf.Point))
        end
    end

    local w, h

    if conf.Size then
        w, h = unpack(conf.Size)
        if conf.Distribution == 'LEFT' or conf.Distribution == 'RIGHT' or conf.Distribution == 'CENTER' then
            frame:SetSize((w + (max(conf.Spacing[1], -conf.Spacing[1]) or 0)) * conf.Count, h)
        else
            frame:SetSize(w, (h + (max(conf.Spacing[2], -conf.Spacing[2]) or 0)) * conf.Count)
        end
    end

    --frame:SetSize(frame:GetParent():GetWidth(), 40)
    --frame:SetHeight(30)
    frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(0, 0, 0, 0.5)

    if conf.HasBorder == true then
        if conf.BorderClassColor == true then
            frame:CreateOneBorder('bottom', 1, { r, g, b })
        else
            frame:CreateOneBorder('bottom', 1, { 1, 1, 1 })
        end
    end

    local offsetX, offsetY = unpack(conf.Spacing or { 0, 0 })

    local data, offset, anchorPoint, relativeTo
    for i = 1, conf.Count do
        data = CreateFrame('Button', 'Data' .. i, frame)

        --data.bg = data:CreateTexture('BACKGROUND')
        --data.bg:SetAllPoints()
        --data.bg:SetColorTexture(0,0,0,0.66)

        --Debug
        --data.border = data:CreateBorder(1, {1,1,1})

        if conf.Size then
            data:SetSize(w, h)
        end
        if i == 1 then
            if conf.Distribution == 'LEFT' then
                data:SetPoint('RIGHT')
            elseif conf.Distribution == 'RIGHT' then
                data:SetPoint('LEFT')
            elseif conf.Distribution == 'BOTTOM' then
                data:SetPoint('TOPLEFT')
            elseif conf.Distribution == 'TOP' then
                data:SetPoint('BOTTOMLEFT')
            else
                data:SetPoint('TOP')
            end
        else
            offset, anchorPoint, relativeTo = getPoint(conf.Distribution, offset)
            if conf.Distribution == 'CENTER' then
                data:SetPoint(anchorPoint, frame.elements[max(i - 2, 1)], relativeTo, offset * offsetX, offset * offsetY)
            else
                data:SetPoint(anchorPoint, frame.elements[i - 1], relativeTo, offsetX, offsetY)
            end
        end

        data.SetStat = function(self, stat)
            self.stat = stat
        end

        --Setup observer to be notified on stat update
        data.Observer = LibObserver:CreateObserver()

        tinsert(frame.elements, data)
    end

    return frame
end

local function enableStat(self)

    local element
    local frameId, itemId, hasIcon, hasText, hasStatusBar, hasTooltip, hasBorder
    for k, idxTable in pairs(frames.Stats) do

        --print (k)
        frameId, itemId, hasIcon, hasText, hasStatusBar, hasBorder = unpack(idxTable)

        LibUnitStat:AddStat(k)
        element = self.Frames[frameId].elements[itemId]
        element:SetStat(k)

        if hasIcon == true then
            createIcon(element)
            --element.Icon:SetPoint('LEFT')
        end

        if hasStatusBar == true then
            createStatusBar(element, frames[frameId].StatusBarClassColor)
        end

        if hasText == true then
            createText(element)
            --element.Text:SetPoint('RIGHT')
        end

        if hasTooltip == true then
            --AddTooltip
        end

        if hasBorder == true then
            if frames[frameId].BorderClassColor == true then
                element:CreateOneBorder('bottom', 1, { r, g, b })
            else
                element:CreateOneBorder('bottom', 1, { 1, 1, 1 })
            end
        end

        LibUnitStat:RegisterObserver(k, element.Observer)
        if elements[k] then
            elements[k].Enable(element)
        end
    end
    LibUnitStat:Enable()
end

local function enableData(self)
    local element
    local frameId, itemId, hasIcon, hasText, hasStatusBar, hasTooltip, hasBorder
    for k, idxTable in pairs(frames.Datas) do
        frameId, itemId, hasIcon, hasText, hasStatusBar, hasTooltip, hasBorder = unpack(idxTable)
        element = self.Frames[frameId].elements[itemId]
        element:SetStat(k)

        if hasIcon == true then
            createIcon(element)
            --element.Icon:SetPoint('LEFT')
        end

        if hasStatusBar == true then
            createStatusBar(element)
        end

        if hasText == true then
            createText(element)
            --element.Text:SetPoint('RIGHT')
        end

        if hasTooltip == true then
            --AddTooltip
        end

        if hasBorder == true then
            if frames[frameId].BorderClassColor == true then
                element:CreateOneBorder('bottom', 1, { r, g, b })
            else
                element:CreateOneBorder('bottom', 1, { 1, 1, 1 })
            end
        end

        if elements[k] then
            elements[k].Enable(element)
        end
    end
end

function DataFrames:Enable()

    for _, conf in ipairs(frames) do
        tinsert(self.Frames, createDataFrames(conf))
    end

    enableStat(self)
    enableData(self)
end

function DataFrames:Disable()

end

function DataFrames:RegisterElement(elementType, enableFct, disableFct, updateFct)
    if elements[elementType] then
        return
    end

    elements[elementType] = {
        Enable = enableFct or function()
        end,
        Disable = disableFct or function()
        end,
        Update = updateFct or function()
        end,
    }

end
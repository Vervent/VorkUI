local select = select
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local unpack = unpack
local BreakUpLargeNumbers = BreakUpLargeNumbers
local LE_UNIT_STAT_INTELLECT = LE_UNIT_STAT_INTELLECT
local LE_UNIT_STAT_AGILITY = LE_UNIT_STAT_AGILITY
local LE_UNIT_STAT_STRENGTH = LE_UNIT_STAT_STRENGTH
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo

local iconCoord = {
    ['strength'] = 'STRENGTH',
    ['intellect'] = 'INTELLIGENCE',
    ['stamina'] = 'STAMINA',
    ['agility'] = 'AGILITY',
}

local iconPath = {
    ['strength'] = [[INTERFACE\ICONS\ABILITY_WARRIOR_STRENGTHOFARMS]],
    ['intellect'] = [[INTERFACE\ICONS\SPELL_HOLY_MAGICALSENTRY]],
    ['stamina'] = [[INTERFACE\ICONS\SPELL_HOLY_WORDFORTITUDE]],
    ['agility'] = [[INTERFACE\ICONS\SPELL_HOLY_BLESSINGOFAGILITY]],
}

local primaryStat = {
    [LE_UNIT_STAT_INTELLECT] = 'intellect',
    [LE_UNIT_STAT_AGILITY] = 'agility',
    [LE_UNIT_STAT_STRENGTH] = 'strength',
}

local function update(self, event)

    local _, stat = unpack(event)
    local _, effectiveStat = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(effectiveStat or 0))
    end

end

local function enable(self, onlyPrimary)

    self:SetSize(100, 30)

    self.Icon:SetSize(25, 25)
    self.Icon:SetTexture(iconPath[self.stat])
    --self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)
    self.Text:SetJustifyH('LEFT')

    --self.Icon:SetVertexColor(1, 0, 0)
    self.Observer.OnNotify = function(...)
        update(self, ...)
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

local function updatePrimary(self, event)
    local _, stat = unpack(event)
    local _, effectiveStat = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(effectiveStat or 0))
    end
end

local function onEvent(self, event)

    local currentSpec = GetSpecialization()
    local primary = select(6, GetSpecializationInfo(currentSpec))
    local stat = primaryStat[primary]
    if event == 'PLAYER_ENTERING_WORLD' then
        DataFrames.LibUnitStat:AddStat(stat)
    else
        DataFrames.LibUnitStat:UnregisterObserver(stat, self.Observer)
        DataFrames.LibUnitStat:RemoveStat(self.currentStat)
        DataFrames.LibUnitStat:AddStat(stat)
    end

    DataFrames.LibUnitStat:RegisterObserver(stat, self.Observer)
    self.currentStat = stat
    self.Icon:SetTexture(iconPath[stat])
end

local function enablePrimary(self)
    self:SetSize(100, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetPoint('LEFT', 1, 0)
    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self.Observer.OnNotify = function(...)
        updatePrimary(self, ...)
    end

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
    self:SetScript('OnEvent', onEvent)
end

local function disablePrimary(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')

    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('primary', enablePrimary, disablePrimary, updatePrimary)
DataFrames:RegisterElement('strength', enable, disable, update)
DataFrames:RegisterElement('intellect', enable, disable, update)
DataFrames:RegisterElement('stamina', enable, disable, update)
DataFrames:RegisterElement('agility', enable, disable, update)
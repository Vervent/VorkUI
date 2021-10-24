local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local unpack = unpack
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetSpecializationRole = GetSpecializationRole
local IsRangedWeapon = IsRangedWeapon
local format = format

--local iconCoord = {
--    ['mastery'] = 'MASTERY',
--    ['crit_chance'] = 'CRITICAL',
--    ['haste'] = 'HASTE',
--    ['versatility'] = 'VERSATILITY',
--    ['avoidance'] = 'RAGE',
--    ['lifesteal'] = 'RUNICPOWER',
--    ['speed'] = 'MAELSTROM',
--}

local iconPath = {
    ['mastery'] = [[INTERFACE\ICONS\SPELL_ARCANE_MINDMASTERY]],
    ['crit_chance'] = [[INTERFACE\ICONS\ABILITY_HUNTER_MASTERMARKSMAN]],
    ['haste'] = [[INTERFACE\ICONS\SPELL_HOLY_POWERINFUSION]],
    ['versatility'] = [[INTERFACE\ICONS\SPELL_HOLY_HOLYGUIDANCE]],
    ['avoidance'] = [[INTERFACE\ICONS\SPELL_HOLY_LASTINGDEFENSE]],
    ['lifesteal'] = [[INTERFACE\ICONS\SPELL_WARLOCK_HARVESTOFLIFE]],
    ['speed'] = [[INTERFACE\ICONS\SPELL_LIFEGIVINGSPEED]],
}

local unitClass = UnitClass('Player')

local function updateCrit(self, event)
    local _, stat = unpack(event)
    --local meleeCrit, meleeRating, meleeRatingBonus,
    --rangedCrit, rangedRating, rangedRatingBonus,
    --spellCrit, spellRating, spellRatingBonus
    local critTable = DataFrames.LibUnitStat:GetStat(stat)
    local spec, role
    spec = GetSpecialization()
    if spec then
        role = GetSpecializationRole(spec)
    end

    local percent, rating, bonus
    if role == 'HEALER' then
        percent = critTable[7]
        rating = critTable[8]
        bonus = critTable[9]
    elseif IsRangedWeapon() then
        percent = critTable[4]
        rating = critTable[5]
        bonus = critTable[6]
    else
        percent = critTable[1]
        rating = critTable[2]
        bonus = critTable[3]
    end

    if self.Text then
        self.Text:SetText(format('%.2f%%', percent or 0))
    end

    if (self.StatusBar) then
        self.StatusBar:SetValue(percent or 0)
    end
end

local function updateVersa(self, event)

    local _, stat = unpack(event)
    local versatility, outcomeRatingBonus, outcomeVersaBonus, incomeRatingBonus, incomeVersaBonus = unpack(DataFrames.LibUnitStat:GetStat(stat))
    if self.Text then
        self.Text:SetText(format('%.2f%%', outcomeRatingBonus + outcomeVersaBonus))
    end

    if (self.StatusBar) then
        self.StatusBar:SetValue(outcomeRatingBonus + outcomeVersaBonus)
    end

end

local function update(self, event)

    local _, stat = unpack(event)
    local value, coeff, rating, percent = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(format('%.2f%%', value))
    end

    if (self.StatusBar) then
        self.StatusBar:SetValue(value)
    end

end

local function enable(self)
    self:SetSize(100, 30)

    self.Icon:SetSize(25, 25)
    self.Icon:SetTexture(iconPath[self.stat])
    --self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT', 1, 0)

    if self.Text then
        self.Text:SetPoint('TOPLEFT', self.Icon, 'TOPRIGHT', 2, 0)
        self.Text:SetJustifyH('LEFT')
    end

    if self.StatusBar then
        self.StatusBar:SetOrientation('HORIZONTAL')
        self.StatusBar:SetPoint('BOTTOMLEFT', self.Icon, 'BOTTOMRIGHT', 2, 0)
        self.StatusBar:SetPoint('RIGHT', self, 'RIGHT')
        self.StatusBar:SetHeight(self:GetHeight() * 0.2)
        self.StatusBar:SetMinMaxValues(0, 100)
    end

    if self.stat == 'crit_chance' then
        self.Observer.OnNotify = function(...)
            updateCrit(self, ...)
        end
    elseif self.stat == 'versatility' then
        self.Observer.OnNotify = function(...)
        updateVersa(self, ...)
        end
    else
        self.Observer.OnNotify = function(...)
            update(self, ...)
        end
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('crit_chance', enable, disable, updateCrit)
DataFrames:RegisterElement('versatility', enable, disable, updateVersa)
DataFrames:RegisterElement('mastery', enable, disable, update)
DataFrames:RegisterElement('haste', enable, disable, update)
DataFrames:RegisterElement('lifesteal', enable, disable, update)
DataFrames:RegisterElement('speed', enable, disable, update)
DataFrames:RegisterElement('avoidance', enable, disable, update)
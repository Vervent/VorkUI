local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local unpack = unpack
local BreakUpLargeNumbers = BreakUpLargeNumbers

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

local function update(self, event)

    local _, stat = unpack(event)
    local _, effectiveStat = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(effectiveStat or 0))
    end

end

local function enable(self)
    --local path = LibAtlas:GetPath('GlobalIcon')
    --self.Icon:SetTexture(path)
    --self.Icon:SetTexCoord(LibAtlas:GetTexCoord('GlobalIcon', iconCoord[self.stat]))
    self.Icon:SetTexture(iconPath[self.stat])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT')
    self.Text:SetJustifyH('LEFT')
    --self.Icon:SetVertexColor(1, 0, 0)
    self.Observer.OnNotify = function(...)
        update(self, ...)
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('strength', enable, disable, update)
DataFrames:RegisterElement('intellect', enable, disable, update)
DataFrames:RegisterElement('stamina', enable, disable, update)
DataFrames:RegisterElement('agility', enable, disable, update)
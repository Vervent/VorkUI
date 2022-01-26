local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local Medias = Module:GetModule('Medias')
local DataFrames = Module:GetModule('DataFrames')

local unpack = unpack
local BreakUpLargeNumbers = BreakUpLargeNumbers

local function update(self, event)

    local _, stat = unpack(event)
    local power = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(power))
    end

end

local function enable(self)

    self:SetSize(100, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetPoint('LEFT', 1, 0)
    --self.Icon:SetTexture('interface/icons/ability_parry')
    --self.Icon:SetTexture('interface/icons/ability_defend')
    self.Icon:SetTexture([[INTERFACE\ICONS\SPELL_HOLY_GREATERBLESSINGOFKINGS]])
    --self.Icon:SetDesaturated(true)

    if self.Text then
        self.Text:SetPoint('TOPLEFT', self.Icon, 'TOPRIGHT', 2, 0)
        self.Text:SetJustifyH('LEFT')
    end

    self.Observer.OnNotify = function(...)
        update(self, ...)
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('attack_power', enable, disable, update)
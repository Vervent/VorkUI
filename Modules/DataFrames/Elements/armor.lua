local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...


local DataFrames = V["DataFrames"]
local Medias = V["Medias"]

local Module = V.Module
local Medias = Module:GetModule('Medias')
local DataFrames = Module:GetModule('DataFrames')

local unpack = unpack
local BreakUpLargeNumbers = BreakUpLargeNumbers
local max = max

local function update(self, event)

    local _, stat = unpack(event)
    local baselineArmor, effectiveArmor, armor, bonusArmor, armorReduction, armorReductionAgainstTarget = unpack(DataFrames.LibUnitStat:GetStat(stat))

    local val = max(armorReduction, armorReductionAgainstTarget)
    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(val))
    end

    if self.StatusBar then
        self.StatusBar:SetValue(val)
    end

end

local function enable(self)

    --self.Icon:SetTexture('interface/icons/ability_parry')
    --self.Icon:SetTexture('interface/icons/ability_defend')
    self:SetSize(100, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetTexture([[INTERFACE\ICONS\INV_SHIELD_06]])
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

    self.Observer.OnNotify = function(...)
        update(self, ...)
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('armor', enable, disable, update)
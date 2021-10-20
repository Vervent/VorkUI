local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local unpack = unpack
local BreakUpLargeNumbers = BreakUpLargeNumbers

local function update(self, event)

    local _, stat = unpack(event)
    local percent, shieldBlockArmor, blockArmorReduction, blockArmorReductionAgainstTarget = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(percent or 0))
    end

    if self.StatusBar then
        self.StatusBar:SetValue(percent or 0)
    end

end

local function enable(self)

    --self.Icon:SetTexture('interface/icons/ability_parry')
    --self.Icon:SetTexture('interface/icons/ability_defend')
    self.Icon:SetTexture([[INTERFACE\ICONS\ABILITY_DEFEND]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

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

DataFrames:RegisterElement('block', enable, disable, update)
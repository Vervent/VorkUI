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
    local arrayPower = DataFrames.LibUnitStat:GetStat(stat)

    local max = 0
    for _, spell in ipairs(arrayPower) do
        if spell > max then
            max = spell
        end
    end

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(max))
    end

end

local function enable(self)
    self:SetSize(30, 30)
    --self.Icon:SetTexture('interface/icons/ability_parry')
    --self.Icon:SetTexture('interface/icons/ability_defend')
    self.Icon:SetTexture([[INTERFACE\ICONS\achievement_reputation_kirintor_offensive]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

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

DataFrames:RegisterElement('spell_power', enable, disable, update)
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local unpack = unpack
local BreakUpLargeNumbers = BreakUpLargeNumbers

local function update(self, event)

    local _, stat = unpack(event)
    local _, max = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(max))
    end

end

local function enable(self)
    self:SetSize(100, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetPoint('LEFT', 1, 0)
    --self.Icon:SetTexture([[Interface\AddOns\VorkUI\Medias\Icons\Statusbar\PetBattle_Health]])
    self.Icon:SetTexture([[interface/icons/petbattle_health]])

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

DataFrames:RegisterElement('health', enable, disable, update)
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
    local _, max = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if self.Text then
        self.Text:SetText(BreakUpLargeNumbers(max))
    end

end

local function enable(self)

    --local path = LibAtlas:GetPath('GlobalIcon')
    --self.Icon:SetTexture(path)
    --self.Icon:SetTexCoord(LibAtlas:GetTexCoord('GlobalIcon', 'HEALTH'))
    self.Icon:SetTexture([[Interface\AddOns\VorkUI\Medias\Icons\Statusbar\PetBattle_Health]])
    --self.Icon:SetDesaturated(true)

    --self.Icon:SetTexture('interface/icons/ability_parry')
    --self.Icon:SetTexture('interface/icons/ability_defend')
    --self.Icon:SetDesaturated(true)
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

DataFrames:RegisterElement('health', enable, disable, update)
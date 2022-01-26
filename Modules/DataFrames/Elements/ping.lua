local select = select
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local format = format
local GetNetStats = GetNetStats
local GetClassColor = GetClassColor

local colors = {
    [0] = select(4, GetClassColor('DEATHKNIGHT')),
    [1] = select(4, GetClassColor('DRUID') ),
    [2] = select(4, GetClassColor('ROGUE') ),
    [3] = select(4, GetClassColor('MONK') ),
}

local function getColor(value)
    if value > 1000 then
        return colors[0]
    elseif value > 200 then
        return colors[1]
    elseif value > 60 then
        return colors[2]
    else
        return colors[3]
    end
end

local function update(self, _)
    local _, _, latencyHome, latencyWorld = GetNetStats()

    self.Text:SetText(format('|c%s%.0f|r ms | |c%s%.0f|r ms', getColor(latencyHome), latencyHome, getColor(latencyWorld), latencyWorld))
end

local function enable(self)
    self:SetSize(120, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetTexture([[Interface\AddOns\VorkUI\Medias\Icons\Statusbar\ping]])
    self.Icon:SetPoint('LEFT', 1, 0)
    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)
    self:SetScript('OnUpdate', update)

end

local function disable(self)
    self:SetScript('OnUpdate', nil)
end

DataFrames:RegisterElement('ping', enable, disable, update)
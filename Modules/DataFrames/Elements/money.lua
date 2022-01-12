local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local GetMoney = GetMoney
local GetCoinText = GetCoinText

local copperIcon = [[interface/icons/inv_misc_coin_05]]
local silverIcon = [[interface/icons/inv_misc_coin_03]]
local goldIcon = [[interface/icons/inv_misc_coin_01]]

local function formatQTY(money)
    local copper = money % 100
    local silver = (money / 100) % 100
    local gold = money / 100 / 100

    if gold > 999999 then
        return format('%.2fm|T%s:0:1|t', gold / 1000000, goldIcon)
    elseif gold > 9999 then
        return format('%.2fk|T%s:0:1|t%.0f|T%s:0:1|t', gold / 1000, goldIcon, silver, silverIcon)
    else
        return format('%.f|T%s:0:1|t%.0f|T%s:0:1|t%.0f|T%s:0:1|t', gold, goldIcon, silver, silverIcon, copper, copperIcon)
    end
end

local function update(self, event)
    self.Text:SetText(formatQTY(GetMoney()))
end

local function enable(self)
    self:SetSize(120, 30)
    self.Text:SetPoint('LEFT', 1, 0)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_MONEY')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('PLAYER_MONEY')
end

DataFrames:RegisterElement('money', enable, disable, update)
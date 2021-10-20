local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local GetMoney = GetMoney
local GetCoinText = GetCoinText

local function update(self, event)

    self.Text:SetText(GetCoinText(GetMoney()))

end

local function enable(self)

    self.Icon:SetTexture([[INTERFACE\ICONS\inv_misc_coin_01]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT')

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_MONEY')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('PLAYER_MONEY')
end

DataFrames:RegisterElement('money', enable, disable, update)
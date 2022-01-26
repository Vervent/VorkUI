local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local GetMoney = GetMoney
local GetCoinText = GetCoinText

local formatQTY = V.Utils.Functions.FormatMoney

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
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local tinsert = tinsert
local tostring = tostring
local format = format
local C_CurrencyInfo = C_CurrencyInfo
local CreateFrame = CreateFrame
local ipairs = ipairs

local id = {
    1813, --anima
    1810, --redeemed soul
    1767, --stygia
    1977, --stygian ember
    1904, --tower knowledge
    1931, --cataloged research
    1828, --soul ash
    1906, --soul cinders
    1191, --valor
}

local path = {
    [[INTERFACE/ICONS/SPELL_ANIMAARDENWEALD_ORB]], --anima
    [[INTERFACE/ICONS/SHA_SPELL_WARLOCK_DEMONSOUL_NIGHTBORNE]], --redeemed soul
    [[INTERFACE/ICONS/INV_STYGIA]], --stygia
    [[INTERFACE/ICONS/ABILITY_DEATHKNIGHT_SOULREAPER]], --stygian ember
    [[INTERFACE/ICONS/SPELL_BROKER_ORB]], --tower knowledge
    [[INTERFACE/ICONS/INV_MISC_PAPERBUNDLE04A]], --cataloged research
    [[INTERFACE/ICONS/INV_SOULASH]], --soul ash
    [[INTERFACE/ICONS/INV_MISC_SUPERSOULASH]], --soul cinders
    [[INTERFACE/ICONS/PVECURRENCY-VALOR]], --valor
}

local name = {
    'Anima', --anima
    'Redeemed Soul', --redeemed soul
    'Stygia', --stygia
    'StygianEmber', --stygian ember
    'TowerKnowledge', --tower knowledge
    'CatalogedResearch', --cataloged research
    'SoulAsh', --soul ash
    'SoulCinders', --soul cinders
    'Valor', --valor
}

local function QtyFormat(qty)
    if qty < 1000 then
        return tostring(qty)
    else
        return format('%.0fk', qty / 1000)
    end
end

local function getIndex(currencyType)
    for i, currency in ipairs(id) do
        if currencyType == currency then
            return i
        end
    end

    return -1
end

local function getData(currencyType)
    return C_CurrencyInfo.GetCurrencyInfo(currencyType)
end

local function update(self, event, ...)

    if event == 'PLAYER_ENTERING_WORLD' then
        for i, currency in ipairs(id) do
            local d = getData(currency)
            self.Buttons[i].Text:SetText(QtyFormat(d.quantity))
        end
    else
        local idx = getIndex(...)
        if idx ~= -1 then
            self.Buttons[idx].Text:SetText(QtyFormat(getData(...).quantity))
        end
    end

end

local function enable(self)
    self:SetSize(236, 30)
    if self.Buttons == nil then
        self.Buttons = {}
        local btn

        for i, id in ipairs(id) do
            btn = CreateFrame('Button', 'Currency' .. name[i], self)
            btn:SetSize(25, 25)
            if #self.Buttons == 0 then
                btn:SetPoint('LEFT', self, 1, 0)
            else
                btn:SetPoint('LEFT', self.Buttons[#self.Buttons], 'RIGHT', 1, 0)
            end

            btn.Icon = btn:CreateTexture('OVERLAY')
            btn.Icon:SetAllPoints()
            btn.Icon:SetTexture(path[i])
            --btn.Icon:SetDesaturated(true)

            btn.Text = btn:CreateFontString(nil, 'OVERLAY', 'NumberFont_OutlineThick_Mono_Small')
            btn.Text:SetPoint('TOP', btn.Icon, 'BOTTOM')

            btn:SetID(id)
            tinsert(self.Buttons, btn)
        end
    else
        for i, btn in ipairs(self.Buttons) do
            btn:Show()
        end
    end

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
    self:SetScript('OnEvent', update)

end

local function disable(self)
    for i, btn in ipairs(self.Buttons) do
        btn:Hide()
    end

    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('CURRENCY_DISPLAY_UPDATE')
end

DataFrames:RegisterElement('currencies', enable, disable, update)
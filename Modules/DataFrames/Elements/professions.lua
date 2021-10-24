local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local format = format
local select = select
local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local CreateFrame = CreateFrame
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo

local function update(self, event)

    local skillLevel, maxSkillLevel
    local profession

    --for i, btn in ipairs(self.Buttons) do
    --    profession = btn:GetID()
    --    skillLevel, maxSkillLevel = select(3, GetProfessionInfo(profession))
    --    btn.Text:SetText(format('%d/%d', skillLevel, maxSkillLevel))
    --end

end

local function createProfButton(self, prof)
    local name, icon = GetProfessionInfo(prof)
    local btn = CreateFrame('Button', 'Profession' .. name, self)
    btn:SetSize(110, 30)
    if #self.Buttons == 0 then
        btn:SetPoint('LEFT', self, 1, 0)
    else
        btn:SetPoint('LEFT', self.Buttons[#self.Buttons], 'RIGHT', 1, 0)
    end

    btn.Icon = btn:CreateTexture('OVERLAY')
    btn.Icon:SetPoint('LEFT')
    btn.Icon:SetSize(25,25)
    btn.Icon:SetTexture(icon)
    --btn.Icon:SetDesaturated(true)

    btn.Text = btn:CreateFontString(nil, 'OVERLAY', 'Number12Font_o1')
    btn.Text:SetPoint('LEFT', btn.Icon, 'RIGHT')
    --btn.Text:SetText(format('%d/%d', skillLevel, maxSkillLevel))
    btn.Text:SetText(format('%s', name))

    btn:SetID(prof)
    tinsert(self.Buttons, btn)
end

local function enable(self)
    local prof1, prof2 = GetProfessions()

    local idx = 0
    if self.Buttons == nil then
        self.Buttons = {}
        if prof1 then
            createProfButton(self, prof1)
            idx = idx + 1
        end
        if prof2 then
            createProfButton(self, prof2)
            idx = idx + 1
        end
    else
        for i, btn in ipairs(self.Buttons) do
            btn:Show()
        end
        idx = #self.Buttons
    end

    self:SetSize(110*idx, 30)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('TRADE_SKILL_LIST_UPDATE')
    self:RegisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self:RegisterEvent('TRADE_SKILL_NAME_UPDATE')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('TRADE_SKILL_LIST_UPDATE')
    self:UnregisterEvent('TRADE_SKILL_DETAILS_UPDATE')
    self:UnregisterEvent('TRADE_SKILL_NAME_UPDATE')
end

DataFrames:RegisterElement('professions', enable, disable, update)
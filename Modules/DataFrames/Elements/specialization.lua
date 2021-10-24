local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local tinsert = tinsert
local ipairs = ipairs
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local MAX_TALENT_TIERS = MAX_TALENT_TIERS
local NUM_TALENT_COLUMNS = NUM_TALENT_COLUMNS
local GetTalentInfoBySpecialization = GetTalentInfoBySpecialization
local format = format

local function update(self, event)

    local currentSpec = GetSpecialization()
    local _, name, _, icon, _, _ = GetSpecializationInfo(currentSpec)
    self.Icon:SetTexture(icon)
    self.Text:SetText(format('%.4s', name))

    for i = 1, MAX_TALENT_TIERS do
        for j=1, NUM_TALENT_COLUMNS do
            local _, _, texture, _, _, _, _, _, _, known, _ = GetTalentInfoBySpecialization(currentSpec, i, j)
            if known == true then
                self.Talents[i].Texture:SetTexture(texture)
                break
            end
        end
    end

end

local function enable(self)
    self:SetSize(244, 30)
    --self.Icon:SetTexture([[INTERFACE\ICONS\ACHIEVEMENT_GUILDPERK_BOUNTIFULBAGS]])
    --self.Icon:SetDesaturated(true)
    self.Icon:SetSize(25,25)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self.Talents = {}
    local btn
    for i = 1, MAX_TALENT_TIERS do
        btn = CreateFrame('button', nil, self)
        btn:SetSize(25, 25)
        if i == 1 then
            btn:SetPoint('LEFT', self.Text, 'RIGHT', 1, 0)
        else
            btn:SetPoint('LEFT', self.Talents[i - 1], 'RIGHT', 1, 0)
        end

        btn.Texture = btn:CreateTexture('ARTWORK')
        btn.Texture:SetAllPoints()
        --btn.Texture:SetDesaturated(true)

        btn:Show()
        tinsert(self.Talents, btn)
    end

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
    self:RegisterEvent('PLAYER_TALENT_UPDATE')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_TALENT_UPDATE')
    self:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')

    for _, btn in ipairs(self.Talents) do
        btn:Hide()
    end
end

DataFrames:RegisterElement('specialization', enable, disable, update)
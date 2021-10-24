local select = select
local V = select(2, ...):unpack()

local DataFrames = V["DataFrames"]

local floor = floor
local format = format
local GetClassColor = GetClassColor
local UnitLevel = UnitLevel
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
local GetXPExhaustion = GetXPExhaustion

local maxLevel = GetMaxLevelForPlayerExpansion()

local colors = {
    [0] = select(4, GetClassColor('DEATHKNIGHT')),
    [1] = select(4, GetClassColor('DRUID') ),
    [2] = select(4, GetClassColor('ROGUE') ),
    [3] = select(4, GetClassColor('MONK') ),
}

local function update(self, event, ...)
    local level

    if event == 'PLAYER_LEVEL_UP' then
        level = ...
    else
        level = UnitLevel('player')
    end

    if level == maxLevel then
        self.Text:SetText(format('%d', level))
        if self.StatusBar then
            self.StatusBar:SetValue(1)
        end
    else
        local XP = UnitXP('player')
        local XPMax = UnitXPMax('player')
        local rest = GetXPExhaustion()
        local ratio = XP/XPMax
        local colorIdx =  floor(ratio / 0.25)
        local color = colors[colorIdx]

        self.Text:SetText(format('%d / %d - |c%s%.f / %.f|r (%.f)', level, maxLevel, color, XP, XPMax, rest))
        if self.StatusBar then
            self.StatusBar:SetValue(XP / XPMax)
        end
    end
end

local function enable(self)
    self:SetSize(250, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetTexture([[interface/icons/xp_icon]])
    self.Icon:SetPoint('LEFT', 1, 0)

    if self.Text then
        self.Text:SetPoint('TOPLEFT', self.Icon, 'TOPRIGHT', 2, 0)
        self.Text:SetJustifyH('LEFT')
    end

    if self.StatusBar then
        self.StatusBar:SetOrientation('HORIZONTAL')
        self.StatusBar:SetPoint('BOTTOMLEFT', self.Icon, 'BOTTOMRIGHT', 2, 0)
        self.StatusBar:SetPoint('RIGHT', self, 'RIGHT')
        self.StatusBar:SetHeight(self:GetHeight() * 0.2)
        self.StatusBar:SetMinMaxValues(0, 1)
    end

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_LEVEL_UP')
    self:RegisterEvent('PLAYER_XP_UPDATE')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('PLAYER_LEVEL_UP')
    self:UnregisterEvent('PLAYER_XP_UPDATE')
end

DataFrames:RegisterElement('xp', enable, disable, update)
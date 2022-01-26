local select = select
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local C_WeeklyRewards=C_WeeklyRewards
local unpack = unpack
local UIParentLoadAddOn = UIParentLoadAddOn
local _G=_G
local format = format
local HideUIPanel=HideUIPanel
local ShowUIPanel=ShowUIPanel
local GetClassColor = GetClassColor

local colors = {
    [0] = select(4, GetClassColor('DEATHKNIGHT')),
    [1] = select(4, GetClassColor('DRUID') ),
    [2] = select(4, GetClassColor('ROGUE') ),
    [3] = select(4, GetClassColor('MONK') ),
}

local function formatQty(qty)
    local color = colors[qty]

    return format('|c%s%d|r', color, qty)
end

local function update(self, _)

    local canClaimRewards = C_WeeklyRewards.CanClaimRewards()

    if canClaimRewards then
        --update text color to be more visible like YELLOW
        self.Text:SetTextColor(1,1,0)
    else
        self.Text:SetTextColor(1,1,1)
    end

    local activities = C_WeeklyRewards.GetActivities()

    local txt = { 0,0,0 }
    if #activities > 0 then
        for i= 1, 3 do
            if activities[i].progress >= activities[i].threshold then
                txt[1] = txt[1] + 1
            end
            if activities[i+3].progress >= activities[i+3].threshold then
                txt[2] = txt[2] + 1
            end
            if activities[i+6].progress >= activities[i+6].threshold then
                txt[3] = txt[3] + 1
            end
        end
    end

    self.Text:SetText(format('%s/%s/%s', formatQty(txt[1]), formatQty(txt[2]), formatQty(txt[3])))

end

local function enable(self)

    UIParentLoadAddOn('Blizzard_WeeklyRewards')

    self:SetSize(64, 30)
    self.Icon:SetSize(25,25)

    self.Icon:SetTexture([[INTERFACE\ICONS\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('INSTANCE_ENCOUNTER_OBJECTIVE_COMPLETE')
    self:RegisterEvent('BOSS_KILL')

    self:RegisterForClicks('AnyUp')
    self:SetScript('OnClick', function(btn)
        local frame = _G['WeeklyRewardsFrame']
        if frame:IsShown() then
            HideUIPanel(frame)
            btn.Icon:SetDesaturated(true)
        else
            ShowUIPanel(frame)
            btn.Icon:SetDesaturated(false)
        end
    end)

    _G['WeeklyRewardsFrame']:HookScript('OnHide', function()
        self.Icon:SetDesaturated(true)
    end)

    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:RegisterEvent('BOSS_KILL')
    self:RegisterEvent('INSTANCE_ENCOUNTER_OBJECTIVE_COMPLETE')
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

DataFrames:RegisterElement('vault', enable, disable, update)
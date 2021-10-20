local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local C_WeeklyRewards=C_WeeklyRewards
local unpack = unpack
local UIParentLoadAddOn = UIParentLoadAddOn
local _G=_G
local format = format
local HideUIPanel=HideUIPanel
local ShowUIPanel=ShowUIPanel

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
            if #activities[i].rewards > 0 then
                txt[1] = txt[1] + 1
            end
            if #activities[i+3].rewards > 0 then
                txt[2] = txt[2] + 1
            end
            if #activities[i+6].rewards > 0 then
                txt[3] = txt[3] + 1
            end
        end
    end
    self.Text:SetText(format('%d/%d/%d', unpack(txt)))

end

local function enable(self)

    UIParentLoadAddOn('Blizzard_WeeklyRewards')

    self.Icon:SetTexture([[INTERFACE\ICONS\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT')

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

    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:RegisterEvent('BOSS_KILL')
    self:RegisterEvent('INSTANCE_ENCOUNTER_OBJECTIVE_COMPLETE')
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

DataFrames:RegisterElement('vault', enable, disable, update)
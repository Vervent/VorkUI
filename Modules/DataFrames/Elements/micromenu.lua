local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local _G = _G
local HideUIPanel = HideUIPanel
local ShowUIPanel = ShowUIPanel
local PVEFrame_ShowFrame = PVEFrame_ShowFrame
local StoreFrame_IsShown = StoreFrame_IsShown
local StoreFrame_SetShown = StoreFrame_SetShown
local UIParentLoadAddOn = UIParentLoadAddOn
local CreateFrame = CreateFrame
local ipairs = ipairs

local function click(btn, frameName)
    local frame = _G[frameName]
    if frame:IsShown() then
        HideUIPanel(frame)
        btn.Icon:SetDesaturated(false)
        --currentSelection = nil
    else
        ShowUIPanel(frame)
        btn.Icon:SetDesaturated(true)
        --currentSelection = btn
    end
end

local menus = {
    {
        Path = [[INTERFACE/ICONS/INV_MISC_GROUPLOOKING]],
        Name = 'CharacterFrame',
        OnClick = function(btn)
           click(btn, 'CharacterFrame')
        end
    }, --paperdoll
    {
        Path = [[INTERFACE/ICONS/INV_MISC_BOOK_11]],
        Name = 'SpellBookFrame',
        OnClick = function(btn)
            click(btn, 'SpellBookFrame')
        end
    }, --spellbook
    {
        Path = [[INTERFACE/ICONS/INV_7XP_INSCRIPTION_TALENTTOME01]],
        Name = 'PlayerTalentFrame',
        OnClick = function(btn)
            click(btn, 'PlayerTalentFrame')
        end
    }, --talent
    {
        Path = [[INTERFACE/ICONS/ACHIEVEMENT_QUESTS_COMPLETED_08]],
        Name = 'AchievementFrame',
        OnClick = function(btn)
            click(btn, 'AchievementFrame')
        end
    }, --achievement
    {
        Path = [[INTERFACE/ICONS/INV_MISC_NOTEFOLDED2A]],
        Name = 'WorldMapFrame',
        OnClick = function(btn)
            click(btn, 'WorldMapFrame')
        end
    }, --quest
    {
        Path = [[INTERFACE/ICONS/RAF-ICON]],
        Name = 'FriendsFrame',
        OnClick = function(btn)
            click(btn, 'FriendsFrame')
        end
    }, --social
    {
        Path = [[INTERFACE/ICONS/ACHIEVEMENT_GUILDPERK_EVERYBODYSFRIEND]],
        Name = 'CommunitiesFrame',
        OnClick = function(btn)
            click(btn, 'CommunitiesFrame')
        end
    }, --guild
    {
        --Path = [[INTERFACE/ICONS/INV_MISC_grouplooking]],
        Path = [[INTERFACE/ICONS/LEVELUPICON-LFD]],
        Name = 'PVEFrame',
        OnClick = function(btn)
            local frame = _G['PVEFrame']
            if frame:IsShown() then
                HideUIPanel(frame)
                btn.Icon:SetDesaturated(false)
            else
                btn.Icon:SetDesaturated(true)
                PVEFrame_ShowFrame()
            end
        end
    }, --finder
    {
        Path = [[INTERFACE/ICONS/INV_MISC_BOOK_02]],
        Name = 'EncounterJournal',
        OnClick = function(btn)
            click(btn, 'EncounterJournal')
        end
    }, --adventure
    {
        Path = [[INTERFACE/ICONS/ACHIEVEMENT_GUILDPERK_MOUNTUP]],
        Name = 'CollectionsJournal',
        OnClick = function(btn)
            click(btn, 'CollectionsJournal')
        end
    }, --collection
    {
        Path = [[INTERFACE/ICONS/INV_MISC_QUESTIONMARK]],
        Name = 'GameMenuFrame',
        OnClick = function(btn)
            click(btn, 'GameMenuFrame')
        end
    }, --mainmenu
    {
        Path = [[INTERFACE/ICONS/WOW_STORE]],
        Name = 'StoreFrame',
        OnClick = function(btn)
            if StoreFrame_IsShown() then
                btn.Icon:SetDesaturated(false)
                StoreFrame_SetShown(false)
            else
                btn.Icon:SetDesaturated(true)
                StoreFrame_SetShown(true)
                btn:SetScript('OnUpdate', function()
                    if not StoreFrame_IsShown() then
                        btn.Icon:SetDesaturated(false)
                        btn:SetScript('OnUpdate', nil)
                    end
                end)
            end
        end
    }, --shop
}

local function update(self, event)

    --local _, stat = unpack(event)
    --local _, max = unpack(DataFrames.LibUnitStat:GetStat(stat))
    --
    --if self.Text then
    --    self.Text:SetText(BreakUpLargeNumbers(max))
    --end

end

local function enable(self)
    self:SetSize(30, 313)

    UIParentLoadAddOn("Blizzard_Communities")
    UIParentLoadAddOn("Blizzard_Collections")
    UIParentLoadAddOn("Blizzard_EncounterJournal")
    UIParentLoadAddOn("Blizzard_GuildUI")
    UIParentLoadAddOn("Blizzard_TalentUI")
    UIParentLoadAddOn("Blizzard_AchievementUI")
    UIParentLoadAddOn("Blizzard_StoreUI")

    if self.Buttons == nil then
        self.Buttons = {}
        local btn
        local parent = self
        for i, item in ipairs(menus) do
            btn = CreateFrame('Button', 'MicroMenuButton'..item.Name, self)
            btn:SetSize(25, 25)
            --setOrientedPoint(btn, parent, i==1, 'VERTICAL')
            btn:OrientedSetPoint(parent, i==1, 'UP')
            parent = btn
            --if i == 1 then
            --    btn:SetPoint('LEFT', self, 'LEFT', 1, 0)
            --else
            --    btn:SetPoint('LEFT', self.Buttons[i-1], 'RIGHT', 1, 0)
            --end

            btn.Icon = btn:CreateTexture('OVERLAY')
            btn.Icon:SetAllPoints()
            btn.Icon:SetTexture(item.Path)
            btn.Icon:SetDesaturated(false)

            btn:SetID(i)

            btn:RegisterForClicks('AnyUp')
            btn:SetScript('OnClick', item.OnClick)
            if i < #menus then
                _G[item.Name]:HookScript('OnHide', function()
                    self.Buttons[i].Icon:SetDesaturated(false)
                end)
            end

            tinsert(self.Buttons, btn)
        end
    else
        for i, btn in ipairs(self.Buttons) do
            btn:Show()
        end
    end

end

local function disable(self)
    for i, btn in ipairs(self.Buttons) do
        btn:Hide()
    end
end

DataFrames:RegisterElement('micromenu', enable, disable, update)
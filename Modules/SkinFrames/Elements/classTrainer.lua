local select = select
local ipairs = ipairs
local _G = _G

local V, C, L = select(2, ...):unpack()

local Module = V.Module
local SkinFrames = Module:GetModule('SkinFrames')

--we need to force loading otherwise frame is nil
UIParentLoadAddOn('Blizzard_TrainerUI')
local frame = _G['ClassTrainerFrame']

CLASS_TRAINER_SKILL_BARBUTTON_WIDTH = frame:GetWidth()-20

local function skinButton(self)
    local disabledBG = self.disabledBG
    self:SetNormalTexture('')
end

local function skinFilter(self)
    if self.Left then
        self.Left:SetAlpha(0)
    end
    if self.Middle then
        self.Middle:SetAlpha(0)
    end
    if self.Right then
        self.Right:SetAlpha(0)
    end

    self:ClearAllPoints()
    self:SetPoint('TOPRIGHT', -8, -30)
    self:SetHeight(25)

    self.Text:ClearAllPoints()
    self.Text:SetPoint('RIGHT', self.Button, 'LEFT', -2, 0)
    self.Text:SetPoint('LEFT', self, 'LEFT', 2, 0)

    self.Button:ClearAllPoints()
    self.Button:SetPoint('RIGHT', -2, 0)
    self.Background = self:CreateBackground({ 0.2, 0.4, 0.6, 0.5 })
    self:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    self:HookScript("OnEnter", function()
        if not self.Background then
            return
        end

        local Class = select(2, UnitClass("player"))
        local r, g, b = GetClassColor(Class)

        self.Background:SetColorTexture(r * .2, g * .2, b * .2)
        self:SetBorderColor({ r, g, b })
    end)

    self:HookScript("OnLeave", function()
        self.Background:SetColorTexture(0.2, 0.4, 0.6, 0.5)
        self:SetBorderColor({ 0.2, 0.4, 0.6, 0.75 })
    end)

    self:HookScript('OnShow', function(...)
        UIDropDownMenu_SetWidth(self, 80)
    end)
end

local function skinStatusBar()
    local statusBar = _G['ClassTrainerStatusBar']
    local n = statusBar:GetName()

    _G[n..'Left']:SetAlpha(0)
    _G[n..'Right']:SetAlpha(0)
    _G[n..'Middle']:SetAlpha(0)

    statusBar:ClearAllPoints()
    statusBar:SetPoint('TOPLEFT', frame.TitleText, 'BOTTOMLEFT', 0, -2)

    statusBar:CreateBorder(1, {0.2, 0.4, 0.6, 0.75})
end

local function skinScrollFrame(scroll)
    local scrollChild = scroll.scrollChild
    local scrollBar = scroll.scrollBar

    scrollChild:SetWidth(CLASS_TRAINER_SKILL_BARBUTTON_WIDTH)

    for _, b in ipairs({scrollChild:GetChildren()}) do
        skinButton(b)
    end
    scrollBar:SetAlpha(0)
end

local function skinFrame()
    local name = frame:GetName()

    local titleText = frame.TitleText
    local scroll = _G['ClassTrainerScrollFrame']

    frame.Bg:SetAlpha(0)
    frame.BG:SetAlpha(0)
    frame.Inset:SetAlpha(0)
    frame.bottomInset:SetAlpha(0)
    frame.NineSlice:SetAlpha(0)
    frame.TitleBg:SetAlpha(0)
    frame.TopTileStreaks:SetAlpha(0)

    titleText:ClearAllPoints()
    titleText:SetPoint('TOPLEFT', frame.portrait, 'TOPRIGHT', 2, 0)
    titleText:SetWidth(frame:GetWidth()-100)
    titleText:SetJustifyH('LEFT')

    frame.portrait:SetSize(40, 40)
    frame.portrait:ClearAllPoints()
    frame.portrait:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)

    frame.Background = frame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    frame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    skinStatusBar()
    skinFilter(_G['ClassTrainerFrameFilterDropDown'])

    _G['ClassTrainerFrameMoneyBg']:Kill()
    skinButton(_G['ClassTrainerFrameSkillStepButton'])
    skinScrollFrame(scroll)

    local spacer = frame:CreateTexture(nil, 'BACKGROUND', nil, 2)
    spacer:SetSize(frame:GetWidth()-10, 1)
    spacer:SetColorTexture(0.2, 0.4, 0.6, 1)
    spacer:SetPoint('BOTTOM', scroll, 'TOP', 0, 2)

    frame.Spacer = spacer
end

local function enable()
    skinFrame()
end

local function disable()

end

SkinFrames:RegisterSkin(frame, enable, disable)
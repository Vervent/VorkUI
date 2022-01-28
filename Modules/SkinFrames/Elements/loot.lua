local select = select
local _G = _G

local V, C, L = select(2, ...):unpack()

local LibSlant = LibStub:GetLibrary("LibSlant")
local Module = V.Module
local Medias = Module:GetModule('Medias')
local SkinFrames = Module:GetModule('SkinFrames')

local frame = _G['LootFrame']
local LOOTFRAME_NUMBUTTONS = LOOTFRAME_NUMBUTTONS

LOOTFRAME_AUTOLOOT_DELAY = 0

local function skinButton(self)
    local iconBorder = self.IconBorder
    local count = self.Count
    local icon = self.icon
    local name = self:GetName()
    local nameFrame = _G[name..'NameFrame']
    local textureBorder = _G[name..'NormalTexture']
    local text = _G[name..'Text']

    local w = frame:GetWidth()-icon:GetWidth() - 60

    iconBorder:SetAlpha(0)
    nameFrame:Kill()
    textureBorder:Kill()
    text:SetWidth( w )
    text:SetHeight(24)

    self:SetSize(24, 24)
    self:SetNormalTexture('')

    self.Slant = LibSlant:CreateSlant(self)
    self.Quality = self.Slant:AddTexture('BACKGROUND', 2)
    self.Quality:SetSize(w, 4)
    self.Quality:SetPoint('BOTTOMLEFT', self, 'BOTTOMRIGHT')
    self.Quality:SetTexture(Medias:GetStatusBar('VorkuiBackground'))
    self.Quality:SetColorTexture(0.2, 0.4, 0.6, 0.25)
    self.Slant:CalculateAutomaticSlant()
    self.Slant:StaticSlant('BACKGROUND')

    self.Text = text

    Module:GetModule('DebugFrames'):Log(self)
end

local function updateButton(index)
    local button = _G["LootButton"..index]
    local quality = button.quality

    local r, g, b, a = 0.2, 0.4, 0.6, 0.75
    if quality then
        r, g, b = ITEM_QUALITY_COLORS[quality].r, ITEM_QUALITY_COLORS[quality].g, ITEM_QUALITY_COLORS[quality].b
        button.Quality:SetColorTexture(r, g, b, 1)
    else
        button.Quality:SetColorTexture(r, g, b, a)
    end
    button.Text:SetTextColor(1, 1, 1)
end

local function skinFrame()
    local name = frame:GetName()

    local titleText = frame.TitleText

    frame:SetWidth(300)

    frame.Bg:SetAlpha(0)
    frame.Inset:SetAlpha(0)
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

    local btn
    local p = frame
    for i=1, LOOTFRAME_NUMBUTTONS do
        btn = _G['LootButton'..i]
        skinButton(btn)
        btn:ClearAllPoints()
        if i == 1 then
            btn:SetPoint('TOPLEFT', p, 'TOPLEFT', 9, -60)
        else
            btn:SetPoint('TOPLEFT', p, 'BOTTOMLEFT', 0, -4)
        end
        p = btn
    end

    frame.Background = frame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    frame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

end

local function show()
    if GetCVar("lootUnderMouse") ~= "1" then
        frame:ClearAllPoints()
        frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 300, -300)
    end
end

local function createButton(count)
    local btn
    for i=1, count do
        btn = CreateFrame('ItemButton', 'LootButton'..LOOTFRAME_NUMBUTTONS+1, frame, 'LootButtonTemplate')
        btn:SetID(LOOTFRAME_NUMBUTTONS + 1)
        btn:Hide()
        LOOTFRAME_NUMBUTTONS = LOOTFRAME_NUMBUTTONS + 1
    end
end

local function enable()
    createButton(2)
    skinFrame()

    hooksecurefunc('LootFrame_UpdateButton', updateButton)
    hooksecurefunc('LootFrame_Show', show)
end

local function disable()

end

SkinFrames:RegisterSkin(frame, enable, disable)
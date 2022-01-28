local select = select
local hooksecurefunc = hooksecurefunc

local V, C, L = select(2, ...):unpack()

local LibSlant = LibStub:GetLibrary("LibSlant")
local Module = V.Module
local Medias = Module:GetModule('Medias')
local SkinFrames = Module:GetModule('SkinFrames')

local _G = _G

local BUYBACK_ITEMS_PER_PAGE = BUYBACK_ITEMS_PER_PAGE
local UnitClass = UnitClass
local GetClassColor = GetClassColor
local CanMerchantRepair = CanMerchantRepair
local CanGuildBankRepair = CanGuildBankRepair
local MerchantFrame_UpdateCanRepairAll = MerchantFrame_UpdateCanRepairAll
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS

local frame = _G['MerchantFrame']

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
    self.Text:SetWidth(200)
    self.Text:ClearAllPoints()
    self.Text:SetPoint('RIGHT', self.Button, 'LEFT', -2, 0)
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
end

local function skinTab(self)
    local name = self:GetName()
    local left = _G[name .. 'Left']
    local leftDisabled = _G[name .. 'LeftDisabled']
    local right = _G[name .. 'Right']
    local rightDisabled = _G[name .. 'RightDisabled']
    local middle = _G[name .. 'Middle']
    local middleDisabled = _G[name .. 'MiddleDisabled']

    left:SetAlpha(0)
    leftDisabled:SetAlpha(0)
    right:SetAlpha(0)
    rightDisabled:SetAlpha(0)
    middle:SetAlpha(0)
    middleDisabled:SetAlpha(0)

    self.Background = self:CreateBackground()
    self:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    hooksecurefunc(self, 'Enable', function(tab)
        tab.Background:SetColorTexture(0.1, 0.1, 0.1, 0.85)
    end)

    hooksecurefunc(self, 'Disable', function(tab)
        tab.Background:SetColorTexture(0.2, 0.4, 0.6, 0.85)
    end)
end

local function skinButton(item)
    local nameFrame, slotTexture, btn, name, moneyFrame, altCurrency

    item:SetSize(item:GetParent():GetWidth() - 22, 24)

    item.Slant = LibSlant:CreateSlant(item)
    item.Quality = item.Slant:AddTexture('BACKGROUND')
    item.Quality:SetSize(item:GetWidth() - 4, 4)
    item.Quality:SetPoint('BOTTOM')
    item.Quality:SetTexture(Medias:GetStatusBar('VorkuiBackground'))
    item.Quality:SetColorTexture(0.2, 0.4, 0.6, 0.25)
    item.Slant:CalculateAutomaticSlant()
    item.Slant:StaticSlant('BACKGROUND')

    nameFrame = _G[item:GetName() .. 'NameFrame']
    slotTexture = _G[item:GetName() .. 'SlotTexture']
    moneyFrame = _G[item:GetName() .. 'MoneyFrame']
    altCurrency = _G[item:GetName() .. 'AltCurrencyFrame']

    if nameFrame then
        nameFrame:SetAlpha(0)
    end
    if slotTexture then
        slotTexture:SetAlpha(0)
    end
    if moneyFrame then
        moneyFrame:ClearAllPoints()
        moneyFrame:SetPoint('RIGHT', item, 'RIGHT', -2, 0)
    end
    if altCurrency then
        altCurrency:ClearAllPoints()
        altCurrency:SetPoint('RIGHT', item, 'RIGHT', -2, 0)
        local altCurrencyFrameItem1 = _G[item:GetName() .. 'AltCurrencyFrameItem1']
        local altCurrencyFrameItem2 = _G[item:GetName() .. 'AltCurrencyFrameItem2']
        local altCurrencyFrameItem3 = _G[item:GetName() .. 'AltCurrencyFrameItem3']
        altCurrencyFrameItem1:ClearAllPoints()
        altCurrencyFrameItem1:SetPoint('RIGHT', altCurrency, 'RIGHT', -12, 0)
        altCurrencyFrameItem2:ClearAllPoints()
        altCurrencyFrameItem2:SetPoint('RIGHT', altCurrencyFrameItem1, 'LEFT', -12, 0)
        altCurrencyFrameItem3:ClearAllPoints()
        altCurrencyFrameItem3:SetPoint('RIGHT', altCurrencyFrameItem2, 'LEFT', -12, 0)
    end

    btn = item.ItemButton
    if btn then
        btn.IconBorder:SetAlpha(0)
        btn:ClearAllPoints()
        btn:SetPoint('TOPLEFT', 2, -2)
        btn:SetSize(24, 24)
        btn:SetNormalTexture('')
        btn:SetPushedTexture('')
    end

    name = item.Name
    if name then
        name:ClearAllPoints()
        name:SetPoint('TOPLEFT', btn, 'TOPRIGHT', 2, 0)
        name:SetPoint('TOPRIGHT', moneyFrame, 'TOPLEFT', -2, 0)
        name:SetJustifyV('TOP')
    end
end

local function skinFrame()
    local name = frame:GetName()

    local merchantNameText = _G['MerchantNameText']
    local frameTab1 = _G[name .. 'Tab1']
    local frameTab2 = _G[name .. 'Tab2']
    local prevButton = _G['MerchantPrevPageButton']
    local nextButton = _G['MerchantNextPageButton']
    local buyBackBG = _G.BuybackBG
    local buyBackItem = _G['MerchantBuyBackItem']
    local merchantPageText = _G['MerchantPageText']

    buyBackBG:SetAlpha(0)
    frame.TitleBg:SetAlpha(0)
    frame.TopTileStreaks:SetAlpha(0)
    frame.Bg:SetAlpha(0)
    _G[name .. 'BottomLeftBorder']:SetAlpha(0)
    _G[name .. 'BottomRightBorder']:SetAlpha(0)
    frame.NineSlice:SetAlpha(0)
    frame.Inset:SetAlpha(0)

    frame.Background = frame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    frame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    local item, slotTexture
    local lastItem
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        item = _G['MerchantItem' .. i]
        skinButton(item)
        if i > 1 then
            item:ClearAllPoints()
            item:SetPoint('TOPLEFT', lastItem, 'BOTTOMLEFT', 0, -6)
        end
        lastItem = item
    end

    --remove background
    prevButton:ClearAllPoints()
    prevButton:SetPoint('CENTER', frame, 'BOTTOMLEFT', 25, 60)
    local r = select(2, prevButton:GetRegions())
    r:SetAlpha(0)

    nextButton:ClearAllPoints()
    nextButton:SetPoint('CENTER', frame, 'BOTTOMRIGHT', -25, 60)
    r = select(2, nextButton:GetRegions())
    r:SetAlpha(0)
    skinFilter(frame.lootFilter)

    merchantPageText:ClearAllPoints()
    merchantPageText:SetPoint('CENTER', frame, 'BOTTOM', 0, 60)

    merchantNameText:ClearAllPoints()
    merchantNameText:SetPoint('TOPLEFT', frame.portrait, 'TOPRIGHT', 2, 0)

    frame.portrait:SetSize(40, 40)
    frame.portrait:ClearAllPoints()
    frame.portrait:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)

    skinTab(frameTab1)
    frameTab1:ClearAllPoints()
    frameTab1:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT')
    skinTab(frameTab2)
    frameTab2:ClearAllPoints()
    frameTab2:SetPoint('LEFT', frameTab1, 'RIGHT', 2, 0)

    skinButton(buyBackItem)
    buyBackItem:ClearAllPoints()
    buyBackItem:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 11, 25)

    _G['MerchantMoneyBg']:SetAlpha(0)
    _G['MerchantMoneyInset']:SetAlpha(0)
    _G['MerchantExtraCurrencyBg']:SetAlpha(0)
    _G['MerchantExtraCurrencyInset']:SetAlpha(0)
    local repairText = _G['MerchantRepairText']
    repairText:ClearAllPoints()
    repairText:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', 4, 8)
    repairText:Show()

    lastItem = repairText
    item = _G['MerchantRepairItemButton']
    item:ClearAllPoints()
    item:SetPoint('LEFT', lastItem, 'RIGHT', 4, 0)
    item:SetSize(20, 20)
    slotTexture = item:GetRegions()
    slotTexture:SetTexCoord(0.02, 0.26, 0.08, 0.5225)
    lastItem = item

    item = _G['MerchantRepairAllButton']
    item:ClearAllPoints()
    item:SetPoint('LEFT', lastItem, 'RIGHT', 4, 0)
    item:SetSize(20, 20)
    slotTexture = item:GetRegions()
    slotTexture:SetTexCoord(0.5825, 0.82, 0.08, 0.5225)
    lastItem = item

    item = _G['MerchantGuildBankRepairButton']
    item:ClearAllPoints()
    item:SetPoint('LEFT', lastItem, 'RIGHT', 4, 0)
    item:SetSize(20, 20)
    slotTexture = item:GetRegions()
    slotTexture:SetTexCoord(0.5825, 0.82, 0.08, 0.5225)

end

local function updateRepair()
    local text = _G['MerchantRepairText']
    local repairBtn = _G['MerchantRepairItemButton']
    local repairAllBtn = _G['MerchantRepairAllButton']
    local repairGuildBankBtn = _G['MerchantGuildBankRepairButton']

    if (CanMerchantRepair()) then
        text:Show()
        repairBtn:Show()
        repairAllBtn:Show()
        if ( CanGuildBankRepair() ) then
            repairGuildBankBtn:Show()
        end
        MerchantFrame_UpdateCanRepairAll();
    else
        text:Hide()
        repairBtn:Hide()
        repairAllBtn:Hide()
        repairGuildBankBtn:Hide()
    end
end

local function resetBorderColor(btn)
    btn.Quality:SetColorTexture(0.2, 0.4, 0.6, 0.75)
end

local function updateQuality(self, link, isBound)
    local quality = link and select(3, GetItemInfo(link)) or nil;

    local r, g, b, a = 0.2, 0.4, 0.6, 0.75
    if quality then
        r, g, b = ITEM_QUALITY_COLORS[quality].r, ITEM_QUALITY_COLORS[quality].g, ITEM_QUALITY_COLORS[quality].b
        self.Quality:SetColorTexture(r, g, b, 1)
    else
        self.Quality:SetColorTexture(r, g, b, a)
    end

    self.Name:SetTextColor(1, 1, 1)
end

local function updateMerchantInfo()

    local item, altCurrency
    local lastButton
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        item = _G['MerchantItem' .. i]
        altCurrency = _G['MerchantItem' .. i .. 'AltCurrencyFrame']
        altCurrency:ClearAllPoints()
        altCurrency:SetPoint('RIGHT', item, 'RIGHT', -2, 0)
        if item.ItemButton.hasItem then
            updateQuality(item, item.ItemButton.link)
        else
            resetBorderColor(item)
        end

        if i > 1 and i % 2 == 1 then
            item:ClearAllPoints()
            item:SetPoint('TOPLEFT', lastButton, 'BOTTOMLEFT', 0, -6)
        end
        lastButton = item

    end
end

local function updateBuybackInfo()
    local item, altCurrency
    local lastButton
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        item = _G['MerchantItem' .. i]
        altCurrency = _G['MerchantItem' .. i .. 'AltCurrencyFrame']
        altCurrency:ClearAllPoints()
        altCurrency:SetPoint('RIGHT', item, 'RIGHT', -2, 0)
        if item.ItemButton.hasItem then
            updateQuality(item, GetBuybackItemLink(i))
        else
            resetBorderColor(item)
        end

        if i > 1 and i % 2 == 1 then
            item:ClearAllPoints()
            item:SetPoint('TOPLEFT', lastButton, 'BOTTOMLEFT', 0, -6)
        end
        lastButton = item

    end
end

local function enable()

    hooksecurefunc('MerchantFrameItem_UpdateQuality', updateQuality)
    hooksecurefunc('MerchantFrame_UpdateMerchantInfo', updateMerchantInfo)
    hooksecurefunc('MerchantFrame_UpdateBuybackInfo', updateBuybackInfo)

    MerchantFrame_UpdateRepairButtons = updateRepair
    skinFrame()

end

local function disable()
    --TODO
end

SkinFrames:RegisterSkin(frame, enable, disable)
local select = select
local type = type
local floor = floor
local format = format

local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Merchant = V['Merchant']
local DebugFrames = V['DebugFrames']

local AutoSellJunk = true
local AutoRepair = true
local Skin = false

local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemID = GetContainerItemID
local GetItemInfo = GetItemInfo
local GetContainerItemInfo = GetContainerItemInfo
local GetRepairAllCost = GetRepairAllCost
local RepairAllItems = RepairAllItems
local CanMerchantRepair = CanMerchantRepair
local UseContainerItem = UseContainerItem
local PickupMerchantItem = PickupMerchantItem
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local IsAltKeyDown = IsAltKeyDown
local GetMerchantItemLink = GetMerchantItemLink
local BuyMerchantItem = BuyMerchantItem
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local BlizzardMerchantClick = BlizzardMerchantClick
local MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local GENERIC_MONEY_GAINED_RECEIPT = GENERIC_MONEY_GAINED_RECEIPT
local REPAIR_COST = REPAIR_COST
local ERR_NOT_ENOUGH_MONEY = ERR_NOT_ENOUGH_MONEY
local BUYBACK_ITEMS_PER_PAGE = BUYBACK_ITEMS_PER_PAGE

local copperIcon = [[interface/icons/inv_misc_coin_05]]
local silverIcon = [[interface/icons/inv_misc_coin_03]]
local goldIcon = [[interface/icons/inv_misc_coin_01]]

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
        --tab:SetWidth(50)
    end)

    hooksecurefunc(self, 'Disable', function(tab)
        tab.Background:SetColorTexture(0.2, 0.4, 0.6, 0.85)
        --tab:SetWidth(50)
    end)
end

local function skinButton(item)
    local nameFrame, slotTexture, btn, name, moneyFrame, altCurrency

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
        moneyFrame:SetPoint('BOTTOMLEFT', item, 'BOTTOMLEFT', 2, 2)
    end
    if altCurrency then
        altCurrency:ClearAllPoints()
        altCurrency:SetPoint('BOTTOMLEFT', item, 'BOTTOMLEFT', 2, 2)
    end

    item.Background = item:CreateBackground({ 0.2, 0.4, 0.6, 0.25 })
    item:CreateBorder(1)

    btn = item.ItemButton
    if btn then
        btn.IconBorder:SetAlpha(0)
        btn:ClearAllPoints()
        btn:SetPoint('TOPLEFT', 2, -2)
        btn:SetSize(24, 24)
        btn:SetNormalTexture('')
        btn:SetPushedTexture('')

        --btn.Count:SetFontObject('Number12Font_o1')
    end

    name = item.Name
    if name then
        name:ClearAllPoints()
        name:SetPoint('TOPLEFT', btn, 'TOPRIGHT', 2, 0)
        name:SetPoint('TOPRIGHT', item, 'TOPRIGHT', -2, 0)
    end
end

local function skinFrame()
    local str = 'MerchantFrame'
    local frame = _G[str]

    local merchantNameText = _G['MerchantNameText']
    local frameTab1 = _G[frame:GetName() .. 'Tab1']
    local frameTab2 = _G[frame:GetName() .. 'Tab2']
    local prevButton = _G['MerchantPrevPageButton']
    local nextButton = _G['MerchantNextPageButton']
    local buyBackBG = _G.BuybackBG
    local buyBackItem = _G['MerchantBuyBackItem']

    buyBackBG:SetAlpha(0)
    frame.TitleBg:SetAlpha(0)
    frame.TopTileStreaks:SetAlpha(0)
    frame.Bg:SetAlpha(0)
    _G[str .. 'BottomLeftBorder']:SetAlpha(0)
    _G[str .. 'BottomRightBorder']:SetAlpha(0)
    frame.NineSlice:SetAlpha(0)
    frame.Inset:SetAlpha(0)

    frame.Background = frame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    frame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    local item, nameFrame, slotTexture, btn, name, moneyFrame, altCurrency
    local itemWidth = frame:GetWidth() - 20
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        item = _G['MerchantItem' .. i]
        skinButton(item)
    end
    --remove background
    local r = select(2, prevButton:GetRegions())
    r:SetAlpha(0)
    r = select(2, nextButton:GetRegions())
    r:SetAlpha(0)
    skinFilter(frame.lootFilter)

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

    _G['MerchantMoneyBg']:SetAlpha(0)
    _G['MerchantMoneyInset']:SetAlpha(0)
    _G['MerchantExtraCurrencyBg']:SetAlpha(0)
    _G['MerchantExtraCurrencyInset']:SetAlpha(0)
    local repairIcon = _G['MerchantRepairItemButton']:GetRegions()
    repairIcon:SetTexCoord(0.02, 0.26, 0.08, 0.5225)
    repairIcon = _G['MerchantRepairAllButton']:GetRegions()
    repairIcon:SetTexCoord(0.5825, 0.82, 0.08, 0.5225)
    repairIcon = _G['MerchantGuildBankRepairButton']:GetRegions()
    repairIcon:SetTexCoord(0.5825, 0.82, 0.08, 0.5225)
end

local function resetBorderColor(btn)
    btn:SetBorderColor({ 0.2, 0.4, 0.6, 0.75 })
end

local function resetAllBorderColors()
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        --_G['MerchantItem' .. i]:SetBorderColor({ 0.2, 0.4, 0.6, 0.75 })
        resetBorderColor(_G['MerchantItem' .. i])
    end
end

local function updateFrame()
    if _G['MerchantFrame'].selectedTab ~= 1 then
        resetAllBorderColors()
    end
end

local function updateQuality(self, link, isBound)
    local quality = link and select(3, GetItemInfo(link)) or nil;

    local r, g, b, a = 0.2, 0.4, 0.6, 0.75
    if quality then
        r, g, b = ITEM_QUALITY_COLORS[quality].r, ITEM_QUALITY_COLORS[quality].g, ITEM_QUALITY_COLORS[quality].b
        self:SetBorderColor({ r, g, b, 1 })
    else
        self:SetBorderColor({ r, g, b, a })
    end
end

local function updateMerchantInfo()

    local item, altCurrency
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        item = _G['MerchantItem' .. i]
        altCurrency = _G['MerchantItem' .. i .. 'AltCurrencyFrame']
        altCurrency:ClearAllPoints()
        altCurrency:SetPoint('BOTTOMLEFT', item, 'BOTTOMLEFT', 2, 2)
        if item.ItemButton.hasItem then
            updateQuality(item, item.ItemButton.link)
        else
            resetBorderColor(item)
        end

    end
end

local function formatQTY(money)
    local copper = money % 100
    local silver = floor((money % 10000) / 100)
    local gold = floor(money / 10000)

    if gold > 999999 then
        return format('%.2fm|T%s:0:1|t', gold / 1000000, goldIcon)
    elseif gold > 9999 then
        return format('%.2fk|T%s:0:1|t%.0f|T%s:0:1|t', gold / 1000, goldIcon, silver, silverIcon)
    else
        return format('%.f|T%s:0:1|t%.0f|T%s:0:1|t%.0f|T%s:0:1|t', gold, goldIcon, silver, silverIcon, copper, copperIcon)
    end
end

local function sellJunk()
    local cost = 0

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link, id = GetContainerItemLink(bag, slot), GetContainerItemID(bag, slot)

            if (link and id and type(link) == "string") then
                local price = 0
                local mult1, mult2 = select(11, GetItemInfo(link)), select(2, GetContainerItemInfo(bag, slot))

                if (mult1 and mult2) then
                    price = mult1 * mult2
                end

                if (select(3, GetItemInfo(link)) == 0 and price > 0) then
                    UseContainerItem(bag, slot)
                    PickupMerchantItem()
                    cost = cost + price
                end
            end
        end
    end

    if (cost > 0) then
        --local gold, silver, copper = floor(cost / 10000) or 0, floor((cost % 10000) / 100) or 0, cost % 100

        DEFAULT_CHAT_FRAME:AddMessage(format(GENERIC_MONEY_GAINED_RECEIPT, formatQTY(cost)), 1, 1, 0)
    end
end

local function autoRepair()
    if (CanMerchantRepair()) then
        local cost, possible = GetRepairAllCost()

        if (cost > 0) then
            if possible then
                RepairAllItems()

                DEFAULT_CHAT_FRAME:AddMessage(REPAIR_COST .. formatQTY(cost), 1, 0.5, 0)

                --local Copper = cost % 100
                --local Silver = floor((cost % 10000) / 100)
                --local Gold = floor(cost / 10000)
                --DEFAULT_CHAT_FRAME:AddMessage(L.Merchant.RepairCost.." |cffffffff"..Gold..L.DataText.GoldShort.." |cffffffff"..Silver..L.DataText.SilverShort.." |cffffffff"..Copper..L.DataText.CopperShort..".", 255, 255, 0)
            else
                DEFAULT_CHAT_FRAME:AddMessage(ERR_NOT_ENOUGH_MONEY, 1, 0, 0)
            end
        end
    end
end

local function onEvent(self, event, ...)
    if event == 'MERCHANT_SHOW' then
        if AutoSellJunk then
            sellJunk()
        end

        if AutoRepair then
            autoRepair()
        end
    else
        resetAllBorderColors()
    end
end

local function onClick(self, ...)
    if (IsAltKeyDown()) then
        local MaxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))

        if (MaxStack and MaxStack > 1) then
            BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
        end
    end

    BlizzardMerchantClick(self, ...)
end

function Merchant:Enable()
    self:RegisterEvent('MERCHANT_SHOW')
    self:SetScript('OnEvent', onEvent)

    MerchantItemButton_OnModifiedClick = onClick

    self:EnableMouse(true)

    if Skin then
        self:RegisterEvent('MERCHANT_CLOSED')

        hooksecurefunc('MerchantFrameItem_UpdateQuality', updateQuality)
        hooksecurefunc('MerchantFrame_UpdateMerchantInfo', updateMerchantInfo)
        hooksecurefunc('MerchantFrame_Update', updateFrame)

        skinFrame()
    end
end

function Merchant:Disable()
    self:UnregisterEvent('MERCHANT_SHOW')
    self:SetScript('OnEvent', nil)

    MerchantItemButton_OnModifiedClick = BlizzardMerchantClick

    if Skin then
        self:UnregisterEvent('MERCHANT_CLOSED')

        hooksecurefunc('MerchantFrameItem_UpdateQuality', nil)
        hooksecurefunc('MerchantFrame_UpdateMerchantInfo', nil)
        hooksecurefunc('MerchantFrame_Update', nil)

    end
end
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Bags = V['Bags']

local UIParent = UIParent
local unpack = unpack
local hooksecurefunc = hooksecurefunc
local mpi = math.pi
local select = select
local bit = bit
local CreateFrame = CreateFrame
local GameTooltip_Hide = GameTooltip_Hide
local UnitIsDead = UnitIsDead
local NotWhileDeadError = NotWhileDeadError
local UnitClass = UnitClass
local GetClassColor = GetClassColor
local PlaySound = PlaySound
local SOUNDKIT = SOUNDKIT
local KEYRING_CONTAINER = KEYRING_CONTAINER
local TRANSMOG_SOURCE_2 = TRANSMOG_SOURCE_2
local GetTime = GetTime

local BankFrame = BankFrame
local MerchantFrame = MerchantFrame
local InboxFrame = InboxFrame
local CloseBankBagFrames = CloseBankBagFrames
local CloseBankFrame = CloseBankFrame
local ContainerFrame1Item1 = ContainerFrame1Item1
local ContainerFrame1MoneyFrame = ContainerFrame1MoneyFrame
local ReagentBankFrame = ReagentBankFrame
local BankFrameMoneyFrame = BankFrameMoneyFrame
local BackpackTokenFrameToken1 = BackpackTokenFrameToken1
local BackpackTokenFrameToken2 = BackpackTokenFrameToken2
local BackpackTokenFrameToken3 = BackpackTokenFrameToken3

local C_NewItems = C_NewItems
local LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_ARMOR
local LE_ITEM_CLASS_WEAPON = LE_ITEM_CLASS_WEAPON
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerItemInfo = GetContainerItemInfo
local GetItemInfo = GetItemInfo
local IsCosmeticItem = IsCosmeticItem
local GetItemQualityColor = GetItemQualityColor
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local CloseAllBags = CloseAllBags
local IsBagOpen = IsBagOpen
local CloseBag = CloseBag
local CanOpenPanels = CanOpenPanels
local ContainerFrame_GetOpenFrame = ContainerFrame_GetOpenFrame
local BankFrame_AutoSortButtonOnClick = BankFrame_AutoSortButtonOnClick
local BankFrame_ShowPanel = BankFrame_ShowPanel
local BANK = BANK
local REAGENT_BANK = REAGENT_BANK
local BANK_PANELS = BANK_PANELS
local ReagentBankFrameUnlockInfo = ReagentBankFrameUnlockInfo
local ReagentBankFrameUnlockInfoPurchaseButton = ReagentBankFrameUnlockInfoPurchaseButton
local ReagentBankFrameUnlockInfoText = ReagentBankFrameUnlockInfoText
local BankFramePurchaseInfo = BankFramePurchaseInfo
local BankFrameSlotCost = BankFrameSlotCost
local BankFrameDetailMoneyFrame = BankFrameDetailMoneyFrame
local BankFramePurchaseButton = BankFramePurchaseButton
local BankSlotsFrame = BankSlotsFrame
local InCombatLockdown = InCombatLockdown
local GetContainerItemCooldown = GetContainerItemCooldown
local BackpackTokenFrame_Update = BackpackTokenFrame_Update
local ItemButtonUtil = ItemButtonUtil
local SoulbindViewer = SoulbindViewer
local SetSortBagsRightToLeft = SetSortBagsRightToLeft
local SetInsertItemsLeftToRight = SetInsertItemsLeftToRight
local SortBags = SortBags
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS
local GroupLootContainer = GroupLootContainer

local bagSettings = {
    ['Size'] = { 32, 32 },
    ['Spacing'] = { 2, 2 },
    ['ItemsPerRow'] = 12,
    ['SortingOrder'] = 'Ascending',
    ['GroupingPolicy'] = 'Category',
    ['IdentifyQuestItems'] = true,
    ['FlashNewItems'] = true,
    ['ItemLevel'] = true,
    ['SortToBottom'] = false,
}

local characterBags = {
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
}

local BagProfessions = {
    [8] = "Leatherworking", -- 0x0008
    [16] = "Inscription", -- 0x0010
    [32] = "Herb", -- 0x0020
    [64] = "Enchanting", -- 0x0040
    [128] = "Engineering", -- 0x0080
    [512] = "Gem", -- 0x0200
    [1024] = "Mining", -- 0x0400
    [32768] = "Fishing", -- 0x8000
}
local Bag_Normal = 1
local Bag_SoulShard = 2
local Bag_Profession = 3
local Bag_Quiver = 4
local BAGTYPE_QUIVER = 0x0001 + 0x0002
local BAGTYPE_SOUL = 0x004
local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400

local BagSize = {}

local function getBagType(bag)
    local bagType = select(2, GetContainerNumFreeSlots(bag))
    if bit.band(bagType, BAGTYPE_QUIVER) > 0 then
        return Bag_Quiver
    elseif bit.band(bagType, BAGTYPE_SOUL) > 0 then
        return Bag_SoulShard
    elseif bit.band(bagType, BAGTYPE_PROFESSION) > 0 then
        return Bag_Profession
    end

    return Bag_Normal
end

local function skinButton(self)
    -- Unskin everything
    if self.Left then self.Left:SetAlpha(0) end
    if self.Middle then self.Middle:SetAlpha(0) end
    if self.Right then self.Right:SetAlpha(0) end
    if self.TopLeft then self.TopLeft:SetAlpha(0) end
    if self.TopMiddle then self.TopMiddle:SetAlpha(0) end
    if self.TopRight then self.TopRight:SetAlpha(0) end
    if self.MiddleLeft then self.MiddleLeft:SetAlpha(0) end
    if self.MiddleMiddle then self.MiddleMiddle:SetAlpha(0) end
    if self.MiddleRight then self.MiddleRight:SetAlpha(0) end
    if self.BottomLeft then self.BottomLeft:SetAlpha(0) end
    if self.BottomMiddle then self.BottomMiddle:SetAlpha(0) end
    if self.BottomRight then self.BottomRight:SetAlpha(0) end
    if self.LeftSeparator then self.LeftSeparator:SetAlpha(0) end
    if self.RightSeparator then self.RightSeparator:SetAlpha(0) end
    if self.SetNormalTexture then self:SetNormalTexture("") end
    if self.SetHighlightTexture then self:SetHighlightTexture("") end
    if self.SetPushedTexture then self:SetPushedTexture("") end
    if self.SetDisabledTexture then self:SetDisabledTexture("") end

    self.Background = self:CreateBackground({0.2, 0.4, 0.6, 0.5})
    self:CreateBorder(1, {0.2, 0.4, 0.6, 0.75})

    self:HookScript("OnEnter", function()
        if not self.Background then
            return
        end

        local Class = select(2, UnitClass("player"))
        local r, g, b = GetClassColor(Class)

        self.Background:SetColorTexture(r * .2, g * .2, b * .2)
        self:SetBorderColor({r, g, b})
    end)

    self:HookScript("OnLeave", function()
        self.Background:SetColorTexture(0.2, 0.4, 0.6, 0.5)
        self:SetBorderColor({0.2, 0.4, 0.6, 0.75})
    end)
end

local function skinBagButton(self)
    if self.IsSkinned then
        return
    end

    local Icon = _G[self:GetName().."IconTexture"]
    local Quest = _G[self:GetName().."IconQuestTexture"]
    local Count = _G[self:GetName().."Count"]
    local JunkIcon = self.JunkIcon
    local Border = self.IconBorder
    local BattlePay = self.BattlepayItemTexture

    self:SetFrameLevel(0)

    Border:SetAlpha(0)

    Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) --TODO

    Count:ClearAllPoints()
    Count:SetPoint("BOTTOMRIGHT", 1, 1)
    Count:SetFontObject('GameFontNormal') --TODO

    if Quest then
        Quest:SetAlpha(0)
    end

    if JunkIcon then
        JunkIcon:SetAlpha(0)
    end

    if BattlePay then
        BattlePay:SetAlpha(0)
    end

    self:SetNormalTexture("")
    self:SetPushedTexture("")
    self.Background = self:CreateBackground({0.2, 0.4, 0.6, 0.25})
    self:CreateBorder(1, {0.2, 0.4, 0.6, 0.75})
    --self:StyleButton() --TODO
    self.IconOverlay:SetAlpha(0)

    self.IsSkinned = true
end

local function closeAllBankBags()
    local Bank = BankFrame

    if (Bank:IsVisible()) then
        CloseBankBagFrames()
        CloseBankFrame()
    end
end

local function closeAllBags()
    if MerchantFrame:IsVisible() or InboxFrame:IsVisible() then
        return
    end

    CloseAllBags()

    if IsBagOpen(KEYRING_CONTAINER) then
        CloseBag(KEYRING_CONTAINER)
    end

    PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
end

local function createSortButton(self, pt, onClickFct)
    local btn = CreateFrame('Button', nil, self)
    btn:SetSize(16, 16)
    btn:SetPoint(unpack(pt))
    btn.Texture = btn:CreateTexture(nil, 'OVERLAY')
    btn.Texture:SetAllPoints()
    btn.Texture:SetTexture('interface/containerframe/bags.blp')
    btn.Texture:SetTexCoord(0.33, 0.40, 0.56, 0.62)
    btn:SetScript('OnEnter', GameTooltip_Hide)
    btn:SetScript('OnClick', onClickFct)

    return btn
end

local function slotUpdate(self, id, button)
    if not button then
        return
    end

    local _, _, _, Rarity, _, _, ItemLink, _, _, ItemID, IsBound = GetContainerItemInfo(id, button:GetID())
    local QuestItem = false
    local IsNewItem = C_NewItems.IsNewItem(id, button:GetID())

    if (button.ItemID == ItemID) then
        return
    end

    if button.Quest then
        button.Quest:Hide()
    end

    button.ItemID = ItemID

    if ItemLink then
        local itemName, itemString, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemLink)

        if itemString then
            if (itemType == TRANSMOG_SOURCE_2) then
                QuestItem = true
            end
        end

        if IsCosmeticItem(ItemLink) and not IsBound then
            button.IconOverlay:SetAlpha(1)
        else
            button.IconOverlay:SetAlpha(0)
        end
    end

    if bagSettings.IdentifyQuestItems and QuestItem then
        if not button.QuestTex then
            button.Quest = CreateFrame("Frame", nil, button)
            button.Quest:SetFrameLevel(button:GetFrameLevel())
            button.Quest:SetSize(8, button:GetHeight() - 2)
            button.Quest:SetPoint("TOPLEFT", 1, -1)

            button.Quest.Background = button.Quest:CreateBackground({ 0.2, 0.4, 0.6, 0.25 })
            button.Quest:CreateOneBorder('right', 1, { 1, 1, 0 }, 1)

            button.Quest.Texture = button.Quest:CreateTexture(nil, "OVERLAY", -1)
            button.Quest.Texture:SetTexture("Interface\\QuestFrame\\AutoQuest-Parts")
            button.Quest.Texture:SetTexCoord(0.13476563, 0.17187500, 0.01562500, 0.53125000)
            button.Quest.Texture:SetSize(8, 16)
            button.Quest.Texture:SetPoint("CENTER")
        end

        button.Quest:Show()
        button:SetBorderColor({1, 1, 0})
        --button.Backdrop:SetBorderColor(1, 1, 0) --TODO
    else
        if Rarity then
            local r, g, b = GetItemQualityColor(Rarity)
            button:SetBorderColor({r, g, b})
            --button.Backdrop:SetBorderColor(GetItemQualityColor(Rarity))
        else
            button:SetBorderColor({0.2, 0.4, 0.6, 0.75})
            --button.Backdrop:SetBorderColor(unpack(C["General"].BorderColor))
        end
    end

    if bagSettings.FlashNewItems and IsNewItem then
        if not button.Animation then
            button.Animation = button:CreateAnimationGroup()
            button.Animation:SetLooping("BOUNCE")

            button.Animation.FadeOut = button.Animation:CreateAnimation("Alpha")
            button.Animation.FadeOut:SetFromAlpha(1)
            button.Animation.FadeOut:SetToAlpha(.3)
            button.Animation.FadeOut:SetDuration(.3)
            button.Animation.FadeOut:SetSmoothing("IN_OUT")
            button:HookScript("OnEnter", function(self)
                local ItemID = self.ItemID
                local BagID = self:GetID()

                if ItemID and BagID then
                    local IsNewItem = C_NewItems.IsNewItem(self.ItemID, self:GetID())

                    if not IsNewItem and button.Animation:IsPlaying() then
                        button.Animation:Stop()
                    end
                end
            end)
        end

        if not button.Animation:IsPlaying() then
            button.Animation:Play()
        end
    end

    if bagSettings.ItemLevel then
        if ItemLink then
            local Level = GetDetailedItemLevelInfo(ItemLink)
            local _, _, Rarity, _, _, _, _, _, _, _, _, ClassID = GetItemInfo(ItemLink)

            if (ClassID == LE_ITEM_CLASS_ARMOR or ClassID == LE_ITEM_CLASS_WEAPON) and Level > 1 then
                if not button.ItemLevel then
                    button.ItemLevel = button:CreateFontString(nil, "ARTWORK")
                    button.ItemLevel:SetPoint("TOPRIGHT", 1, -1)
                    button.ItemLevel:SetFontObject('GameFontNormal') --TODO
                    button.ItemLevel:SetJustifyH("RIGHT")
                end

                button.ItemLevel:SetText(Level)

                if Rarity then
                    button.ItemLevel:SetTextColor(GetItemQualityColor(Rarity))
                else
                    button.ItemLevel:SetTextColor(1, 1, 1)
                end
            else
                if button.ItemLevel then
                    button.ItemLevel:SetText("")
                end
            end
        else
            if button.ItemLevel then
                button.ItemLevel:SetText("")
            end
        end
    end
end

local function bagUpdate(self, id)
    local slotsCount = GetContainerNumSlots(id)
    local containerID = IsBagOpen(KEYRING_CONTAINER) and 1 or id + 1

    local button
    for slotIndex = 1, slotsCount do
        button = _G["ContainerFrame" .. containerID .. "Item" .. slotIndex]

        if button then
            if not button:IsShown() then
                button:Show()
            end

            local BagType = getBagType(id)

            if (BagType ~= 1) and (not button.IsTypeStatusCreated) then
                button.TypeStatus = CreateFrame("StatusBar", nil, button)
                button.TypeStatus:SetPoint("BOTTOMLEFT", 1, 1)
                button.TypeStatus:SetPoint("BOTTOMRIGHT", -1, 1)
                button.TypeStatus:SetHeight(3)
                button.TypeStatus:SetFrameStrata(button:GetFrameStrata())
                button.TypeStatus:SetFrameLevel(button:GetFrameLevel())
                button.TypeStatus:SetStatusBarTexture(C.Medias.Blank)

                button.IsTypeStatusCreated = true
            end

            if BagType == 2 then
                -- Warlock Soul Shards Slots
                button.TypeStatus:SetStatusBarColor(GetClassColor("WARLOCK"))
            elseif BagType == 3 then
                local ProfessionType = Bags:GetBagProfessionType(id)

                if ProfessionType == "Leatherworking" then
                    button.TypeStatus:SetStatusBarColor(102 / 255, 51 / 255, 0 / 255)
                elseif ProfessionType == "Inscription" then
                    button.TypeStatus:SetStatusBarColor(204 / 255, 204 / 255, 0 / 255)
                elseif ProfessionType == "Herb" then
                    button.TypeStatus:SetStatusBarColor(0 / 255, 153 / 255, 0 / 255)
                elseif ProfessionType == "Enchanting" then
                    button.TypeStatus:SetStatusBarColor(230 / 255, 25 / 255, 128 / 255)
                elseif ProfessionType == "Engineering" then
                    button.TypeStatus:SetStatusBarColor(25 / 255, 230 / 255, 230 / 255)
                elseif ProfessionType == "Gem" then
                    button.TypeStatus:SetStatusBarColor(232 / 255, 252 / 255, 252 / 255)
                elseif ProfessionType == "Mining" then
                    button.TypeStatus:SetStatusBarColor(138 / 255, 40 / 255, 40 / 255)
                elseif ProfessionType == "Fishing" then
                    button.TypeStatus:SetStatusBarColor(54 / 255, 54 / 255, 226 / 255)
                end
            elseif BagType == 4 then
                -- Hunter Quiver Slots
                button.TypeStatus:SetStatusBarColor(GetClassColor("HUNTER"))
            end

            slotUpdate(self, id, button)
        end
    end
end

local function updateAllBags(self)
    local size = bagSettings.Size
    local spacing = bagSettings.Spacing
    local itemsPerRow = bagSettings.ItemsPerRow
    -- check if containers changed
    if not self.NeedBagRefresh then
        for i = 1, 5 do
            local containerSize = _G["ContainerFrame" .. i].size

            if containerSize ~= BagSize[i] then
                self.NeedBagRefresh = true

                BagSize[i] = containerSize
            end
        end

        if not self.NeedBagRefresh then
            return
        end
    end

    -- Refresh layout if a refresh if found
    local rowsCount, lastRowButton, buttonsCount, lastButton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
    local firstButton

    for Bag = 1, 5 do
        local ID = Bag - 1

        if IsBagOpen(KEYRING_CONTAINER) then
            ID = -2
        end

        local numSlots = GetContainerNumSlots(ID)

        local button
        for Item = numSlots, 1, -1 do
            button = _G["ContainerFrame" .. Bag .. "Item" .. Item]

            if not firstButton then
                firstButton = button
            end

            button:ClearAllPoints()
            button:SetSize(unpack(size))
            --button:SetScale(1) --TODO

            button.newitemglowAnim:Stop()
            button.newitemglowAnim.Play = function()
            end

            button.flashAnim:Stop()
            button.flashAnim.Play = function()
            end

            if (button == firstButton) then
                button:SetPoint("TOPLEFT", Bags.Bag, "TOPLEFT", 10, -40)
                lastRowButton = button
                lastButton = button
            elseif (buttonsCount == itemsPerRow) then
                button:SetPoint("TOPRIGHT", lastRowButton, "TOPRIGHT", 0, -(spacing[2] + size[2]))
                button:SetPoint("BOTTOMLEFT", lastRowButton, "BOTTOMLEFT", 0, -(spacing[2] + size[2]))
                lastRowButton = button
                rowsCount = rowsCount + 1
                buttonsCount = 1
            else
                button:SetPoint("TOPRIGHT", lastButton, "TOPRIGHT", (spacing[1] + size[1]), 0)
                button:SetPoint("BOTTOMLEFT", lastButton, "BOTTOMLEFT", (spacing[1] + size[1]), 0)
                buttonsCount = buttonsCount + 1
            end

            lastButton = button

            if not button.IsSkinned then
                skinBagButton(button)
            end
        end

        bagUpdate(self, ID)

        if IsBagOpen(KEYRING_CONTAINER) then
            break
        end
    end

    local money = ContainerFrame1MoneyFrame
    if not money.IsMoved then
        money:ClearAllPoints()
        money:Show()
        money:SetPoint("BOTTOMLEFT", self.Bag, "BOTTOMLEFT", 10, 8)
        money.IsMoved = true
    end

    self.NeedBagRefresh = false

    self.Bag:SetHeight(((size[2] + spacing[2]) * (rowsCount + 1) + 64 + (spacing[2] * 4)) - spacing[2])
end

local function openBag(self, id)
    if (not CanOpenPanels()) then
        if (UnitIsDead("player")) then
            NotWhileDeadError()
        end

        return
    end

    local Size = GetContainerNumSlots(id)
    local OpenFrame = ContainerFrame_GetOpenFrame()

    for i = 1, 40 do
        local Index = Size - i + 1
        local Button = _G[OpenFrame:GetName() .. "Item" .. i]

        if Button then
            if (i > Size) then
                Button:Hide()
            else
                Button:SetID(Index)
                Button:Show()
            end
        end
    end

    OpenFrame.size = Size
    OpenFrame:SetID(id)
    OpenFrame:Show()

    if (id == 4) then
        updateAllBags(self)
    end
end

local function itemSetPoint(container, settings, gName, buttonCount, firstButton)
    local rowsCount, lastRowButton, buttonsCount, lastButton = 0, firstButton or _G[gName .. '1'], 1, firstButton or _G[gName .. '1']
    local size = settings.Size
    local spacing = settings.Spacing
    local itemsPerRow = settings.ItemsPerRow

    local button, icon
    for i = 1, buttonCount do
        button = _G[gName .. i]
        --count = _G[button:GetName() .. "Count"]
        icon = _G[button:GetName() .. "IconTexture"]

        button:ClearAllPoints()
        button:SetSize(unpack(size))
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetHighlightTexture("")
        --Button:CreateBackdrop()
        button.Background = button:CreateBackground({ 0.2, 0.4, 0.6, 0.25 })
        button:CreateBorder(1, {0.2, 0.4, 0.6, 0.75}) --TODO
        button.IconBorder:SetAlpha(0)

        if (i == 1) then
            button:SetPoint("TOPLEFT", container, "TOPLEFT", 10, -40)
            lastRowButton = button
            lastButton = button
        elseif (buttonsCount == itemsPerRow) then
            button:SetPoint("TOPRIGHT", lastRowButton, "TOPRIGHT", 0, -(spacing[2] + size[2]))
            button:SetPoint("BOTTOMLEFT", lastRowButton, "BOTTOMLEFT", 0, -(spacing[2] + size[2]))
            lastRowButton = button
            rowsCount = rowsCount + 1
            buttonsCount = 1
        else
            button:SetPoint("TOPRIGHT", lastButton, "TOPRIGHT", (spacing[1] + size[1]), 0)
            button:SetPoint("BOTTOMLEFT", lastButton, "BOTTOMLEFT", (spacing[1] + size[1]), 0)
            buttonsCount = buttonsCount + 1
        end

        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) --TODO

        lastButton = button

        slotUpdate(self, -3, button)
    end

    return rowsCount, lastRowButton, buttonsCount, lastButton
end

local function createReagentContainer(self, settings)
    local size = settings.Size
    local spacing = settings.Spacing
    local itemsPerRow = settings.ItemsPerRow

    ReagentBankFrame:StripTextures()

    --local DataTextLeft = T.DataTexts.Panels.Left
    local container = CreateFrame("Frame", "VorkuiReagentContainer", UIParent)
    container:SetWidth(((size[1] + spacing[1]) * itemsPerRow) + 22 - spacing[1])
    container:SetPoint("BOTTOMLEFT", self.Bank, "BOTTOMLEFT", 0, 0)
    container.Background = container:CreateBackground({ 0.1, 0.2, 0.3, 0.95 })
    container:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })
    container:SetFrameStrata(self.Bank:GetFrameStrata())
    container:SetFrameLevel(self.Bank:GetFrameLevel())

    local NumButtons = ReagentBankFrame.size
    --local rowsCount, lastRowButton, buttonsCount, lastButton = 0, ReagentBankFrameItem1, 1, ReagentBankFrameItem1
    local deposit = ReagentBankFrame.DespositButton

    local sortButton = createSortButton(container, { 'TOPLEFT', container, 'TOPLEFT', 4, -6 }, BankFrame_AutoSortButtonOnClick)

    local switchBankButton = CreateFrame("Button", nil, container)
    switchBankButton:SetSize((container:GetWidth() / 2) - 1, 23)
    skinButton(switchBankButton)
    switchBankButton:SetPoint("LEFT", sortButton, "RIGHT", 4, 0)
    switchBankButton.Text = switchBankButton:CreateFontString(nil, "OVERLAY")
    switchBankButton.Text:SetFontObject('GameFontNormal') --TODO
    switchBankButton.Text:SetJustifyH("LEFT")
    switchBankButton.Text:SetPoint("CENTER")
    switchBankButton.Text:SetText("Switch to: " .. BANK)
    switchBankButton:SetScript("OnClick", function()
        container:Hide()
        self.Bank:Show()
        BankFrame_ShowPanel(BANK_PANELS[1].name)

        for i = 5, 11 do
            if (not IsBagOpen(i)) then
                openBag(self, i, 1)
            end
        end
    end)

    deposit:SetParent(container)
    deposit:ClearAllPoints()
    deposit:SetSize(container:GetWidth(), 23)
    deposit:SetPoint("BOTTOM", container, "TOP", 0, 2)
    skinButton(deposit)

    local button, count, icon
    ReagentBankFrame:SetParent(container)
    ReagentBankFrame:ClearAllPoints()
    ReagentBankFrame:SetAllPoints()

    local rowsCount = itemSetPoint(container, settings, 'ReagentBankFrameItem', 98)
    container:SetHeight(((size[2] + spacing[2]) * (rowsCount + 1) + 50) - spacing[2])

    container:SetScript("OnHide", function()
        ReagentBankFrame:Hide()
    end)

    -- Unlock window
    local unlockInfo = ReagentBankFrameUnlockInfo
    local purchaseButton = ReagentBankFrameUnlockInfoPurchaseButton
    unlockInfo.Text = ReagentBankFrameUnlockInfoText
    unlockInfo.Text:SetWidth(unlockInfo:GetWidth()-22)
    unlockInfo.Text:SetHeight(80)

    unlockInfo:StripTextures()
    unlockInfo:SetAllPoints(container)
    unlockInfo.Background = unlockInfo:CreateBackground({ 0.1, 0.2, 0.3, 0.75 })
    unlockInfo:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    skinButton(purchaseButton)

    self.Reagent = container
    self.Reagent.SwitchBankButton = switchBankButton
    self.Reagent.SortButton = sortButton
end

local function createBankContainer(self, settings)
    local size = settings.Size
    local spacing = settings.Spacing
    local itemsPerRow = settings.ItemsPerRow

    local container = CreateFrame('Frame', 'VorkuiBankContainer', UIParent)
    container:SetWidth((size[1] + spacing[1]) * itemsPerRow + 22 - spacing[1])
    container:SetPoint('CENTER', 0, 0)
    container:SetFrameStrata('MEDIUM')
    container:SetFrameLevel(1)
    container:Hide()
    container.Background = container:CreateBackground({ 0.1, 0.2, 0.3, 0.95 })
    container:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })
    container:EnableMouse(true)

    --Window to purchase slot
    local purchaseInfo = BankFramePurchaseInfo
    purchaseInfo:ClearAllPoints()
    purchaseInfo:SetWidth(container:GetWidth() + 50)
    purchaseInfo:SetHeight(70)
    purchaseInfo:SetPoint("BOTTOM", container, "TOP", 0, 50)
    purchaseInfo.Background = purchaseInfo:CreateBackground({0.2, 0.4, 0.6, 0.25})
    purchaseInfo:CreateBorder(1, {0.2, 0.4, 0.6, 0.75})

    local purchaseLabel = purchaseInfo:GetRegions()
    purchaseInfo.PurchaseLabel = purchaseLabel
    purchaseLabel:SetWidth(purchaseInfo:GetWidth())
    purchaseLabel:ClearAllPoints()
    purchaseLabel:SetPoint('TOPRIGHT', 0, -15)
    purchaseLabel:SetJustifyH('CENTER')

    local slotCost = BankFrameSlotCost
    slotCost:ClearAllPoints()
    slotCost:SetPoint("BOTTOMLEFT", 60, 10)

    local detailMoneyFrame = BankFrameDetailMoneyFrame
    detailMoneyFrame:ClearAllPoints()
    detailMoneyFrame:SetPoint("LEFT", slotCost, "RIGHT", 0, 0)

    local purchaseButton = BankFramePurchaseButton
    purchaseButton:ClearAllPoints()
    purchaseButton:SetPoint("BOTTOMRIGHT", -10, 10)
    skinButton(purchaseButton)
    --End Window

    --Add Cleanup Button
    local sortButton = createSortButton(container, { 'TOPLEFT', container, 'TOPLEFT', 4, -6 }, BankFrame_AutoSortButtonOnClick)

    --Add ReagentButton
    local reagentButton = CreateFrame("Button", nil, container)
    reagentButton:SetSize((container:GetWidth() / 2) - 1, 20)
    skinButton(reagentButton)
    reagentButton:SetPoint("LEFT", sortButton, "RIGHT", 4, 0)
    reagentButton:SetScript("OnClick", function()
        BankFrame_ShowPanel(BANK_PANELS[2].name)

        if (not ReagentBankFrame.isMade) then
            createReagentContainer(self, settings)
            ReagentBankFrame.isMade = true
        else
            self.Reagent:Show()
        end

        for i = 5, 11 do
            CloseBag(i)
        end
    end)
    reagentButton.Text = reagentButton:CreateFontString(nil, "OVERLAY")
    reagentButton.Text:SetFontObject('GameFontNormal') --TODO
    reagentButton.Text:SetJustifyH("LEFT")
    reagentButton.Text:SetPoint("CENTER")
    reagentButton.Text:SetText("Switch to: " .. REAGENT_BANK)

    --Skin BankContainer
    local bankContainer = CreateFrame("Frame", nil, container)
    bankContainer:SetSize(container:GetWidth(), BankSlotsFrame.Bag1:GetHeight() + spacing[2] + spacing[2])
    bankContainer.Background = bankContainer:CreateBackground({0.2, 0.4, 0.6, 0.25})
    bankContainer:CreateBorder(1, {0.2, 0.4, 0.6, 0.75})
    bankContainer:SetPoint("BOTTOMLEFT", container, "TOPLEFT")
    bankContainer:SetFrameLevel(container:GetFrameLevel())
    bankContainer:SetFrameStrata(container:GetFrameStrata())

    for i = 1, 7 do
        local Bag = BankSlotsFrame["Bag" .. i]
        if Bag then
            Bag:SetParent(bankContainer)
            Bag:SetWidth(size[1])
            Bag:SetHeight(size[2])

            Bag.IconBorder:SetAlpha(0)
            Bag.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) --TODO
            --Bag.icon:SetInside()

            skinButton(Bag)
            Bag:ClearAllPoints()

            Bag.SlotHighlightTexture:SetAlpha(0)

            if i == 1 then
                Bag:SetPoint("TOPLEFT", bankContainer, "TOPLEFT", spacing[1], -spacing[2])
            else
                Bag:SetPoint("LEFT", BankSlotsFrame["Bag" .. i - 1], "RIGHT", spacing[1], 0)
            end
        end
    end

    bankContainer:SetWidth((size[1] * 7) + (spacing[1] * (7 + 1)))
    bankContainer:SetHeight(size[2] + (spacing[2] * 2))
    bankContainer:Hide()

    BankFrame:EnableMouse(false)

    container.BagsContainer = bankContainer
    container.SortButton = sortButton
    container.ReagentButton = reagentButton

    self.Bank = container

end

local function createBagContainer(self, settings)
    local size = settings.Size
    local spacing = settings.Spacing
    local itemsPerRow = settings.ItemsPerRow

    local container = CreateFrame('Frame', 'VorkuiBagContainer', UIParent)
    container:SetWidth((size[1] + spacing[1]) * itemsPerRow + 22 - spacing[1])
    container:SetPoint('BOTTOMRIGHT', 0, 400)
    container:SetFrameStrata('MEDIUM')
    container:SetFrameLevel(1)
    container:Hide()
    container.Background = container:CreateBackground({ 0.1, 0.2, 0.3, .95 })
    container:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })
    container:EnableMouse(true)

    local bags = CreateFrame('Frame', nil, container)
    --bags:SetSize(10, 10)
    bags:SetPoint('BOTTOMRIGHT', container, 'TOPRIGHT')
    bags:Hide()
    bags.Background = bags:CreateBackground({ 0.2, 0.4, 0.6, 0.25 })
    bags:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    local closeBagsButton = CreateFrame('Button', nil, container, 'UIPanelCloseButton')
    closeBagsButton:SetSize(32, 32)
    closeBagsButton:SetPoint('TOPRIGHT', container, 'TOPRIGHT')
    closeBagsButton:EnableMouse(true)
    closeBagsButton:SetScript('OnEnter', GameTooltip_Hide)
    closeBagsButton:SetScript('OnMouseUp', function(b, mouse)
        CloseAllBags()
        CloseBankBagFrames()
        CloseBankFrame()

        PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
    end)

    self.ReplaceBags = 0
    local toggleBags = CreateFrame('Button', nil, container)
    toggleBags:SetSize(32, 32)
    toggleBags:SetPoint('RIGHT', closeBagsButton, 'LEFT')
    toggleBags.Texture = toggleBags:CreateTexture(nil, 'OVERLAY')
    toggleBags.Texture:SetAllPoints()
    toggleBags.Texture:SetTexture('interface/talentframe/ui-talentarrows.blp')
    toggleBags.Texture:SetTexCoord(0, 0.5, 0, 0.5)
    toggleBags.Texture:SetRotation(0)
    --toggleBags.Texture:SetColorTexture(0, 1, 0) --TODO change this to show arrow up
    toggleBags:SetScript('OnEnter', GameTooltip_Hide)
    toggleBags:SetScript('OnClick', function(btn)
        local bank = self.Bank.BagsContainer

        if self.ReplaceBags == 0 then
            self.ReplaceBags = 1
            bags:Show()
            bank:Show()

            btn.Texture:SetRotation(mpi)
            --btn.Texture:SetColorTexture(1, 1, 0) --TODO change this to show arrow down
        else
            self.ReplaceBags = 0
            bags:Hide()
            bank:Hide()

            btn.Texture:SetRotation(0)
            --btn.Texture:SetColorTexture(0, 1, 0) --TODO change this to show arrow up
        end
    end)

    local sortButton = createSortButton(container, {'RIGHT', toggleBags, 'LEFT'}, function()
        if InCombatLockdown() then
            return
        end

        SortBags()
    end)

    local searchBox = CreateFrame('Editbox', nil, container, 'BagSearchBoxTemplate')
    searchBox:SetFrameLevel(container:GetFrameLevel() + 10)
    searchBox:SetSize(150, 18)
    searchBox:SetPoint('TOPRIGHT', sortButton, 'TOPLEFT', -4, 0)
    searchBox:SetPoint('LEFT', container, 'LEFT', 10, 0)
    skinButton(searchBox)
    searchBox.Instructions:SetTextColor( 1, 1, 1, 1 )

    local lastButtonBag, buttonBags
    for _, buttonBags in pairs(characterBags) do
        local Count = _G[buttonBags:GetName().."Count"]
        local Icon = _G[buttonBags:GetName().."IconTexture"]

        buttonBags:SetParent(bags)
        buttonBags:ClearAllPoints()
        buttonBags:SetSize(unpack(size))
        buttonBags:SetNormalTexture("")
        buttonBags:SetPushedTexture("")
        buttonBags.Background = buttonBags:CreateBackground({ 0.2, 0.4, 0.6, 0.25})
        buttonBags:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75})
        buttonBags.IconBorder:SetAlpha(0)
        skinButton(buttonBags)

        buttonBags.SlotHighlightTexture:SetAlpha(0)

        if lastButtonBag then
            buttonBags:SetPoint("LEFT", lastButtonBag, "RIGHT", spacing[1], 0)
        else
            buttonBags:SetPoint("TOPLEFT", bags, "TOPLEFT", spacing[2], -spacing[2])
        end

        Count.Show = function()  end
        Count:Hide()
        Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        lastButtonBag = buttonBags
        bags:SetWidth((size[1] * #characterBags) + (spacing[1] * (#characterBags + 1)))
        bags:SetHeight(size[2] + (spacing[2] * 2))
    end

    container.Bags = bags
    container.CloseButton = closeBagsButton
    container.SortButton = sortButton
    container.SearchBox = searchBox
    container.ToggleBags = toggleBags

    self.Bag = container

end

local function updateAllBankBags(self)
    -- check if containers changed
    for i = 6, 13 do
        local ContainerSize = _G["ContainerFrame" .. i].size

        if ContainerSize ~= BagSize[i] then
            self.NeedBankRefresh = true

            BagSize[i] = ContainerSize
        end
    end

    if not self.NeedBankRefresh then
        return
    end

    local size = bagSettings.Size
    local spacing = bagSettings.Spacing
    local itemsPerRow = bagSettings.ItemsPerRow
    local BankFrameMoneyFrame = BankFrameMoneyFrame

    local rowsCount, lastRowButton, buttonsCount, lastButton = itemSetPoint(self.Bank, bagSettings, 'BankFrameItem', 28)

    BankFrameMoneyFrame:Hide()

    for Bag = 6, 12 do
        local Slots = GetContainerNumSlots(Bag - 1)
        for Item = Slots, 1, -1 do
            local Button = _G["ContainerFrame" .. Bag .. "Item" .. Item]

            Button:ClearAllPoints()
            Button:SetSize(unpack(size))
            --Button:SetScale(1) --TODO
            Button.IconBorder:SetAlpha(0)

            if (buttonsCount == itemsPerRow) then
                Button:SetPoint("TOPRIGHT", lastRowButton, "TOPRIGHT", 0, -(spacing[2] + size[2]))
                Button:SetPoint("BOTTOMLEFT", lastRowButton, "BOTTOMLEFT", 0, -(spacing[2] + size[2]))
                lastRowButton = Button
                rowsCount = rowsCount + 1
                buttonsCount = 1
            else
                Button:SetPoint("TOPRIGHT", lastButton, "TOPRIGHT", (spacing[1] + size[1]), 0)
                Button:SetPoint("BOTTOMLEFT", lastButton, "BOTTOMLEFT", (spacing[1] + size[1]), 0)
                buttonsCount = buttonsCount + 1
            end

            skinBagButton(Button)
            slotUpdate(self, Bag - 1, Button)

            lastButton = Button
        end
    end

    self.Bank:SetHeight(((size[2] + spacing[2]) * (rowsCount + 1) + 50) - spacing[2])
    self.NeedBankRefresh = false
end

local function hideBlizzard()
    local BankPortraitTexture = _G["BankPortraitTexture"]
    local BankSlotsFrame = _G["BankSlotsFrame"]

    BankPortraitTexture:Hide()

    BankFrame:EnableMouse(false)

    for i = 1, 12 do
        local CloseButton = _G["ContainerFrame" .. i .. "CloseButton"]
        CloseButton:Hide()

        for k = 1, 7 do
            local Container = _G["ContainerFrame" .. i]
            select(k, Container:GetRegions()):SetAlpha(0)
        end
    end

    -- Hide Bank Frame Textures
    for i = 1, BankFrame:GetNumRegions() do
        local Region = select(i, BankFrame:GetRegions())

        Region:SetAlpha(0)
    end

    -- Hide BankSlotsFrame Textures and Fonts
    for i = 1, BankSlotsFrame:GetNumRegions() do
        local Region = select(i, BankSlotsFrame:GetRegions())

        Region:SetAlpha(0)
    end

    local TokenFrame = _G["BackpackTokenFrame"]
    local Inset = _G["BankFrameMoneyFrameInset"]
    local Border = _G["BankFrameMoneyFrameBorder"]
    local BankClose = _G["BankFrameCloseButton"]
    local BankItemSearchBox = _G["BankItemSearchBox"]
    local BankItemAutoSortButton = _G["BankItemAutoSortButton"]

    TokenFrame:GetRegions():SetAlpha(0)
    Inset:Hide()
    Border:Hide()
    BankClose:Hide()

    BankItemAutoSortButton:Hide()
    BankItemSearchBox:Hide()

    BankFrame.NineSlice:SetAlpha(0)

    -- Hide Tabs, we will create our tabs
    for i = 1, 2 do
        local Tab = _G["BankFrameTab" .. i]
        Tab:Hide()
    end
end

local function openAllBankBags(self)
    local Bank = BankFrame
    --local CustomPosition = TukuiDatabase.Variables[T.MyRealm][T.MyName].Move.TukuiBank

    if Bank:IsShown() then
        self.Bank:Show()

        for i = 5, 11 do
            if (not IsBagOpen(i)) then

                openBag(self, i, 1)
            end
        end
    end
end

local function openAllBags(self)
    openBag(self, 0)

    for i = 1, 4 do
        openBag(self, i)
    end

    if IsBagOpen(0) then
        self.Bag:Show()
    end
end

local function toggleBags(self, id, openonly)
    if id == KEYRING_CONTAINER then
        if not IsBagOpen(KEYRING_CONTAINER) then
            CloseAllBags()
            CloseBankBagFrames()
            CloseBankFrame()

            self.NeedBagRefresh = true

            openBag(self.Bags, id)
            updateAllBags(self.Bags)

            self.NeedBagRefresh = true
        else
            CloseBag(id)
        end
    else
        if (self.Bag:IsShown() and BankFrame:IsShown()) and (not self.Bank:IsShown()) then
            if ReagentBankFrame:IsShown() then
                return
            end

            openAllBankBags(self)

            return
        end

        if (not openonly) and (self.Bag:IsShown() or self.Bank:IsShown()) then
            if MerchantFrame:IsVisible() or InboxFrame:IsVisible() then
                return
            end

            closeAllBags()
            closeAllBankBags()

            return
        end

        if not self.Bag:IsShown() then
            openAllBags(self)
        end

        if not self.Bank:IsShown() and BankFrame:IsShown() then
            openAllBankBags(self)
        end
    end
end

local function cooldownOnUpdate(self, elapsed)
    local Now = GetTime()
    local Timer = Now - self.StartTimer
    local Cooldown = self.DurationTimer - Timer

    self.Elapsed = self.Elapsed - elapsed

    if self.Elapsed < 0 then
        if Cooldown <= 0 then
            self.Text:SetText("")

            self:SetScript("OnUpdate", nil)
        else
            self.Text:SetFont(C.Medias.Font, 12, "THINOUTLINE")
            self.Text:SetTextColor(1, 0, 0)
            self.Text:SetText(V.Utils.Functions.FormatTime(Cooldown))
        end

        self.Elapsed = .1
    end
end

local function updateCooldown(self, button)
    local Cooldown = button.Cooldown or _G[button:GetName() .. "Cooldown"]
    local Start, Duration = GetContainerItemCooldown(self, button:GetID())

    if not Cooldown.Text then
        Cooldown.Text = Cooldown:CreateFontString(nil, "OVERLAY")
        Cooldown.Text:SetPoint("CENTER", 1, 0)
    end

    Cooldown.StartTimer = Start
    Cooldown.DurationTimer = Duration
    Cooldown.Elapsed = .1
    Cooldown:SetScript("OnUpdate", cooldownOnUpdate)
end

local function onEvent(self, event, ...)
    if (event == "BAG_UPDATE") then
        if not IsBagOpen(KEYRING_CONTAINER) then
            bagUpdate(self, ...)
        else
            bagUpdate(self, -2)
        end
    elseif (event == "MERCHANT_CLOSED" or event == "MAIL_CLOSED") then
        CloseAllBags()
    elseif (event == "CURRENCY_DISPLAY_UPDATE") then
        BackpackTokenFrame_Update()
    elseif (event == "BAG_CLOSED") then
        -- This is usually where the client find a bag swap in character or bank slots.

        local Bag = ... + 1

        -- We need to hide buttons from a bag when closing it because they are not parented to the original frame
        local Container = _G["ContainerFrame" .. Bag]
        local Size = Container.size

        if Size then
            for i = 1, Size do
                local Button = _G["ContainerFrame" .. Bag .. "Item" .. i]

                if Button then
                    Button:Hide()
                end
            end
        end

        -- We close to refresh the all in one layout.
        closeAllBags()
        closeAllBankBags()
    elseif (event == "PLAYERBANKSLOTS_CHANGED") then
        local ID = ...

        if ID <= 28 then
            local Button = _G["BankFrameItem" .. ID]

            if (Button) then
                slotUpdate(self, -1, Button)
            end
        end
    elseif (event == "PLAYERREAGENTBANKSLOTS_CHANGED") then
        local ID = ...

        local Button = _G["ReagentBankFrameItem" .. ID]

        if (Button) then
            slotUpdate(self, -3, Button)
        end
    elseif (event == "BANKFRAME_CLOSED") then
        local Bank = self.Bank

        closeAllBags()
        closeAllBankBags()

        -- Clear search on close
        self.Bag.SearchBox:SetText("")
    elseif (event == "BANKFRAME_OPENED") then
        local Bank = self.Bank

        Bank:Show()
        updateAllBankBags(self)
    elseif (event == "SOULBIND_FORGE_INTERACTION_STARTED") then
        openAllBags(self)

        ItemButtonUtil.OpenAndFilterBags(SoulbindViewer)
    elseif (event == "SOULBIND_FORGE_INTERACTION_ENDED") then
        closeAllBags()
    end

end

local function setTokensPosition(self)
    local Money = ContainerFrame1MoneyFrame
    local token1 = BackpackTokenFrameToken1
    local token2 = BackpackTokenFrameToken2
    local token3 = BackpackTokenFrameToken3

    MAX_WATCHED_TOKENS = 3

    -- Set Position
    token1:ClearAllPoints()
    token1:SetPoint("LEFT", Money, "RIGHT", 0, 0)
    token1:SetWidth(75)

    token2:ClearAllPoints()
    token2:SetPoint("LEFT", token1, "RIGHT", 0, 0)
    token2:SetWidth(75)

    --token3:SetParent(V.Hider)
    token3:ClearAllPoints()
    token3:SetPoint("LEFT", token2, "RIGHT", 0, 0)
    token3:SetWidth(75)

    -- Skin text
    token1.count:SetFontObject('NumberFontNormalRight')
    token2.count:SetFontObject('NumberFontNormalRight')
    token3.count:SetFontObject('NumberFontNormalRight')

    -- Skin Icons
    token1.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    token2.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    token3.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

function Bags:Enable()

    if bagSettings.SortToBottom then
        SetSortBagsRightToLeft(false)
    else
        SetSortBagsRightToLeft(true)
    end
    SetInsertItemsLeftToRight(false)

    GroupLootContainer:EnableMouse(false)

    createBagContainer(self, bagSettings)
    createBankContainer(self, bagSettings)
    hideBlizzard()

    --rewrite hook
    local bag = ContainerFrame1
    local bankItem1 = BankFrameItem1
    bag:SetScript('OnHide', function()
        self.Bag:Hide()
    end)

    bag:HookScript('OnShow', function()
        self.Bag:Show()
    end)

    bankItem1:SetScript('OnHide', function()
        self.Bank:Hide()
    end)

    -- Rewrite Blizzard Bags Functions
    function UpdateContainerFrameAnchors()
    end
    function ToggleBag(id)
        ToggleAllBags(id)
    end
    function ToggleBackpack()
        ToggleAllBags()
    end
    function OpenAllBags()
        ToggleAllBags(1, true)
    end
    function OpenBackpack()
        ToggleAllBags(1, true)
    end
    function ToggleAllBags(id, openonly)
        toggleBags(self, id, openonly)
    end

    -- Destroy bubbles help boxes
    for i = 1, 13 do
        local HelpBox = _G["ContainerFrame" .. i .. "ExtraBagSlotsHelpBox"]

        if HelpBox then
            HelpBox:Kill()
        end
    end

    OpenAllBagsMatchingContext = function()
        return 4
    end

    -- Register Events for Updates
    self:RegisterEvent("BAG_UPDATE")
    self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
    self:RegisterEvent("BAG_CLOSED")
    self:RegisterEvent("BANKFRAME_CLOSED")
    self:RegisterEvent("BANKFRAME_OPENED")
    self:RegisterEvent("MERCHANT_CLOSED")
    self:RegisterEvent("MAIL_CLOSED")
    self:SetScript("OnEvent", onEvent)

    for i = 1, 13 do
        _G["ContainerFrame" .. i]:EnableMouse(false)
    end

    -- Add Text Cooldowns Timer
    hooksecurefunc("ContainerFrame_UpdateCooldown", updateCooldown)
    hooksecurefunc("BankFrame_UpdateCooldown", updateCooldown)

    setTokensPosition(self)

    BankFrame:HookScript("OnHide", function()
        if self.Reagent and self.Reagent:IsShown() then
            self.Reagent:Hide()
        end
    end)

    self:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED")
    self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    self:RegisterEvent("SOULBIND_FORGE_INTERACTION_STARTED")
    self:RegisterEvent("SOULBIND_FORGE_INTERACTION_ENDED")

    ToggleAllBags()
end

function Bags:Disable()

end
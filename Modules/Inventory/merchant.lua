local select = select
local type = type
local floor = floor
local format = format

local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Merchant = V['Merchant']

local AutoSellJunk = true
local AutoRepair = true

local formatQTY = V.Utils.Functions.FormatMoney

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

end

function Merchant:Disable()
    self:UnregisterEvent('MERCHANT_SHOW')
    self:SetScript('OnEvent', nil)

    MerchantItemButton_OnModifiedClick = BlizzardMerchantClick

end
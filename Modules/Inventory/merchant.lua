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

local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemID = GetContainerItemID
local GetItemInfo = GetItemInfo
local GetContainerItemInfo = GetContainerItemInfo
local GetRepairAllCost = GetRepairAllCost
local RepairAllItems = RepairAllItems
local CanMerchantRepair = CanMerchantRepair
local UseContainerItem = UseContainerItem
local PickupMerchantItem =PickupMerchantItem
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

local copperIcon = [[interface/icons/inv_misc_coin_05]]
local silverIcon = [[interface/icons/inv_misc_coin_03]]
local goldIcon = [[interface/icons/inv_misc_coin_01]]

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

        DEFAULT_CHAT_FRAME:AddMessage(format(GENERIC_MONEY_GAINED_RECEIPT,formatQTY(cost)), 1, 1, 0)
    end
end

local function autoRepair()
    if (CanMerchantRepair()) then
        local cost, possible = GetRepairAllCost()

        if (cost > 0) then
            if possible then
                RepairAllItems()

                DEFAULT_CHAT_FRAME:AddMessage(REPAIR_COST..formatQTY(cost), 1, 1, 0)

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
    if AutoSellJunk then
        sellJunk()
    end

    if AutoRepair then
        autoRepair()
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
    self:RegisterEvent("MERCHANT_SHOW")
    self:SetScript("OnEvent", onEvent)

    MerchantItemButton_OnModifiedClick = onClick
end

function Merchant:Disable()
    self:UnregisterEvent("MERCHANT_SHOW")
    self:SetScript("OnEvent", nil)

    MerchantItemButton_OnModifiedClick = BlizzardMerchantClick
end
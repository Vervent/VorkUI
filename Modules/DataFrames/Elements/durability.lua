local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local ipairs = ipairs
local tinsert = tinsert
local format = format
local GetInventorySlotInfo = GetInventorySlotInfo
local GetInventoryItemDurability = GetInventoryItemDurability
local BreakUpLargeNumbers = BreakUpLargeNumbers

local item = {
    'HeadSlot',
    'ShoulderSlot',
    'ChestSlot',
    'WaistSlot',
    'LegsSlot',
    'FeetSlot',
    'WristSlot',
    'HandsSlot',
    'MainHandSlot',
    'SecondaryHandSlot'
}

local durability = {}

local percent = 100

local function updateID()
    local id
    for _, it in ipairs(item) do
        id = GetInventorySlotInfo(it)
        tinsert(durability, id)
    end
end

local function update(self, event, ...)
    local current, maximum, p
    if event == 'PLAYER_EQUIPMENT_CHANGED' then
        local id = ...
        current, maximum = GetInventoryItemDurability(id)
        if not current then
            return
        end
        p = current / maximum
        if percent > p then
            percent = p
        end
        self.Text:SetText(format('%d%%', BreakUpLargeNumbers(percent * 100)))
        return
    elseif event == 'PLAYER_ENTERING_WORLD' then
        updateID()
    end

    for _, slotId in ipairs(durability) do
        current, maximum = GetInventoryItemDurability(slotId)
        --print (event, slotId, current, maximum)
        if current then
            p = current / maximum
            if percent > p then
                percent = p
            end
        end
    end

    self.Text:SetText(format('%d%%', BreakUpLargeNumbers(percent * 100)))
end

local function enable(self)
    self:SetSize(66, 30)
    self.Icon:SetSize(25,25)

    self.Icon:SetTexture([[INTERFACE\ICONS\TRADE_BLACKSMITHING]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
    self:RegisterEvent('UPDATE_INVENTORY_ALERTS')
    self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
    self:RegisterEvent('MERCHANT_UPDATE')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('UPDATE_INVENTORY_ALERTS')
    self:UnregisterEvent('UPDATE_INVENTORY_DURABILITY')
    self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
    self:UnregisterEvent('MERCHANT_UPDATE')
end

DataFrames:RegisterElement('durability', enable, disable, update)
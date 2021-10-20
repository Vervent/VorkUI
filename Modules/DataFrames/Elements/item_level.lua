local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

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

    local _, stat = unpack(event)
    local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP, minItemLevel = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if avgItemLevelEquipped and self.Text then
        self.Text:SetText(BreakUpLargeNumbers(avgItemLevelEquipped))
    end
end

local function enable(self)

    self.Icon:SetTexture([[INTERFACE\ICONS\GARRISON_BLUEARMORUPGRADE]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT')

    self.Observer.OnNotify = function(...)
        update(self, ...)
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('item_level', enable, disable, update)
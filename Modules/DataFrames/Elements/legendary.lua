local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local ipairs = ipairs
local Item = Item
local format = format
local C_LegendaryCrafting = C_LegendaryCrafting
local GetInventorySlotInfo = GetInventorySlotInfo
local GetSpellInfo = GetSpellInfo

local item = {
    'HeadSlot',
    'NeckSlot',
    'ShoulderSlot',
    'ChestSlot',
    'WaistSlot',
    'LegsSlot',
    'FeetSlot',
    'WristSlot',
    'HandsSlot',
    'Finger0Slot',
    'Finger1Slot',
    'Trinket0Slot',
    'Trinket1Slot',
    'BackSlot',
    'MainHandSlot',
    --'RangedSlot',
    --'SecondaryHandSlot'
}

local function update(self, event, ...)
    local id, location, check, powerID, runeforgePowerInfo, spellID
    for _, it in ipairs(item) do
        id = GetInventorySlotInfo(it)
        location = Item:CreateFromEquipmentSlot(id):GetItemLocation()
        check = C_LegendaryCrafting.IsRuneforgeLegendary(location)
        if check == true then
            powerID = C_LegendaryCrafting.GetRuneforgeLegendaryComponentInfo(location).powerID
            runeforgePowerInfo = C_LegendaryCrafting.GetRuneforgePowerInfo(powerID)
            spellID = runeforgePowerInfo.descriptionSpellID
            local name, _, icon = GetSpellInfo(spellID)
            self.Text:SetText(format('%.8s', name))
            self.Icon:SetTexture(icon)
            return
        end
    end

    self.Text:SetText('')
    self.Icon:SetTexture(nil)
end

local function enable(self)
    self:SetSize(90, 30)
    --self.Icon:SetTexture([[INTERFACE\ICONS\TRADE_BLACKSMITHING]])
    --self.Icon:SetDesaturated(true)
    self.Icon:SetSize(25, 25)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
    self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
end

DataFrames:RegisterElement('legendary', enable, disable, update)
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local format = format
local C_EquipmentSet = C_EquipmentSet

local function update(self, event)

    local name, iconFileID, isEquipped

    for i=1, 20 do
        name, iconFileID, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(i)
        if isEquipped == true then
            self.Icon:SetTexture(iconFileID)
            self.Text:SetText(format('%.10s', name))
            return
        end
    end

    self.Icon:SetTexture(nil)
    self.Text:SetText('')

end

local function enable(self)
    self:SetSize(150, 30)
    self.Icon:SetSize(25, 25)
    --self.Icon:SetTexture([[INTERFACE\ICONS\SPELL_ANIMAARDENWEALD_ORB]])
    --self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end

DataFrames:RegisterElement('equipmentset', enable, disable, update)
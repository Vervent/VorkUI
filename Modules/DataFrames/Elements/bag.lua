local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local format = format
local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local IsBagOpen = IsBagOpen
local CloseAllBags = CloseAllBags
local ToggleAllBags = ToggleAllBags

local function update(self, event)

    local totalFree, freeSlots, bagFamily = 0;
    local max = 0
    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        freeSlots, bagFamily = GetContainerNumFreeSlots(i)
        totalFree = totalFree + freeSlots
        max = max + GetContainerNumSlots(i)
    end

    if totalFree == max then
        self.Text:SetTextColor(1, 0, 0)
    else
        self.Text:SetTextColor(1, 1, 1)
    end

    self.Text:SetText(format('%d/%d',totalFree, max))

end

local function enable(self)

    self.Icon:SetTexture([[INTERFACE\ICONS\ACHIEVEMENT_GUILDPERK_BOUNTIFULBAGS]])
    self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT')

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT')

    self:RegisterForClicks('AnyUp')
    self:SetScript('OnClick', function(btn)
        if IsBagOpen(0) then
            CloseAllBags()
        else
            ToggleAllBags()
        end
    end)

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('BAG_UPDATE')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('BAG_UPDATE')
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end

DataFrames:RegisterElement('bag', enable, disable, update)
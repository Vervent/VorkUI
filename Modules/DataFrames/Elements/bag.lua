local select = select
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local format = format
local floor = floor
local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local IsBagOpen = IsBagOpen
local CloseAllBags = CloseAllBags
local ToggleAllBags = ToggleAllBags
local GetClassColor = GetClassColor

local colors = {
    [0] = { GetClassColor('MONK') },
    [1] = { GetClassColor('ROGUE') },
    [2] = { GetClassColor('DRUID') },
    [3] = { GetClassColor('DEATHKNIGHT') },
    [4] = { GetClassColor('DEATHKNIGHT') },
}

local function update(self, event)

    local totalFree, freeSlots, bagFamily = 0;
    local max = 0
    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        freeSlots, bagFamily = GetContainerNumFreeSlots(i)
        totalFree = totalFree + freeSlots
        max = max + GetContainerNumSlots(i)
    end

    local ratio = 1-totalFree/max
    local colorIdx = floor(ratio / 0.25)
    local color = colors[colorIdx]

    self.Text:SetTextColor(color[1], color[2], color[3])
    self.Text:SetText(format('%d/%d',totalFree, max))

end

local function enable(self)
    self:SetSize(80, 30)
    self.Icon:SetSize(25, 25)

    self.Icon:SetTexture([[INTERFACE\ICONS\ACHIEVEMENT_GUILDPERK_BOUNTIFULBAGS]])
    --self.Icon:SetDesaturated(false)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

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
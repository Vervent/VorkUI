local select = select
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DataFrames = Module:GetModule('DataFrames')

local format = format
local floor = floor
local min = min
local GetClassColor = GetClassColor
local GetFramerate = GetFramerate
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetNumAddOns = GetNumAddOns

local colors = {
    [0] = select(4, GetClassColor('DEATHKNIGHT')),
    [1] = select(4, GetClassColor('DRUID') ),
    [2] = select(4, GetClassColor('ROGUE') ),
    [3] = select(4, GetClassColor('MONK') ),
}

local numAddon
local memory = 0

local function memoryFormat(memory)
    if memory > 1024 then
        return format('%.1fMb', memory/1024)
    else
        return format('%dKb', memory)
    end
end

local function updateMemory()
    UpdateAddOnMemoryUsage()

    memory = 0
    for i=1, numAddon do
        memory = memory + GetAddOnMemoryUsage(i)
    end
end

local function update(self, event)

    local framerate = GetFramerate()

    local ratio = framerate/15
    local colorIdx = min( floor(ratio), 3)
    local color = colors[colorIdx]

    --self.Text:SetText(format('%.0f fps %s', framerate, memoryFormat(memory)))
    self.Text:SetText(format('|c%s%.0f|rfps', color, framerate))

end

local function enable(self)
    self:SetSize(74, 30)
    self.Icon:SetSize(25, 25)
    numAddon = GetNumAddOns()

    self.Icon:SetTexture([[Interface\AddOns\VorkUI\Medias\Icons\Statusbar\framerate]])
    self.Icon:SetPoint('LEFT', 1, 0)
    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    --C_Timer.NewTicker( 5, updateMemory )

    self:SetScript('OnUpdate', update)

end

local function disable(self)
    self:SetScript('OnUpdate', nil)
end

DataFrames:RegisterElement('framerate', enable, disable, update)
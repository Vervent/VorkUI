local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local unpack = unpack
local format = format

local function update(self, event)

    local _, stat = unpack(event)
    local meleehaste, speed, ohspeed = unpack(DataFrames.LibUnitStat:GetStat(stat))

    if speed > 0 then
        if self.Text then
            if ohspeed then
                self.Text:SetText(format('%.2f | %.2f', speed, ohspeed))
            else
                self.Text:SetText(format('%.2f', speed))
            end

        end

        if self.StatusBar then
            self.StatusBar:SetValue(meleehaste or 0)
        end
    end

end

local function enable(self)
    self:SetSize(100, 30)
    self.Icon:SetSize(25, 25)
    self.Icon:SetPoint('LEFT', 1, 0)
    --self.Icon:SetTexture('interface/icons/ability_parry')
    --self.Icon:SetTexture('interface/icons/ability_defend')
    self.Icon:SetTexture([[INTERFACE\ICONS\ABILITY_ROGUE_ROLLTHEBONES02]])
    --self.Icon:SetDesaturated(true)

    if self.Text then
        self.Text:SetPoint('TOPLEFT', self.Icon, 'TOPRIGHT', 2, 0)
        self.Text:SetJustifyH('LEFT')
    end

    if self.StatusBar then
        self.StatusBar:SetOrientation('HORIZONTAL')
        self.StatusBar:SetPoint('BOTTOMLEFT', self.Icon, 'BOTTOMRIGHT', 2, 0)
        self.StatusBar:SetPoint('RIGHT', self, 'RIGHT')
        self.StatusBar:SetHeight(self:GetHeight() * 0.2)
        self.StatusBar:SetMinMaxValues(0, 100)
    end

    self.Observer.OnNotify = function(...)
        update(self, ...)
    end
end

local function disable(self)
    self.Observer.OnNotify = nil
end

DataFrames:RegisterElement('attack_speed', enable, disable, update)
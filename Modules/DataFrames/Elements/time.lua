local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local GetCVarBool = GetCVarBool
local date = date
local GetGameTime = GetGameTime
local format = format

local function update(self, _)

    local h, m, s
    if GetCVarBool('timeMgrUseLocalTime') then
        local dateTable = date('*t')
        s = dateTable['sec']
        m = dateTable['min']
        h = dateTable['hour']
    else
        h, m = GetGameTime()
    end
    local sFormat = ''
    if GetCVarBool("timeMgrUseMilitaryTime") then
        if not s then
            sFormat = '%02d:%02d'
        else
            sFormat = '%02d:%02d:%02d'
        end
    else
        if not s then
            sFormat = '%d:%02d'
        else
            sFormat = '%d:%02d:%02d'
        end

        if h == 0 then
            h = 12
        elseif h > 12 then
            h = h - 12
        end
    end
    if not s then
        self.Text:SetText(format(sFormat, h, m))
    else
        self.Text:SetText(format(sFormat, h, m, s))
    end

end

local function enable(self)

    self:SetSize(90, 30)
    if self.Icon then
        self.Icon:SetSize(25,25)
        self.Icon:SetTexture([[INTERFACE\ICONS\SPELL_HOLY_BORROWEDTIME]])
        --self.Icon:SetDesaturated(true)
        self.Icon:SetPoint('LEFT', 1, 0)
        self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)
    else
        self.Text:SetPoint('CENTER')
    end

    self.Text:SetFontObject(Medias:GetFont('Montserrat Bold Italic14'))
    self:SetScript('OnUpdate', update)
end

local function disable(self)
    self:SetScript('OnUpdate', nil)
end

DataFrames:RegisterElement('time', enable, disable, update)
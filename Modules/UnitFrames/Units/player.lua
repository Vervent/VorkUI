local V, C, L = select(2, ...):unpack()

local LibSlant = LibStub:GetLibrary("LibSlant")

local UnitFrames = V["UnitFrames"]
local Class = select(2, UnitClass("player"))

--[[
    bg healthcolor = {0.69, 0.04, 0.04}
    gradient color = {
        full = { 0, 0.45, 0.07 },
        mid = { 1, 0.45, 0.03 },
        low = { 0, 0, 0 }
    }
    overlay color = { 0.51, 0.77, 1 }
]]--

--left, right, top, bottom
local ClassIconAtlas = {
    width = 512,
    height = 256,
    ["DEMONHUNTER"] = {0, 80, 0, 82},
    ["DEATHKNIGHT"] = {80, 158, 0, 82},
    ["DRUID"] = {158, 239, 0, 70},
    ["HUNTER"] = {239, 317, 0, 82},
    ["MAGE"] = {317, 397, 0, 80},
    ["WARLOCK"] = {397, 480, 0, 83},
    ["MONK"] = {0, 80, 83, 163},
    ["PALADIN"] = {80, 155, 83, 165},
    ["PRIEST"] = {155, 237, 83, 153},
    ["ROGUE"] = {237, 320, 83, 164},
    ["SHAMAN"] = {320, 402, 83, 163},
    ["WARRIOR"] = {402, 472, 83, 165},
}

local function GetTexCoord (class)
    local l, r, t, b = unpack(ClassIconAtlas[class])
    return l/ClassIconAtlas.width, r/ClassIconAtlas.width, t/ClassIconAtlas.height, b/ClassIconAtlas.height
end

function UnitFrames:Player()

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    local Frame = CreateFrame("Frame", nil, self)
    Frame:SetAllPoints()
    Frame.background = Frame:CreateTexture(nil, "BACKGROUND")
    Frame.background:SetAllPoints()
    Frame.background:SetColorTexture(0,0,0,1)

    --[[
       ABSORB SLANTED STATUSBAR
   --]]
    local slantAbsorb = LibSlant:CreateSlant(Frame)
    local Absorb = slantAbsorb:AddTexture("ARTWORK")
    Absorb:SetSize(232,8)
    Absorb:SetPoint("TOPRIGHT", Frame, "TOPRIGHT", 0, 0)
    Absorb:SetTexture([[Interface\AddOns\VorkUI\Medias\StatusBar\bubbles.tga]])

    Absorb.background = slantAbsorb:AddTexture("BACKGROUND", 1)
    Absorb.background:SetSize(232,8)
    Absorb.background:SetAllPoints(Absorb)
    Absorb.background:SetColorTexture(0,0,0,1)

    slantAbsorb.IgnoreBackground = true -- ignore Background layer for update
    slantAbsorb.FillInverse = true
    slantAbsorb:CalculateAutomaticSlant() -- set automatic slant if you don't want to set manually
    slantAbsorb:StaticSlant("BACKGROUND")

    Absorb.Slant = slantAbsorb
    Absorb.Override = UnitFrames.UpdateAbsorbOverride

    --[[
        HEALTH SLANTED STATUSBAR
    --]]

    local slantHealth = LibSlant:CreateSlant(Frame)
    local Health = slantHealth:AddTexture("ARTWORK")
    Health:SetSize(256,32)
    Health:SetPoint("TOPRIGHT", Absorb, "BOTTOMRIGHT", -8, 0)
    Health:SetTexture([[Interface\AddOns\VorkUI\Medias\StatusBar\status_1.tga]])

    Health.background = slantHealth:AddTexture("BACKGROUND", 1)
    Health.background:SetSize(256,32)
    Health.background:SetAllPoints(Health)
    Health.background:SetTexture([[Interface\AddOns\VorkUI\Medias\StatusBar\status_bg.tga]])

    Health.border = slantHealth:AddTexture("OVERLAY")
    --Health.border:SetSize(256,32)
    Health.border:SetAllPoints(Health)
    Health.border:SetTexture([[Interface\AddOns\VorkUI\Medias\StatusBar\status_border.tga]])

    slantHealth.IgnoreBackground = true -- ignore Background layer for update
    slantHealth:CalculateAutomaticSlant() -- set automatic slant if you don't want to set manually
    slantHealth:StaticSlant("BACKGROUND")
    Health.Slant = slantHealth

    Health.colorSmooth = true
    Health.Override = UnitFrames.UpdateHealthOverride
    Health.UpdateColor = UnitFrames.UpdateHealthColorOverride

    --[[
        HEALTH PREDICTION SLANTED STATUSBAR
    --]]
    local slantMyPrediction = LibSlant:CreateSlant(Frame)
    local MyPrediction = slantMyPrediction:AddTexture("ARTWORK", 1)
    MyPrediction:SetSize( Health:GetSize() )
    MyPrediction:SetTexture(Health:GetTexture())
    MyPrediction:SetBlendMode("ADD")

    MyPrediction.border = slantMyPrediction:AddTexture("OVERLAY")
    MyPrediction.border:SetAllPoints(MyPrediction)
    MyPrediction.border:SetTexture(Health.border:GetTexture())

    slantMyPrediction.Inverse = slantHealth.Inverse
    slantMyPrediction.FillInverse = slantHealth.FillInverse
    slantMyPrediction:CalculateAutomaticSlant()
    MyPrediction.Slant = slantMyPrediction

    local slantOtherPrediction = LibSlant:CreateSlant(Frame)
    local OtherPrediction = slantOtherPrediction:AddTexture("ARTWORK", 1)
    OtherPrediction:SetSize( Health:GetSize() )
    OtherPrediction:SetTexture(Health:GetTexture())

    OtherPrediction.border = slantOtherPrediction:AddTexture("OVERLAY")
    OtherPrediction.border:SetAllPoints(OtherPrediction)
    OtherPrediction.border:SetTexture(Health.border:GetTexture())

    slantOtherPrediction.Inverse = slantHealth.Inverse
    slantOtherPrediction.FillInverse = slantHealth.FillInverse
    slantOtherPrediction:CalculateAutomaticSlant()
    OtherPrediction.Slant = slantOtherPrediction

    self.HealthPrediction = {
        myBar = MyPrediction,
        otherBar = OtherPrediction,
        maxOverflow = 1,
    }
    self.HealthPrediction.Override = UnitFrames.UpdatePredictionOverride

    --[[
        POWER SLANTED STATUSBAR
    --]]
    local slantPower = LibSlant:CreateSlant(Frame)
    local Power = slantPower:AddTexture("ARTWORK")
    Power:SetSize(235,10)
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", -10, 0)
    Power:SetTexture([[Interface\AddOns\VorkUI\Medias\StatusBar\status_1.tga]])

    Power.background = slantPower:AddTexture("BACKGROUND", 1)
    Power.background:SetSize(240,16)
    Power.background:SetAllPoints(Power)
    Power.background:SetTexture([[Interface\AddOns\VorkUI\Medias\StatusBar\status_bg.tga]])

    slantPower.IgnoreBackground = true -- ignore Background layer for update
    slantPower:CalculateAutomaticSlant() -- set automatic slant if you don't want to set manually
    slantPower:StaticSlant("BACKGROUND")

    Power.Slant = slantPower
    Power.colorPower = true
    Power.frequentUpdates=true

    Power.Override = UnitFrames.UpdatePowerOverride
    Power.UpdateColor = UnitFrames.UpdatePowerColorOverride

    --[[
        POWER PREDICTION SLANTED STATUSBAR
    --]]
    local slantMyPowerPrediction = LibSlant:CreateSlant(Frame)
    local MyPowerPrediction = slantMyPowerPrediction:AddTexture("ARTWORK", 1)
    MyPowerPrediction:SetSize( Power:GetSize() )
    MyPowerPrediction:SetTexture(Power:GetTexture())
    MyPowerPrediction:SetBlendMode("ADD")

    slantMyPowerPrediction.Inverse = slantPower.Inverse
    slantMyPowerPrediction.FillInverse = not slantPower.FillInverse
    slantMyPowerPrediction:CalculateAutomaticSlant()
    MyPowerPrediction.Slant = slantMyPowerPrediction

    --local slantAltPowerPrediction = LibSlant:CreateSlant(Frame)
    --local AltPowerPrediction = slantAltPowerPrediction:AddTexture("ARTWORK", 1)
    --AltPowerPrediction:SetSize(256,32)
    --AltPowerPrediction:SetTexture(Health:GetTexture())
    --
    --AltPowerPrediction.border = slantAltPowerPrediction:AddTexture("OVERLAY")
    --AltPowerPrediction.border:SetAllPoints(AltPowerPrediction)
    --AltPowerPrediction.border:SetTexture(Power.border:GetTexture())
    --
    --slantAltPowerPrediction.Inverse = slantPower.Inverse
    --slantAltPowerPrediction.FillInverse = slantHealth.FillInverse
    --slantAltPowerPrediction:CalculateAutomaticSlant()
    --AltPowerPrediction.Slant = slantAltPowerPrediction

    self.PowerPrediction = {
        mainBar = MyPowerPrediction,
        --altBar = AltPowerPrediction,
    }
    self.PowerPrediction.Override = UnitFrames.UpdatePowerPredictionOverride

    --[[
        PORTRAIT 3D
    --]]

    local Portrait = CreateFrame('PlayerModel', nil, Frame)
    Portrait:SetModelDrawLayer("BACKGROUND")
    Portrait:SetSize(45, 45)
    Portrait:SetPoint("BOTTOMLEFT", Power, "BOTTOMLEFT", -20, 1)
    --Portrait:SetPortraitZoom(1)
    Portrait.PostUpdate = function(unit)
        Portrait:SetPosition(0.15,0 ,0)
        Portrait:SetRotation(-math.pi/5)
    end

    --[[
        CLASS ICON
    --]]

    local classIconPanel = Frame:CreateTexture(nil, "ARTWORK")
    classIconPanel:SetSize(20, 25)
    classIconPanel:SetPoint("BOTTOMLEFT", Portrait, "BOTTOMLEFT",0 , -1)
    classIconPanel:SetTexture([[Interface\AddOns\VorkUI\Medias\Icons\mask.tga]])

    local classIcon = Frame:CreateTexture(nil, "OVERLAY")
    classIcon:SetSize(16, 16)
    classIcon:SetPoint("BOTTOMLEFT", classIconPanel, "BOTTOMLEFT", -4, -4)
    classIcon:SetTexture([[Interface\AddOns\VorkUI\Medias\Icons\Class\atlas.tga]])
    classIcon:SetTexCoord(GetTexCoord(Class))

    -- Register with oUF
    self.Absorb = Absorb
    self.Absorb.bg = Absorb.background
    self.Health = Health
    self.Health.bg = Health.background
    self.Power = Power
    self.Power.bg = Power.background

    self.Portrait = Portrait
    self.Portrait.bg = Portrait.background

    self.ClassIcon = classIcon
    self.ClassIcon.bg = classIconPanel

    --affect same frame level for PlayerModel than the PlayerFrame
    Portrait:SetFrameLevel(Frame:GetFrameLevel())
    self.Frame = Frame

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end

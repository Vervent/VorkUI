local V, C, L = select(2, ...):unpack()

local LibSlant = LibStub:GetLibrary("LibSlant")

local UnitFrames = V["UnitFrames"]
local Class = select(2, UnitClass("target"))

function UnitFrames:Target()

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)


    --[[
        HEALTH SLANTED STATUSBAR
    --]]

    local slantHealth = LibSlant:CreateSlant(self)
    local Health = slantHealth:AddTexture("ARTWORK")
    Health:SetSize(256,32)
    Health:SetPoint("TOPLEFT", self, "TOPLEFT",0, 0)
    Health:SetTexture([[Interface\AddOns\VorkUI\Medias\default_statusbar.tga]])

    Health.background = slantHealth:AddTexture("BACKGROUND")
    Health.background:SetSize(256,32)
    Health.background:SetAllPoints(Health)
    Health.background:SetColorTexture(0,0,0,1)

    slantHealth.IgnoreBackground = true -- ignore Background layer for update
    slantHealth.Inverse = true
    slantHealth:CalculateAutomaticSlant() -- set automatic slant if you don't want to set manually
    slantHealth:StaticSlant("BACKGROUND")
    --slant:Slant(0, 1)
    Health.Slant = slantHealth
    Health.colorSmooth = true
    --Health.colorDisconnected = true
    --Health.colorClass = true

    Health.Override = UnitFrames.UpdateHealthOverride
    Health.UpdateColor = UnitFrames.UpdateHealthColorOverride

    --[[
        POWER SLANTED STATUSBAR
    --]]
    local slantPower = LibSlant:CreateSlant(self)
    local Power = slantPower:AddTexture("ARTWORK")
    Power:SetSize(240,16)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 15, 0)
    Power:SetTexture([[Interface\AddOns\VorkUI\Medias\absorb3.tga]])

    Power.background = slantPower:AddTexture("BACKGROUND")
    Power.background:SetSize(240,16)
    Power.background:SetAllPoints(Power)
    Power.background:SetColorTexture(0,0,0,1)

    slantPower.IgnoreBackground = true -- ignore Background layer for update
    slantPower.Inverse = true
    slantPower:CalculateAutomaticSlant() -- set automatic slant if you don't want to set manually
    slantPower:StaticSlant("BACKGROUND")

    Power.Slant = slantPower
    Power.colorPower = true
    Power.frequentUpdates=true

    Power.Override = UnitFrames.UpdatePowerOverride
    Power.UpdateColor = UnitFrames.UpdatePowerColorOverride

    --[[
        ABSORB SLANTED STATUSBAR
    --]]
    local slantAbsorb = LibSlant:CreateSlant(self)
    local Absorb = slantAbsorb:AddTexture("ARTWORK")
    Absorb:SetSize(232,8)
    Absorb:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", -31, 0)
    Absorb:SetTexture([[Interface\AddOns\VorkUI\Medias\absorb3.tga]])

    Absorb.background = slantAbsorb:AddTexture("BACKGROUND")
    Absorb.background:SetSize(232,8)
    Absorb.background:SetAllPoints(Absorb)
    Absorb.background:SetColorTexture(0,0,0,1)

    slantAbsorb.IgnoreBackground = true -- ignore Background layer for update
    slantAbsorb.Inverse = true
    slantAbsorb.FillInverse = true
    slantAbsorb:CalculateAutomaticSlant() -- set automatic slant if you don't want to set manually
    slantAbsorb:StaticSlant("BACKGROUND")

    Absorb.Slant = slantAbsorb
    Absorb.Override = UnitFrames.UpdateAbsorbOverride

    -- Register with oUF
    self.Absorb = Absorb
    self.Absorb.bg = Absorb.background
    self.Health = Health
    self.Health.bg = Health.background
    self.Power = Power
    self.Power.bg = Power.background

    self.Panel = Panel

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end

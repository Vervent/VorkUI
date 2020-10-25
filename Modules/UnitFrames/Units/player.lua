---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by flori.
--- DateTime: 19/10/2020 23:53
---

local V, C, L = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]
local Class = select(2, UnitClass("player"))

function UnitFrames:Player()

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)


    --[[
        HEALTH SLANTED STATUSBAR
    --]]
    local size = {256, 32}
    local Health = self:CreateTexture(nil, "ARTWORK")
    Health:SetSize(unpack(size))
    Health:SetPoint("TOPLEFT", self, "TOPLEFT")
    Health:SetTexture([[Interface\AddOns\VorkUI\Medias\slantedTest.tga]])

    Health.background = self:CreateTexture(nil, "BACKGROUND")
    Health.background:SetSize(256,32)
    Health.background:SetAllPoints(Health)
    Health.background:SetTexture([[Interface\AddOns\VorkUI\Medias\slantedTest.tga]])
    Health.background:SetColorTexture(0,0,0,1)

    Health.colorDisconnected = true
    Health.colorClass = true
    Health.colorReaction = true
    Health.animTexture = true
    Health.slant = size[2] / size[1]

    --[[
        POWER SLANTED STATUSBAR
    --]]
    size = {240, 16}
    local Power = self:CreateTexture(nil, "ARTWORK")
    Power:SetSize(unpack(size))
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", -15, 0)
    Power:SetTexture([[Interface\AddOns\VorkUI\Medias\slantedTest.tga]])

    Power.background = self:CreateTexture(nil, "BACKGROUND")
    Power.background:SetSize(228,16)
    Power.background:SetAllPoints(Power)
    Power.background:SetTexture([[Interface\AddOns\VorkUI\Medias\slantedTest.tga]])
    Power.background:SetColorTexture(0,0,0,1)

    Power.colorPower = true
    Power.animTexture = true
    Power.frequentUpdates=true
    Power.slant = size[2] / size[1]

    -- Register with oUF
    self.SlantHealth = Health
    self.SlantHealth.bg = Health.background

    self.SlantPower = Power
    self.SlantPower.bg = Power.background

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end

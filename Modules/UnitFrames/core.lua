---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by flori.
--- DateTime: 19/10/2020 23:54
---

local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...
local oUF = Plugin.oUF or oUF
local Noop = function() end
local UnitFrames = V["UnitFrames"]
local LibSlant = LibStub:GetLibrary("LibSlant")

-- Lib globals
local strfind = strfind
local format = format
local floor = floor

-- WoW globals (I don't really wanna import all the funcs we use here, so localize the ones called a LOT, like in Health/Power functions)
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsFriend = UnitIsFriend
local UnitIsConnected = UnitIsConnected
local UnitPlayerControlled = UnitPlayerControlled
local UnitIsGhost = UnitIsGhost
local UnitIsDead = UnitIsDead
local UnitPowerType = UnitPowerType

UnitFrames.oUF = oUF
UnitFrames.Units = {}
UnitFrames.Headers = {}

UnitFrames.HighlightBorder = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    insets = {top = -2, left = -2, bottom = -2, right = -2}
}

UnitFrames.AddClassFeatures = {}

UnitFrames.NameplatesVariables = {
    nameplateMaxAlpha = 1,
    nameplateMinAlpha = 1,
    nameplateSelectedAlpha = 1,
    nameplateNotSelectedAlpha = 1,
    nameplateMaxScale = 1,
    nameplateMinScale = 1,
    nameplateSelectedScale = 1,
    nameplateSelfScale = 1,
    nameplateSelfAlpha = 1,
    nameplateOccludedAlphaMult = 1,
}

function UnitFrames:DisableBlizzard()
end

function UnitFrames:ShortPercent(precision)
    if not precision or precision <= 0 then
        return string.format("%d", self)
    else
        return string.format("%."..precision.."f", self)
    end
end

function UnitFrames:ShortValue()
    if self <= 999 then
        return self
    end

    local Value

    if self >= 1000000 then
        Value = format("%.1fm", self / 1000000)
        return Value
    elseif self >= 1000 then
        Value = format("%.1fk", self / 1000)
        return Value
    end
end

function UnitFrames:UTF8Sub(i, dots)
    if not self then return end

    local Bytes = self:len()
    if (Bytes <= i) then
        return self
    else
        local Len, Pos = 0, 1
        while(Pos <= Bytes) do
            Len = Len + 1
            local c = self:byte(Pos)
            if (c > 0 and c <= 127) then
                Pos = Pos + 1
            elseif (c >= 192 and c <= 223) then
                Pos = Pos + 2
            elseif (c >= 224 and c <= 239) then
                Pos = Pos + 3
            elseif (c >= 240 and c <= 247) then
                Pos = Pos + 4
            end
            if (Len == i) then break end
        end

        if (Len == i and Pos <= Bytes) then
            return self:sub(1, Pos - 1)..(dots and "..." or "")
        else
            return self
        end
    end
end

--[[
* textures - table of this form { path or color, layer, sublayer }
--]]
function UnitFrames:CreateSlantedStatusBar(frame, textures, size, point, slantSettings, staticLayer)
    local slant = LibSlant:CreateSlant(frame)
    local result = nil
    local texture
    for _, t in ipairs(textures) do
        texture = slant:AddTexture(t[2], t[3])
        texture:SetSize(unpack(size))

        if result == nil then
            if point ~= nil then
                texture:SetPoint(unpack(point))
            end
        else
            texture:SetAllPoints(result)
        end

        if type(t[1]) == 'table' then
            texture:SetColorTexture(unpack(t[1]))
        elseif type(t[1]) == 'string' then
            texture:SetTexture(t[1])
        else
            print("|cFFFF2200 ERROR CreateSlantedStatusBar |r")
        end
        if result == nil then
            result = texture
            result.childs = {}
        else
            result.childs[#result.childs+1] = texture
        end
    end

    for k,v in pairs(slantSettings) do
        slant[k]=v
    end

    slant:CalculateAutomaticSlant()
    if staticLayer then
        slant:StaticSlant(staticLayer)
    end
    result.Slant = slant
    return result
end

function UnitFrames:UpdatePowerPredictionOverride(event, unit)
    if(self.unit ~= unit) then return end

    local element = self.PowerPrediction

    --[[ Callback: PowerPrediction:PreUpdate(unit)
    Called before the element has been updated.

    * self - the PowerPrediction element
    * unit - the unit for which the update has been triggered (string)
    --]]
    if(element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local colors = self.colors.prediction

    local _, _, _, startTime, endTime, _, _, _, spellID = UnitCastingInfo(unit)
    local mainPowerType = UnitPowerType(unit)
    local hasAltManaBar = ALT_MANA_BAR_PAIR_DISPLAY_INFO[playerClass] and ALT_MANA_BAR_PAIR_DISPLAY_INFO[playerClass][mainPowerType]
    local mainCost, altCost = 0, 0

    if(event == 'UNIT_SPELLCAST_START' and startTime ~= endTime) then
        local costTable = GetSpellPowerCost(spellID)
        for _, costInfo in next, costTable do
            -- costInfo content:
            -- - name: string (powerToken)
            -- - type: number (powerType)
            -- - cost: number
            -- - costPercent: number
            -- - costPerSec: number
            -- - minCost: number
            -- - hasRequiredAura: boolean
            -- - requiredAuraID: number
            if(costInfo.type == mainPowerType) then
                mainCost = costInfo.cost

                break
            elseif(costInfo.type == ADDITIONAL_POWER_BAR_INDEX) then
                altCost = costInfo.cost

                break
            end
        end
    end

    if(element.mainBar) then
        --We need to align Point using TexCoord cause of slant mechanism
        if not element.mainBar.Slant.FillInverse then
            local left = select(7 ,self.Power:GetTexCoord())
            element.mainBar:SetPoint("TOPLEFT", self.Power, "TOPLEFT", left*element.mainBar:GetWidth(), 0)
        else
            local right = select(5 ,self.Power:GetTexCoord())
            element.mainBar:SetPoint("TOPRIGHT", self.Power, "TOPLEFT", right*element.mainBar:GetWidth(), 0)
        end
        element.mainBar.Slant:Slant(0, mainCost/UnitPowerMax(unit, mainPowerType))
        element.mainBar:SetVertexColor( unpack(colors.power) )
        element.mainBar:Show()
    end

    if(element.altBar and hasAltManaBar) then
        --We need to align Point using TexCoord cause of slant mechanism
        if not element.altBar.Slant.FillInverse then
            local left = select(7 ,self.AltPower:GetTexCoord())
            element.altBar:SetPoint("TOPLEFT", self.AltPower, "TOPLEFT", left*256, 0)
        else
            local right = select(5 ,self.AltPower:GetTexCoord())
            element.altBar:SetPoint("TOPRIGHT", self.AltPower, "TOPLEFT", right*256, 0)
        end
        element.altBar.Slant:Slant(0, altCost/UnitPowerMax(unit, ADDITIONAL_POWER_BAR_INDEX))
        element.altBar:SetVertexColor( unpack(colors.altPower) )
        element.altBar:Show()
    end

    --[[ Callback: PowerPrediction:PostUpdate(unit, mainCost, altCost, hasAltManaBar)
    Called after the element has been updated.

    * self          - the PowerPrediction element
    * unit          - the unit for which the update has been triggered (string)
    * mainCost      - the main power type cost of the cast ability (number)
    * altCost       - the secondary power type cost of the cast ability (number)
    * hasAltManaBar - indicates if the unit has a secondary power bar (boolean)
    --]]
    if(element.PostUpdate) then
        return element:PostUpdate(unit, mainCost, altCost, hasAltManaBar)
    end
end

function UnitFrames:UpdatePredictionOverride(event, unit)
    if(self.unit ~= unit) then return end

    local element = self.HealthPrediction

    --[[ Callback: HealthPrediction:PreUpdate(unit)
    Called before the element has been updated.

    * self - the HealthPrediction element
    * unit - the unit for which the update has been triggered (string)
    --]]
    if(element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local colors = self.colors.prediction

    local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

    local absorb = UnitGetTotalAbsorbs(unit) or 0
    local healAbsorb = UnitGetTotalHealAbsorbs(unit) or 0
    local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
    local otherIncomingHeal = 0
    local hasOverHealAbsorb = false

    if(healAbsorb > allIncomingHeal) then
        healAbsorb = healAbsorb - allIncomingHeal
        allIncomingHeal = 0
        myIncomingHeal = 0

        if(health < healAbsorb) then
            hasOverHealAbsorb = true
            healAbsorb = health
        end
    else
        allIncomingHeal = allIncomingHeal - healAbsorb
        healAbsorb = 0

        if(health + allIncomingHeal > maxHealth * element.maxOverflow) then
            allIncomingHeal = maxHealth * element.maxOverflow - health
        end

        if(allIncomingHeal < myIncomingHeal) then
            myIncomingHeal = allIncomingHeal
        else
            otherIncomingHeal = allIncomingHeal - myIncomingHeal
        end
    end

    local hasOverAbsorb = false
    if(health + allIncomingHeal + absorb >= maxHealth) then
        if(absorb > 0) then
            hasOverAbsorb = true
        end

        absorb = math.max(0, maxHealth - health - allIncomingHeal)
    end

    if(element.myBar) then
        --We need to align Point using TexCoord cause of slant mechanism
        if not element.myBar.Slant.FillInverse then
            local left = select(7 ,self.Health:GetTexCoord())
            element.myBar:SetPoint("TOPLEFT", self.Health, "TOPLEFT", left*256, 0)
        else
            local right = select(5 ,self.Health:GetTexCoord())
            element.myBar:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", right*256, 0)
        end
        element.myBar.Slant:Slant(0, myIncomingHeal/maxHealth)
        element.myBar:SetVertexColor( unpack(colors.myHeal) )
        element.myBar:Show()
    end

    if(element.otherBar) then
        if not element.otherBar.Slant.FillInverse then
            local left = select(7 , element.myBar:GetTexCoord())
            element.otherBar:SetPoint("TOPLEFT", element.myBar, "TOPLEFT", left*256, 0)
        else
            local right = select(5 , element.myBar:GetTexCoord())
            element.otherBar:SetPoint("TOPRIGHT",element.myBar, "TOPLEFT", right*256, 0)
        end
        element.otherBar.Slant:Slant(0, otherIncomingHeal/maxHealth)
        element.otherBar:SetVertexColor( unpack(colors.otherHeal) )
        element.otherBar:Show()
    end

    --[[ Callback: HealthPrediction:PostUpdate(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
    Called after the element has been updated.

    * self              - the HealthPrediction element
    * unit              - the unit for which the update has been triggered (string)
    * myIncomingHeal    - the amount of incoming healing done by the player (number)
    * otherIncomingHeal - the amount of incoming healing done by others (number)
    * absorb            - the amount of damage the unit can absorb without losing health (number)
    * healAbsorb        - the amount of healing the unit can absorb without gaining health (number)
    * hasOverAbsorb     - indicates if the amount of damage absorb is higher than the unit's missing health (boolean)
    * hasOverHealAbsorb - indicates if the amount of heal absorb is higher than the unit's current health (boolean)
    --]]
    if(element.PostUpdate) then
        return element:PostUpdate(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
    end
end

function UnitFrames:UpdateAbsorbOverride(event, unit)
    if(not unit or self.unit ~= unit) then return end
    local element = self.Absorb

    --[[ Callback: Absorb:PreUpdate(unit)
    Called before the element has been updated.

    * self - the Absorb element
    * unit - the unit for which the update has been triggered (string)
    --]]
    if(element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local curDamageAbsorb = UnitGetTotalAbsorbs(unit)
    local curHealAbsorb = UnitGetTotalHealAbsorbs(unit)
    local cur

    if curDamageAbsorb > curHealAbsorb then
        element.colors = self.colors.absorbs.damageAbsorb
        cur = curDamageAbsorb - curHealAbsorb
    else
        element.colors = self.colors.absorbs.healAbsorb
        cur = curHealAbsorb - curDamageAbsorb
    end

    local max = UnitHealthMax(unit)

    if(UnitIsConnected(unit)) then
        element.Slant:Slant(0, cur/max);
    else
        element.Slant:Slant(0, 1);
    end

    element.cur = cur
    element.max = max

    --[[ Callback: Absorb:PostUpdate(unit, cur, max)
    Called after the element has been updated.

    * self - the Health element
    * unit - the unit for which the update has been triggered (string)
    * cur  - the unit's current health value (number)
    * max  - the unit's maximum possible health value (number)
    --]]
    if(element.PostUpdate) then
        element:PostUpdate(unit, cur, max)
    end
end

function UnitFrames:UpdatePowerOverride(event, unit)
    if(self.unit ~= unit) then return end
    local element = self.Power

    --[[ Callback: Power:PreUpdate(unit)
    Called before the element has been updated.

    * self - the Power element
    * unit - the unit for which the update has been triggered (string)
    --]]
    if(element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local displayType, min
    if(element.displayAltPower) then
        displayType, min = element:GetDisplayPower()
    end

    local cur, max = UnitPower(unit, displayType), UnitPowerMax(unit, displayType)

    if(UnitIsConnected(unit)) and max ~= 0 then
        element.Slant:Slant(0, cur/max);
    else
        element.Slant:Slant(0, 1);
    end

    element.cur = cur
    element.min = min
    element.max = max
    element.displayType = displayType

    --[[ Callback: Power:PostUpdate(unit, cur, min, max)
    Called after the element has been updated.

    * self - the Power element
    * unit - the unit for which the update has been triggered (string)
    * cur  - the unit's current power value (number)
    * min  - the unit's minimum possible power value (number)
    * max  - the unit's maximum possible power value (number)
    --]]
    if(element.PostUpdate) then
        element:PostUpdate(unit, cur, min, max)
    end
end

function UnitFrames:UpdatePowerColorOverride(event, unit)
    if(self.unit ~= unit) then return end
    local element = self.Power

    local pType, pToken, altR, altG, altB = UnitPowerType(unit)

    local r, g, b, t
    if(element.colorDisconnected and not UnitIsConnected(unit)) then
        t = self.colors.disconnected
    elseif(element.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
        t = self.colors.tapped
    elseif(element.colorThreat and not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit)) then
        t =  self.colors.threat[UnitThreatSituation('player', unit)]
    elseif(element.colorPower) then
        if(element.displayType ~= ALTERNATE_POWER_INDEX) then
            t = self.colors.power[pToken]
            if(not t) then
                if(element.GetAlternativeColor) then
                    r, g, b = element:GetAlternativeColor(unit, pType, pToken, altR, altG, altB)
                elseif(altR) then
                    r, g, b = altR, altG, altB
                    if(r > 1 or g > 1 or b > 1) then
                        -- BUG: As of 7.0.3, altR, altG, altB may be in 0-1 or 0-255 range.
                        r, g, b = r / 255, g / 255, b / 255
                    end
                else
                    t = self.colors.power[pType] or self.colors.power.MANA
                end
            end
        else
            t = self.colors.power[ALTERNATE_POWER_INDEX]
        end
    elseif(element.colorClass and UnitIsPlayer(unit))
            or (element.colorClassNPC and not UnitIsPlayer(unit))
            or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
        local _, class = UnitClass(unit)
        t = self.colors.class[class]
    elseif(element.colorSelection and unitSelectionType(unit, element.considerSelectionInCombatHostile)) then
        t = self.colors.selection[unitSelectionType(unit, element.considerSelectionInCombatHostile)]
    elseif(element.colorReaction and UnitReaction(unit, 'player')) then
        t = self.colors.reaction[UnitReaction(unit, 'player')]
    elseif(element.colorSmooth) then
        local adjust = 0 - (element.min or 0)
        r, g, b = self:ColorGradient((element.cur or 1) + adjust, (element.max or 1) + adjust, unpack(element.smoothGradient or self.colors.smooth))
    end

    if(t) then
        r, g, b = t[1], t[2], t[3]
    end

    if(b) then
        element:SetVertexColor(r, g, b)

        local bg = element.bg
        if(bg) then
            local mu = bg.multiplier or 1
            bg:SetVertexColor(r * mu, g * mu, b * mu)
        end
    end

    --[[ Callback: Power:PostUpdateColor(unit, r, g, b)
    Called after the element color has been updated.

    * self - the Power element
    * unit - the unit for which the update has been triggered (string)
    * r    - the red component of the used color (number)[0-1]
    * g    - the green component of the used color (number)[0-1]
    * b    - the blue component of the used color (number)[0-1]
    --]]
    if(element.PostUpdateColor) then
        element:PostUpdateColor(unit, r, g, b)
    end
end

function UnitFrames:UpdateHealthOverride(event, unit)
    if(not unit or self.unit ~= unit) then
        return
    end
    local element = self.Health

    if(element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local cur, max = UnitHealth(unit), UnitHealthMax(unit)

    if(UnitIsConnected(unit)) then
        element.Slant:Slant(0, cur/max);
    else
        element.Slant:Slant(0, 1);
    end

    element.cur = cur
    element.max = max

    if(element.PostUpdate) then
        element:PostUpdate(unit, cur, max)
    end
end

function UnitFrames:UpdateHealthColorOverride(event, unit)
    if(not unit or self.unit ~= unit)
    then
        return
    end
    local element = self.Health

    local r, g, b, t
    if(element.colorDisconnected and not UnitIsConnected(unit)) then
        t = self.colors.disconnected
        --print ("colorDisconnected")
    elseif(element.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
        t = self.colors.tapped
        --print ("colorTapping")
    elseif(element.colorThreat and not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit)) then
        t =  self.colors.threat[UnitThreatSituation('player', unit)]
        --print ("colorThreat")
    elseif(element.colorClass and UnitIsPlayer(unit))
            or (element.colorClassNPC and not UnitIsPlayer(unit))
            or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
        local _, class = UnitClass(unit)
        t = self.colors.class[class]
        --print ("colorClass")
    elseif(element.colorSelection and unitSelectionType(unit, element.considerSelectionInCombatHostile)) then
        t = self.colors.selection[unitSelectionType(unit, element.considerSelectionInCombatHostile)]
        --print ("colorSelection")
    elseif(element.colorReaction and UnitReaction(unit, 'player')) then
        t = self.colors.reaction[UnitReaction(unit, 'player')]
        --print ("colorReaction")
    elseif(element.colorSmooth) then
        r, g, b = self:ColorGradient(element.cur or 1, element.max or 1, unpack(element.smoothGradient or self.colors.smooth))
        --print ("colorSmooth")
    elseif(element.colorHealth) then
        t = self.colors.health
        --print ("colorHealth")
    end

    if(t) then
        r, g, b = t[1], t[2], t[3]
    end

    if(b) then
        --element:SetStatusBarColor(r, g, b)

        element:SetVertexColor(r, g, b)

        local bg = element.bg
        if(bg) then
            local mu = bg.multiplier or 1
            bg:SetVertexColor(r * mu, g * mu, b * mu)
        end
    end

    --[[ Callback: Health:PostUpdateColor(unit, r, g, b)
    Called after the element color has been updated.

    * self - the Health element
    * unit - the unit for which the update has been triggered (string)
    * r    - the red component of the used color (number)[0-1]
    * g    - the green component of the used color (number)[0-1]
    * b    - the blue component of the used color (number)[0-1]
    --]]
    if(element.PostUpdateColor) then
        element:PostUpdateColor(unit, r, g, b)
    end
end

function UnitFrames:MouseOnPlayer()

end

function UnitFrames:Highlight()

end

function UnitFrames:PostCreateAuraBar(bar)

end

function UnitFrames:UpdateBuffsHeaderPosition(height)

end

function UnitFrames:UpdateDebuffsHeaderPosition()

end

function UnitFrames:CustomCastTimeText(duration)

end

function UnitFrames:CustomCastDelayText(duration)

end

function UnitFrames:CheckInterrupt(unit)

end

function UnitFrames:CheckCast(unit, name, rank, castid)

end

function UnitFrames:CheckChannel(unit, name, rank)

end



function UnitFrames:PreUpdateHealth(unit)

end

function UnitFrames:DisplayPlayerAndPetNames(event)

end

function UnitFrames:PostUpdateHealth(unit, min, max)

    if self.Value then
        if (not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then
            if (not UnitIsConnected(unit)) then
                self.Value:SetText("|cffD7BEA5"..FRIENDS_LIST_OFFLINE.."|r")
            elseif (UnitIsDead(unit)) then
                self.Value:SetText("|cffD7BEA5"..DEAD.."|r")
            elseif (UnitIsGhost(unit)) then
                self.Value:SetText("|cffD7BEA5"..L.UnitFrames.Ghost.."|r")
            end
        else
            local IsRaid = string.match(self:GetParent():GetName(), "Button") or false

            if (min == max) then
                self.Value:SetText("")
            else
                self.Value:SetText(UnitFrames.ShortValue(min))
            end
        end
    end

    if self.Percent then
        if (not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then
            return
        else
            local IsRaid = string.match(self:GetParent():GetName(), "Button") or false

            if (min == max) then
                self.Percent:SetText("")
            else
                self.Percent:SetText(UnitFrames.ShortPercent(min/max *100))
            end
        end
    end

end

function UnitFrames:UpdateAltPower(minimum, current, maximum)

end

function UnitFrames:SetAuraTimer(elapsed)

end

function UnitFrames:CancelPlayerBuff(index)

end

function UnitFrames:PostCreateAura(button)

end

function UnitFrames:PostUpdateAura(unit, button, index, offset, filter, isDebuff, duration, timeLeft)

end

function UnitFrames:Update()
    for _, element in ipairs(self.__elements) do
        element(self, "UpdateElement", self.unit)
    end
end

function UnitFrames:DisplayNameplatePowerAndCastBar(unit, cur, min, max)

end

function UnitFrames:RunesPostUpdate(runemap)

end

function UnitFrames:UpdateTotemTimer(elapsed)

end

function UnitFrames:UpdateTotemOverride(event, slot)

end

function UnitFrames:GetPartyFramesAttributes()
    return
   ""
end

function UnitFrames:GetPetPartyFramesAttributes()
    return
   ""
end

function UnitFrames:GetRaidFramesAttributes()

    return
   ""
end

function UnitFrames:GetPetRaidFramesAttributes()
  return ""
end

function UnitFrames:Style(unit)
    if (not unit) then
        return
    end

    local Parent = self:GetParent():GetName()

    if (unit == "player") then
        UnitFrames.Player(self)
    elseif (unit == "target") then
        UnitFrames.Target(self)
    end

    return self
end

function UnitFrames:CreateUnits()

    local Player = oUF:Spawn("player", "VorkuiPlayerFrame")
    Player:SetPoint("CENTER", nil, "CENTER", -235, 0)
    Player:SetSize(300, 60)

    local Target = oUF:Spawn("target", "VorkuiTargetFrame")
    Target:SetPoint("CENTER", nil, "CENTER", 235, 0)
    Target:SetSize(256, 60)

    self.Units.Player = Player
    self.Units.Target = Target

end

function UnitFrames:UpdateRaidDebuffIndicator()

end

function UnitFrames:Enable()

    oUF:RegisterStyle("Vorkui", UnitFrames.Style)
    oUF:SetActiveStyle("Vorkui")

    self:CreateUnits()
end

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by flori.
--- DateTime: 01/11/2020 14:19
---

local _, ns = ...
local oUF = ns.oUF

oUF.Tags.Events['Vorkui:PerHP'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags.Methods['Vorkui:PerHP'] = function(unit)
    local max = UnitHealthMax(unit)
    local cur = UnitHealth(unit)
    if (max == 0) then
        return 0
    elseif cur == max then
        return ''
    else
        local result = math.floor(cur / max * 100 + .5)
        if result > 0 then
            return result
        else
            return ''
        end
    end
end

oUF.Tags.Events['Vorkui:HealthColor'] = 'UNIT_HEALTH'
oUF.Tags.Methods['Vorkui:HealthColor'] = function(unit, _, smooth)
    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    if smooth and smooth == 'true' then
        r, g, b = oUF.ColorGradient(_, cur or 1, max or 1, unpack(oUF.colors.smoothGradient or oUF.colors.smooth))
        return Hex(r, g, b)
    else
        return Hex(1, 1, 1)
    end
end

oUF.Tags.Events['Vorkui:AbsorbColor'] = 'UNIT_ABSORB_AMOUNT_CHANGED UNIT_HEAL_ABSORB_AMOUNT_CHANGED'
oUF.Tags.Methods['Vorkui:AbsorbColor'] = function(unit)

    local curDamageAbsorb = UnitGetTotalAbsorbs(unit)
    local curHealAbsorb = UnitGetTotalHealAbsorbs(unit)

    if curDamageAbsorb > curHealAbsorb then
        return Hex(unpack(oUF.colors.absorbs.damageAbsorb or {1,1,1}))
    else
        return Hex(unpack(oUF.colors.absorbs.healAbsorb or {1,1,1}))
    end
end

oUF.Tags.Events['Vorkui:Absorb'] = 'UNIT_ABSORB_AMOUNT_CHANGED UNIT_HEAL_ABSORB_AMOUNT_CHANGED'
oUF.Tags.Methods['Vorkui:Absorb'] = function(unit)
    local curDamageAbsorb = UnitGetTotalAbsorbs(unit)
    local curHealAbsorb = UnitGetTotalHealAbsorbs(unit)

    local val = math.max(curDamageAbsorb, curHealAbsorb) - math.min(curDamageAbsorb, curHealAbsorb)
    if val > 0 then
        return "("..val..")"
    else
        return ""
    end
end

oUF.Tags.Events['Vorkui:Deficit:Curhp'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags.Methods['Vorkui:Deficit:Curhp'] = function(unit)

    if not UnitIsFriend("player", unit) == true then
        return UnitHealth(unit)
    else
        local max = UnitHealthMax(unit)
        local deficit = max - UnitHealth(unit)
        if deficit > 0 and deficit < max-1 then
            return deficit
        else
            return ""
        end
    end

end

oUF.Tags.Events['Vorkui:Deficit:Curhp-Max'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags.Methods['Vorkui:Deficit:Curhp-Max'] = function(unit)
    local cur, max = UnitHealth(unit), UnitHealthMax(unit)

    if cur == 0 then
        return ""
    end

    if not UnitIsFriend("player", unit) == true then
        return cur.." | "..max
    else
        local deficit =  max - cur
        if deficit > 0 then
            return deficit
        else
            return ""
        end
    end

end

oUF.Tags.Methods['Vorkui:Name'] = function(unit, realUnit, ...)
    local name = _TAGS['name'](unit, realUnit)
    local length = tonumber(... or 0)
    if length > 0 then
        return name:sub(1, length) -- please note, this code doesn't support UTF-8 chars
    else
        return name
    end
end
oUF.Tags.Events['Vorkui:Name'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Vorkui:FirstName'] = function(unit, realUnit, ...)
    local name = _TAGS['name'](unit, realUnit)
    local firstname = strmatch(name, '(%a+)$')
    local length = tonumber(... or 0)
    if length > 0 then
        return firstname:sub(1, length) -- please note, this code doesn't support UTF-8 chars
    else
        return firstname
    end
end
oUF.Tags.Events['Vorkui:FirstName'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Vorkui:SmartName'] = function(unit, realUnit, ...)
    local name = _TAGS['name'](unit, realUnit)
    local length = tonumber(... or 0)

    if length > 0 then
        if strlen(name) > length then
            local n = strmatch(name, '(%a+)$') or name
            return n:sub(1, length)
        else
            return name
        end
    else
        return name
    end
end
oUF.Tags.Events['Vorkui:SmartName'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Vorkui:SmartLevel'] = function(unit)
    local l = UnitLevel(unit)
    if(UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then
        l = UnitBattlePetLevel(unit)
    end

    if (l > 0 and l < 60) then
        return l
    elseif (l <= 0) then
        return '??'
    end
end
oUF.Tags.Events['Vorkui:SmartLevel'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'
--[[
	local LibUnitStat = LibStub:GetLibrary("LibUnitStat")
	if (not LibUnitStat) then return end

	LibUnitStat:AddStats('STRENGTH', 'STAMINA')
	LibUnitStat:AddStat('INTELLECT')
	LibUnitStat:RemoveStat('STRENGTH')
	LibUnitStat:RemoveStats('INTELLECT')
	LibUnitStat:ClearStats()

	LibUnitStat:GetStat('STAMINA')
	LibUnitStat:GetStat('stamina')
	LibUnitStat:GetAllStats()

    LibUnitStat:Enable()
    LibUnitStat:Disable()
--]]
local LibStub = LibStub

local LibUnitStat = LibStub:NewLibrary("LibUnitStat", 1)

if not LibUnitStat then
    return
end

local LibObserver = LibStub:GetLibrary('LibObserver')

local CreateFrame = CreateFrame
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local UnitStat = UnitStat
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPowerType = UnitPowerType
local UnitPowerMax = UnitPowerMax
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetAverageItemLevel = GetAverageItemLevel
local C_PaperDollInfo = C_PaperDollInfo
local GetUnitSpeed = GetUnitSpeed
local GetSpellCritChance = GetSpellCritChance
local GetRangedCritChance = GetRangedCritChance
local GetCritChance = GetCritChance
local GetHaste = GetHaste
local GetMasteryEffect = GetMasteryEffect
local GetVersatilityBonus = GetVersatilityBonus
local GetLifesteal = GetLifesteal
local GetAvoidance = GetAvoidance
local GetSpeed = GetSpeed
local UnitAttackSpeed = UnitAttackSpeed
local IsRangedWeapon = IsRangedWeapon
local UnitDamage = UnitDamage
local UnitRangedDamage = UnitRangedDamage
local GetSpellBonusDamage = GetSpellBonusDamage
local GetSpellBonusHealing = GetSpellBonusHealing
local UnitAttackPower = UnitAttackPower
local UnitRangedAttackPower = UnitRangedAttackPower
local GetMeleeHaste = GetMeleeHaste
local GetPowerRegen = GetPowerRegen
local GetRuneCooldown = GetRuneCooldown
local UnitHasMana = UnitHasMana
local GetManaRegen = GetManaRegen
local UnitArmor = UnitArmor
local UnitEffectiveLevel = UnitEffectiveLevel
local GetDodgeChance = GetDodgeChance
local GetParryChance = GetParryChance
local GetBlockChance = GetBlockChance
local GetShieldBlock = GetShieldBlock
local GetSpellCooldown = GetSpellCooldown

local SPEC_MONK_MISTWEAVER = SPEC_MONK_MISTWEAVER
local MAX_SPELL_SCHOOLS = MAX_SPELL_SCHOOLS

local strupper = strupper
local floor = floor
local unpack = unpack
local frame = CreateFrame('Frame')

---@param fct function the basic function to call to get value, coeff
---@param ratingKey number the rating value to get combat rating and combat rating bonus
---@return value, coeff, rating, percent
local function getStats(fct, ratingKey)
    local value, coeff = fct()
    local rating, percent
    if ratingKey ~= nil then
        rating = GetCombatRating(ratingKey)
        percent = GetCombatRatingBonus(ratingKey)
    end
    return value, coeff, rating, percent
end

---@param unit string the name of the unit
---@param id number the id of the stat
---@return stat, effectiveStat, posBuff, negBuff
local function getPrimaryStats(unit, id)
    if (unit ~= 'player') then
        return
    end

    return UnitStat(unit, id)
end

local StatMethods = {
    -- General
    ["HEALTH"] = {
        Get = function(unit)
            if (not unit) then
                unit = 'player'
            end
            return UnitHealth(unit), UnitHealthMax(unit)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["POWER"] = {
        Get = function(unit)
            if (not unit) then
                unit = 'player'
            end
            local powerType, powerToken = UnitPowerType(unit)
            local power = UnitPowerMax(unit) or 0;
            return power, powerType, powerToken
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["ALTERNATE_MANA"] = {
        Get = function(unit)
            if (not unit) then
                unit = 'player'
            end
            local _, class = UnitClass(unit);
            if (class ~= "DRUID" and (class ~= "MONK" or GetSpecialization() ~= SPEC_MONK_MISTWEAVER)) then
                return
            end
            local powerType, powerToken = UnitPowerType(unit);
            if (powerToken == "MANA") then
                return
            end

            local power = UnitPowerMax(unit, 0);
            return power, powerType, powerToken
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["ITEM_LEVEL"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return
            end

            local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel()
            local minItemLevel = C_PaperDollInfo.GetMinItemLevel()

            return avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP, minItemLevel
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["MOVE_SPEED"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return ;
            end

            local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed(unit);
            --local baseSpeed = 7
            --local wasSwimming = nil
            --runSpeed = runSpeed/baseSpeed*100;
            --flightSpeed = flightSpeed/baseSpeed*100;
            --swimSpeed = swimSpeed/baseSpeed*100;
            --currentSpeed = currentSpeed/baseSpeed*100;

            ---- Determine whether to display running, flying, or swimming speed
            --local speed = runSpeed;
            --local swimming = IsSwimming(unit);
            --if (swimming) then
            --    speed = swimSpeed;
            --elseif (IsFlying(unit)) then
            --    speed = flightSpeed;
            --end
            --
            ---- Hack so that your speed doesn't appear to change when jumping out of the water
            --if (IsFalling(unit)) then
            --    if (wasSwimming) then
            --        speed = swimSpeed;
            --    end
            --else
            --    wasSwimming = swimming;
            --end

            --Let the logic for the user
            return currentSpeed, runSpeed, flightSpeed, swimSpeed

        end,
        Subject = LibObserver:CreateSubject(),
    },

    -- Base stats
    ["STRENGTH"] = {
        Get = function(unit)
            return getPrimaryStats(unit, 1)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["AGILITY"] = {
        Get = function(unit)
            return getPrimaryStats(unit, 2)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["INTELLECT"] = {
        Get = function(unit)
            return getPrimaryStats(unit, 4)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["STAMINA"] = {
        Get = function(unit)
            return getPrimaryStats(unit, 3)
        end,
        Subject = LibObserver:CreateSubject(),
    },

    -- Enhancements
    ["CRIT_CHANCE"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return ;
            end

            local spellCrit = {}
            for i = 1, MAX_SPELL_SCHOOLS do
                spellCrit[i] = GetSpellCritChance(i)
            end

            local rangedCrit = GetRangedCritChance();
            local meleeCrit = GetCritChance();

            return meleeCrit, GetCombatRating(9), GetCombatRatingBonus(9),
            rangedCrit, GetCombatRating(10), GetCombatRatingBonus(10),
            unpack(spellCrit), GetCombatRating(11), GetCombatRatingBonus(11)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["HASTE"] = {
        Get = function()
            return getStats(GetHaste, 18)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["MASTERY"] = {
        Get = function()
            return getStats(GetMasteryEffect, 26)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["VERSATILITY"] = {
        Get = function()
            local versatility = GetCombatRating(29);
            local outcomeRatingBonus = GetCombatRatingBonus(29)
            local outcomeVersaBonus = GetVersatilityBonus(29)
            local incomeRatingBonus = GetCombatRatingBonus(31)
            local incomeVersaBonus = GetVersatilityBonus(31)

            return versatility, outcomeRatingBonus, outcomeVersaBonus, incomeRatingBonus, incomeVersaBonus
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["LIFESTEAL"] = {
        Get = function()
            return getStats(GetLifesteal, 17)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["AVOIDANCE"] = {
        Get = function()
            return getStats(GetAvoidance, 21)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["SPEED"] = {
        Get = function()
            return getStats(GetSpeed, 14)
        end,
        Subject = LibObserver:CreateSubject(),
    },

    -- Attack
    ["ATTACK_DAMAGE"] = {
        Get = function(unit)
            local _, offhandSpeed = UnitAttackSpeed(unit)
            local minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent

            if IsRangedWeapon() then
                _, minDamage, maxDamage, _, _, percent = UnitRangedDamage(unit)
                minOffHandDamage = nil
                maxOffHandDamage = nil
                physicalBonusPos = 0
                physicalBonusNeg = 0
            else
                minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage(unit);
            end

            -- calculate base damage
            minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg
            maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg

            local baseDamage = (minDamage + maxDamage) * 0.5
            local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent

            -- If there's an offhand speed then add the offhand info to the tooltip
            if (offhandSpeed and minOffHandDamage and maxOffHandDamage) then
                minOffHandDamage = (minOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg
                maxOffHandDamage = (maxOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg

                local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5
                local offhandFullDamage = (offhandBaseDamage + physicalBonusPos + physicalBonusNeg) * percent

                return minDamage, maxDamage, minOffHandDamage, maxOffHandDamage,
                baseDamage, fullDamage, offhandBaseDamage, offhandFullDamage, percent
            end

            return minDamage, maxDamage, baseDamage, fullDamage, percent

        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["SPELL_POWER"] = {
        Get = function(_, school)
            local spellPower = {}

            if school then
                if school > 0 and school < MAX_SPELL_SCHOOLS then
                    return GetSpellBonusDamage(school)
                elseif school == MAX_SPELL_SCHOOLS then
                    return GetSpellBonusHealing()
                end
            end

            for i = 1, MAX_SPELL_SCHOOLS do
                spellPower[i] = GetSpellBonusDamage(i)
            end
            spellPower[MAX_SPELL_SCHOOLS] = GetSpellBonusHealing()

            return unpack(spellPower)
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["ATTACK_POWER"] = {
        Get = function(unit)
            local base, posBuff, negBuff = UnitAttackPower(unit)

            return base, posBuff, negBuff
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["RANGED_ATTACK_POWER"] = {
        Get = function(unit)
            if not IsRangedWeapon() then
                return
            end
            local base, posBuff, negBuff = UnitRangedAttackPower(unit);

            return base, posBuff, negBuff
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["ATTACK_SPEED"] = {
        Get = function(unit)
            local meleeHaste = GetMeleeHaste();
            local speed, offhandSpeed = UnitAttackSpeed(unit);
            return meleeHaste, speed, offhandSpeed
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["ENERGY_REGEN"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return
            end

            local _, powerToken = UnitPowerType(unit);
            if (powerToken ~= "ENERGY") then
                return
            end

            local regenRate = GetPowerRegen();
            return regenRate
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["RUNE_REGEN"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return
            end

            local _, class = UnitClass(unit)
            if (class ~= "DEATHKNIGHT") then
                return
            end

            local _, regenRate = GetRuneCooldown(1) -- Assuming they are all the same for now

            return regenRate
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["FOCUS_REGEN"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return ;
            end

            local _, powerToken = UnitPowerType(unit)
            if (powerToken ~= "FOCUS") then
                return ;
            end

            local regenRate = GetPowerRegen()

            return regenRate
        end,
        Subject = LibObserver:CreateSubject(),
    },

    -- Spell
    ["MANA_REGEN"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return
            end

            if (not UnitHasMana(unit)) then
                return
            end

            local base, combat = GetManaRegen();
            -- All mana regen stats are displayed as mana/5 sec.
            base = floor(base * 5.0);
            combat = floor(combat * 5.0);

            return base, combat
        end,
        Subject = LibObserver:CreateSubject(),
    },

    -- Defense
    ["ARMOR"] = {
        Get = function(unit)
            local baselineArmor, effectiveArmor, armor, bonusArmor = UnitArmor(unit)

            local armorReduction = C_PaperDollInfo.GetArmorEffectiveness(effectiveArmor, UnitEffectiveLevel(unit)) * 100
            local armorReductionAgainstTarget = (C_PaperDollInfo.GetArmorEffectivenessAgainstTarget(effectiveArmor) or 0) * 100

            return baselineArmor, effectiveArmor, armor, bonusArmor, armorReduction, armorReductionAgainstTarget
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["DODGE"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return ;
            end

            local chance = GetDodgeChance()
            return chance
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["PARRY"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return ;
            end

            local chance = GetParryChance();
            return chance
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["BLOCK"] = {
        Get = function(unit)
            if (unit ~= 'player') then
                return
            end

            local chance = GetBlockChance()
            local shieldBlockArmor = GetShieldBlock()
            local blockArmorReduction = C_PaperDollInfo.GetArmorEffectiveness(shieldBlockArmor, UnitEffectiveLevel(unit)) * 100
            local blockArmorReductionAgainstTarget = (C_PaperDollInfo.GetArmorEffectivenessAgainstTarget(shieldBlockArmor) or 0) * 100

            return chance, shieldBlockArmor, blockArmorReduction, blockArmorReductionAgainstTarget
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ["STAGGER"] = {
        Get = function(unit)
            local stagger, staggerAgainstTarget = C_PaperDollInfo.GetStaggerPercentage(unit);

            return stagger, staggerAgainstTarget
        end,
        Subject = LibObserver:CreateSubject(),
    },
    ['GLOBAL_COOLDOWN'] = {
        Get = function()
            local _, gcd = GetSpellCooldown(61304)
            return gcd
        end,
        Subject = LibObserver:CreateSubject(),
    }
}

--
local events = {
    'CHARACTER_POINTS_CHANGED',
    'UNIT_STATS',
    'UNIT_RANGEDDAMAGE',
    'UNIT_ATTACK_POWER',
    'UNIT_RANGED_ATTACK_POWER',
    'UNIT_ATTACK',
    'UNIT_SPELL_HASTE',
    'UNIT_RESISTANCES',
    'PLAYER_GUILD_UPDATE',
    'SKILL_LINES_CHANGED',
    'COMBAT_RATING_UPDATE',
    'MASTERY_UPDATE',
    'SPEED_UPDATE',
    'LIFESTEAL_UPDATE',
    'AVOIDANCE_UPDATE',
    'PLAYER_TALENT_UPDATE',
    'BAG_UPDATE',
    'PLAYER_EQUIPMENT_CHANGED',
    'PLAYER_AVG_ITEM_LEVEL_UPDATE',
    'PLAYER_DAMAGE_DONE_MODS',
    'ACTIVE_TALENT_GROUP_CHANGED',
    'SPELL_POWER_CHANGED',
    'CHARACTER_ITEM_FIXUP_NOTIFICATION',
    'PLAYER_TARGET_CHANGED'
}
local unitEvents = {
    'UNIT_DAMAGE',
    'UNIT_ATTACK_SPEED',
    'UNIT_MAXHEALTH',
    'UNIT_AURA',
    'UNIT_HEALTH',
}

local StatObserved = {}

---@param stat string the statistic to track
function LibUnitStat:AddStat(stat)
    local s = strupper(stat)

    if not StatObserved[s] then
        StatObserved[s] = {}
    end

end

---@param stat string the statistic to remove
function LibUnitStat:RemoveStat(stat)
    local s = strupper(stat)

    if StatObserved[s] then
        StatObserved[s] = nil
    end
end

---@vararg string Statistics to remove
function LibUnitStat:RemoveStats(...)
    for i = 1, select('#', ...) do
        self:RemoveStat(select(i, ...))
    end
end

---@vararg string Statistics to track
function LibUnitStat:AddStats(...)
    for i = 1, select('#', ...) do
        self:AddStat(select(i, ...))
    end
end

---wipe the tracked stat table
function LibUnitStat:ClearStats()
    wipe(StatObserved)
end

local function updateStat(unit, stat)
    StatObserved[stat] = { StatMethods[stat].Get(unit or 'player') }
    StatMethods[stat].Subject:Notify({ 'OnUpdate', stat })
end

local function onEvent(_, event, unit, ...)

    if event == 'MASTERY_UPDATE' then
        updateStat(unit, 'MASTERY')
    elseif event == 'UNIT_SPELL_HASTE' then
        updateStat(unit, 'HASTE')
    elseif event == 'SPEED_UPDATE' then
        updateStat(unit, 'SPEED')
    elseif event == 'LIFESTEAL_UPDATE' then
        updateStat(unit, 'LIFESTEAL')
    elseif event == 'AVOIDANCE_UPDATE' then
        updateStat(unit, 'AVOIDANCE')
    elseif event == 'SPELL_POWER_CHANGED' then
        updateStat(unit, 'SPELL_POWER')
    elseif event == 'UNIT_MAXHEALTH' or event == 'UNIT_HEALTH' then
        updateStat(unit, 'HEALTH')
    elseif event == 'UNIT_RANGEDDAMAGE' then
        updateStat(unit, 'ATTACK_DAMAGE')
    elseif event == 'UNIT_ATTACK_POWER' then
        updateStat(unit, 'ATTACK_POWER')
    elseif event == 'UNIT_RANGED_ATTACK_POWER' then
        updateStat(unit, 'RANGED_ATTACK_POWER')
    elseif event == 'UNIT_ATTACK_SPEED' then
        updateStat(unit, 'ATTACK_SPEED')
    elseif event == 'COMBAT_RATING_UPDATE' then
        updateStat(unit, 'MASTERY')
        updateStat(unit, 'HASTE')
        updateStat(unit, 'CRIT_CHANCE')
        updateStat(unit, 'VERSATILITY')
        updateStat(unit, 'LIFESTEAL')
        updateStat(unit, 'AVOIDANCE')
        updateStat(unit, 'SPEED')
    else
        for stat, _ in pairs(StatObserved) do
            updateStat(unit, stat)
            --StatObserved[stat] = { StatMethods[stat].Get(unit or 'player') }
            --if StatMethods[stat].Subject then
            --StatMethods[stat].Subject:Notify({'OnUpdate', stat})
            --end
        end
    end

end

---Enable the module
function LibUnitStat:Enable()

    for _, e in ipairs(events) do
        frame:RegisterEvent(e)
    end

    for _, e in ipairs(unitEvents) do
        frame:RegisterUnitEvent(e, 'player')
    end

    frame:SetScript('OnEvent', onEvent)
end

---Disable the module
function LibUnitStat:Disable()
    frame:UnregisterAllEvents()
end

function LibUnitStat:RegisterObserver(statName, entity)
    local s = strupper(statName)

    if StatMethods[s].Subject then
        StatMethods[s].Subject:RegisterObserver(entity)
    end
end

---@param statName string the statistic to get
---@return number[]|nil may return multiples values or nil
function LibUnitStat:GetStat(statName)
    local s = strupper(statName)

    if (not s) or (not StatObserved[s]) then
        return
    end

    return StatObserved[s]
end

---@return table<string, number[]> return an array of value for every stat
function LibUnitStat:GetAllStats()
    return StatObserved
end

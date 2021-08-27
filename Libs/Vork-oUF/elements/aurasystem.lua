--[[
# Element: AuraSystem

Handles updating auras icon with multiple group of Aura

## Widget

AuraFrames  - a container of Frames which hold Button's representing buffs and debuffs.

## Notes

The reason for this design of AuraFrames is because I would multiples groups of Aura anchored by precise side
Think about :
 - first group is anchored TOPLEFT with 3 Buttons
 - second group is anchored TOP with 1 Button
 ...

## Options

.ColorBorder        - Specify if the border is colored using dispell color. False by default
.ShowDispellable    - Filter to display only dispellable aura by player
.filter             - Custom filter list for auras to display.
.whitelist          - Structure for auras to display. Cannot be combine with filter
    .FrameID        - Specify Group for this Aura
    .Position       - Specify fixed position in the Group. If not specified it takes dynamically free Button
    .TexturedIcon   - Display the icon of the aura instead of colored point
    .Color          - Specify color of the square. Cannot be combine with TexturedIcon
.blacklist          - Array for auras to hide. Can be combine with filter

## Future Update

    priority aura in the whitelist if multiple aura are on the same position

--]]

local _, ns = ...
local oUF = ns.oUF or oUF

local format = format
local floor = floor
local GetTime = GetTime
local UnitAura = UnitAura
local UnitIsCharmed = UnitIsCharmed
local UnitCanAttack = UnitCanAttack
local abs = math.abs
local unpack = unpack
local select = select
local UnitClass = UnitClass
local GetActiveSpecGroup = GetActiveSpecGroup
local GetSpecialization = GetSpecialization
local ipairs = ipairs

local ViragDevTool = _G['ViragDevTool']

local DispellColor = {
    ['Magic'] = { .2, .6, 1 },
    ['Curse'] = { .6, 0, 1 },
    ['Disease'] = { .6, .4, 0 },
    ['Poison'] = { 0, .6, 0 },
    ['none'] = { 1, 0, 0 },
}

local FrameTableID = {
    ['Left'] = 1,
    ['Top'] = 2,
    ['Right'] = 3,
    ['Bottom'] = 4,
    ['Center'] = 5,
    [1] = 'Left',
    [2] = 'Top',
    [3] = 'Right',
    [4] = 'Bottom',
    [5] = 'Center',
}

local DispellPerClass = {
    ['PRIEST'] = {
        ['Magic'] = true,
        ['Disease'] = true,
    },
    ['SHAMAN'] = {
        ['Magic'] = false,
        ['Curse'] = true,
    },
    ['PALADIN'] = {
        ['Poison'] = true,
        ['Magic'] = false,
        ['Disease'] = true,
    },
    ['DRUID'] = {
        ['Magic'] = false,
        ['Curse'] = true,
        ['Poison'] = true,
        ['Disease'] = false,
    },
    ['MONK'] = {
        ['Magic'] = false,
        ['Disease'] = true,
        ['Poison'] = true,
    },
}

local NEW_AURA = 0
local REFRESH_AURA = 1

local function log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    end
end

local function formatTime(s)
    if s > 60 then
        return format('%dm', s / 60), s % 60
    elseif s < 1 then
        return format("%.1f", s), s - floor(s)
    else
        return format('%d', s), s - floor(s)
    end
end

local function UpdateDispellPerClass(self, event, levels)
    -- Not interested in gained points from leveling
    if event == "CHARACTER_POINTS_CHANGED" and levels > 0 then
        return
    end

    local playerClass = select(2, UnitClass('player'))
    local checkTalent = function(tree)
        local activeGroup = GetActiveSpecGroup()
        if activeGroup and GetSpecialization(false, false, activeGroup) then
            return tree == GetSpecialization(false, false, activeGroup)
        end
    end
    --Check for certain talents to see if we can dispel magic or not
    if playerClass == 'PALADIN' then
        if checkTalent(1) then
            DispellPerClass['PALADIN'].Magic = true
        else
            DispellPerClass['PALADIN'].Magic = false
        end
    elseif playerClass == 'SHAMAN' then
        if checkTalent(3) then
            DispellPerClass['SHAMAN'].Magic = true
        else
            DispellPerClass['SHAMAN'].Magic = false
        end
    elseif playerClass == 'DRUID' then
        if checkTalent(4) then
            DispellPerClass['DRUID'].Magic = true
        else
            DispellPerClass['DRUID'].Magic = false
        end
    elseif playerClass == 'MONK' then
        if checkTalent(2) then
            DispellPerClass['MONK'].Magic = true
        else
            DispellPerClass['MONK'].Magic = false
        end
    end
end

local function resetAura(f)

    f.name = ''
    f.spellId = -1
    f.icon:SetTexture(nil)
    f.icon:Hide()
    f.duration = -1

    if f.count then
        f.count:SetText('')
        f.count:Hide()
    end

    if f.time then
        f:SetScript('OnUpdate', nil)
        f.time:Hide()
    end

    if f.cd then
        f.cd:Hide()
    end

    f:Hide()

end

local function OnUpdate(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 0.1 then
        local timeLeft = self.expiration - GetTime()
        if self.reverse then
            timeLeft = abs((self.expiration - GetTime()) - self.duration)
        end
        if timeLeft > 0 then
            local text = formatTime(timeLeft)
            self.time:SetText(text)
        end
        self.elapsed = 0
    end
end

local function showAura(frame, name, icon, stack, dType, duration, expiration, spellId, isBorderColored)
    frame.name = name
    frame.spellId = spellId
    if type(icon) == 'table' then
        frame.icon:SetColorTexture(unpack(icon))
    else
        frame.icon:SetTexture(icon)
    end
    frame.icon:Show()
    frame.duration = duration

    if frame.Borders and isBorderColored then
        frame:SetBorderColor((DispellColor[dType] or DispellColor.none))
    else
        --frame:SetBackdropBorderColor(c[1], c[2], c[3])
    end

    if frame.count and stack and stack > 1 then
        frame.count:SetText(stack)
        frame.count:Show()
    end

    if frame.time and duration and duration > 0 then
        frame.expiration = expiration
        frame.nextUpdate = 0
        frame:SetScript('OnUpdate', OnUpdate)
        frame.time:Show()
    end

    if duration and duration > 0 then
        if frame.cd then
            frame.cd:SetCooldown(expiration - duration, duration)
            frame.cd:Show()
        end
        frame:Show()
    end
end

local function refreshAura(frame, stack, duration, expiration)

    local remainingTime = expiration - GetTime()
    if remainingTime > 0 then

        if frame.count and stack and stack > 1 then
            if stack > 1 then
                frame.count:SetText(stack)
            else
                frame.count:Hide()
            end
        end

        if frame.time and duration and duration > 0 then
            frame.expiration = expiration
            frame.nextUpdate = 0
        end

        if duration and duration > 0 then
            if frame.cd then
                frame.cd:SetCooldown(expiration - duration, duration)
            end
        end
    else
        resetAura(frame)
    end
end

local function getSlot(auraHolder, name, spellId, position)

    if position ~= nil then

        if auraHolder[position].spellId == spellId then
            return auraHolder[position], REFRESH_AURA
        else
            return auraHolder[position], NEW_AURA
        end
    end

    local n = name or ''
    for _, f in ipairs(auraHolder) do
        if f.name == n and f.spellId == spellId then
            return f, REFRESH_AURA --return to refresh this slot
        end
    end

    for _, f in ipairs(auraHolder) do
        if (not f:IsShown()) and (not f:IsVisible()) then
            return f, NEW_AURA --return to affect new slot
        end
    end

    return nil, nil --return first slot by default

end

local function updateAura(self, name, icon, stack, dType, duration, expiration, spellId, frameID, position)
    local element = self.AuraSystem
    local frameCount = #element.AuraFrames or 0
    if frameCount == 0 then
        return
    end
    if frameID > frameCount then
        return
    end

    local f, status = getSlot(element.AuraFrames[frameID], name, spellId, position)
    if f == nil then
        return
    elseif status == NEW_AURA then
        showAura(f, name, icon, stack, dType, duration, expiration, spellId, element.ColorBorder)
    elseif status == REFRESH_AURA then
        refreshAura(f, stack, duration, expiration, spellId)
    end

end

local function preUpdate(self)
    local element = self.AuraSystem
    local findAura

    for _, aura in ipairs(element.AuraTable) do
        findAura = false
        for i = 1, 40 do
            if aura.spellId == select(10, UnitAura(self.unit, i, element.filter)) then
                findAura = true
            end
        end

        if findAura == false and aura.spellId > 0 then
            resetAura(aura)
        end
    end
end

local function postUpdate(self)

end

local function IsIgnored(ignore_data, id)

    for i, v in ipairs(ignore_data) do
        if v == id then
            return true
        end
    end

    return false
end

local function CanDispell(debuffType)
    local playerClass = select(2, UnitClass('Player'))
    local dispellFilter = (DispellPerClass[playerClass] or {})

    if dispellFilter then
        return dispellFilter[debuffType] or false
    else
        return false
    end
end

local function Update(self, event, unit)
    if unit ~= self.unit then
        return
    end
    local element = self.AuraSystem

    if element.PreUpdate then
        element:PreUpdate(self)
    else
        preUpdate(self)
    end

    local filter = element.filter

    local showDispellable = element.ShowDispellable

    --store if the unit its charmed, mind controlled units
    local isCharmed = UnitIsCharmed(unit)

    --store if we cand attack that unit, if its so the unit its hostile
    local canAttack = UnitCanAttack("player", unit)

    local frameID, position
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
    spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod

    local isIgnored

    for i = 1, 40 do
        if filter == nil then
            --explicit filter by spellId
            name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i)
            if not name then
                --no aura for n >= i so breqk
                break
            end

            isIgnored = IsIgnored(element.ignore_data, spellId) or isCharmed or canAttack
            if showDispellable then
                isIgnored = isIgnored or not CanDispell(debuffType)
            end

            if not isIgnored and element.aura_data[spellId] then
                frameID = element.aura_data[spellId].FrameID or nil
                position = element.aura_data[spellId].Position or nil
                if not element.aura_data[spellId].TexturedIcon then
                    icon = element.aura_data[spellId].Color or { 1, 1, 1 }
                end
                if frameID ~= nil then
                    updateAura(self, name, icon, count, debuffType, duration, expirationTime, spellId, frameID, position)
                end
            end
        else
            --let me filter only with a classic wow filter then affect aura to frameID == 1
            name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, filter)
            if not name then
                --no aura for n >= i so breqk
                break
            end

            isIgnored = IsIgnored(element.ignore_data, spellId) or isCharmed or canAttack
            if showDispellable then
                isIgnored = isIgnored or not CanDispell(debuffType)
            end

            if not isIgnored then
                updateAura(self, name, icon, count, debuffType, duration, expirationTime, spellId, 1)
            end
        end
    end

    if element.PostUpdate then
        element:PostUpdate(self)
    else
        postUpdate(self)
    end

end

local function initAuraTable(auraTable, auraFrames)
    for _, hFrame in ipairs(auraFrames) do
        for _, f in ipairs(hFrame) do
            tinsert(auraTable, f)
        end
    end
end

local function Enable(self, unit)
    local element = self.AuraSystem
    if element then
        element.__owner = self
        element.AuraTable = {}
        element.aura_data = element.aura_data or {
            [1459] = {
                ["FrameID"] = 1, --arcane intell
                ["Position"] = 1,
            },
            [774] = {
                ["FrameID"] = 1, --rejuv
                ["Position"] = 1,
                ["Color"] = { 163/255, 48/255, 201/255 },
                ["TexturedIcon"] = true,
            },
            [8936] = {
                ["FrameID"] = 1, --regrowth
                ["Position"] = 2,
                ["Color"] = { 0, 1, 150/255 },
                ["TexturedIcon"] = true,
            },
            [188550] = {
                ["FrameID"] = 1 ,--lifebloom
                ["Position"] = 3,
                ["Color"] = { 171/255, 212/255, 115/255 },
                ["TexturedIcon"] = true,
            },
            [320009] = {
                ["FrameID"] = 1, --Empowered Chrysalis
                ["Position"] = 4,
                ["TexturedIcon"] = true,
            },
            [48438] = {
                ["FrameID"] = 2, --Wild Growth
                ["Position"] = 1,
                ["Color"] = { 1, 245/255, 105/255 },
                ["TexturedIcon"] = true,
            },
            [344244] = {
                ["FrameID"] = 2, --Manabound Mirror
                ["TexturedIcon"] = true,
                --["Position"] = 2,
            },
        }
        element.ignore_data = element.ignore_data or {
            --Heroism/Lust/Warp debuff
            57724, --Sated
            57723, --Sated
            80354, --Temporal Displacement
            95809, --Insanity
            264689, --Fatigued
            --Mythic Keystone debuff
            206151, --Challenger's Burden
        }

        initAuraTable(element.AuraTable, element.AuraFrames)

        self:RegisterEvent('UNIT_AURA', Update)
        self:RegisterEvent("PLAYER_TALENT_UPDATE", UpdateDispellPerClass, true)
        self:RegisterEvent("CHARACTER_POINTS_CHANGED", UpdateDispellPerClass, true)
        self:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateDispellPerClass, true)

        return true
    end
end

local function Disable(self)
    local element = self.AuraSystem
    if element then
        self:UnregisterEvent('PLAYER_ENTERING_WORLD', UpdateDispellPerClass, true)
        self:UnregisterEvent("CHARACTER_POINTS_CHANGED", UpdateDispellPerClass, true)
        self:UnregisterEvent("PLAYER_TALENT_UPDATE", UpdateDispellPerClass, true)
        self:UnregisterEvent('UNIT_AURA', Update)
        element:Hide()
    end
end

oUF:AddElement('AuraSystem', Update, Enable, Disable)
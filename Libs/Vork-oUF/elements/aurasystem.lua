--[[

## Options

.config                   - pair values (anchor point, number) to config subwidgets and number of item (variadic value)
                            'left', 3, 'right', 1, 'top', 4, 'bottom', 2, 'center', 0

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

local DispellColor = {
    ['Magic'] = { .2, .6, 1 },
    ['Curse'] = { .6, 0, 1 },
    ['Disease'] = { .6, .4, 0 },
    ['Poison'] = { 0, .6, 0 },
    ['none'] = { 1, 0, 0 },
}

local function formatTime(s)
    if s > 60 then
        return format('%dm', s / 60), s % 60
    elseif s < 1 then
        return format("%.1f", s), s - floor(s)
    else
        return format('%d', s), s - floor(s)
    end
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
        else
            self:SetScript('OnUpdate', nil)
            self.time:Hide()
        end
        self.elapsed = 0
    end
end

local function getSlot(auraHolder, name, spellId)

    local n = name or ''
    for _, f in ipairs(auraHolder) do
        if f.name == n and f.spellId == spellId then
            return f
        end
    end

    for _, f in ipairs(auraHolder) do
        if (not f:IsShown()) and (not f:IsVisible()) then
            return f
        end
    end

    return auraHolder[1] --return first slot by default

end

local function updateAura(self, name, icon, stack, dType, duration, expiration, spellId, frameID)
    local element = self.AuraSystem
    local frameCount = #element.AuraFrames or 0

    if frameCount == 0 then
        print('AURASYSTEM UPDATE AURA FRAMECOUNT == 0')
        return
    end
    if frameID > frameCount then
        print('AURASYSTEM UPDATE AURA FRAMEID > FRAMECOUNT')
        return
    end

    local f = getSlot(element.AuraFrames[frameID], name, spellId)
    f.name = name or ''
    f.spellId = spellId
    f.icon:SetTexture(icon)
    f.icon:Show()
    f.duration = duration

    local c = DispellColor[dType] or DispellColor.none

    if f.Borders then
        f.Borders:SetBorderColor(unpack(c))
    else
        --f:SetBackdropBorderColor(c[1], c[2], c[3])
    end

    if f.count then
        if stack and stack > 1 then
            f.count:SetText(stack)
            f.count:Show()
        else
            f.count:SetText('')
            f.count:Hide()
        end
    end

    if f.time then
        if duration and duration > 0 then
            f.expiration = expiration
            f.nextUpdate = 0
            f:SetScript('OnUpdate', OnUpdate)
            f.time:Show()
        else
            f:SetScript('OnUpdate', nil)
            f.time:Hide()
        end
    end

    if f.cd then
        if duration and (duration > 0) then
            f.cd:SetCooldown(expiration - duration, duration)
            f.cd:Show()
        else
            f.cd:Hide()
        end
    end

    if duration and duration > 0 then
        print ('SHOW', name,  duration)
        f:Show()
    else
        print ('HIDE', name, duration)
        f:Hide()
    end

end

local function Update(self, event, unit)
    if unit ~= self.unit then
        return
    end
    local element = self.AuraSystem
    local filter = element.filter
    local showDispellable = element.showDispellable

    --store if the unit its charmed, mind controlled units
    local isCharmed = UnitIsCharmed(unit)

    --store if we cand attack that unit, if its so the unit its hostile
    local canAttack = UnitCanAttack("player", unit)

    local frameID
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
    spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod

    for i = 1, 40 do
        name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
        spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, filter)
        if not name then
            --no aura for n >= i so breqk
            break
        end

        frameID = (element.aura_data[spellId] and element.aura_data[spellId].frameID)
        if frameID then
            updateAura(self, name, icon, count, debuffType, duration, expirationTime, spellId, frameID)
        end

    end
end

local function Enable(self, unit)
    local element = self.AuraSystem
    if element then
        element.__owner = self
        element.filter = element.filter or 'PLAYER HELPFUL'
        element.showDispellable = element.showDispellable or true
        element.onlyMatchSpellID = element.onlyMatchSpellID or true
        element.aura_data = element.aura_data or {
            [1459] = {
                ["frameID"] = 1
            }
        }
        self:RegisterEvent('UNIT_AURA', Update)

        return true
    end
end

local function Disable(self)
    local element = self.AuraSystem
    if element then
        self:UnregisterEvent('UNIT_AURA', Update)
        element:Hide()
    end
end

oUF:AddElement('AuraSystem', Update, Enable, Disable)
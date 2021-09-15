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
.Aura_Data          - Structure to specify for groups multiples params for every entry :
    .Filter                     - Custom filter list for auras to display.
    .Whitelist                  - Structure for auras to display.
    .Position                   - Specify fixed position in the Group. If not specified it takes dynamically free Button
    .Priority                   - Specify priority on draw to manage multiple aura at same position. If a spell takes
    priority over current Aura, it takes dynamically free Button
    .TexturedIcon               - Display the icon of the aura instead of colored point
    .Color                      - Specify color of the square. Cannot be combine with TexturedIcon
    .Blacklist                  - Array for auras to hide
    .OnlyShowWhitelist          - Ignore all aura not in the Whilelist. False by default
    .DisableDynamicPosition     - Disable Dynamic Aura Position. Works only with WhiteList. False by default

## Future Update

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
local GameTooltip = GameTooltip
local pairs = pairs
local tinsert = tinsert
local setmetatable = setmetatable
local getmetatable = getmetatable

local ViragDevTool = _G['ViragDevTool']

local DispellColor = {
    ['Magic'] = { .2, .6, 1 },
    ['Curse'] = { .6, 0, 1 },
    ['Disease'] = { .6, .4, 0 },
    ['Poison'] = { 0, .6, 0 },
    ['none'] = { 0, 0, 0 },
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

local function resetAura(f)

    f.name = ''
    f.spellId = -1
    f.priority = 0
    f.icon:SetTexture(nil)
    f.icon:Hide()
    f.duration = -1
    f:EnableMouse(false)
    f:SetID(-1)

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

local AuraGroupFunction = {

    RefreshAura = function(_, auraID, frame, stack, duration, expiration)
        local remainingTime = expiration - GetTime()
        if remainingTime > 0 then
            frame:SetID(auraID)
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
        elseif duration ~= 0 then
            resetAura(frame)
        end

        return true
    end,

    ShowAura = function(self, auraID, name, icon, stack, dType, duration, expiration, spellId, isBorderColored)

        if self:IsIgnored(spellId) then
            return false
        end
        local forceIcon = false

        local position = self:GetPosition(spellId)
        local priority = self:GetPriority(spellId)
        --check priority if position > 0
        if position > 0 then
            if not self:IsPriority(spellId, self[position].spellId or 0) then
                if not self.DisableDynamicPosition then
                    position = self:GetFreeSlotIndex()
                    forceIcon = true
                else
                    return false
                end
            end
        end
        if position == -1 then
            if self.OnlyShowWhitelist == true then
                return false
            end

            --not in whitelist so automatically icon
            position = self:GetFreeSlotIndex()
            forceIcon = true
        end

        local frame = self[position]

        if frame == nil then
            return false
        end

        frame.name = name
        frame.spellId = spellId
        frame.priority = priority
        frame:SetID(auraID)
        frame:EnableMouse(not self.DisableMouse)
        if forceIcon == true or self:IsTexturedIcon(spellId) then
            frame.icon:SetTexture(icon)
        else
            frame.icon:SetColorTexture(self:GetColor(spellId))
        end

        frame.icon:Show()
        frame.duration = duration

        if frame.Borders and isBorderColored then
            frame:SetBorderColor(DispellColor[dType] or DispellColor.none)
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
        end
        frame:Show()
        return true
    end,

    HasTooltip = function(self)
        if self.HasTooltip then
            return self.HasTooltip
        end
        return false
    end,

    HasAura = function(self, spellId)
        for idx, frame in ipairs(self) do
            if frame.spellId == spellId then
                return true, idx
            end
        end
        return false, nil
    end,

    GetIndex = function(self, spellId)
        if not self.Whitelist then
            return -1
        end
        return self.Whitelist[spellId] or -1
    end,

    GetPosition = function(self, spellId)

        if self.Position == nil or self.Position[spellId] == nil or self.Position[spellId] > #self then
            return -1
        end

        return self.Position[spellId]
    end,

    GetFreeSlotIndex = function(self)
        for idx, frame in ipairs(self) do
            if frame.name == nil or frame.name == '' then
                return idx
            end
        end
    end,

    GetFreeSlot = function(self)
        for _, frame in ipairs(self) do
            if frame.name == nil or frame.name == '' then
                return frame
            end
        end
    end,

    HasFreeSlot = function(self)
        for _, frame in ipairs(self) do
            if frame.name == nil or frame.name == '' then
                return true
            end
        end
    end,

    GetFreeSlots = function(self)
        local freeSlots = {}
        for i, frame in ipairs(self) do
            if frame.name == '' then
                tinsert(freeSlots, i)
            end
        end

        return freeSlots
    end,

    IsTexturedIcon = function(self, index)
        local isTexturedIcon = self.TexturedIcon
        if isTexturedIcon == nil then
            return false
        end
        if type(isTexturedIcon) == 'boolean' then
            return isTexturedIcon
        elseif type(isTexturedIcon) == 'table' then
            return self.TexturedIcon[index]
        end
    end,

    GetColor = function(self, index)
        if self.Color[index] then
            return unpack(self.Color[index])
        end
        return 1, 1, 1
    end,

    IsIgnored = function(self, spellID)

        if not self.Blacklist then
            return false
        end
        return self.Blacklist[spellID] and true
    end,

    GetPriority = function(self, spellId)
        if spellId < 0 or self.Priority == nil then
            return 0
        end

        return self.Priority[spellId] or 0
    end,

    IsPriority = function(self, spell1, spell2)
        if spell2 == nil then
            return true
        end
        return self:GetPriority(spell1) > self:GetPriority(spell2)
    end,
}

local function UpdateDispellPerClass(_, event, levels)
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

local function preUpdate(self)
    local element = self.AuraSystem
    local findAura

    for _, aura in ipairs(element.AuraTable) do
        findAura = false
        for i = 1, 40 do
            if aura.spellId == select(10, UnitAura(self.unit, i, element.filter)) then
                findAura = true
                aura:SetID(i)
            end
        end

        if findAura == false and (aura.spellId and aura.spellId > 0) then
            resetAura(aura)
        end
    end
end

local function postUpdate(_)

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

local function Update(self, _, unit)
    if unit ~= self.unit then
        return
    end
    local element = self.AuraSystem

    if element.PreUpdate then
        element:PreUpdate(self)
    else
        preUpdate(self)
    end

    --local filter = element.filter

    local showDispellable = element.ShowDispellable

    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
    spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod

    local group, frameIdx, refresh

    for filter, auraGroup in pairs(element.Filters) do
        for i = 1, 40 do
            name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, filter)
            if not name then
                --no aura for n >= i so breqk
                break
            end

            if showDispellable == nil or showDispellable == false or (showDispellable == CanDispell(debuffType)) then
                for _, frameID in ipairs(auraGroup) do
                    group = element.AuraFrames[frameID]
                    refresh, frameIdx = group:HasAura(spellId)
                    if refresh == true then
                        group:RefreshAura(i, group[frameIdx], count, duration, expirationTime)
                        break
                    end
                end

                if refresh == false then
                    for _, frameID in ipairs(auraGroup) do
                        group = element.AuraFrames[frameID]
                        if group:ShowAura(i, name, icon, count, debuffType, duration, expirationTime, spellId, element.ColorBorder) == true then
                            break
                        end
                    end
                end
            end

        end
    end

    if element.PostUpdate then
        element:PostUpdate(self)
    else
        postUpdate(self)
    end

end

local function init(auraFrames, auraData)
    local auraTable, filters = {}, {}

    local filter

    for idxGroup, hFrame in ipairs(auraFrames) do
        filter = auraData[idxGroup].Filter or 'HELPFUL'
        if not filters[filter] then
            filters[filter] = { idxGroup }
        else
            tinsert(filters[filter], idxGroup)
        end

        --link the frame holder with its corresponding data
        if idxGroup <= #auraData then
            hFrame.Whitelist = auraData[idxGroup].Whitelist
            hFrame.Blacklist = auraData[idxGroup].Blacklist
            hFrame.TexturedIcon = auraData[idxGroup].TexturedIcon
            hFrame.Color = auraData[idxGroup].Color
            hFrame.Position = auraData[idxGroup].Position
            hFrame.Priority = auraData[idxGroup].Priority
            hFrame.OnlyShowWhitelist = auraData[idxGroup].OnlyShowWhitelist or false
            hFrame.DisableDynamicPosition = auraData[idxGroup].DisableDynamicPosition or false
            hFrame.DisableMouse = auraData[idxGroup].DisableMouse or false
            hFrame.TooltipAnchor = auraData[idxGroup].TooltipAnchor or 'ANCHOR_TOPLEFT'
            hFrame.HasTooltip = auraData[idxGroup].HasTooltip
            hFrame.Filter = filter
        end

        --Setup GameTooltip
        for _, f in ipairs(hFrame) do
            if not hFrame.DisableMouse then
                f:RegisterForClicks('RightButtonUp')
                if hFrame.HasTooltip == true then
                    f.UpdateTooltip = function(self)
                        if(GameTooltip:IsForbidden()) then return end

                        GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), hFrame.Filter)
                    end
                    f:SetScript('OnEnter', function(self)
                        if(GameTooltip:IsForbidden() or not self:IsVisible()) then return end
                        -- Avoid parenting GameTooltip to frames with anchoring restrictions,
                        -- otherwise it'll inherit said restrictions which will cause issues with
                        -- its further positioning, clamping, etc
                        GameTooltip:SetOwner(self, self:GetParent().__restricted and 'ANCHOR_CURSOR' or hFrame.TooltipAnchor)
                        self:UpdateTooltip()
                    end)
                    f:SetScript('OnLeave', function(_)
                        if(GameTooltip:IsForbidden()) then return end

                        GameTooltip:Hide()
                    end)
                end
            end
            tinsert(auraTable, f)
        end

        --push our internal Methods in the metatable, if it taints, need to wrap this
        setmetatable(hFrame, { __index = setmetatable(AuraGroupFunction, getmetatable(hFrame)) })
    end

    return auraTable, filters
end

local function Enable(self, _)
    local element = self.AuraSystem
    if element then
        element.__owner = self
        element.__restricted = not pcall(self.GetCenter, self)
        element.AuraTable = {}
        element.AuraTable, element.Filters = init(element.AuraFrames, element.aura_data)

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
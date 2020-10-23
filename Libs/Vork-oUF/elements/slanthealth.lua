--[[
# Element: Slant Health Bar

Handles the updating of a texture that displays the unit's health.

## Widget

Health - A `Slanted StatusBar` used to represent the unit's health.

## Sub-Widgets

.bg - A `Texture` used as a background. It will inherit the color of the main StatusBar.

## Notes

A default texture will be applied if the widget is a StatusBar and doesn't have a texture set.

## Options

.smoothGradient                   - 9 color values to be used with the .colorSmooth option (table)
.considerSelectionInCombatHostile - Indicates whether selection should be considered hostile while the unit is in
                                    combat with the player (boolean)

The following options are listed by priority. The first check that returns true decides the color of the bar.

.colorDisconnected - Use `self.colors.disconnected` to color the bar if the unit is offline (boolean)
.colorTapping      - Use `self.colors.tapping` to color the bar if the unit isn't tapped by the player (boolean)
.colorThreat       - Use `self.colors.threat[threat]` to color the bar based on the unit's threat status. `threat` is
                     defined by the first return of [UnitThreatSituation](https://wow.gamepedia.com/API_UnitThreatSituation) (boolean)
.colorClass        - Use `self.colors.class[class]` to color the bar based on unit class. `class` is defined by the
                     second return of [UnitClass](http://wowprogramming.com/docs/api/UnitClass.html) (boolean)
.colorClassNPC     - Use `self.colors.class[class]` to color the bar if the unit is a NPC (boolean)
.colorClassPet     - Use `self.colors.class[class]` to color the bar if the unit is player controlled, but not a player
                     (boolean)
.colorSelection    - Use `self.colors.selection[selection]` to color the bar based on the unit's selection color.
                     `selection` is defined by the return value of Private.unitSelectionType, a wrapper function
                     for [UnitSelectionType](https://wow.gamepedia.com/API_UnitSelectionType) (boolean)
.colorReaction     - Use `self.colors.reaction[reaction]` to color the bar based on the player's reaction towards the
                     unit. `reaction` is defined by the return value of
                     [UnitReaction](http://wowprogramming.com/docs/api/UnitReaction.html) (boolean)
.colorSmooth       - Use `smoothGradient` if present or `self.colors.smooth` to color the bar with a smooth gradient
                     based on the player's current health percentage (boolean)
.colorHealth       - Use `self.colors.health` to color the bar. This flag is used to reset the bar color back to default
                     if none of the above conditions are met (boolean)

## Sub-Widgets Options

.multiplier - Used to tint the background based on the main widgets R, G and B values. Defaults to 1 (number)[0-1]

## Examples

    -- Position and size
    local Health = self:CreateTexture('ARTWORK', nil, self)
    Health:SetHeight(20)
    Health:SetPoint('TOP')
    Health:SetPoint('LEFT')
    Health:SetPoint('RIGHT')

    -- Add a background
    local Background = self:CreateTexture(nil, 'BACKGROUND')
    Background:SetAllPoints(Health)
    Background:SetTexture(1, 1, 1, .5)

    -- Options
    Health.colorTapping = true
    Health.colorDisconnected = true
    Health.colorClass = true
    Health.colorReaction = true
    Health.colorHealth = true

    -- Make the background darker.
    Background.multiplier = .5

    -- Register it with oUF
    Health.bg = Background
    self.SlantHealth = Health
--]]

local _, ns = ...
local oUF = ns.oUF
local VorkoUF = ns.VorkoUF

local coord = {
    ULx = 0,
    ULy = 0,
    LLx = 0,
    LLy = 1,
    URx = 1,
    URy = 0,
    LRx = 1,
    LRy = 1,

    ULvx = 0,
    ULvy = 0,
    LLvx = 0,
    LLvy = 0,
    URvx = 0,
    URvy = 0,
    LRvx = 0,
    LRvy = 0,
};

local slant = 0

local animationTime
local animationDuration
local animationValue
local animationUpdate

local function UpdateColor(self, event, unit)
    if(not unit or self.unit ~= unit) then return end
    local element = self.SlantHealth

    local r, g, b, t
    if(element.colorDisconnected and not UnitIsConnected(unit)) then
        t = self.colors.disconnected
    elseif(element.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
        t = self.colors.tapped
    elseif(element.colorThreat and not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit)) then
        t =  self.colors.threat[UnitThreatSituation('player', unit)]
    elseif(element.colorClass and UnitIsPlayer(unit))
            or (element.colorClassNPC and not UnitIsPlayer(unit))
            or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
        local _, class = UnitClass(unit)
        t = self.colors.class[class]
    --elseif(element.colorSelection and unitSelectionType(unit, element.considerSelectionInCombatHostile)) then
    --    t = self.colors.selection[unitSelectionType(unit, element.considerSelectionInCombatHostile)]
    elseif(element.colorReaction and UnitReaction(unit, 'player')) then
        t = self.colors.reaction[UnitReaction(unit, 'player')]
    elseif(element.colorSmooth) then
        r, g, b = self:ColorGradient(element.cur or 1, element.max or 1, unpack(element.smoothGradient or self.colors.smooth))
    elseif(element.colorHealth) then
        t = self.colors.health
    end

    if(t) then
        r, g, b = t[1], t[2], t[3]
    end

    if(b) then
        element:SetColorTexture(r, g, b)

        local bg = element.bg
        if(bg) then
            local mu = bg.multiplier or 1
            bg:SetVertexColor(r * mu, g * mu, b * mu)
        end
    end

    --[[ Callback: SlantHealth:PostUpdateColor(unit, r, g, b)
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



local function ColorPath(self, ...)
    --[[ Override: SlantHealth.UpdateColor(self, event, unit)
    Used to completely override the internal function for updating the widgets' colors.

    * self  - the parent object
    * event - the event triggering the update (string)
    * unit  - the unit accompanying the event (string)
    --]]
    (self.SlantHealth.UpdateColor or UpdateColor) (self, ...)
end

local function SetDefaultAnimationData(val, duration, fct)
    animationTime = 0
    animationDuration = duration or 1
    animationValue = val or 0
    animationUpdate = fct or (function() end)
end

local function Update(self, event, unit)
    if(not unit or self.unit ~= unit) then return end
    local element = self.SlantHealth

    --[[ Callback: SlantHealth:PreUpdate(unit)
    Called before the element has been updated.

    * self - the Health element
    * unit - the unit for which the update has been triggered (string)
    --]]
    if(element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    --element:SetMinMaxValues(0, max)

    if(UnitIsConnected(unit)) then
        if element.animTexture then
            element.onAnim = true
            animationTime = 0
            animationValue = element.cur or cur
        else
            VorkoUF.SetValue(element, cur, max, coord, slant)
            --SetValue(element, cur, max)
        end
    else
        if element.animTexture then
            element.onAnim = true
            animationTime = 0
            animationValue = element.cur or cur
        else
            VorkoUF.SetValue(element, max, max, coord, slant)
            --SetValue(element, max, max)
        end

    end

    element.cur = cur
    element.max = max

    --[[ Callback: SlantHealth:PostUpdate(unit, cur, max)
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

local function Path(self, ...)
    --[[ Override: SlantHealth.Override(self, event, unit)
    Used to completely override the internal update function.

    * self  - the parent object
    * event - the event triggering the update (string)
    * unit  - the unit accompanying the event (string)
    --]]
    (self.SlantHealth.Override or Update) (self, ...);

    ColorPath(self, ...)
end

local function ForceUpdate(element)
    Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

--[[ SlantHealth:SetColorDisconnected(state, isForced)
Used to toggle coloring if the unit is offline.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorDisconnected(element, state, isForced)
    if(element.colorDisconnected ~= state or isForced) then
        element.colorDisconnected = state
        if(state) then
            element.__owner:RegisterEvent('UNIT_CONNECTION', ColorPath)
        else
            element.__owner:UnregisterEvent('UNIT_CONNECTION', ColorPath)
        end
    end
end

--[[ SlantHealth:SetColorSelection(state, isForced)
Used to toggle coloring by the unit's selection.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorSelection(element, state, isForced)
    if(element.colorSelection ~= state or isForced) then
        element.colorSelection = state
        if(state) then
            element.__owner:RegisterEvent('UNIT_FLAGS', ColorPath)
        else
            element.__owner:UnregisterEvent('UNIT_FLAGS', ColorPath)
        end
    end
end

--[[ SlantHealth:SetColorTapping(state, isForced)
Used to toggle coloring if the unit isn't tapped by the player.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorTapping(element, state, isForced)
    if(element.colorTapping ~= state or isForced) then
        element.colorTapping = state
        if(state) then
            element.__owner:RegisterEvent('UNIT_FACTION', ColorPath)
        else
            element.__owner:UnregisterEvent('UNIT_FACTION', ColorPath)
        end
    end
end

--[[ SlantHealth:SetColorThreat(state, isForced)
Used to toggle coloring by the unit's threat status.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorThreat(element, state, isForced)
    if(element.colorThreat ~= state or isForced) then
        element.colorThreat = state
        if(state) then
            element.__owner:RegisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
        else
            element.__owner:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
        end
    end
end

--[[ SlantHealth:UpdateAnimation(self, elapsed)
Used to anim the texture progression

* self     - the SlantHealth element
* elapsed  - the time between last update
--]]
local function UpdateAnimation(self, elapsed)
    local element = self.SlantHealth
    if element and element.animTexture and element.onAnim then
        animationTime = animationTime + elapsed

        local cur, max = element.cur, element.max
        --animation is over
        if animationTime > animationDuration then
            if element.inverse then
                VorkoUF.SetValue(element, cur/max, 0, coord, slant)
            else
                VorkoUF.SetValue(element, 0, cur/max, coord, slant)
            end
            element.onAnim = false
            animationTime = 0
            animationValue = cur
        else
            if element.inverse then
                VorkoUF.SetValue(element, animationUpdate(animationTime, animationValue, cur-animationValue, animationDuration)/max, 0, coord, slant)
            else
                VorkoUF.SetValue(element, 0, animationUpdate(animationTime, animationValue, cur-animationValue, animationDuration)/max, coord, slant)
            end
        end
    end
end

local function Enable(self, unit)
    local element = self.SlantHealth

    if(element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate
        element.SetColorDisconnected = SetColorDisconnected
        element.SetColorSelection = SetColorSelection
        element.SetColorTapping = SetColorTapping
        element.SetColorThreat = SetColorThreat

        slant = element.slant or 0

        if(element.colorDisconnected) then
            self:RegisterEvent('UNIT_CONNECTION', ColorPath)
        end

        if(element.colorSelection) then
            self:RegisterEvent('UNIT_FLAGS', ColorPath)
        end

        if(element.colorTapping) then
            self:RegisterEvent('UNIT_FACTION', ColorPath)
        end

        if(element.colorThreat) then
            self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
        end

        self:RegisterEvent('UNIT_HEALTH', Path)
        self:RegisterEvent('UNIT_MAXHEALTH', Path)

        if element.animTexture then
            self:HookScript("OnUpdate", UpdateAnimation)
            --duration should be < event_time to avoid visual artefact
            SetDefaultAnimationData(0, 0.33, VorkoUF.Easing["linear"])
            if element.inverse then
                VorkoUF.SetValue(element.bg, 1, 0, coord, slant)
            else
                VorkoUF.SetValue(element.bg, 0, 1, coord, slant)
            end
        end

        element:Show()

            return true
        end
end

local function Disable(self)
    local element = self.SlantHealth
    if(element) then
        element:Hide()

        self:UnregisterEvent('UNIT_HEALTH', Path)
        self:UnregisterEvent('UNIT_MAXHEALTH', Path)
        self:UnregisterEvent('UNIT_CONNECTION', ColorPath)
        self:UnregisterEvent('UNIT_FACTION', ColorPath)
        self:UnregisterEvent('UNIT_FLAGS', ColorPath)
        self:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
    end
end

oUF:AddElement('SlantHealth', Path, Enable, Disable)

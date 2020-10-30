--[[
# Element: Absorb Bar

Handles the updating of a status bar that displays the unit's absorb.

## Widget

Absorb - A `StatusBar` used to represent the unit's health.

## Sub-Widgets

.bg - A `Texture` used as a background. It will inherit the color of the main StatusBar.

## Notes

A default texture will be applied if the widget is a StatusBar and doesn't have a texture set.

## Sub-Widgets Options

.multiplier - Used to tint the background based on the main widgets R, G and B values. Defaults to 1 (number)[0-1]

## Examples

    -- Position and size
    local Absorb = CreateFrame('StatusBar', nil, self)
    Absorb:SetHeight(20)
    Absorb:SetPoint('TOP')
    Absorb:SetPoint('LEFT')
    Absorb:SetPoint('RIGHT')

    -- Add a background
    local Background = Absorb:CreateTexture(nil, 'BACKGROUND')
    Background:SetAllPoints(Absorb)
    Background:SetTexture(1, 1, 1, .5)

    -- Make the background darker.
    Background.multiplier = .5

    -- Register it with oUF
    Absorb.bg = Background
    self.Absorb = Absorb
--]]

local _, ns = ...
local oUF = ns.oUF

local function UpdateColor(self, event, unit)
    if(not unit or self.unit ~= unit) then return end
    local element = self.Absorb

    local r, g, b = unpack(element.colors)

    if(b) then
        if element:IsObjectType('StatusBar') then
            element:SetStatusBarColor(r, g, b)
        else
            element:SetVertexColor(r, g, b)
        end

        local bg = element.bg
        if(bg) then
            local mu = bg.multiplier or 1
            bg:SetVertexColor(r * mu, g * mu, b * mu)
        end
    end

    --[[ Callback: Absorb:PostUpdateColor(unit, r, g, b)
    Called after the element color has been updated.

    * self - the Absorb element
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
    --[[ Override: Absorb.UpdateColor(self, event, unit)
    Used to completely override the internal function for updating the widgets' colors.

    * self  - the parent object
    * event - the event triggering the update (string)
    * unit  - the unit accompanying the event (string)
    --]]
    (self.Absorb.UpdateColor or UpdateColor) (self, ...)
end

local function Update(self, event, unit)
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
    element:SetMinMaxValues(0, max)

    if(UnitIsConnected(unit)) then
        element:SetValue(cur)
    else
        element:SetValue(max)
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

local function Path(self, ...)
    --[[ Override: Absorb.Override(self, event, unit)
    Used to completely override the internal update function.

    * self  - the parent object
    * event - the event triggering the update (string)
    * unit  - the unit accompanying the event (string)
    --]]
    (self.Absorb.Override or Update) (self, ...);

    ColorPath(self, ...)
end

local function ForceUpdate(element)
    Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

--[[ Health:SetColorDisconnected(state, isForced)
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

local function Enable(self, unit)
    local element = self.Absorb
    if(element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate
        element.SetColorDisconnected = SetColorDisconnected

        if(element.colorDisconnected) then
            self:RegisterEvent('UNIT_CONNECTION', ColorPath)
        end

        self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
        self:RegisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)

        if(element:IsObjectType('StatusBar') and not (element:GetStatusBarTexture() or element:GetStatusBarAtlas())) then
            element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
        end

        element:Show()

        return true
    end
end

local function Disable(self)
    local element = self.Absorb
    if(element) then
        element:Hide()

        self:UnregisterEvent('UNIT_CONNECTION', Path)
        self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
        self:UnregisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)
    end
end

oUF:AddElement('Absorb', Path, Enable, Disable)

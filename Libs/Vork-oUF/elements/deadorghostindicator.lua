--[[
# Element: Dead or Ghost Indicator

Toggles the visibility of an indicator based on the unit's leader status.

## Widget

DeadOrGhostIndicator - Any UI widget.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.

## Examples

    -- Position and size
    local DeadOrGhostIndicator = self:CreateTexture(nil, 'OVERLAY')
    DeadOrGhostIndicator:SetSize(16, 16)
    DeadOrGhostIndicator:SetPoint('BOTTOM', self, 'TOP')

    -- Register it with oUF
    self.DeadOrGhostIndicator = DeadOrGhostIndicator
--]]

local _, ns = ...
local oUF = ns.oUF

local function Update(self, event)
    local element = self.DeadOrGhostIndicator
    local unit = self.unit

    --[[ Callback: LeaderIndicator:PreUpdate()
    Called before the element has been updated.

    * self - the LeaderIndicator element
    --]]
    if(element.PreUpdate) then
        element:PreUpdate()
    end

    local isDeadOrGhost = (UnitIsConnected(unit) and UnitIsDeadOrGhost(unit))

    if(isDeadOrGhost) then
        element:Show()
    else
        element:Hide()
    end

    --[[ Callback: LeaderIndicator:PostUpdate(isLeader)
    Called after the element has been updated.

    * self     - the LeaderIndicator element
    * isLeader - indicates whether the element is shown (boolean)
    --]]
    if(element.PostUpdate) then
        return element:PostUpdate(isLeader)
    end
end

local function Path(self, ...)
    --[[ Override: LeaderIndicator.Override(self, event, ...)
    Used to completely override the internal update function.

    * self  - the parent object
    * event - the event triggering the update (string)
    * ...   - the arguments accompanying the event
    --]]
    return (self.DeadOrGhostIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
    local element = self.DeadOrGhostIndicator
    if(element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        self:RegisterEvent('UNIT_HEALTH', Path, true)

        if(element:IsObjectType('Texture') and not element:GetTexture()) then
            element:SetTexture(132331)
        end

        return true
    end
end

local function Disable(self)
    local element = self.DeadOrGhostIndicator
    if(element) then
        element:Hide()

        self:UnregisterEvent('UNIT_HEALTH', Path)
    end
end

oUF:AddElement('DeadOrGhostIndicator', Path, Enable, Disable)

--[[
# Element: Resting Indicator

Toggles the visibility of an indicator based on the unit's class

## Widget

ClassIndicator - Any UI widget.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.

## Examples

    -- Position and size
    local ClassIndicator = self:CreateTexture(nil, 'OVERLAY')
    ClassIndicator:SetSize(16, 16)
    ClassIndicator:SetPoint('TOPLEFT', self)

    -- Register it with oUF
    self.ClassIndicator = ClassIndicator
--]]

local _, ns = ...
local oUF = ns.oUF
local select = select
local UnitClass = UnitClass
local UnitName = UnitName
local unpack = unpack

local function Update(self, event, unit)

    local element = self.ClassIndicator
    local class = select(2, UnitClass(unit))
    local name = UnitName(unit)

    --[[ Callback: RestingIndicator:PreUpdate()
    Called before the element has been updated.

    * self - the RestingIndicator element
    --]]
    if(element.PreUpdate) then
        element:PreUpdate()
    end

    if element.name ~= name then
        element.name = name
        if(element:IsObjectType('Texture') and element:GetTexture() == 131146) then
            element:SetTexCoord( unpack(CLASS_ICON_TCOORDS[class]) )
        end
    end

    --[[ Callback: RestingIndicator:PostUpdate(isResting)
    Called after the element has been updated.

    * self  - the RestingIndicator element
    * class - the class of the unit
    --]]
    if(element.PostUpdate) then
        return element:PostUpdate(class)
    end
end

local function Path(self, ...)
    --[[ Override: RestingIndicator.Override(self, event)
    Used to completely override the internal update function.

    * self  - the parent object
    * event - the event triggering the update (string)
    --]]
    return (self.ClassIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
    local element = self.ClassIndicator
    if(element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        self:RegisterEvent('UNIT_TARGET', Path, true)
        element.name = ''

        if(element:IsObjectType('Texture') and not element:GetTexture()) then
            element:SetTexture([[Interface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]])
            local _,class = UnitClass(unit);
            element:SetTexCoord( unpack(CLASS_ICON_TCOORDS[class]) )
        end

        return true
    end
end

local function Disable(self)
    local element = self.ClassIndicator
    if(element) then
        element:Hide()

        element.name = ''
        self:UnregisterEvent('UNIT_TARGET', Path)
    end
end

oUF:AddElement('ClassIndicator', Path, Enable, Disable)

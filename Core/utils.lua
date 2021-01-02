print ("UTILS.LUA")

local V,C,L = select(2,...):unpack()

local CreateFrame = CreateFrame

local Utils = CreateFrame("Frame")
local strlower = strlower
local tinsert = tinsert
local EnumerateFrames = EnumerateFrames
---------------------------------------------------
-- Basic Utils
---------------------------------------------------
local Resolution = select(1, GetPhysicalScreenSize()).."x"..select(2, GetPhysicalScreenSize())
local PixelPerfectScale = 768 / string.match(Resolution, "%d+x(%d+)")

Utils.Settings = {}
Utils.API = {}
Utils.Functions = {}
Utils.DefaultSettings = {
    ["UIScale"] = PixelPerfectScale,
}

Utils.Functions.AddAPI = function(object)
    local mt = getmetatable(object).__index

    for API, FUNCTIONS in pairs(Utils.API) do
        if not object[API] then mt[API] = Utils.API[API] end
    end
end

Utils.Functions.OnEvent = function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        SetCVar("uiScale", self.Settings.UIScale)
        SetCVar("useUiScale", 1)

         --Allow 4K and WQHD Resolution to have an UIScale lower than 0.64, which is
         --the lowest value of UIParent scale by default
        if (self.Settings.UIScale < 0.64) then
            UIParent:SetScale(self.Settings.UIScale)
        end

    elseif event == "ADDON_LOADED" then
        local Addon = ...

        if Addon == "Vorkui" then
            self:Enable()
        end
    end
end

Utils.Functions.HideBlizzard = function(self)
    Display_UseUIScale:Hide()
    Display_UIScaleSlider:Hide()
end

Utils.Functions.RegisterDefaultSettings = function(self)
    for Option, Parameter in pairs(self.DefaultSettings) do
        if not self.Settings[Option] then
            self.Settings[Option] = Parameter
        end
    end
end

---------------------------------------------------
-- Utils init
---------------------------------------------------

Utils.Enable = function(self)
    local Handled = {["Frame"] = true}
    local Object = CreateFrame("Frame")
    local AddAPI = self.Functions.AddAPI
    local AddFrames = self.Functions.AddFrames
    local AddHooks = self.Functions.AddHooks
    local HideBlizzard = self.Functions.HideBlizzard
    local RegisterDefaultSettings = self.Functions.RegisterDefaultSettings

    AddAPI(Object)
    AddAPI(Object:CreateTexture())
    AddAPI(Object:CreateFontString())

    Object = EnumerateFrames()

    while Object do
        if not Object:IsForbidden() and not Handled[Object:GetObjectType()] then
            AddAPI(Object)

            Handled[Object:GetObjectType()] = true
        end

        Object = EnumerateFrames(Object)
    end

    RegisterDefaultSettings(self)
    HideBlizzard(self)
end

Utils:RegisterEvent("PLAYER_LOGIN")
Utils:RegisterEvent("ADDON_LOADED")
print ("|cFF10FF10 BIND UTILS EVENT|r")
Utils:SetScript("OnEvent", Utils.Functions.OnEvent)

V.Utils = Utils

---------------------------------------------------
-- API func
---------------------------------------------------

Utils.API.CreateBorder = function( self, size, color )
    self.Borders = {}

    local top = self:CreateTexture(nil, "BORDER", nil, 1)
    top:SetSize(size, size)
    top:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)

    local bottom = self:CreateTexture(nil, "BORDER", nil, 1)
    bottom:SetSize(size, size)
    bottom:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)

    local left = self:CreateTexture(nil, "BORDER", nil, 1)
    left:SetSize(size, size)
    left:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
    left:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)

    local right = self:CreateTexture(nil, "BORDER", nil, 1)
    right:SetSize(size, size)
    right:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
    right:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)

    tinsert(self.Borders, top)
    tinsert(self.Borders, bottom)
    tinsert(self.Borders, left)
    tinsert(self.Borders, right)

    if color then
        self:SetBorderColor(color)
    end
end

Utils.API.SetBorderColor = function (self, color )
    if self.Borders and type(self.Borders) == 'table' then
        for _, b in ipairs(self.Borders) do
            b:SetColorTexture(unpack(color))
        end
    end
end

Utils.API.GetRealSize = function(self)
    local childs = { self:GetRegions() }

    local width = self:GetWidth()
    local height = self:GetHeight()

    if self.text then
        width = width + self.text:GetWrappedWidth()
        height = height + self.text:GetStringHeight()
    end

    for _, child in ipairs(childs) do
        local w, h = child:GetRealSize()
        width = width + w
        height = height + h
    end

    return width, height
end

--Grid aligned
Utils.API.UpdateWidgetsLayout = function (self, firstItemIndex)
    local maxWidth, maxHeight = self:GetWidth(), self:GetHeight()
    local width = 0
    local height = 0
    local firstItem = firstItemIndex or 1
    local lineCount = 0
    local nbItemPerLine = 0

    local w
    local nbItem = 0

    for i = firstItem, #self.Widgets do
        w = self.Widgets[i]
        if w:IsObjectType('Frame') and w.text then
            width = max(width, w:GetWidth() + w.text:GetWrappedWidth() + 20 )
            height = max(height, w:GetHeight(), w.text:GetStringHeight())
        else
            width = max(width, w:GetWidth() + 4 )
            height = max(height, w:GetHeight())
        end
    end

    nbItemPerLine = math.floor( maxWidth / width )
    lineCount = math.floor((#self.Widgets - firstItemIndex + 1)/nbItemPerLine) + 1

    for i = firstItem, #self.Widgets do
        w = self.Widgets[i]
        if nbItem < nbItemPerLine then
            if i-1 >= firstItemIndex then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", self.Widgets[i-1], "TOPLEFT", width + 2, 0)
            else
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", 2, -10)
            end
            nbItem = nbItem + 1
        else
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", self.Widgets[firstItem], "BOTTOMLEFT", 0, -2)
            firstItem = i
            nbItem = 1
        end
    end
end

Utils.API.ShallowCopyTableRecursivelyIgnoring = function(self, orig, degree, degreeMax, ignoreField)

    local orig_type = type(orig)
    local copy
    if orig_type == 'table' and degree <= degreeMax then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            --if type(orig_key) == 'number' then
            --    copy = self:ShallowCopyTableRecursivelyIgnoring(orig_value, degree + 1, degreeMax, ignoreField)
            --else
                if type(orig_value) == 'table' then
                copy[orig_key] = self:ShallowCopyTableRecursivelyIgnoring(orig_value, degree + 1, degreeMax, ignoreField)
            else
                if type(ignoreField) == 'string' and orig_key ~= ignoreField then
                    copy[orig_key] = orig_value
                elseif type(ignoreField) == 'table' and ignoreField[orig_key] == nil then
                    copy[orig_key] = orig_value
                end
            end
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

Utils.API.ShallowCopyTableRecursively = function(self, orig, degree, degreeMax)

    local orig_type = type(orig)
    local copy
    if orig_type == 'table' and degree <= degreeMax then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            if type(orig_value) == 'table' then
                copy[orig_key] = self:ShallowCopyTableRecursively(orig_value, degree + 1, degreeMax)
            else
                copy[orig_key] = orig_value
            end
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

Utils.API.ShallowCopyTable = function(self, orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

Utils.API.Point = function (self, point, root)
    if self == nil then
        print ("|cFFFF2200 ERROR API POINT self == nil|r")
    end

    if type(point) == 'string' then
        self:SetPoint(point)
    else
        local anchor, parent, relativePoint, xOff, yOff = unpack(point)

        if parent == nil then
            parent = self:GetParent()
            self:SetPoint(anchor, parent, relativePoint, xOff, yOff)
        elseif type(parent) == 'string' then
            if strlower(parent) == 'uiparent' then
                self:SetPoint(anchor, parent, relativePoint, xOff, yOff)
            else
                if self[parent] then
                    parent = self[parent]
                elseif root and root[parent] then
                    parent = root[parent]
                else
                    --look if GetParent()[parent] exists
                    local realParent = self:GetParent()
                    parent = realParent[parent] or realParent
                end
                --parent = self[parent] or self:GetParent()
                self:SetPoint(anchor, parent, relativePoint, xOff, yOff)
            end
        end

        return anchor, parent, relativePoint, xOff, yOff
    end
end
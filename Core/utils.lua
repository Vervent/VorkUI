print ("UTILS.LUA")

local V,C,L = select(2,...):unpack()

local CreateFrame = CreateFrame

local Utils = CreateFrame("Frame")
local strlower = strlower
local tinsert = tinsert
local EnumerateFrames = EnumerateFrames

local type = type
local print = print
local pairs = pairs
local ipairs = ipairs
local getmetatable = getmetatable
local string = string
local select = select
local unpack = unpack
local math = math
local min = min
local max = max
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

Utils.API.UpdateWidgetsFloatLayout = function(self, firstItemIndex, paddingTop, paddingBottom)
    local maxWidth, maxHeight = self:GetWidth(), self:GetHeight()

    local width = 0
    local height = 0
    local firstItem = firstItemIndex or 1
    local lineCount = 1
    local newWidth = 0
    local w

    for i = firstItem, #self.Widgets do
        w = self.Widgets[i]
        height = max(height, w:GetHeight())
        newWidth = width + w:GetWidth()
        if newWidth > maxWidth then
            --cut to index i to end
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", self.Widgets[firstItem], "BOTTOMLEFT", 0, -2)
            firstItem = i
            lineCount = lineCount + 1
            width = newWidth - width
        else
            if i-1 >= firstItemIndex then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", self.Widgets[i-1], "TOPRIGHT", 2, 0)
            end
            width = newWidth
        end
    end
    local newHeight = height * lineCount + lineCount * 2 + paddingTop + paddingBottom

    if newHeight > maxHeight then
        --We change height, so we need to replace first item as every other button are anchored on it
        self.Widgets[firstItemIndex]:ClearAllPoints()
        self.Widgets[firstItemIndex]:SetPoint("TOPLEFT", 2, -(paddingTop or 0))

        return newHeight
    end

    return maxHeight

end

--Grid aligned
Utils.API.UpdateWidgetsLayout = function (self, firstItemIndex, paddingTop, paddingBottom)
    local maxWidth, maxHeight = self:GetWidth(), self:GetHeight()

    if maxWidth == 0 then
        return 0
    end

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
            if type(w.text) ~= 'string' then
                width = max(width, w:GetWidth() + w.text:GetWrappedWidth() )
                height = max(height, w:GetHeight(), w.text:GetStringHeight())
            else
                width = max(width, w:GetTextWidth() + 20 )
                height = max(height, w:GetTextHeight())
            end
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
                w:SetPoint("TOPLEFT", 0, - (paddingTop or 0))
            end
            nbItem = nbItem + 1
        else
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", self.Widgets[firstItem], "BOTTOMLEFT", 0, 0)
            firstItem = i
            nbItem = 1
        end
    end

    return lineCount*height + (paddingTop or 0) + (paddingBottom or 0)
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

local function GetRealParent(self, parent, root)
    if parent == nil then
        return self:GetParent()
    elseif strlower(parent) == 'uiparent' then
        return parent
    else
        if self[parent] then
            return self[parent]
        elseif root and root[parent] then
            return root[parent]
        else
            local realParent = self:GetParent()
            return realParent[parent] or realParent
        end
    end

    return nil
end

Utils.API.Point = function (self, point, root)
    if self == nil then
        print ("|cFFFF2200 ERROR API POINT self == nil|r")
    end

    if type(point) == 'string' then
        self:SetPoint(point)
    else
        local anchor, parent, relativePoint, xOff, yOff
        if type(point[1]) == 'table' then
            for _, p in pairs(point) do
                anchor, parent, relativePoint, xOff, yOff = unpack(p)
                parent = GetRealParent(self, parent, root)
                self:SetPoint(anchor, parent, relativePoint, xOff, yOff)
            end
        else
            anchor, parent, relativePoint, xOff, yOff = unpack(point)
            parent = GetRealParent(self, parent, root)
            self:SetPoint(anchor, parent, relativePoint, xOff, yOff)
        end
    end
end

local V, C, L = select(2, ...):unpack()
V.Hider:Hide()

local CreateFrame = CreateFrame

local Module = V.Module
local Utils = Module:RegisterModule('Utils', false)
--local Utils = CreateFrame("Frame")
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
local Resolution = select(1, GetPhysicalScreenSize()) .. "x" .. select(2, GetPhysicalScreenSize())
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
        if not object[API] then
            mt[API] = Utils.API[API]
        end
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

Utils.Functions.RGBToHex = function(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0

    return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

-- Return short value of a number!
Utils.Functions.ShortValue = function(v)
    if (v >= 1e6) then
        return gsub(format("%.1fm", v / 1e6), "%.?0+([km])$", "%1")
    elseif (v >= 1e3 or v <= -1e3) then
        return gsub(format("%.1fk", v / 1e3), "%.?0+([km])$", "%1")
    else
        return v
    end
end

Utils.Functions.FormatMoney = function(money)
    local copperIcon = [[interface/icons/inv_misc_coin_05]]
    local silverIcon = [[interface/icons/inv_misc_coin_03]]
    local goldIcon = [[interface/icons/inv_misc_coin_01]]

    local copper = money % 100
    local silver = floor((money % 10000) / 100)
    local gold = floor(money / 10000)

    if gold > 999999 then
        return format('%.2fm|T%s:0:1|t', gold / 1000000, goldIcon)
    elseif gold > 9999 then
        return format('%.2fk|T%s:0:1|t%.0f|T%s:0:1|t', gold / 1000, goldIcon, silver, silverIcon)
    else
        return format('%.f|T%s:0:1|t%.0f|T%s:0:1|t%.0f|T%s:0:1|t', gold, goldIcon, silver, silverIcon, copper, copperIcon)
    end
end

Utils.Functions.FormatTime = function(s)
    if s == Infinity then
        return
    end

    local Day, Hour, Minute = 86400, 3600, 60

    if (s >= Day) then
        return format("%dd", ceil(s / Day))
    elseif (s >= Hour) then
        return format("%dh", ceil(s / Hour))
    elseif (s >= Minute) then
        return format("%dm", ceil(s / Minute))
    elseif (s >= Minute / 12) then
        return ceil(s)
    end

    return format("%.1f", s)
end
---------------------------------------------------
-- Utils init
---------------------------------------------------

Utils.Enable = function(self)
    local Handled = { ["Frame"] = true }
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
Utils:SetScript("OnEvent", Utils.Functions.OnEvent)

--V.Utils = Utils

---------------------------------------------------
-- API func
---------------------------------------------------
Utils.API.CreateBorderBySides = function(self, size, color, ...)

    for k, v in ipairs({ ... }) do
        self:CreateOneBorder(v, size, color)
    end

end

Utils.API.CreateOneBorder = function(self, side, size, color, o)
    local borders = self.Borders or {}

    local b = self:CreateTexture(nil, 'BORDER', nil, 1)
    b:SetSize(size, size)

    if side == 'top' then
        b:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, o or 0)
        b:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, o or 0)
    elseif side == 'bottom' then
        b:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, -(o or 0))
        b:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, -(o or 0))
    elseif side == 'right' then
        b:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', o or 0, 0)
        b:SetPoint('TOPRIGHT', self, 'TOPRIGHT', o or 0, 0)
    elseif side == 'left' then
        b:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', -(o or 0), 0)
        b:SetPoint('TOPLEFT', self, 'TOPLEFT', -(o or 0), 0)
    end

    if color then
        b:SetColorTexture(unpack(color))
    end

    tinsert(borders, b)
    self.Borders = borders
end

Utils.API.StripTextures = function(self, Kill)
    for i = 1, self:GetNumRegions() do
        local Region = select(i, self:GetRegions())
        if (Region and Region:GetObjectType() == "Texture") then
            if (Kill and type(Kill) == "boolean") then
                Region:Kill()
            elseif (Region:GetDrawLayer() == Kill) then
                Region:SetTexture(nil)
            elseif (Kill and type(Kill) == "string" and Region:GetTexture() ~= Kill) then
                Region:SetTexture(nil)
            else
                Region:SetTexture(nil)
            end
        end
    end
end

Utils.API.OrientedSetPoint = function(self, parent, isFirst, orientation)
    if orientation == 'UP' then
        if isFirst == true then
            self:SetPoint('BOTTOM', parent, 'BOTTOM', 0, 1)
        else
            self:SetPoint('BOTTOM', parent, 'TOP', 0, 1)
        end
    elseif orientation == 'DOWN' then
        if isFirst == true then
            self:SetPoint('TOP', parent, 'TOP', 0, -1)
        else
            self:SetPoint('TOP', parent, 'BOTTOM', 0, -1)
        end
    elseif orientation == 'RIGHT' then
        if isFirst == true then
            self:SetPoint('LEFT', parent, 'LEFT', 1, 0)
        else
            self:SetPoint('LEFT', parent, 'RIGHT', 1, 0)
        end
    else
        if isFirst == true then
            self:SetPoint('RIGHT', parent, 'RIGHT', -1, 0)
        else
            self:SetPoint('RIGHT', parent, 'LEFT', -1, 0)
        end
    end
end

Utils.API.DirectionalSetPoint = function(self, parent, isFirst, direction)
    if direction == 'VERTICAL' then
        if isFirst == true then
            self:SetPoint('TOP', parent, 'TOP', 0, 1)
        else
            self:SetPoint('TOP', parent, 'BOTTOM', 0, 1)
        end
    else
        if isFirst == true then
            self:SetPoint('LEFT', parent, 'LEFT', 1, 0)
        else
            self:SetPoint('LEFT', parent, 'RIGHT', 1, 0)
        end
    end
end

Utils.API.Kill = function(self, withChilds)

    if withChilds and self:GetNumChildren() > 0 then
        for _, c in ipairs({ self:GetChildren() }) do
            c:Kill()
        end
    end

    if (self.UnregisterAllEvents) then
        self:UnregisterAllEvents()
        self:SetParent(V.Hider)
    else
        self.Show = self.Hide
    end

    self:Hide()
end

Utils.API.CreateBackground = function(self, bg)
    local background = self:CreateTexture(nil, 'BACKGROUND')
    background:SetAllPoints()

    if type(bg) == 'string' then
        background:SetTexture(bg)
    elseif type(bg) == 'table' then
        background:SetColorTexture(unpack(bg))
    end

    return background
end

Utils.API.CreateBackdrop = function(self)
    local backdropInfo = {
        bgFile = [[Interface/Tooltips/UI-Tooltip-Background]],
        edgeFile = [[Interface/Tooltips/UI-Tooltip-Border]],
        edgeSize = 1,
    }

    local backdrop = CreateFrame('frame', nil, self, 'BackdropTemplate')
    backdrop:SetAllPoints()
    backdrop:SetFrameLevel(self:GetFrameLevel())
    --backdrop:CreateBorder(1, {1, 1, 1})

    backdrop:SetBackdrop(backdropInfo)
    --backdrop:SetBackdropColor(0, 0, 0, 1)

    self.Backdrop = backdrop
end

Utils.API.CreateBorder = function(self, size, color, layer)
    self.Borders = {}
    local l = layer or 'BORDER'

    local top = self:CreateTexture(nil, l, nil, 1)
    top:SetSize(size, size)
    top:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    top:SetSnapToPixelGrid(false)
    top:SetTexelSnappingBias(0)

    local bottom = self:CreateTexture(nil, l, nil, 1)
    bottom:SetSize(size, size)
    bottom:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
    bottom:SetSnapToPixelGrid(false)
    bottom:SetTexelSnappingBias(0)

    local left = self:CreateTexture(nil, l, nil, 1)
    left:SetSize(size, size)
    left:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
    left:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    left:SetSnapToPixelGrid(false)
    left:SetTexelSnappingBias(0)

    local right = self:CreateTexture(nil, l, nil, 1)
    right:SetSize(size, size)
    right:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
    right:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    right:SetSnapToPixelGrid(false)
    right:SetTexelSnappingBias(0)

    tinsert(self.Borders, top)
    tinsert(self.Borders, bottom)
    tinsert(self.Borders, left)
    tinsert(self.Borders, right)

    if color then
        self:SetBorderColor(color)
    end
end

Utils.API.SetBorderGradientColor = function(self, gradient)
    if self.Borders and type(self.Borders) == 'table' then
        for _, b in ipairs(self.Borders) do
            b:SetGradient(unpack(gradient))
        end
    end
end

Utils.API.SetBorderTexture = function(self, texture)
    if self.Borders and type(self.Borders) == 'table' then
        for _, b in ipairs(self.Borders) do
            b:SetTexture(texture)
        end
    end
end

Utils.API.SetBorderVertexColor = function(self, color)
    if self.Borders and type(self.Borders) == 'table' then
        for _, b in ipairs(self.Borders) do
            b:SetVertexColor(unpack(color))
        end
    end
end

Utils.API.SetBorderColor = function(self, color)
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
            if i - 1 >= firstItemIndex then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", self.Widgets[i - 1], "TOPRIGHT", 2, 0)
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

Utils.API.UpdateFloatLayoutOnWidgets = function(self, widgets, paddingTop, paddingBottom)
    local maxWidth, maxHeight = self:GetWidth(), self:GetHeight()

    local width = 0
    local height = 0
    local firstItem = 1
    local lineCount = 0
    local newWidth = 0
    local w

    for i = 1, #widgets do
        w = widgets[i]
        height = max(height, w:GetHeight())
        newWidth = width + w:GetWidth()
        if newWidth > maxWidth then
            --cut to index i to end
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", widgets[firstItem], "BOTTOMLEFT", 0, -2)
            firstItem = i
            lineCount = lineCount + 1
            width = newWidth - width
        else
            if i - 1 >= 1 then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", widgets[i - 1], "TOPRIGHT", 2, 0)
            end
            width = newWidth
        end
    end
    local newHeight = height * lineCount + paddingTop + paddingBottom

    if newHeight > maxHeight then
        --We change height, so we need to replace first item as every other button are anchored on it
        widgets[1]:ClearAllPoints()
        widgets[1]:SetPoint("TOPLEFT", 2, -(paddingTop or 0))

        return newHeight
    end

    return maxHeight

end

--Grid aligned by component type
Utils.API.UpdateLayoutOnWidgets = function(self, widgets, paddingTop, paddingBottom)
    local maxWidth, maxHeight = self:GetWidth(), self:GetHeight()

    if maxWidth == 0 then
        return 0
    end

    local width = 0
    local height = 0
    local firstItem = 1
    local lineCount = 0
    local nbItemPerLine = 0

    local w
    local nbItem = 0

    for i = firstItem, #widgets do
        w = widgets[i]
        if w:IsShown() then
            if w:IsObjectType('Frame') and w.text then
                if type(w.text) ~= 'string' then
                    width = max(width, w:GetWidth() + w.text:GetWrappedWidth())
                    height = max(height, w:GetHeight(), w.text:GetStringHeight())
                else
                    width = max(width, w:GetTextWidth() + 20)
                    height = max(height, w:GetTextHeight())
                end
            else
                width = max(width, w:GetWidth() + 4)
                height = max(height, w:GetHeight())
            end
        end
    end

    nbItemPerLine = math.floor(maxWidth / width)
    lineCount = math.floor((#widgets) / nbItemPerLine) + 1

    for i = firstItem, #widgets do
        w = widgets[i]
        if nbItem < nbItemPerLine then
            if i - 1 >= 1 then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", widgets[i - 1], "TOPLEFT", width + 2, 0)
            else
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", 0, -(paddingTop or 0))
            end
            nbItem = nbItem + 1
        else
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", widgets[firstItem], "BOTTOMLEFT", 0, 0)
            firstItem = i
            nbItem = 1
        end
    end

    return lineCount * height + (paddingTop or 0) + (paddingBottom or 0)
end

Utils.API.UpdateWidgetsByTypeLayout = function(self, widgetType, paddingTop, paddingBottom)
    local maxWidth, maxHeight = self:GetWidth(), self:GetHeight()

    if maxWidth == 0 then
        return 0
    end

    local width = 0
    local height = 0
    local firstItem = 1
    local lineCount = 0
    local nbItemPerLine = 0

    local w
    local nbItem = 0
    local widgets = {}
    for k, v in ipairs(self.Widgets) do
        if v.type == widgetType then
            tinsert(widgets, v)
        end
    end

    for i = firstItem, #widgets do
        w = widgets[i]
        if w:IsObjectType('Frame') and w.text then
            if type(w.text) ~= 'string' then
                width = max(width, w:GetWidth() + w.text:GetWrappedWidth())
                height = max(height, w:GetHeight(), w.text:GetStringHeight())
            else
                width = max(width, w:GetTextWidth() + 20)
                height = max(height, w:GetTextHeight())
            end
        else
            width = max(width, w:GetWidth() + 4)
            height = max(height, w:GetHeight())
        end
    end

    nbItemPerLine = math.floor(maxWidth / width)
    lineCount = math.floor((#widgets) / nbItemPerLine) + 1

    for i = firstItem, #widgets do
        w = widgets[i]
        if nbItem < nbItemPerLine then
            if i - 1 >= 1 then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", widgets[i - 1], "TOPLEFT", width + 2, 0)
            else
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", 0, -(paddingTop or 0))
            end
            nbItem = nbItem + 1
        else
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", widgets[firstItem], "BOTTOMLEFT", 0, 0)
            firstItem = i
            nbItem = 1
        end
    end

    return lineCount * height + (paddingTop or 0) + (paddingBottom or 0)
end

--Grid aligned
Utils.API.UpdateWidgetsLayout = function(self, firstItemIndex, paddingTop, paddingBottom)
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
                width = max(width, w:GetWidth() + w.text:GetWrappedWidth())
                height = max(height, w:GetHeight(), w.text:GetStringHeight())
            else
                width = max(width, w:GetTextWidth() + 20)
                height = max(height, w:GetTextHeight())
            end
        else
            width = max(width, w:GetWidth() + 4)
            height = max(height, w:GetHeight())
        end
    end

    nbItemPerLine = math.floor(maxWidth / width)
    lineCount = math.floor((#self.Widgets - firstItemIndex + 1) / nbItemPerLine) + 1

    for i = firstItem, #self.Widgets do
        w = self.Widgets[i]
        if nbItem < nbItemPerLine then
            if i - 1 >= firstItemIndex then
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", self.Widgets[i - 1], "TOPLEFT", width + 2, 0)
            else
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", 0, -(paddingTop or 0))
            end
            nbItem = nbItem + 1
        else
            w:ClearAllPoints()
            w:SetPoint("TOPLEFT", self.Widgets[firstItem], "BOTTOMLEFT", 0, 0)
            firstItem = i
            nbItem = 1
        end
    end

    return lineCount * height + (paddingTop or 0) + (paddingBottom or 0)
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
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

Utils.API.DeepCopyTable = function(self, orig)
    local copy = {}

    local clone = { unpack(orig) }
    for i = 1, #clone do
        if type(clone[i]) == 'table' then
            copy[i] = self:DeepCopyTable(clone[i])
        else
            copy[i] = clone[i]
        end
    end

    for k, v in pairs(orig) do
        if type(k) ~= 'number' or math.floor(k) ~= k then
            if type(v) == 'table' then
                if next(v) == nil then
                    --empty table
                    copy[k] = {}
                else
                    copy[k] = self:DeepCopyTable(v)
                end
            else
                copy[k] = v
            end
        end
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
                local clone = { unpack(orig_value) }
                for i = 1, #clone do
                    print(i, tab[i])
                end

                if type(orig_key) == 'number' then
                    tinsert(copy, self:ShallowCopyTableRecursively(orig_value, degree + 1, degreeMax))
                else
                    copy[orig_key] = self:ShallowCopyTableRecursively(orig_value, degree + 1, degreeMax)
                end
            else
                if type(orig_key) == 'number' then
                    tinsert(copy, orig_value or nil)
                else
                    copy[orig_key] = orig_value or nil
                end
            end
        end
    else
        -- number, string, boolean, etc
        copy = orig or nil
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
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function GetRealParent(self, parent, root)
    if parent == nil then
        return self:GetParent()
    elseif type(parent) == 'string' and strlower(parent) == 'uiparent' then
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

Utils.API.Point = function(self, point, root)
    if self == nil then
        print("|cFFFF2200 ERROR API POINT self == nil|r")
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

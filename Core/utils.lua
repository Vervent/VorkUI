local V,C,L = select(2,...):unpack()

local CreateFrame = CreateFrame

local Utils = CreateFrame("Frame", "UTILS", UIParent)

---------------------------------------------------
-- Basic Utils
---------------------------------------------------

Utils.Settings = {}
Utils.API = {}
Utils.Functions = {}
Utils.DefaultSettings = {}

Utils.Functions.AddAPI = function(object)
    local mt = getmetatable(object).__index

    for API, FUNCTIONS in pairs(Utils.API) do
        if not object[API] then mt[API] = Utils.API[API] end
    end
end

Utils.Functions.OnEvent = function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        --SetCVar("uiScale", self.Settings.UIScale)
        --SetCVar("useUiScale", 1)

        -- Allow 4K and WQHD Resolution to have an UIScale lower than 0.64, which is
        -- the lowest value of UIParent scale by default
        --if (self.Settings.UIScale < 0.64) then
        --    UIParent:SetScale(self.Settings.UIScale)
        --end
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
Utils:SetScript("OnEvent", Utils.Functions.OnEvent)

V.Utils = Utils

---------------------------------------------------
-- API func
---------------------------------------------------

Utils.API.CreateBorder = function( self, size )
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
end

Utils.API.SetBorderColor = function (self, color )
    if self.Borders and type(self.Borders) == 'table' then
        for _, b in ipairs(self.Borders) do
            b:SetColorTexture(unpack(color))
        end
    end
end

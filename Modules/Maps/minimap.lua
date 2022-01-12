local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...
local LibStub = LibStub
local LibDBIcon = LibStub:GetLibrary('LibDBIcon-1.0') or nil
local LibDataBroker = LibStub:GetLibrary("LibDataBroker-1.1") or nil

local DebugFrames = V['DebugFrames']
local Medias = V["Medias"]
local Minimap = V['Minimap']
local C_Map = C_Map
local CreateFrame = CreateFrame

local addonBtn = nil
local backdropInfo = {
    bgFile = [[Interface/Tooltips/UI-Tooltip-Background]],
    edgeFile = [[Interface/Tooltips/UI-Tooltip-Border]],
    edgeSize = 2,
}

local Interval = 1
Minimap.ZoneColors = {
    ["friendly"] = {0.1, 1.0, 0.1},
    ["sanctuary"] = {0.41, 0.8, 0.94},
    ["arena"] = {1.0, 0.1, 0.1},
    ["hostile"] = {1.0, 0.1, 0.1},
    ["contested"] = {1.0, 0.7, 0.0},
}

local blank = [[Interface\AddOns\VorkUI\Medias\Textures\blank]]
local rect = [[Interface\AddOns\VorkUI\Medias\Textures\rectangle]]

local maskSetup = {
    ['blank'] = {
        ZoneTextPoint = { 'TOP', 0, -4 },
        TrackingPoint = { 'TOPLEFT', 0, -0 },
        GameTimeFramePoint = { 'TOPRIGHT', -0, -0 },
        AddonButtonPoint = { 'BOTTOMLEFT', 0, 0 },
        QueuePoint = { 'BOTTOMRIGHT', 0, 0 },
        Point = { 'TOPRIGHT', UIParent, 'TOPRIGHT', -20, -32 },
        Texture = [[Interface\AddOns\VorkUI\Medias\Textures\blank]],
    },
    ['rect'] = {
        ZoneTextPoint = { 'TOP', 0, -4 },
        TrackingPoint = { 'TOPLEFT', 0, -46 },
        GameTimeFramePoint = { 'TOPRIGHT', 0, -46 },
        AddonButtonPoint = { 'BOTTOMLEFT', 0, 46 },
        QueuePoint = { 'BOTTOMRIGHT', 0, 46 },
        Point = { 'TOPRIGHT', UIParent, 'TOPRIGHT', -20, 0 },
        Texture = [[Interface\AddOns\VorkUI\Medias\Textures\rectangle]],
    }
}

local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local floor = math.floor
local unpack = unpack

function getDBIcon(self)
    if LibDBIcon == nil then
        self.AddonButton:Hide()
        return
    end

    if self.AddonButton then
        self.AddonButton:Show()
    end

    local nameList = LibDBIcon:GetButtonList()
    addonBtn = {}
    for _, name in ipairs(nameList) do
        tinsert(addonBtn, LibDBIcon:GetMinimapButton(name))
    end
end

function Minimap:GetMinimapShape()
    return "SQUARE"
end

function Minimap:SizeMinimap()
    local x, y = self:GetSize()
    if x == 0 then x = 300 end
    if y == 0 then y = 300 end
    local scale = C.MinimapScale or 2.5

    self:SetSize(x * scale, y * scale)
end
function Minimap:UpdateCoords(t)
    if (Minimap.MinimapCoords:GetAlpha() == 0) then
        Interval = 0

        return
    end

    Interval = Interval - t

    if (Interval < 0) then
        local UnitMap = C_Map.GetBestMapForUnit("player")
        local X, Y = 0, 0

        if UnitMap then
            local GetPlayerMapPosition = C_Map.GetPlayerMapPosition(UnitMap, "player")

            if GetPlayerMapPosition then
                X, Y = C_Map.GetPlayerMapPosition(UnitMap, "player"):GetXY()
            end
        end

        local XText, YText

        X = floor(100 * X)
        Y = floor(100 * Y)

        if (X == 0 and Y == 0) then
            Minimap.MinimapCoords:Hide()
        else
            Minimap.MinimapCoords:Show()

            if (X < 10) then
                XText = "0"..X
            else
                XText = X
            end

            if (Y < 10) then
                YText = "0"..Y
            else
                YText = Y
            end

            Minimap.MinimapCoords.Text:SetText(XText .. ", " .. YText)
        end

        Interval = 1
    end
end

function Minimap:MoveGarrisonButton()
    --GarrisonLandingPageMinimapButton:Hide()
    GarrisonLandingPageMinimapButton:ClearAllPoints()
    GarrisonLandingPageMinimapButton:SetPoint("BOTTOM")
end

function Minimap:DisableMinimapElements()
    local time = _G["TimeManagerClockButton"]
    local north = _G["MinimapNorthTag"]
    local hiddenFrames = {
        --"MinimapCluster",
        "MinimapBorder",
        "MinimapBorderTop",
        "MinimapZoomIn",
        "MinimapZoomOut",
        "MinimapNorthTag",
        --"MinimapZoneTextButton",
        --"GameTimeFrame",
        "MiniMapWorldMapButton",
        --"MinimapBackdrop",
    }

    local frame
    for i, frameName in pairs(hiddenFrames) do
        frame = _G[frameName]
        frame:Hide()

        if frame.UnregisterAllEvents then
            frame:UnregisterAllEvents()
        end
    end

    north:SetTexture(nil)

    if time then
        time:Kill()
    end
end

function Minimap:StyleMinimap(shape)
    local mail = MiniMapMailFrame
    local mailBorder = MiniMapMailBorder
    local mailIcon = MiniMapMailIcon
    local zoneTextButton = MinimapZoneTextButton
    local QueueStatusMinimapButton = QueueStatusMinimapButton
    local QueueStatusFrame = QueueStatusFrame
    local MiniMapInstanceDifficulty = MiniMapInstanceDifficulty
    local GuildInstanceDifficulty = GuildInstanceDifficulty
    local HelpOpenTicketButton = HelpOpenTicketButton
    local MiniMapTracking = MiniMapTracking

    local maskTable = maskSetup[shape]

    self:SetParent(UIParent)
    self:ClearAllPoints()
    self:SetPoint(unpack(maskTable.Point))
    --self:SetMovable(true)
    self:SetMaskTexture(maskTable.Texture)
    self.Backdrop = MinimapBackdrop
    self.Backdrop:ClearAllPoints()
    self.Backdrop:SetPoint('TOPRIGHT', self, 'TOPRIGHT')
    self.Backdrop:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT')
    --self.Backdrop:CreateBorder(1, {GetClassColor(select(2, UnitClass('Player')))})
    self.ZoneText = MinimapZoneText
    zoneTextButton:ClearAllPoints()
    zoneTextButton:SetPoint(unpack(maskTable.ZoneTextPoint))

    self.Cluster = MinimapCluster
    self.Cluster:SetParent(self)
    self.Cluster:EnableMouse(false)
    self.Cluster:ClearAllPoints()
    if shape == 'rect' then
        self.Cluster:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, -46)
        self.Cluster:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 46)
    else
        self.Cluster:SetAllPoints()
    end

    self.GameTimeFrame = GameTimeFrame
    self.GameTimeFrame:ClearAllPoints()
    self.GameTimeFrame:SetPoint(unpack(maskTable.GameTimeFramePoint))

    mail:ClearAllPoints()
    mail:SetPoint("BOTTOMRIGHT", 3, -4)
    mail:SetFrameLevel(QueueStatusMinimapButton:GetFrameLevel() - 2)
    mailBorder:Hide()
    --mailIcon:SetTexture("Interface\\AddOns\\Tukui\\Medias\\Textures\\Others\\Mail")
    --
    self:SetArchBlobRingScalar(0)
    self:SetQuestBlobRingScalar(0)

    MiniMapTracking:SetParent(self)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint(unpack(maskTable.TrackingPoint))

    QueueStatusMinimapButton:SetParent(self)
    QueueStatusMinimapButton:ClearAllPoints()
    QueueStatusMinimapButton:SetPoint(unpack(maskTable.QueuePoint))
    QueueStatusMinimapButton:SetFrameLevel(QueueStatusMinimapButton:GetFrameLevel() + 2)
    QueueStatusMinimapButtonBorder:Kill()

    QueueStatusFrame:StripTextures()

    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetParent(self)
    MiniMapInstanceDifficulty:SetPoint(unpack(maskTable.TrackingPoint))

    GuildInstanceDifficulty:ClearAllPoints()
    GuildInstanceDifficulty:SetParent(self)
    GuildInstanceDifficulty:SetPoint(unpack(maskTable.TrackingPoint))

    GarrisonLandingPageMinimapButton:Kill()

end

function Minimap:AddZoneAndCoords()

    local MinimapCoords = CreateFrame("Frame", "VorkuiMinimapCoord", self)
    MinimapCoords:SetSize(40, 19)
    MinimapCoords:SetPoint('TOP', MinimapZoneTextButton, 'BOTTOM', 0, -2)
    MinimapCoords:SetFrameStrata(self:GetFrameStrata())

    MinimapCoords.Text = MinimapCoords:CreateFontString("VorkuiMinimapCoordText", "OVERLAY")
    MinimapCoords.Text:SetFontObject('GameFontNormal')
    MinimapCoords.Text:SetPoint('CENTER')

    -- Update coordinates
    MinimapCoords:SetScript("OnUpdate", self.UpdateCoords)

    self.MinimapCoords = MinimapCoords
end

function Minimap:EnableMouseWheelZoom()
    self:EnableMouseWheel(true)
    self:SetScript("OnMouseWheel", function(self, delta)
        if (delta > 0) then
            MinimapZoomIn:Click()
        elseif (delta < 0) then
            MinimapZoomOut:Click()
        end
    end)
end

function Minimap:TaxiExitOnEvent(event)
    if CanExitVehicle() then
        if (UnitOnTaxi("player")) then
            self.Text:SetText("|cffFF0000" .. TAXI_CANCEL .. "|r")
        else
            self.Text:SetText("|cffFF0000" .. BINDING_NAME_VEHICLEEXIT .. "|r")
        end

        self:Show()
    elseif UnitOnTaxi("player") then
        self.Text:SetText("|cffFF0000" .. TAXI_CANCEL .. "|r")

        self:Show()
    else
        self:Hide()
    end
end

function Minimap:TaxiExitOnClick()
    if (UnitOnTaxi("player")) then
        TaxiRequestEarlyLanding()
    else
        VehicleExit()
    end

    Minimap.EarlyExitButton:Hide()
end

function Minimap:AddTaxiEarlyExit()
    Minimap.EarlyExitButton = CreateFrame("Button", nil, self)
    --Minimap.EarlyExitButton:SetAllPoints(T.DataTexts.Panels.Minimap)
    --Minimap.EarlyExitButton:SetSize(T.DataTexts.Panels.Minimap:GetWidth(), T.DataTexts.Panels.Minimap:GetHeight())
    --Minimap.EarlyExitButton:SkinButton()
    Minimap.EarlyExitButton:ClearAllPoints()
    --Minimap.EarlyExitButton:SetAllPoints(T.DataTexts.Panels.Minimap)
    --Minimap.EarlyExitButton:SetFrameLevel(T.DataTexts.Panels.Minimap:GetFrameLevel() + 2)
    Minimap.EarlyExitButton:RegisterForClicks("AnyUp")
    Minimap.EarlyExitButton:SetScript("OnClick", Minimap.TaxiExitOnClick)
    Minimap.EarlyExitButton:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
    Minimap.EarlyExitButton:RegisterEvent("PLAYER_ENTERING_WORLD")
    Minimap.EarlyExitButton:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    Minimap.EarlyExitButton:RegisterEvent("UNIT_ENTERED_VEHICLE")
    Minimap.EarlyExitButton:RegisterEvent("UNIT_EXITED_VEHICLE")
    Minimap.EarlyExitButton:RegisterEvent("VEHICLE_UPDATE")
    Minimap.EarlyExitButton:RegisterEvent("PLAYER_ENTERING_WORLD")
    Minimap.EarlyExitButton:SetScript("OnEvent", Minimap.TaxiExitOnEvent)
    Minimap.EarlyExitButton:Hide()

    Minimap.EarlyExitButton.Text = Minimap.EarlyExitButton:CreateFontString(nil, "OVERLAY")
    Minimap.EarlyExitButton.Text:SetFontObject(Medias:GetFont('Montserrat Bold Italic14'))
    Minimap.EarlyExitButton.Text:SetPoint("CENTER", 0, 0)
    Minimap.EarlyExitButton.Text:SetShadowOffset(1.25, -1.25)
end

function expand(btn)
    btn.Icon:SetRotation(0)
    btn.isExpanded = true
    btn.Panel:Show()
end

function collapse(btn)
    btn.Icon:SetRotation(math.pi/2)
    btn.isExpanded = false
    btn.Panel:Hide()
end

function Minimap:HookButton()
    local width, height, maxIdx = 0, 0, 0
    local btn = self.AddonButton

    getDBIcon(self)
    if addonBtn then
        local btnWidth = addonBtn[1]:GetWidth()
        local w = btnWidth * #addonBtn
        local mapWidth = self:GetWidth()
        if w > mapWidth then
            --we need to have multiple line for buttons
            width = mapWidth
            maxIdx = floor(width/btnWidth)
            height = floor(#addonBtn/maxIdx + 1) * addonBtn[1]:GetHeight()
        else
            width = w
            height = addonBtn[1]:GetHeight()
        end
        local line, col = 1, 1
        for i, b in ipairs(addonBtn) do
            b:SetParent(btn.Panel)

            for _, r in ipairs({b:GetRegions()}) do
                if r ~= b.icon then
                    r:Kill()
                end
            end

            b:ClearAllPoints()
            if line == 1 and col == 1 then
                b:SetPoint('TOPLEFT', btn.Panel)
            elseif line > 1 and col == 1 then
                b:SetPoint('TOPLEFT', addonBtn[i-maxIdx], 'BOTTOMLEFT')
            else
                b:SetPoint('LEFT', addonBtn[i-1], 'RIGHT')
            end
            if col == maxIdx then
                line = line + 1
                col = 1
            else
                col = col + 1
            end
        end
    end

    btn.Panel:SetSize(width, height)
end

function Minimap:AddAddonBtnRegion(shape)
    local width, height, maxIdx = 0, 0, 0
    local maskTable = maskSetup[shape]
    local btn
    btn = CreateFrame("Button", nil, self)
    btn:SetSize(32,32)
    btn:SetPoint(unpack(maskTable.AddonButtonPoint))

    btn.Icon = btn:CreateTexture(nil, 'BACKGROUND')
    btn.Icon:SetAllPoints()
    btn.Icon:SetTexture('interface/talentframe/ui-talentarrows.blp')
    btn.Icon:SetTexCoord(0, 0.5, 0, 0.5)

    btn.Panel = CreateFrame("Frame", nil, btn, 'BackdropTemplate')
    btn.Panel:SetPoint('TOPLEFT', btn, 'BOTTOMLEFT')
    btn.Panel.Background = btn.Panel:CreateTexture (nil, 'BACKGROUND')
    btn.Panel.Background:SetAllPoints()
    btn.Panel.Background:SetTexture(Medias:GetStatusBar('VorkuiBackground'))
    btn.Panel:Hide()

    collapse(btn)

    btn:SetScript('OnClick', function(b)
        if btn.isExpanded == true then
            collapse(b)
        else
            expand(b)
        end
    end)
    self.AddonButton = btn
end

function Minimap:Enable()
    local shape = 'blank'

    self:DisableMinimapElements()
    self:StyleMinimap(shape)
    --self:AddMinimapDataTexts()
    self:AddZoneAndCoords()
    self:AddAddonBtnRegion(shape)

    --self:EnableMouseOver()
    self:EnableMouseWheelZoom()
    self:AddTaxiEarlyExit()
    self:HookButton()

    --hooksecurefunc("GarrisonLandingPageMinimapButton_UpdateIcon", self.MoveGarrisonButton)
end

function Minimap:Disable()
end

Minimap:RegisterEvent('VARIABLES_LOADED')
Minimap:SetScript('OnEvent', function(self, event)
    if event == 'VARIABLES_LOADED' then
        self:SizeMinimap()
        self:UnregisterEvent('VARIABLES_LOADED')
    end
end)

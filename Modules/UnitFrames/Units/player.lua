local V, C, L = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local Class = select(2, UnitClass("player"))

--[[
    Player Configuration
]]--
local Config = {
    Absorb = {
        Textures ={
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\bubbles.tga]], "ARTWORK"
            },
            {
                {0,0,0,1}, "BACKGROUND", 1
            }
        },
        Size = { 232, 8 },
        Point = { "TOPRIGHT", "Frame", "TOPRIGHT", 0, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["FillInverse"] = true
        },
        StaticLayer = "BACKGROUND"
    },
    Health = {
        Textures ={
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_1.tga]], "ARTWORK"
            },
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_bg.tga]], "BACKGROUND", 1
            },
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_border.tga]], "OVERLAY"
            }
        },
        Size =  { 256, 32 },
        Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
        },
        StaticLayer = "BACKGROUND"
    },
    HealthPrediction = {
        Textures ={
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_1.tga]], "ARTWORK", 1
            },
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_border.tga]], "OVERLAY"
            }
        },
        Size =  { 256, 32 },
        --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
        }
    },
    Power = {
        Textures ={
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_1.tga]], "ARTWORK"
            },
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_bg.tga]], "BACKGROUND", 1
            }
        },
        Size =  { 235, 10 },
        Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -10, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
        },
        StaticLayer = "BACKGROUND"
    },
    PowerPrediction = {
        Textures ={
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_1.tga]], "ARTWORK", 1
            },
            {
                [[Interface\AddOns\VorkUI\Medias\StatusBar\status_border.tga]], "OVERLAY"
            }
        },
        Size =  { 235, 10 },
        --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["FillInverse"] = true
        }
    },
}

function UnitFrames:Player()

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    local textureClassIconPath = LibAtlas:GetPath("ClassIcon")
    local textureGlobalIconPath = LibAtlas:GetPath("GlobalIcon")
    local textureRaidIconPath = LibAtlas:GetPath("RaidIcon")

    local Frame = CreateFrame("Frame", nil, self)
    Frame:SetAllPoints()
    Frame.background = Frame:CreateTexture(nil, "BACKGROUND")
    Frame.background:SetAllPoints()
    Frame.background:SetColorTexture( 33/255, 44/255, 79/255, 0.75 )

    --
    ----[[
    --    FONT
    ----]]
    local regularTinyFont = Medias:GetFont('Regular10')
    local regularNormalFont = Medias:GetFont('Regular14')
    local regularMediumFont = Medias:GetFont('Regular22')
    local regularBigFont = Medias:GetFont('Regular30')

    local italicNormalFont = Medias:GetFont('Italic14')
    local italicMediumFont = Medias:GetFont('Italic22')
    local italicBigFont = Medias:GetFont('Italic30')

    --[[
       ABSORB SLANTED STATUSBAR
   --]]
    Config.Absorb.Point[2] = Frame
    local Absorb = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Absorb.Textures,
            Config.Absorb.Size,
            Config.Absorb.Point,
            Config.Absorb.SlantSettings,
            Config.Absorb.StaticLayer)
    Absorb.Override = UnitFrames.UpdateAbsorbOverride

    --[[
        HEALTH SLANTED STATUSBAR
    --]]
    Config.Health.Point[2] = Absorb
    local Health = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Health.Textures,
            Config.Health.Size,
            Config.Health.Point,
            Config.Health.SlantSettings,
            Config.Health.StaticLayer)
    Health.colorSmooth = true
    Health.Override = UnitFrames.UpdateHealthOverride
    Health.UpdateColor = UnitFrames.UpdateHealthColorOverride

    --[[
        HEALTH PREDICTION SLANTED STATUSBAR
    --]]
    local HealthPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.HealthPrediction.Textures,
            Config.HealthPrediction.Size,
            Config.HealthPrediction.Point,
            Config.HealthPrediction.SlantSettings,
            Config.HealthPrediction.StaticLayer)
    HealthPrediction:SetBlendMode("ADD")

    local OtherHealthPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.HealthPrediction.Textures,
            Config.HealthPrediction.Size,
            Config.HealthPrediction.Point,
            Config.HealthPrediction.SlantSettings,
            Config.HealthPrediction.StaticLayer)
    OtherHealthPrediction:SetBlendMode("ADD")

    --[[
        POWER SLANTED STATUSBAR
    --]]
    Config.Power.Point[2] = Health
    local Power = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Power.Textures,
            Config.Power.Size,
            Config.Power.Point,
            Config.Power.SlantSettings,
            Config.Power.StaticLayer)

    Power.colorPower = true
    Power.frequentUpdates=true
    Power.Override = UnitFrames.UpdatePowerOverride
    Power.UpdateColor = UnitFrames.UpdatePowerColorOverride

    --[[
        POWER PREDICTION SLANTED STATUSBAR
    --]]
    local PowerPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.PowerPrediction.Textures,
            Config.PowerPrediction.Size,
            Config.PowerPrediction.Point,
            Config.PowerPrediction.SlantSettings,
            Config.PowerPrediction.StaticLayer)
    PowerPrediction:SetBlendMode("ADD")

    --[[
        PORTRAIT 3D
    --]]

    local Portrait = CreateFrame('PlayerModel', nil, Frame)
    Portrait:SetModelDrawLayer("BACKGROUND")
    Portrait:SetSize(49, 49)
    Portrait:SetPoint("TOPLEFT", Frame, "TOPLEFT", 0, 0)
    --Portrait:SetPortraitZoom(1)
    Portrait.PostUpdate = function(unit)
        Portrait:SetPosition(0.15,0 ,0)
        Portrait:SetRotation(-math.pi/5)
    end

    --[[
        CLASS ICON
    --]]

    local classIndicator = Frame:CreateTexture(nil, "OVERLAY")
    classIndicator:SetSize(16, 16)
    classIndicator:SetPoint("TOPLEFT", Portrait, "TOPRIGHT", -4, -2)
    classIndicator:SetTexture(textureClassIconPath)
    classIndicator:SetTexCoord(LibAtlas:GetTexCoord("ClassIcon", Class))
    Frame.ClassIndicator = classIndicator
    --[[
        FONT
    --]]
    Frame.Name = Frame:CreateFontString(nil, "OVERLAY")
    Frame.Name:SetFontObject(regularNormalFont)
    Frame.Name:SetPoint("TOPLEFT", Frame, "BOTTOMLEFT", 20, 10)
    self:Tag(Frame.Name, "[classification] [name] [difficulty][level]")

    Health.Value = Frame:CreateFontString(nil, "OVERLAY")
    Health.Value:SetFontObject(italicNormalFont)
    Health.Value:SetPoint("TOPRIGHT", Health, "TOP")
    self:Tag(Health.Value, "[Vorkui:HealthColor(false)][missinghp]")

    Health.Percent = Frame:CreateFontString(nil, "OVERLAY")
    Health.Percent:SetFontObject(italicBigFont)
    Health.Percent:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT")
    self:Tag(Health.Percent, "[Vorkui:HealthColor(true)][Vorkui:PerHP]")

    Power.Value = Frame:CreateFontString(nil, "OVERLAY")
    Power.Value:SetFontObject(italicMediumFont)
    Power.Value:SetPoint("BOTTOM", Power, "BOTTOM")
    self:Tag(Power.Value, "[powercolor][missingpp]")

    Absorb.Value = Frame:CreateFontString(nil, "OVERLAY")
    Absorb.Value:SetFontObject(italicNormalFont)
    Absorb.Value:SetText("100")
    Absorb.Value:SetPoint("TOPLEFT", Health, "TOP")
    self:Tag(Absorb.Value, " ([Vorkui:HealthColor][Vorkui:Absorb])")

    --[[
    RAID ICON
    ]]--
    local raidIndicator = Frame:CreateTexture(nil, "OVERLAY")
    raidIndicator:SetSize(16, 16)
    raidIndicator:SetPoint("LEFT", Health, "LEFT", 10, 0)
    raidIndicator:SetTexture(textureRaidIconPath)
    self.RaidTargetIndicator = raidIndicator

    --[[
    LEADER ICON
    ]]--
    local leaderIndicator = Frame:CreateTexture(nil, "OVERLAY")
    leaderIndicator:SetSize(64/4, 53/4)
    leaderIndicator:SetPoint("RIGHT", Frame.Name, "LEFT")
    leaderIndicator:SetTexture(textureGlobalIconPath)
    leaderIndicator:SetTexCoord(LibAtlas:GetTexCoord("GlobalIcon", "LEADER"))
    leaderIndicator:SetVertexColor(163/255, 220/255, 255/255)
    self.LeaderIndicator = leaderIndicator

    --[[
    RESTING ICON
    ]]--
    local restingIndicator = Frame:CreateTexture(nil, "OVERLAY")
    restingIndicator:SetSize(32, 30)
    restingIndicator:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT")
    restingIndicator:SetTexture(textureGlobalIconPath)
    restingIndicator:SetTexCoord(LibAtlas:GetTexCoord("GlobalIcon", "RESTING"))
    restingIndicator:SetGradientAlpha("VERTICAL", 163/255, 220/255, 255/255, 0.75, 0, 0, 0, 1)
    restingIndicator:SetBlendMode("ADD")
    self.RestingIndicator = restingIndicator

    -- Register with oUF
    self.Absorb = Absorb
    self.Absorb.bg = Absorb.background
    self.Health = Health
    self.Health.bg = Health.background
    self.Power = Power
    self.Power.bg = Power.background
    self.Portrait = Portrait
    self.Portrait.bg = Portrait.background
    self.HealthPrediction = {
        myBar = HealthPrediction,
        otherBar = OtherHealthPrediction,
        maxOverflow = 1,
        Override = UnitFrames.UpdatePredictionOverride
    }
    self.PowerPrediction = {
        mainBar = PowerPrediction,
        --altBar = AltPowerPrediction,
        Override = UnitFrames.UpdatePowerPredictionOverride
    }

    self.ClassIcon = classIndicator

    --affect same frame level for PlayerModel than the PlayerFrame
    Portrait:SetFrameLevel(Frame:GetFrameLevel())
    self.Frame = Frame

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end

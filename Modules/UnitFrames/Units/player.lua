local V, C, L = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
--[[
    Player Configuration
]]--
local Config = {
    Absorb = {
        Textures ={
            {
                "Bubbles", "ARTWORK"
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
        StaticLayer = "BACKGROUND",
        Value = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic14",
            Point = { "TOPLEFT", nil, "TOP" },
            Tag = " ([Vorkui:HealthColor][Vorkui:Absorb])"
        },
    },
    Health = {
        Textures ={
            {
                "Default", "ARTWORK"
            },
            {
                "Background", "BACKGROUND", 1
            },
            {
                "Border", "OVERLAY"
            }
        },
        Size =  { 256, 32 },
        Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
        },
        StaticLayer = "BACKGROUND",
        Value = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic14",
            Point = { "TOPRIGHT", nil, "TOP" },
            Tag = "[Vorkui:HealthColor(false)][missinghp]"
        },
        Percent = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic30",
            Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
            Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
        }
    },
    HealthPrediction = {
        Textures ={
            {
                "Default", "ARTWORK", 1
            },
            {
                "Border", "OVERLAY"
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
                "Default", "ARTWORK"
            },
            {
                "Border", "BACKGROUND", 1
            }
        },
        Size =  { 235, 10 },
        Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -10, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
        },
        StaticLayer = "BACKGROUND",
        Value = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic22",
            Point = { "BOTTOM", nil, "BOTTOM" },
            Tag = "[powercolor][missingpp]"
        }
    },
    PowerPrediction = {
        Textures ={
            {
                "Default", "ARTWORK", 1
            },
            {
                "Border", "OVERLAY"
            }
        },
        Size =  { 235, 10 },
        --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["FillInverse"] = true
        }
    },
    Portrait = {
        Type = "3D",
        Size = {49, 49},
        Point = {"TOPLEFT", nil, "TOPLEFT", 0, },
        ModelDrawLayer = "BACKGROUND",
        PostUpdate =
        {
            Position = { 0.2, 0, 0 },
            Rotation = - math.pi/5,
            CamDistance = 2
        }
    },
    ClassIndicator = {
        Size = {16, 16},
        Point = { "TOPLEFT", nil, "TOPRIGHT", -4, -2 },
        Texture = "ClassIcon",
        TexCoord = select(2, UnitClass("player"))
    },
    RaidIndicator = {
        Size = { 16, 16 },
        Point = { "LEFT", nil, "LEFT", 10, 0 },
        Texture = "RaidIcon"
    },
    LeaderIndicator = {
        Size = { 64/4, 53/4 },
        Point = { "RIGHT", nil, "LEFT" },
        Texture = "GlobalIcon",
        TexCoord = "LEADER",
        VertexColor = { 163/255, 220/255, 255/255 }
    },
    RestingIndicator = {
        Size = { 64/3, 60/3 },
        Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
        Texture = "GlobalIcon",
        TexCoord = "RESTING",
        GradientAlpha = { "VERTICAL", 163/255, 220/255, 255/255, 0.75, 0, 0, 0, 1 },
        BlendMode = "ADD"
    },
    CombatIndicator = {
        Size = { 39/3, 64/3 },
        Point = { "BOTTOMRIGHT", nil, "TOPRIGHT" },
        Texture = "GlobalIcon",
        TexCoord = "MAELSTROM",
        GradientAlpha = { "VERTICAL", 255/255, 246/255, 0/255, 0.75, 255/255, 50/255, 0/255, 1 },
        BlendMode = "ADD"
    },
    Name = {
        Layer = "OVERLAY",
        FontName = "Montserrat",
        Point = { "TOPLEFT", nil, "BOTTOMLEFT", 20, 10 },
        Tag = "[classification] [name] [difficulty][level]"
    }
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
        FONT
    --]]
    if Config.Name then
        Config.Name.Point[2] = Frame
        Frame.Name = UnitFrames:CreateFontString(Frame, Config.Name)
        self:Tag(Frame.Name, Config.Name.Tag)
    end

    if Config.Health.Value then
        Config.Health.Value.Point[2] = Health
        Health.Value = UnitFrames:CreateFontString(Frame, Config.Health.Value)
        self:Tag(Health.Value, Config.Health.Value.Tag)
    end

    if Config.Health.Percent then
        Config.Health.Percent.Point[2] = Frame
        Health.Percent = UnitFrames:CreateFontString(Frame, Config.Health.Percent)
        self:Tag(Health.Percent, Config.Health.Percent.Tag)
    end

    if Config.Power.Value then
        Config.Power.Value.Point[2] = Power
        Power.Value = UnitFrames:CreateFontString(Frame, Config.Power.Value)
        self:Tag(Power.Value, Config.Power.Value.Tag)
    end

    if Config.Absorb.Value then
        Config.Absorb.Value.Point[2] = Health
        Absorb.Value = UnitFrames:CreateFontString(Frame, Config.Absorb.Value)
        self:Tag(Absorb.Value, Config.Absorb.Value.Tag)
    end

    --[[
    PORTRAIT 3D
    --]]
    if Config.Portrait.Type == "3D" then
        Config.Portrait.Point[2] = Frame
        self.Portrait = UnitFrames:Create3DPortrait("PlayerModel", Frame, Config.Portrait)
    end

    --[[
        CLASS ICON
    --]]
    if Config.ClassIndicator then
        Config.ClassIndicator.Point[2] = self.Portrait or Frame
        self.ClassIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.ClassIndicator)
    end

    --[[
    RAID ICON
    ]]--
    if Config.RaidIndicator then
        Config.RaidIndicator.Point[2] = Health
        self.RaidTargetIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.RaidIndicator)
    end

    --[[
    LEADER ICON
    ]]--
    if Config.LeaderIndicator then
        Config.LeaderIndicator.Point[2] = Frame.Name or Frame
        self.LeaderIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.LeaderIndicator)
    end

    --[[
    RESTING ICON
    ]]--
    if Config.RestingIndicator then
        Config.RestingIndicator.Point[2] = Frame
        self.RestingIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.RestingIndicator)
    end

    --[[
    COMBAT ICON
    ]]--
    if Config.CombatIndicator then
        Config.CombatIndicator.Point[2] = self.RestingIndicator or Frame
        self.CombatIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.CombatIndicator)
    end

    --[[
    CASTBAR
    ]]--
    -- Position and size
    local Castbar = CreateFrame('StatusBar', nil, Frame)
    Castbar:SetSize(256, 20)
    Castbar:SetStatusBarTexture(Medias:GetStatusBar('Default'))
    Castbar:SetPoint('TOP', Frame, 'BOTTOM', 0, -10)

    -- Add a background
    local Background = Castbar:CreateTexture(nil, 'BACKGROUND')
    Background:SetAllPoints(Castbar)
    Background:SetTexture(Medias:GetStatusBar('Background'))

    -- Add a spark
    local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
    Spark:SetSize(20, 30)
    Spark:SetVertexColor(0, 195/255, 1, 1)
    Spark:SetBlendMode('ADD')
    Spark:SetTexture(Medias:GetParticle("Spark"))
    Spark:SetPoint('RIGHT', Castbar:GetStatusBarTexture(), 'RIGHT', 5, 0)

    -- Add a timer
    local Time = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    Time:SetPoint('RIGHT', Castbar)

    -- Add spell text
    local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    Text:SetPoint('LEFT', Castbar)

    -- Add spell icon
    local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
    Icon:SetSize(20, 20)
    Icon:SetPoint('TOPLEFT', Castbar, 'TOPLEFT')

    -- Add Shield
    local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
    Shield:SetSize(20, 20)
    Shield:SetTexture(LibAtlas:GetTexCoord("GlobalIcon", "DEFENSE"))
    Shield:SetPoint('CENTER', Castbar)

    -- Add safezone
    local SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')
    SafeZone:SetTexture(Medias:GetStatusBar('Default'))
    SafeZone:SetVertexColor(255/255, 246/255, 0, 0.75)
    SafeZone:SetBlendMode("ADD")

    -- Register it with oUF
    Castbar.bg = Background
    Castbar.Spark = Spark
    Castbar.Time = Time
    Castbar.Text = Text
    Castbar.Icon = Icon
    Castbar.Shield = Shield
    Castbar.SafeZone = SafeZone
    self.Castbar = Castbar


    -- Register with oUF
    self.Absorb = Absorb
    self.Absorb.bg = Absorb.background
    self.Health = Health
    self.Health.bg = Health.background
    self.Power = Power
    self.Power.bg = Power.background
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

    --affect same frame level for PlayerModel than the PlayerFrame
    self.Portrait:SetFrameLevel(Frame:GetFrameLevel())
    self.Frame = Frame

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end

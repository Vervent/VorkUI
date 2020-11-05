local V, C, L = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]

--[[
    Pet Configuration
]]--
local Config = {
    Absorb = {
        Value = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic14",
            Point = { "TOPLEFT", nil, "TOP" },
            Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
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
        Size =  { 156, 16 },
        Point =  { "TOPRIGHT", "Frame", "TOPRIGHT", 0, 0 },
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
            FontName = "Montserrat Italic22",
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
        Size =  { 156, 16 },
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
        Size =  { 145, 4 },
        Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -4, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
        },
        StaticLayer = "BACKGROUND",
        --Value = {
        --    Layer = "OVERLAY",
        --    FontName = "Montserrat Italic22",
        --    Point = { "BOTTOM", nil, "BOTTOM" },
        --    Tag = "[powercolor][missingpp]"
        --}
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
        Size =  { 145, 4 },
        --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["FillInverse"] = true
        }
    },
    Portrait = {
        Type = "3D",
        Size = {31, 31},
        Point = {"TOPLEFT", nil, "TOPLEFT" },
        ModelDrawLayer = "BACKGROUND",
        PostUpdate =
        {
            Position = { 0.2, 0, 0 },
            Rotation = - math.pi/5,
            CamDistance = 2
        }
    },
    RaidIndicator = {
        Size = { 16, 16 },
        Point = { "LEFT", nil, "LEFT", 10, 0 },
        Texture = "RaidIcon"
    },
    Name = {
        Layer = "OVERLAY",
        FontName = "Montserrat14",
        Point = { "TOPLEFT", nil, "BOTTOMLEFT", 23, 10 },
        Tag = "[classification] [name] [difficulty][level]"
    },
    --CastBar = {
    --    Textures = {
    --        {
    --            "Default", "ARTWORK"
    --        },
    --        {
    --            "Background", "BACKGROUND", 1
    --        },
    --        {
    --            "Border", "OVERLAY"
    --        }
    --    },
    --    Size =  { 190, 16 },
    --    Point =  { "TOP", nil, "BOTTOM", 0, -2 },
    --    StatusBarColor = { 0, 0.5, 1, 1 },
    --    Spark = {
    --        Layer = "OVERLAY",
    --        Size = { 16, 16 },
    --        BlendMode = "ADD",
    --        CastSettings = {
    --            AtlasName = 'Muzzle',
    --            Point = {'RIGHT', nil, 'RIGHT', 5, 0},
    --        },
    --        ChannelSettings = {
    --            AtlasName = 'Spark',
    --            Point = { 'CENTER', nil, 'RIGHT', 0, 0 },
    --        }
    --    },
    --    Time = {
    --        Layer = "OVERLAY",
    --        FontName = 'Montserrat10',
    --        Point = {'RIGHT', nil}
    --    },
    --    Text = {
    --        Layer = "OVERLAY",
    --        FontName = 'Montserrat10',
    --        Point = {'CENTER', nil}
    --    },
    --    Icon = {
    --        Size = {16, 16},
    --        Point = {'TOPLEFT', nil, 'TOPLEFT'}
    --    },
    --    --Shield = {
    --    --    Texture = 'GlobalIcon',
    --    --    TexCoord = 'DEFENSE',
    --    --    Size = {10, 10},
    --    --    Point = {'CENTER', nil}
    --    --},
    --    SafeZone = {
    --        Layer = "OVERLAY",
    --        BlendMode = "ADD",
    --        VertexColor = {255/255, 246/255, 0, 0.75}
    --    }
    --}
}

function UnitFrames:Pet()

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    local Frame = CreateFrame("Frame", nil, self)
    Frame:SetAllPoints()
    Frame.background = Frame:CreateTexture(nil, "BACKGROUND")
    Frame.background:SetAllPoints()
    Frame.background:SetColorTexture( 33/255, 44/255, 79/255, 0.75 )

    --[[
        HEALTH SLANTED STATUSBAR
    --]]
    Config.Health.Point[2] = Absorb or Frame
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
        Frame.Name = UnitFrames:CreateFontString(Frame, Config.Name)
        self:Tag(Frame.Name, Config.Name.Tag)
    end

    if Config.Health.Value then
        Config.Health.Value.Point[2] = Health
        Health.Value = UnitFrames:CreateFontString(Frame, Config.Health.Value)
        self:Tag(Health.Value, Config.Health.Value.Tag)
    end

    if Config.Health.Percent then
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
        AbsorbValue = UnitFrames:CreateFontString(Frame, Config.Absorb.Value)
        self:Tag(AbsorbValue, Config.Absorb.Value.Tag)
    end

    --[[
    PORTRAIT 3D
    --]]
    if Config.Portrait.Type == "3D" then
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
    if Config.CastBar then
        self.Castbar = UnitFrames:CreateCastBar(Frame, Config.CastBar)
    end

    -- Register with oUF
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

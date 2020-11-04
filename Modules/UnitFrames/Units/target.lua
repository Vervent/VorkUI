local V, C, L = select(2, ...):unpack()

local LibSlant = LibStub:GetLibrary("LibSlant")

local UnitFrames = V["UnitFrames"]

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
        Point = { "TOPLEFT", "Frame", "TOPLEFT", 0, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["FillInverse"] = true,
            ["Inverse"] = true
        },
        StaticLayer = "BACKGROUND",
        Value = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic14",
            Point = { "TOPRIGHT", nil, "TOP" },
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
        Point =  { "TOPLEFT", "Absorb", "BOTTOMLEFT", 8, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["Inverse"] = true
        },
        StaticLayer = "BACKGROUND",
        Value = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic14",
            Point = { "TOPLEFT", nil, "TOP" },
            Tag = "[Vorkui:HealthColor(false)][missinghp]"
        },
        Percent = {
            Layer = "OVERLAY",
            FontName = "Montserrat Italic30",
            Point = { "BOTTOMLEFT", nil, "BOTTOMLEFT" },
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
            ["Inverse"] = true
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
        Point =  { "TOPRIGHT", "Health", "BOTTOMRIGHT", 10, 0 },
        SlantSettings = {
            ["IgnoreBackground"] = true,
            ["Inverse"] = true
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
            ["FillInverse"] = true,
            ["Inverse"] = true
        }
    },
    Portrait = {
        Type = "3D",
        Size = {49, 49},
        Point = {"TOPRIGHT", nil, "TOPRIGHT" },
        ModelDrawLayer = "BACKGROUND",
        PostUpdate =
        {
            Position = { 0.1, 0, 0 },
            Rotation = -math.pi/5,
            CamDistance = 2
        }
    },
    ClassIndicator = {
        Size = {16, 16},
        Point = { "TOPRIGHT", nil, "TOPLEFT", 4, -2 },
        Texture = "ClassIcon",
        TexCoord = select(2, UnitClass("player"))
    },
    RaidIndicator = {
        Size = { 16, 16 },
        Point = { "RIGHT", nil, "RIGHT", -10, 0 },
        Texture = "RaidIcon"
    },
    LeaderIndicator = {
        Size = { 64/4, 53/4 },
        Point = { "LEFT", nil, "RIGHT" },
        Texture = "GlobalIcon",
        TexCoord = "LEADER",
        VertexColor = { 163/255, 220/255, 255/255 }
    },
    Name = {
        Layer = "OVERLAY",
        FontName = "Montserrat14",
        Point = { "TOPRIGHT", nil, "BOTTOMRIGHT", -20, 10 },
        Tag = "[level][difficulty] [name] [classification]"
    },
    CastBar = {
        Textures = {
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
        Size =  { 300, 20 },
        Point =  { "TOP", nil, "BOTTOM", 0, -2 },
        StatusBarColor = { 0, 0.5, 1, 1 },
        Spark = {
            Layer = "OVERLAY",
            Size = { 20, 20 },
            BlendMode = "ADD",
            CastSettings = {
                AtlasName = 'Muzzle',
                Point = {'LEFT', nil, 'LEFT', 5, 0},
            },
            ChannelSettings = {
                AtlasName = 'Spark',
                Point = { 'CENTER', nil, 'LEFT', 0, 0 },
            }
        },
        Time = {
            Layer = "OVERLAY",
            FontName = 'Montserrat10',
            Point = {'RIGHT', nil}
        },
        Text = {
            Layer = "OVERLAY",
            FontName = 'Montserrat10',
            Point = {'CENTER', nil}
        },
        Icon = {
            Size = {20, 20},
            Point = {'TOPRIGHT', nil, 'TOPRIGHT'}
        },
        Shield = {
            Texture = 'GlobalIcon',
            TexCoord = 'DEFENSE',
            Size = {20, 20},
            Point = {'CENTER', nil}
        },
        SafeZone = {
            Layer = "OVERLAY",
            BlendMode = "ADD",
            VertexColor = {255/255, 246/255, 0, 0.75}
        },
        ReverseFill = true
    }
}

function UnitFrames:Target()

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

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
        Absorb.Value = UnitFrames:CreateFontString(Frame, Config.Absorb.Value)
        self:Tag(Absorb.Value, Config.Absorb.Value.Tag)
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
        local indicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.ClassIndicator)
        indicator.AtlasName = Config.ClassIndicator.Texture
        indicator.Override = UnitFrames.UpdateClassOverride
        self.ClassIndicator = indicator
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
    CASTBAR
    ]]--
    if Config.CastBar then
        self.Castbar = UnitFrames:CreateCastBar(Frame, Config.CastBar)
    end

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

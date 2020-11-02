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
        StaticLayer = "BACKGROUND"
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
        StaticLayer = "BACKGROUND"
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
        StaticLayer = "BACKGROUND"
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

    --
    ----[[
    --    FONT
    ----]]
    local regularNormalFont = Medias:GetFont('Montserrat')
    local italicNormalFont = Medias:GetFont('Montserrat Italic14')
    local italicMediumFont = Medias:GetFont('Montserrat Italic22')
    local italicBigFont = Medias:GetFont('Montserrat Italic30')

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
    PORTRAIT 3D
    --]]
    if Config.Portrait.Type == "3D" then
        Config.Portrait.Point[2] = Frame
        local Portrait = CreateFrame('PlayerModel', nil, Frame)
        Portrait:SetModelDrawLayer( Config.Portrait.ModelDrawLayer )
        Portrait:SetSize( unpack(Config.Portrait.Size) )
        Portrait:SetPoint( unpack(Config.Portrait.Point) )
        if Config.Portrait.PostUpdate then
            Portrait.PostUpdate = function(unit)
                Portrait:SetPosition( unpack(Config.Portrait.PostUpdate.Position) )
                Portrait:SetCamDistanceScale( Config.Portrait.PostUpdate.CamDistance )
                Portrait:SetRotation( Config.Portrait.PostUpdate.Rotation )
            end
        end
        self.Portrait = Portrait
    end

    --[[
        CLASS ICON
    --]]
    if Config.ClassIndicator then
        Config.ClassIndicator.Point[2] = self.Portrait or Frame
        local ClassIndicator = Frame:CreateTexture(nil, "OVERLAY")
        local textureName = Config.ClassIndicator.Texture
        ClassIndicator:SetSize( unpack(Config.ClassIndicator.Size) )
        ClassIndicator:SetPoint( unpack(Config.ClassIndicator.Point) )
        ClassIndicator:SetTexture( LibAtlas:GetPath(textureName) )
        ClassIndicator:SetTexCoord(LibAtlas:GetTexCoord(textureName, Config.ClassIndicator.TexCoord))
        self.ClassIndicator = ClassIndicator
    end

    --[[
    RAID ICON
    ]]--
    if Config.RaidIndicator then
        Config.RaidIndicator.Point[2] = Health
        local RaidIndicator = Frame:CreateTexture(nil, "OVERLAY")
        RaidIndicator:SetSize( unpack(Config.RaidIndicator.Size) )
        RaidIndicator:SetPoint( unpack(Config.RaidIndicator.Point) )
        RaidIndicator:SetTexture( LibAtlas:GetPath(Config.RaidIndicator.Texture) )
        self.RaidTargetIndicator = RaidIndicator
    end

    --[[
    LEADER ICON
    ]]--
    if Config.LeaderIndicator then
        Config.LeaderIndicator.Point[2] = Frame.Name or Frame
        local LeaderIndicator = Frame:CreateTexture(nil, "OVERLAY")
        LeaderIndicator:SetSize( unpack(Config.LeaderIndicator.Size) )
        LeaderIndicator:SetPoint( unpack(Config.LeaderIndicator.Point) )
        LeaderIndicator:SetTexture( LibAtlas:GetPath(Config.LeaderIndicator.Texture) )
        LeaderIndicator:SetTexCoord(LibAtlas:GetTexCoord(Config.LeaderIndicator.Texture, Config.LeaderIndicator.TexCoord))
        LeaderIndicator:SetVertexColor( unpack(Config.LeaderIndicator.VertexColor) )
        self.LeaderIndicator = LeaderIndicator
    end

    --[[
    RESTING ICON
    ]]--
    if Config.RestingIndicator then
        Config.RestingIndicator.Point[2] = Frame
        local RestingIndicator = Frame:CreateTexture(nil, "OVERLAY")
        RestingIndicator:SetSize( unpack(Config.RestingIndicator.Size) )
        RestingIndicator:SetPoint( unpack(Config.RestingIndicator.Point) )
        RestingIndicator:SetTexture( LibAtlas:GetPath(Config.RestingIndicator.Texture) )
        RestingIndicator:SetTexCoord(LibAtlas:GetTexCoord( Config.RestingIndicator.Texture ,Config.RestingIndicator.TexCoord))
        RestingIndicator:SetGradientAlpha( unpack(Config.RestingIndicator.GradientAlpha) )
        RestingIndicator:SetBlendMode(Config.RestingIndicator.BlendMode)
        self.RestingIndicator = RestingIndicator
    end

    --[[
    COMBAT ICON
    ]]--
    if Config.CombatIndicator then
        Config.CombatIndicator.Point[2] = self.RestingIndicator or Frame
        local CombatIndicator = Frame:CreateTexture(nil, "OVERLAY")
        CombatIndicator:SetSize( unpack(Config.CombatIndicator.Size) )
        CombatIndicator:SetPoint( unpack(Config.CombatIndicator.Point) )
        CombatIndicator:SetTexture(  LibAtlas:GetPath(Config.CombatIndicator.Texture) )
        CombatIndicator:SetTexCoord(LibAtlas:GetTexCoord(Config.CombatIndicator.Texture, Config.CombatIndicator.TexCoord))
        CombatIndicator:SetGradientAlpha( unpack(Config.CombatIndicator.GradientAlpha) )
        CombatIndicator:SetBlendMode(Config.CombatIndicator.BlendMode)
        self.CombatIndicator = CombatIndicator
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

local V = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]

function UnitFrames:Focus(Config, unit)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    local Frame = CreateFrame("Frame", nil, self)
    Frame:SetAllPoints()
    Frame.background = Frame:CreateTexture(nil, "BACKGROUND")
    Frame.background:SetAllPoints()
    Frame.background:SetColorTexture( 33/255, 44/255, 79/255, 0.75 )
    self.Frame = Frame

    --[[
       ABSORB SLANTED STATUSBAR
   --]]
   -- Config.Absorb.Point[2] = Frame
    local Absorb = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Absorb.Rendering,
            Config.Absorb.Size,
            Config.Absorb.Point,
            Config.Absorb.SlantingSettings)
    Absorb.Override = UnitFrames.UpdateAbsorbOverride
    self.Absorb = Absorb
    self.Absorb.bg = Absorb.background
    --[[
        HEALTH SLANTED STATUSBAR
    --]]
    --Config.Health.Point[2] = Absorb
    local Health = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Health.Rendering,
            Config.Health.Size,
            Config.Health.Point,
            Config.Health.SlantingSettings)
    Health.colorSmooth = true
    Health.Override = UnitFrames.UpdateHealthOverride
    Health.UpdateColor = UnitFrames.UpdateHealthColorOverride
    self.Health = Health
    self.Health.bg = Health.background
    --[[
        HEALTH PREDICTION SLANTED STATUSBAR
    --]]
    local HealthPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.HealthPrediction.Rendering,
            Config.Health.Size,
            Config.HealthPrediction.Point,
            Config.HealthPrediction.SlantingSettings)
    HealthPrediction:SetBlendMode("ADD")

    local OtherHealthPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.HealthPrediction.Rendering,
            Config.Health.Size,
            Config.HealthPrediction.Point,
            Config.HealthPrediction.SlantingSettings)
    OtherHealthPrediction:SetBlendMode("ADD")
    self.HealthPrediction = {
        myBar = HealthPrediction,
        otherBar = OtherHealthPrediction,
        maxOverflow = 1,
        Override = UnitFrames.UpdatePredictionOverride
    }
    --[[
        POWER SLANTED STATUSBAR
    --]]
    --Config.Power.Point[2] = Health
    local Power = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Power.Rendering,
            Config.Power.Size,
            Config.Power.Point,
            Config.Power.SlantingSettings)

    Power.colorPower = true
    Power.frequentUpdates=true
    Power.Override = UnitFrames.UpdatePowerOverride
    Power.UpdateColor = UnitFrames.UpdatePowerColorOverride
    self.Power = Power
    self.Power.bg = Power.background
    --[[
        POWER PREDICTION SLANTED STATUSBAR
    --]]
    local PowerPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.PowerPrediction.Rendering,
            Config.Power.Size,
            Config.PowerPrediction.Point,
            Config.PowerPrediction.SlantingSettings)
    PowerPrediction:SetBlendMode("ADD")
    self.PowerPrediction = {
        mainBar = PowerPrediction,
        --altBar = AltPowerPrediction,
        Override = UnitFrames.UpdatePowerPredictionOverride
    }
    --[[
        FONT
    --]]
    if Config.Name then
        Frame.Name = UnitFrames:CreateFontString(Frame, Config.Name, Config)
        self:Tag(Frame.Name, Config.Name.Tag)
    end

    if Config.Health.Value then
        --Config.Health.Value.Point[2] = Health
        Health.Value = UnitFrames:CreateFontString(Frame, Config.Health.Value, Config)
        self:Tag(Health.Value, Config.Health.Value.Tag)
    end

    if Config.Health.Percent then
        Health.Percent = UnitFrames:CreateFontString(Frame, Config.Health.Percent, Config)
        self:Tag(Health.Percent, Config.Health.Percent.Tag)
    end

    if Config.Power.Value then
        --Config.Power.Value.Point[2] = Power
        Power.Value = UnitFrames:CreateFontString(Frame, Config.Power.Value, Config)
        self:Tag(Power.Value, Config.Power.Value.Tag)
    end

    if Config.Absorb.Value then
        --Config.Absorb.Value.Point[2] = Health
        Absorb.Value = UnitFrames:CreateFontString(Frame, Config.Absorb.Value, Config)
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
        --Config.ClassIndicator.Point[2] = self.Portrait or Frame
        local indicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.ClassIndicator, unit)
        indicator.AtlasName = Config.ClassIndicator.Texture
        indicator.Override = UnitFrames.UpdateClassOverride
        self.ClassIndicator = indicator
    end

    --[[
    RAID ICON
    ]]--
    if Config.RaidIndicator then
        --Config.RaidIndicator.Point[2] = Health
        self.RaidTargetIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.RaidIndicator)
    end

    --[[
    LEADER ICON
    ]]--
    if Config.LeaderIndicator then
        --Config.LeaderIndicator.Point[2] = Frame.Name or Frame
        self.LeaderIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.LeaderIndicator)
    end

    --[[
    CASTBAR
    ]]--
    if Config.CastBar then
        self.Castbar = UnitFrames:CreateCastBar(Frame, Config.CastBar, Config)
    end

    -- Register with oUF
    --affect same frame level for PlayerModel than the PlayerFrame
    self.Portrait:SetFrameLevel(Frame:GetFrameLevel())

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end

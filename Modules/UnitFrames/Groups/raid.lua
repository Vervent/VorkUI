local V = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]

function UnitFrames:Raid(Config)

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
    if Config.Absorb and Config.Absorb.Point then
        --Config.Absorb.Point[2] = Frame
        local Absorb = UnitFrames:CreateSlantedStatusBar(Frame,
                Config.Absorb.Rendering,
                Config.Absorb.Size,
                Config.Absorb.Point,
                Config.Absorb.SlantingSettings)
        Absorb.Override = UnitFrames.UpdateAbsorbOverride

        self.Absorb = Absorb
        self.Absorb.bg = Absorb.background
    end

    --[[
        HEALTH SLANTED STATUSBAR
    --]]
    --Config.Health.Point[2] = self.Absorb or Frame
    local Health = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.Health.Rendering,
            Config.Health.Size,
            Config.Health.Point,
            Config.Health.SlantingSettings)
    Health.colorSmooth = true
    Health.Override = UnitFrames.UpdateHealthOverride
    Health.UpdateColor = UnitFrames.UpdateHealthColorOverride
    Health.colorDisconnected = true
    --Health.colorClass = true
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
    if Config.Power then
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

        --[[
            POWER PREDICTION SLANTED STATUSBAR
        --]]
        local PowerPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
                Config.PowerPrediction.Rendering,
                Config.Power.Size,
                Config.PowerPrediction.Point,
                Config.PowerPrediction.SlantingSettings)
        PowerPrediction:SetBlendMode("ADD")

        if Config.Power.Value then
            --Config.Power.Value.Point[2] = Power
            Power.Value = UnitFrames:CreateFontString(Frame, Config.Power.Value, Config)
            self:Tag(Power.Value, Config.Power.Value.Tag)
        end

        self.Power = Power
        self.Power.bg = Power.background
        self.PowerPrediction = {
            mainBar = PowerPrediction,
            --altBar = AltPowerPrediction,
            Override = UnitFrames.UpdatePowerPredictionOverride
        }
    end

    --[[
        FONT
    --]]
    if Config.Name then
        --Config.Name.Point[2] = Frame
        Frame.Name = UnitFrames:CreateFontString(Frame, Config.Name, Config)
        self:Tag(Frame.Name, Config.Name.Tag)
    end

    if Config.Health.Value then
        --Config.Health.Value.Point[2] = Health
        Health.Value = UnitFrames:CreateFontString(Frame, Config.Health.Value, Config)
        self:Tag(Health.Value, Config.Health.Value.Tag)
    end

    if Config.Health.Percent then
        --Config.Health.Percent.Point[2] = Frame
        Health.Percent = UnitFrames:CreateFontString(Frame, Config.Health.Percent, Config)
        self:Tag(Health.Percent, Config.Health.Percent.Tag)
    end

    if Config.Absorb and Config.Absorb.Value then
        --Config.Absorb.Value.Point[2] = Health
        if self.Absorb then
            self.Absorb.Value = UnitFrames:CreateFontString(Frame, Config.Absorb.Value, Config)
            self:Tag(self.Absorb.Value, Config.Absorb.Value.Tag)
        else
            AbsorbValue = UnitFrames:CreateFontString(Frame, Config.Absorb.Value, Config)
            self:Tag(AbsorbValue, Config.Absorb.Value.Tag)
        end
    end

    --[[
        CLASS ICON
    --]]
    if Config.ClassIndicator then
        --Config.ClassIndicator.Point[2] = self.Portrait or Frame
        local indicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.ClassIndicator)
        indicator.AtlasName = Config.ClassIndicator.Texture
        indicator.Override = UnitFrames.UpdateClassOverride
        self.ClassIndicator = indicator
    end

    --[[
    RAID ICON
    ]]--
    if Config.RaidIndicator then
        --Config.RaidIndicator.Point[2] = Frame
        self.RaidTargetIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.RaidIndicator)
    end

    --[[
    LEADER ICON
    ]]--
    if Config.LeaderIndicator then
        --Config.LeaderIndicator.Point[2] = self.ClassIndicator or Frame
        self.LeaderIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.LeaderIndicator)
    end
    if Config.LeaderIndicator then
        --Config.LeaderIndicator.Point[2] = self.ClassIndicator or Frame
        self.LeaderIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.LeaderIndicator)
    end

    --[[
    GROUP ROLE ICON
    ]]--
    if Config.GroupRoleIndicator then
        --Config.GroupRoleIndicator.Point[2] = Frame
        self.GroupRoleIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.GroupRoleIndicator)
    end

    --[[
    READY CHECK ICON
    ]]--
    if Config.ReadyCheckIndicator then
        --Config.ReadyCheckIndicator.Point[2] = Frame
        self.ReadyCheckIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.ReadyCheckIndicator)
    end

    if Config.DeadOrGhostIndicator then
        --Config.DeadOrGhostIndicator.Point[2] = self.Health
        self.DeadOrGhostIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", 7, Config.DeadOrGhostIndicator)
    end

    if Config.ResurrectIndicator then
        --Config.ResurrectIndicator.Point[2] = self.Health
        self.ResurrectIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", 7, Config.ResurrectIndicator)
    end

    if Config.SummonIndicator then
        --Config.SummonIndicator.Point[2] = self.Power or self.Health
        self.SummonIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", 3, Config.SummonIndicator)
    end

    if Config.PhaseIndicator then
        --Config.PhaseIndicator.Point[2] = self.Power or self.Health
        self.PhaseIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", 2, Config.PhaseIndicator)
    end

    -- Register with oUF

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)

end
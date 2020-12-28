local V, C = select(2, ...):unpack()

local UnitFrames = V["UnitFrames"]

function UnitFrames:Player(Config)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    local Frame = CreateFrame("Frame", nil, self)
    Frame:SetAllPoints()
    Frame.background = Frame:CreateTexture(nil, "BACKGROUND")
    Frame.background:SetAllPoints()
    Frame.background:SetColorTexture(33 / 255, 44 / 255, 79 / 255, 0.75)

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
            Config.Health.Size,
            Config.HealthPrediction.Point,
            Config.HealthPrediction.SlantSettings,
            Config.HealthPrediction.StaticLayer)
    HealthPrediction:SetBlendMode("ADD")

    local OtherHealthPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.HealthPrediction.Textures,
            Config.Health.Size,
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
    Power.frequentUpdates = true
    Power.Override = UnitFrames.UpdatePowerOverride
    Power.UpdateColor = UnitFrames.UpdatePowerColorOverride

    --[[
        POWER PREDICTION SLANTED STATUSBAR
    --]]
    local PowerPrediction = UnitFrames:CreateSlantedStatusBar(Frame,
            Config.PowerPrediction.Textures,
            Config.Power.Size,
            Config.PowerPrediction.Point,
            Config.PowerPrediction.SlantSettings,
            Config.PowerPrediction.StaticLayer)
    PowerPrediction:SetBlendMode("ADD")

    --[[
        BUFF/DEBUFF
    --]]
    local Buffs = CreateFrame('Frame', nil, Frame)
    Buffs:SetPoint('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', 2, 0)
    Buffs:SetSize(20 * 2, 3 * 20)
    Buffs.size = 18
    Buffs.onlyShowPlayer = true
    Buffs.num = 6
    Buffs.spacing = 2

    local Debuffs = CreateFrame('Frame', nil, Frame)
    Debuffs:SetPoint('BOTTOMRIGHT', Frame, 'TOPRIGHT', 0, 2)
    Debuffs:SetSize(50 * 3, 2 * 50)
    Debuffs.size = 48
    Debuffs.num = 6
    Debuffs.spacing = 2
    Debuffs['growth-x'] = 'LEFT'
    Debuffs.initialAnchor = 'BOTTOMRIGHT'

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

    if Config.DeadOrGhostIndicator then
        Config.DeadOrGhostIndicator.Point[2] = Frame
        self.DeadOrGhostIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.DeadOrGhostIndicator)
    end

    if Config.ResurrectIndicator then
        Config.ResurrectIndicator.Point[2] = Frame
        self.ResurrectIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", nil, Config.ResurrectIndicator)
    end

    if Config.SummonIndicator then
        Config.SummonIndicator.Point[2] = self.Health
        self.SummonIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", 7, Config.SummonIndicator)
    end

    if Config.PhaseIndicator then
        Config.PhaseIndicator.Point[2] = self.Health
        self.PhaseIndicator = UnitFrames:CreateIndicator(Frame, "OVERLAY", 7, Config.PhaseIndicator)
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
    self.Buffs = Buffs
    self.Debuffs = Debuffs

    self.Frame = Frame

    self:HookScript("OnEnter", UnitFrames.MouseOnPlayer)
    self:HookScript("OnLeave", UnitFrames.MouseOnPlayer)


end

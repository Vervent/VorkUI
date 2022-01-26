local select = select

local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local ActionBars = Module:RegisterModule('ActionBars', false)

local gsub = string.gsub
local tinsert = tinsert
local unpack = unpack
local ceil = ceil
local hooksecurefunc = hooksecurefunc
local _G = _G
local ACTION_BUTTON_SHOW_GRID_REASON_EVENT = ACTION_BUTTON_SHOW_GRID_REASON_EVENT
local UIParent = UIParent
local UnitClass = UnitClass
local IsUsableAction = IsUsableAction
local GetNumFlyouts = GetNumFlyouts
local GetFlyoutID = GetFlyoutID
local GetFlyoutInfo = GetFlyoutInfo
local SpellFlyoutHorizontalBackground = SpellFlyoutHorizontalBackground
local SpellFlyoutVerticalBackground = SpellFlyoutVerticalBackground
local SpellFlyoutBackgroundEnd = SpellFlyoutBackgroundEnd
local GetActionTexture = GetActionTexture
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local InCombatLockdown = InCombatLockdown
local GetNumShapeshiftForms = GetNumShapeshiftForms
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetShapeshiftFormCooldown = GetShapeshiftFormCooldown
local CooldownFrame_Set = CooldownFrame_Set
local PetActionBarFrame = PetActionBarFrame
local HidePetActionBar = HidePetActionBar
local PetHasActionBar = PetHasActionBar
local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
local SharedActionButton_RefreshSpellHighlight = SharedActionButton_RefreshSpellHighlight
local HasPetActionHighlightMark = HasPetActionHighlightMark
local GetPetActionSlotUsable = GetPetActionSlotUsable
local AutoCastShine_AutoCastStart = AutoCastShine_AutoCastStart
local AutoCastShine_AutoCastStop = AutoCastShine_AutoCastStop
local GetPetActionInfo = GetPetActionInfo
local Spell = Spell
local IsPetAttackAction = IsPetAttackAction
local PetActionButton_StartFlash = PetActionButton_StartFlash
local PetActionButton_StopFlash = PetActionButton_StopFlash
local GetTime = GetTime

local SwitchBarOnStance = true
local ShowMacro = true
local ShowHotKey = true
local Fading = 0.5

local FlyoutButtons = 0

local barSettings = {
    {
        ['Page'] = 1,
        ['FrameRef'] = 'Action',
        ['Point'] = { 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 534, 32 },
        ['Size'] = { 29, 29 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 12,
        ['ButtonsPerRow'] = 12,
    },
    {
        ['Page'] = 2,
        ['FrameRef'] = 'MultiBarBottomRight',
        ['Point'] = { 'BOTTOM', nil, 'TOP', 0, 0 },
        ['Size'] = { 29, 29 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 12,
        ['ButtonsPerRow'] = 12,
    },
    {
        ['Page'] = 3,
        ['FrameRef'] = 'MultiBarBottomLeft',
        ['Point'] = { 'BOTTOM', nil, 'TOP', 0, 0 },
        ['Size'] = { 29, 29 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 12,
        ['ButtonsPerRow'] = 12,
    },
    {
        ['Page'] = 4,
        ['FrameRef'] = 'MultiBarLeft',
        ['Point'] = { 'BOTTOM', nil, 'TOP', 0, 0 },
        ['Size'] = { 29, 29 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 12,
        ['ButtonsPerRow'] = 12,
    },
    {
        ['Page'] = 5,
        ['FrameRef'] = 'MultiBarRight',
        ['Point'] = { 'BOTTOM', nil, 'TOP', 0, 0 },
        ['Size'] = { 29, 29 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 12,
        ['ButtonsPerRow'] = 12,
    },
    {
        ['Page'] = 6,
        ['FrameRef'] = 'Stance',
        ['Point'] = { 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 534, 178 },
        ['Size'] = { 32, 32 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 6,
        ['ButtonsPerRow'] = 6,
    },
    {
        ['Page'] = 7,
        ['FrameRef'] = 'PetAction',
        ['Point'] = { 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 534, 180 },
        ['Size'] = { 29, 29 },
        ['Spacing'] = { 1, 0 },
        ['ButtonsCount'] = 10,
        ['ButtonsPerRow'] = 10,
    },
}

local blizzardFrames = {
    MainMenuBar,
    MainMenuBarArtFrame,
    OverrideActionBar,
    PossessBarFrame,
    ShapeshiftBarLeft,
    ShapeshiftBarMiddle,
    ShapeshiftBarRight,
}

local function disableBlizzard()
    local hider = V.Hider

    for _, f in ipairs(blizzardFrames) do
        f:UnregisterAllEvents()
        f:SetParent(hider)
    end

    local options = {
        InterfaceOptionsActionBarsPanelBottomLeft,
        InterfaceOptionsActionBarsPanelBottomRight,
        InterfaceOptionsActionBarsPanelRight,
        InterfaceOptionsActionBarsPanelRightTwo,
        InterfaceOptionsActionBarsPanelStackRightBars,
        InterfaceOptionsActionBarsPanelAlwaysShowActionBars,
    }

    ActionBarButtonEventsFrame:UnregisterEvent("ACTIONBAR_SHOWGRID")
    ActionBarButtonEventsFrame:UnregisterEvent("ACTIONBAR_HIDEGRID")

    for _, o in ipairs(options) do
        o:Hide()
        o:Disable()
        o:SetScale(0.001)
    end

    MultiActionBar_Update = function()
    end
    BeginActionBarTransition = function()
    end
    ActionButton_UpdateRangeIndicator = function()
    end

    MicroButtonAndBagsBar:UnregisterAllEvents()
    MicroButtonAndBagsBar:SetParent(hider)
    --MicroButtonAndBagsBar:ClearAllPoints()
    --MicroButtonAndBagsBar:SetPoint("TOP", UIParent, "TOP", 0, 200)
end

local function setHotKeyText(self)
    local HotKey = self.HotKey
    local Text = HotKey:GetText()
    local Indicator = _G["RANGE_INDICATOR"]

    if (not Text) then
        return
    end

    Text = gsub(Text, "(s%-)", "|cffff8000s|r")
    Text = gsub(Text, "(a%-)", "|cffff8000a|r")
    Text = gsub(Text, "(c%-)", "|cffff8000c|r")
    Text = gsub(Text, KEY_BUTTON3, "m3")
    Text = gsub(Text, KEY_BUTTON4, "m4")
    Text = gsub(Text, KEY_BUTTON5, "m5")
    Text = gsub(Text, KEY_MOUSEWHEELUP, "mU")
    Text = gsub(Text, KEY_MOUSEWHEELDOWN, "mD")
    Text = gsub(Text, KEY_NUMPAD0, "N0")
    Text = gsub(Text, KEY_NUMPAD1, "N1")
    Text = gsub(Text, KEY_NUMPAD2, "N2")
    Text = gsub(Text, KEY_NUMPAD3, "N3")
    Text = gsub(Text, KEY_NUMPAD4, "N4")
    Text = gsub(Text, KEY_NUMPAD5, "N5")
    Text = gsub(Text, KEY_NUMPAD6, "N6")
    Text = gsub(Text, KEY_NUMPAD7, "N7")
    Text = gsub(Text, KEY_NUMPAD8, "N8")
    Text = gsub(Text, KEY_NUMPAD9, "N9")
    Text = gsub(Text, KEY_NUMPADDECIMAL, "N.")
    Text = gsub(Text, KEY_NUMPADDIVIDE, "N/")
    Text = gsub(Text, KEY_NUMPADMINUS, "N-")
    Text = gsub(Text, KEY_NUMPADMULTIPLY, "N*")
    Text = gsub(Text, KEY_NUMPADPLUS, "N+")
    Text = gsub(Text, KEY_PAGEUP, "PU")
    Text = gsub(Text, KEY_PAGEDOWN, "PD")
    Text = gsub(Text, KEY_SPACE, "SPB")
    Text = gsub(Text, KEY_INSERT, "INS")
    Text = gsub(Text, KEY_HOME, "HM")
    Text = gsub(Text, KEY_DELETE, "DEL")
    Text = gsub(Text, KEY_BACKSPACE, "BKS")
    Text = gsub(Text, KEY_INSERT_MAC, "HLP") -- mac

    if HotKey:GetText() == Indicator then
        HotKey:SetText("")
    else
        HotKey:SetText(Text)
    end

    HotKey:SetVertexColor(1, 1, 1)
end

local function styleButton(self)
    local cd = self:GetName() and _G[self:GetName() .. "Cooldown"]

    if (self.SetHighlightTexture and not self.Highlight) then
        local highlight = self:CreateTexture()

        highlight:SetColorTexture(1, 1, 1, 0.3)
        highlight:SetAllPoints()

        self.Highlight = highlight
        self:SetHighlightTexture(highlight)
    end

    if (self.SetPushedTexture and not self.Pushed) then
        local pushed = self:CreateTexture()

        pushed:SetColorTexture(0.9, 0.8, 0.1, 0.3)
        pushed:SetAllPoints()

        self.Pushed = pushed
        self:SetPushedTexture(pushed)
    end

    if (self.SetCheckedTexture and not self.Checked) then
        local checked = self:CreateTexture()

        checked:SetColorTexture(0, 1, 0, 0.3)
        checked:SetAllPoints()

        self.Checked = checked
        self:SetCheckedTexture(checked)
    end

    if (cd) then
        cd:ClearAllPoints()
        cd:SetAllPoints()
        cd:SetDrawEdge(true)
    end
end

local function skinButton(self)
    local button = self
    local name = button:GetName()
    local action = button.action
    local keybindTexture = button.QuickKeybindHighlightTexture
    local icon = _G[name .. "Icon"]
    local count = _G[name .. "Count"]
    local flash = _G[name .. "Flash"]
    local hotkey = _G[name .. "HotKey"]
    local border = _G[name .. "Border"]
    local btnName = _G[name .. "Name"]
    local normalTexture = _G[name .. "NormalTexture"]
    local btnBG = _G[name .. "FloatingBG"]

    if not button.IsSkinned then
        flash:SetTexture("")
        button:SetNormalTexture("")

        count:ClearAllPoints()
        count:SetPoint("BOTTOMRIGHT", 0, 2)

        hotkey:ClearAllPoints()
        hotkey:SetPoint("TOPRIGHT", 0, -3)

        if btnName then
            if ShowMacro then
                btnName:ClearAllPoints()
                btnName:SetPoint("BOTTOM", 1, 1)
            else
                btnName:SetText("")
                btnName:Kill()
            end
        end

        if (btnBG) then
            btnBG:Kill()
        end

        if not ShowHotKey then
            hotkey:SetText("")
            hotkey:Kill()
        end

        if (name:match("Extra")) then
            button.Pushed = true
        end

        button.Background = button:CreateBackground({ 0.2, 0.4, 0.6, 0.25 })
        button:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        icon:SetDrawLayer("BACKGROUND", 7)

        if (normalTexture) then
            normalTexture:ClearAllPoints()
            normalTexture:SetPoint("TOPLEFT")
            normalTexture:SetPoint("BOTTOMRIGHT")

            if (button:GetChecked() and button.UpdateState) then
                button:UpdateState(button)
            end
        end

        if (border) then
            border:SetTexture("")
        end

        if keybindTexture then
            keybindTexture:SetTexture("")
        end

        if ShowHotKey then
            if button.UpdateHotkeys then
                hooksecurefunc(button, "UpdateHotkeys", setHotKeyText)
            end

            setHotKeyText(button)
        end

        styleButton(button)
        button.isSkinned = true
    end

end

local function onUpdatePetBarCooldownText(self, elapsed)
    local Now = GetTime()
    local Timer = Now - self.StartTimer
    local Cooldown = self.DurationTimer - Timer

    self.Elapsed = self.Elapsed - elapsed

    if self.Elapsed < 0 then
        if Cooldown <= 0 then
            self.Text:SetText("")

            self:SetScript("OnUpdate", nil)
        else
            self.Text:SetTextColor(1, 0, 0)
            self.Text:SetText(V.Utils.Functions.FormatTime(Cooldown))
        end

        self.Elapsed = .1
    end
end

local function updatePetBar()
    local Button, Icon, CastTexture, ShineTexture

    for i = 1, barSettings[7].ButtonsCount do
        local PetActionButton = "PetActionButton" .. i

        Button = _G[PetActionButton]
        Icon = _G[PetActionButton .. "Icon"]
        CastTexture = _G[PetActionButton .. "AutoCastable"]
        ShineTexture = _G[PetActionButton .. "Shine"]

        local Name, Texture, IsToken, IsActive, AutoCastAllowed, AutoCastEnabled, SpellID = GetPetActionInfo(i)

        if not IsToken then
            Icon:SetTexture(Texture)
            Button.tooltipName = Name
        else
            Icon:SetTexture(_G[Texture])
            Button.tooltipName = _G[Name]
        end

        Button.isToken = IsToken

        if SpellID then
            local spell = Spell:CreateFromSpellID(SpellID)

            Button.spellDataLoadedCancelFunc = spell:ContinueWithCancelOnSpellLoad(function()
                Button.tooltipSubtext = spell:GetSpellSubtext();
            end)
        end

        if IsActive then
            if IsPetAttackAction(i) then
                PetActionButton_StartFlash(Button)

                Button:GetCheckedTexture():SetAlpha(0.5)
            else
                PetActionButton_StopFlash(Button)

                Button:GetCheckedTexture():SetAlpha(1.0)
            end

            Button:SetChecked(true)
        else
            PetActionButton_StopFlash(Button)

            Button:SetChecked(false)
        end

        if AutoCastAllowed then
            CastTexture:Show()
        else
            CastTexture:Hide()
        end

        if AutoCastEnabled then
            AutoCastShine_AutoCastStart(ShineTexture)
        else
            AutoCastShine_AutoCastStop(ShineTexture)
        end

        if Texture then
            if GetPetActionSlotUsable(i) then
                Icon:SetVertexColor(1, 1, 1)
            else
                Icon:SetVertexColor(0.4, 0.4, 0.4)
            end

            Icon:Show()

            Button:SetNormalTexture("")
        else
            Icon:Hide()

            Button:SetNormalTexture("")
        end

        SharedActionButton_RefreshSpellHighlight(Button, HasPetActionHighlightMark(i))
    end

    PetActionBar_UpdateCooldowns()

    if not PetHasActionBar() then
        HidePetActionBar()
    end

    PetActionBarFrame.rangeTimer = -1
end

local function skinPetButton(button)
    local name = button:GetName()
    local icon = _G[name .. "Icon"]
    local normal = _G[name .. "NormalTexture2"]

    if button.isSkinned then
        return
    end

    local PetSize = barSettings[7].Size

    local HotKey = _G[name .. "HotKey"]
    local Cooldown = _G[name .. "Cooldown"]
    local Flash = _G[name .. "Flash"]

    button:SetWidth(PetSize[1])
    button:SetHeight(PetSize[2])

    button.Background = button:CreateBackground({ 0.2, 0.4, 0.6, 0.25 })
    button:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    HotKey:ClearAllPoints()
    HotKey:SetPoint("TOPRIGHT", 0, -3)

    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    icon:SetDrawLayer("BACKGROUND", 7)

    if (PetSize[1] < 30 or PetSize[2] < 30) then
        local AutoCast = _G[name .. "AutoCastable"]
        AutoCast:SetAlpha(0)
    end

    local Shine = _G[name .. "Shine"]
    Shine:SetSize(PetSize[1], PetSize[2])
    Shine:ClearAllPoints()
    Shine:SetPoint("CENTER", button, 0, 0)

    Flash:SetTexture("")

    if normal then
        normal:Kill()
    end

    if button.QuickKeybindHighlightTexture then
        button.QuickKeybindHighlightTexture:SetTexture("")
    end

    setHotKeyText(button)

    styleButton(button)
    button.isSkinned = true
end

local function createPetBar(self, id)
    local settings = barSettings[id]
    local point = settings.Point
    local anchor, parent, relative, x, y = unpack(point)
    if not parent then
        parent = self.Bars[id - 1]
    end
    local buttonsPerRow = settings.ButtonsPerRow
    local buttonsCount = settings.ButtonsCount
    local size = settings.Size
    local spacing = settings.Spacing
    local fRef = settings.FrameRef

    local petActionBarFrame = PetActionBarFrame
    local petActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns

    if buttonsCount <= buttonsPerRow then
        buttonsPerRow = buttonsCount
    end

    local NumRow = ceil(buttonsCount / buttonsPerRow)

    local actionBar = CreateFrame("Frame", "VorkuiPetActionBar" .. id, parent, "SecureHandlerStateTemplate")
    actionBar:SetPoint(anchor, parent, relative, x, y)
    actionBar:SetFrameStrata('LOW')
    actionBar:SetFrameLevel(10)
    actionBar:SetWidth((size[1] * buttonsPerRow) + (spacing[1] * (buttonsPerRow - 1)))
    actionBar:SetHeight((size[2] * NumRow) + (spacing[2] * (NumRow + 1)))

    actionBar.Background = actionBar:CreateBackground({ 0.2, 0.4, 0.6, 0.05 })

    petActionBarFrame:EnableMouse(0)
    petActionBarFrame:ClearAllPoints()
    petActionBarFrame:SetParent(V.Hider)

    petActionBar_UpdateCooldowns = updatePetBar

    local NumPerRows = buttonsPerRow
    local NextRowButtonAnchor = _G[fRef .. 'Button']

    for i = 1, buttonsCount do
        local Button = _G[fRef .. 'Button' .. i]
        local PreviousButton = _G[fRef .. 'Button' .. i - 1]

        Button:SetParent(actionBar)
        Button:SetNormalTexture('')
        Button:SetSize(unpack(size))
        Button:ClearAllPoints()
        Button:Show()

        skinPetButton(Button)
        if (i == 1) then
            Button:SetPoint("TOPLEFT", actionBar, "TOPLEFT", 0, spacing[2])
        elseif (i == NumPerRows + 1) then
            Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, spacing[2])

            NumPerRows = NumPerRows + buttonsPerRow
            NextRowButtonAnchor = _G[fRef .. 'Button' .. i]
        else
            Button:SetPoint("LEFT", PreviousButton, "RIGHT", spacing[1], 0)
        end

    end

    RegisterStateDriver(actionBar, 'visibility', "[@pet,exists,nopossessbar] show; hide")

    return actionBar
end

local function updateStanceBar(self)
    if InCombatLockdown() then
        return
    end

    local NumForms = GetNumShapeshiftForms()
    local Texture, Name, IsActive, IsCastable, Button, Icon, Cooldown, Start, Duration, Enable
    local settings = barSettings[6]
    local PetSize = settings.Size
    local Spacing = settings.Spacing
    local buttonsCount = settings.ButtonsCount

    if NumForms == 0 then
        self:SetAlpha(0)
    else
        self:SetAlpha(1)
        self:SetSize((PetSize[1] * NumForms) + (Spacing[1] * (NumForms - 1)), PetSize[2] + (Spacing[2] * 2))

        for i = 1, buttonsCount do
            local ButtonName = "StanceButton" .. i

            Button = _G[ButtonName]
            Icon = _G[ButtonName .. "Icon"]

            Button:SetNormalTexture("")

            if i <= NumForms then
                Texture, IsActive, IsCastable = GetShapeshiftFormInfo(i)

                if not Icon then
                    return
                end

                Icon:SetTexture(Texture)
                Cooldown = _G[ButtonName .. "Cooldown"]

                if Texture then
                    Cooldown:SetAlpha(1)
                else
                    Cooldown:SetAlpha(0)
                end

                Start, Duration, Enable = GetShapeshiftFormCooldown(i)
                CooldownFrame_Set(Cooldown, Start, Duration, Enable)

                if IsActive then
                    StanceBarFrame.lastSelected = Button:GetID()
                    Button:SetChecked(true)
                    if Button.Borders then
                        Button:SetBorderColor({ 0, 1, 0 })
                    end

                else
                    Button:SetChecked(false)

                    if Button.Borders then
                        Button:SetBorderColor({ 0.2, 0.4, 0.6 })
                    end
                end

                if IsCastable then
                    Icon:SetVertexColor(1.0, 1.0, 1.0)
                else
                    Icon:SetVertexColor(0.4, 0.4, 0.4)
                end
            end
        end
    end
end

local function createStanceBar(self, id)
    local settings = barSettings[id]
    local point = settings.Point
    local anchor, parent, relative, x, y = unpack(point)
    if not parent then
        parent = self.Bars[id - 1]
    end
    local buttonsPerRow = settings.ButtonsPerRow
    local buttonsCount = settings.ButtonsCount
    local size = settings.Size
    local spacing = settings.Spacing
    local fRef = settings.FrameRef
    local stanceBarFrame = StanceBarFrame

    if buttonsCount <= buttonsPerRow then
        buttonsPerRow = buttonsCount
    end

    local NumRow = ceil(buttonsCount / buttonsPerRow)

    local actionBar = CreateFrame("Frame", "VorkuiActionBar" .. id, parent, "SecureHandlerStateTemplate")
    actionBar:SetPoint(anchor, parent, relative, x, y)
    actionBar.ID = id

    actionBar:SetFrameStrata("LOW")
    actionBar:SetFrameLevel(10)
    actionBar:SetWidth((size[1] * buttonsPerRow) + (spacing[1] * (buttonsPerRow - 1)))
    actionBar:SetHeight((size[2] * NumRow) + (spacing[2] * (NumRow + 1)))

    actionBar.Background = actionBar:CreateBackground({ 0.2, 0.4, 0.6, 0.05 })

    stanceBarFrame.ignoreFramePositionManager = true
    stanceBarFrame:StripTextures()
    stanceBarFrame:SetParent(actionBar)
    stanceBarFrame:ClearAllPoints()
    stanceBarFrame:SetPoint('TOPLEFT', actionBar, 'TOPLEFT')
    stanceBarFrame:EnableMouse(false)

    local NumPerRows = buttonsPerRow
    local NextRowButtonAnchor = _G[fRef .. 'Button']

    for i = 1, buttonsCount do
        local Button = _G[fRef .. 'Button' .. i]
        local PreviousButton = _G[fRef .. 'Button' .. i - 1]

        Button:SetParent(actionBar)
        Button:SetNormalTexture('')
        Button:SetSize(unpack(size))
        Button:ClearAllPoints()
        Button:Show()

        skinButton(Button)
        if (i == 1) then
            Button:SetPoint("TOPLEFT", actionBar, "TOPLEFT", 0, spacing[2])
        elseif (i == NumPerRows + 1) then
            Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, spacing[2])

            NumPerRows = NumPerRows + buttonsPerRow
            NextRowButtonAnchor = _G[fRef .. 'Button' .. i]
        else
            Button:SetPoint("LEFT", PreviousButton, "RIGHT", spacing[1], 0)
        end
    end

    actionBar:RegisterEvent("PLAYER_ENTERING_WORLD")
    actionBar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    actionBar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
    actionBar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
    actionBar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    actionBar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    actionBar:RegisterEvent("SPELLS_CHANGED")
    actionBar:SetScript("OnEvent", function(self, event, ...)
        --if (event == "UPDATE_SHAPESHIFT_FORMS") then
        --
        --elseif (event == "PLAYER_ENTERING_WORLD") then
        --    updateStanceBar()
        --    --ActionBars:SkinStanceButtons()
        --else
        --    updateStanceBar()
        --end
        updateStanceBar(self)
    end)

    return actionBar
end

local function createBar(self, id)
    --local Movers = T["Movers"]

    local settings = barSettings[id]
    local point = settings.Point
    local anchor, parent, relative, x, y = unpack(point)
    if not parent then
        parent = self.Bars[id - 1]
    end
    local buttonsPerRow = settings.ButtonsPerRow
    local buttonsCount = settings.ButtonsCount
    local size = settings.Size
    local spacing = settings.Spacing
    local fRef = settings.FrameRef

    if buttonsCount <= buttonsPerRow then
        buttonsPerRow = buttonsCount
    end

    local NumRow = ceil(buttonsCount / buttonsPerRow)

    local actionBar = CreateFrame("Frame", "VorkuiActionBar" .. id, parent, "SecureHandlerStateTemplate")

    --actionBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 12)
    actionBar:SetPoint(anchor, parent, relative, x, y)
    actionBar.ID = id

    actionBar:SetFrameStrata("LOW")
    actionBar:SetFrameLevel(10)
    actionBar:SetWidth((size[1] * buttonsPerRow) + (spacing[1] * (buttonsPerRow - 1)))
    actionBar:SetHeight((size[2] * NumRow) + (spacing[2] * (NumRow + 1)))

    actionBar.Background = actionBar:CreateBackground({ 0.2, 0.4, 0.6, 0.05 })

    if _G[fRef] and _G[fRef].QuickKeybindGlow then
        _G[fRef].QuickKeybindGlow:SetParent(V.Hider)
    end

    if id == 1 then
        local rogue, druid, warrior, priest = '', '', '', ''
        if SwitchBarOnStance then
            rogue = "[bonusbar:1] 7;"
            druid = "[bonusbar:1,stealth] 2; [bonusbar:1,nostealth] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
            warrior = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;"
            priest = "[bonusbar:1] 7;"
        end
        actionBar.Page = {
            ["DRUID"] = druid,
            ["ROGUE"] = rogue,
            ["WARRIOR"] = warrior,
            ["PRIEST"] = priest,
            ["DEFAULT"] = "[bar:6] 6;[bar:5] 5;[bar:4] 4;[bar:3] 3;[bar:2] 2;[overridebar] 14;[shapeshift] 13;[vehicleui] 12;[possessbar] 12;",
        }

        local function getBar(self)
            local condition = actionBar.Page["DEFAULT"]
            local class = select(2, UnitClass("player"))
            local page = actionBar.Page[class]

            if page then
                condition = condition .. " " .. page
            end

            condition = condition .. " [form] 1; 1"
            return condition
        end

        RegisterStateDriver(actionBar, "page", getBar())

        if _G[fRef] then

        end

        for i = 1, buttonsCount do
            local Button = _G[fRef .. 'Button' .. i]

            actionBar:SetFrameRef(fRef .. 'Button' .. i, Button)
        end

        actionBar:Execute([[
		Button = table.new()
		for i = 1, 12 do
			table.insert(Button, self:GetFrameRef("ActionButton"..i))
		end
	]])

        actionBar:SetAttribute("_onstate-page", [[
		if HasTempShapeshiftActionBar() then
			newstate = GetTempShapeshiftBarIndex() or newstate
		end
		for i, Button in ipairs(Button) do
			Button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])

    else
        _G[fRef]:SetShown(true)
        _G[fRef]:SetParent(actionBar)
        RegisterStateDriver(actionBar, "visibility", "[vehicleui] hide; show")
    end

    actionBar:RegisterEvent("PLAYER_ENTERING_WORLD")
    actionBar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
    actionBar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")

    actionBar:SetScript("OnEvent", function(self, event, unit, ...)
        if (event == "PLAYER_ENTERING_WORLD") then
            local NumPerRows = buttonsPerRow
            local NextRowButtonAnchor = _G[fRef .. 'Button']

            for i = 1, buttonsCount do
                local Button = _G[fRef .. 'Button' .. i]
                local PreviousButton = _G[fRef .. 'Button' .. i - 1]

                Button:SetSize(unpack(size))
                Button:ClearAllPoints()

                if id == 1 then
                    Button:SetParent(self)
                end

                Button:SetAttribute("showgrid", 1)
                Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

                skinButton(Button)

                if i <= buttonsCount then
                    if (i == 1) then
                        Button:SetPoint("TOPLEFT", actionBar, "TOPLEFT", 0, spacing[2])
                    elseif (i == NumPerRows + 1) then
                        Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, spacing[2])

                        NumPerRows = NumPerRows + buttonsPerRow
                        NextRowButtonAnchor = _G[fRef .. 'Button' .. i]
                    else
                        Button:SetPoint("LEFT", PreviousButton, "RIGHT", spacing[1], 0)
                    end
                else
                    Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
                end
            end
        elseif (event == "UPDATE_VEHICLE_ACTIONBAR") or (event == "UPDATE_OVERRIDE_ACTIONBAR") then
            if not self:IsVisible() then
                return
            end

            for i = 1, 12 do
                local Button = _G[fRef .. 'Button' .. i]
                local Action = Button.action
                local Icon = Button.icon

                if Action >= 120 then
                    local Texture = GetActionTexture(Action)

                    if (Texture) then
                        Icon:SetTexture(Texture)
                        Icon:Show()
                    else
                        if Icon:IsShown() then
                            Icon:Hide()
                        end
                    end
                end
            end
        end
    end)

    for i = 1, buttonsCount do
        local Button = _G[fRef .. 'Button' .. i]
        actionBar["Button" .. i] = Button
    end

    return actionBar
end

local function skinFlyoutButtons()
    for i = 1, FlyoutButtons do
        local Button = _G["SpellFlyoutButton" .. i]

        if Button and not Button.IsSkinned then
            skinButton(Button)

            if Button:GetChecked() then
                Button:SetChecked(nil)
            end

            Button.IsSkinned = true
        end
    end
end

local function styleFlyout(self)
    if (self.FlyoutArrow) and (not self.FlyoutArrow:IsShown()) then
        return
    end

    local HB = SpellFlyoutHorizontalBackground
    local VB = SpellFlyoutVerticalBackground
    local BE = SpellFlyoutBackgroundEnd

    if self.FlyoutBorder then
        self.FlyoutBorder:SetAlpha(0)
        self.FlyoutBorderShadow:SetAlpha(0)
    end

    HB:SetAlpha(0)
    VB:SetAlpha(0)
    BE:SetAlpha(0)

    for i = 1, GetNumFlyouts() do
        local ID = GetFlyoutID(i)
        local _, _, NumSlots, IsKnown = GetFlyoutInfo(ID)

        if IsKnown then
            FlyoutButtons = NumSlots

            break
        end
    end

    skinFlyoutButtons()
end

local function rangeUpdate(self, hasRange, inRange)
    local Icon = self.icon
    local NormalTexture = self.NormalTexture
    local ID = self.action

    if not ID then
        return
    end

    local IsUsable, NotEnoughPower = IsUsableAction(ID)
    local HasRange = hasRange
    local InRange = inRange

    if IsUsable then
        if (HasRange and InRange == false) then
            Icon:SetVertexColor(0.8, 0.1, 0.1)

            NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
        else
            Icon:SetVertexColor(1.0, 1.0, 1.0)

            NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
        end
    elseif NotEnoughPower then
        Icon:SetVertexColor(0.1, 0.3, 1.0)

        NormalTexture:SetVertexColor(0.1, 0.3, 1.0)
    else
        Icon:SetVertexColor(0.3, 0.3, 0.3)

        NormalTexture:SetVertexColor(0.3, 0.3, 0.3)
    end
end

local function startHighlight(self)
    if not self.Animation then
        self.Animation = self:CreateAnimationGroup()
        self.Animation:SetLooping("BOUNCE")

        self.Animation.FadeOut = self.Animation:CreateAnimation("Alpha")
        self.Animation.FadeOut:SetFromAlpha(1)
        self.Animation.FadeOut:SetToAlpha(.3)
        self.Animation.FadeOut:SetDuration(.3)
        self.Animation.FadeOut:SetSmoothing("IN_OUT")
    end

    -- Hide Blizard Proc
    if self.overlay and self.overlay:GetParent() ~= V.Hider then
        self.overlay:SetParent(V.Hider)
    end

    if not self.Animation:IsPlaying() then
        self.Animation:Play()

        if self.Borders then
            self.Borders:SetBorderColor({ 1, 1, 0 })
        end
    end
end

local function stopHightlight(self)
    if self.Animation and self.Animation:IsPlaying() then
        self.Animation:Stop()

        if self.Borders then
            self.Borders:SetBorderColor({ 0.2, 0.4, 0.6 })
        end
    end
end

local function addHooks()

    hooksecurefunc("ActionButton_UpdateFlyout", styleFlyout)
    hooksecurefunc("SpellButton_OnClick", styleFlyout)

    hooksecurefunc("ActionButton_UpdateRangeIndicator", rangeUpdate)

    --if C.ActionBars.HotKey then
    hooksecurefunc("PetActionButton_SetHotkeys", setHotKeyText)
    --end

    hooksecurefunc("ActionButton_ShowOverlayGlow", startHighlight)
    hooksecurefunc("ActionButton_HideOverlayGlow", stopHightlight)
end

local function hasStance(class)
    return class == 'Druid' or class == 'Paladin' or class == 'Priest'
end

function ActionBars:Enable()
    self.Bars = {}

    for i = 1, 5 do
        tinsert(self.Bars, createBar(self, i))
    end

    if hasStance(UnitClass('player')) then
        tinsert(self.Bars, createStanceBar(self, 6))
    end
    tinsert(self.Bars, createPetBar(self, 7))

    addHooks()
    disableBlizzard()
end

function ActionBars:Disable()

end
local select = select
local LibStub = LibStub

local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local LibChallengeInfo = LibStub:GetLibrary('LibChallengeInfo')

local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local format = format
local SetCVar = SetCVar

local CreateFrame = CreateFrame
local UIParent = UIParent
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local UnitRace = UnitRace
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitCreatureType = UnitCreatureType
local UnitClassification = UnitClassification
local UnitRealmRelationship = UnitRealmRelationship
local UnitPVPName = UnitPVPName
local UnitIsEnemy = UnitIsEnemy
local UnitIsFriend = UnitIsFriend
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitReaction = UnitReaction
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetClassColor = GetClassColor
local GetMouseFocus = GetMouseFocus
local GetGuildInfo = GetGuildInfo
local GetAverageItemLevel = GetAverageItemLevel
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local CHAT_FLAG_AFK = CHAT_FLAG_AFK
local CHAT_FLAG_DND = CHAT_FLAG_DND
local LEVEL = LEVEL
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local DEAD = DEAD
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local GameTooltip = GameTooltip
local GameTooltipTextLeft1 = GameTooltipTextLeft1
local GameTooltip_Hide = GameTooltip_Hide
local ItemRefTooltip = ItemRefTooltip
local EmbeddedItemTooltip = EmbeddedItemTooltip
local ShoppingTooltip1 = ShoppingTooltip1
local ShoppingTooltip2 = ShoppingTooltip2

local HealthBar = GameTooltipStatusBar

local Module = V.Module
local Medias = Module:GetModule('Medias')
local RealmFlag = Module:GetModule('RealmFlag')
local Tooltip = Module:GetModule('Tooltips')
local Utils = Module:GetModule('Utils')

local RGBToHex = Utils.Functions.RGBToHex
local ShortValue = Utils.Functions.ShortValue

local OnMouseOver = true
local DisplayTitle = true
local UnitHealthText = true
local ItemBorderColor = true
local UnitBorderColor = true

local Classification = {
    worldboss = "|cffAF5050B |r",
    rareelite = "|cffAF5050R+ |r",
    elite = "|cffAF5050+ |r",
    rare = "|cffAF5050R |r",
}

function Tooltip:CreateAnchor()
    local anchor = CreateFrame('Frame', 'VorkuiTooltipAnchor', UIParent)
    anchor:SetSize(200, 21)
    anchor:SetFrameStrata('TOOLTIP')
    anchor:SetFrameLevel(20)
    anchor:SetClampedToScreen(true)
    anchor:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', -28, 285)
    anchor:SetMovable(true)

    self.Anchor = anchor
end

local function setTooltipDefaultAnchor(self, parent)
    local anchor = Tooltip.Anchor

    if (OnMouseOver) then
        if (parent ~= UIParent) then
            self:ClearAllPoints()
            self:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 9)
        else
            self:SetOwner(parent, "ANCHOR_CURSOR")
        end
    else
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 9)
    end
end

function Tooltip:GetTextColor(unit)
    if (not unit) then
        return
    end

    local hex, color, r, g, b

    if (UnitIsPlayer(unit)) then
        local class = select(2, UnitClass(unit))
        color = { GetClassColor(class) }
    else
        --local reaction = UnitReaction(unit, "player")
        --color = Color.Reaction[reaction]
        color = { 1, 0, 0 }
    end

    if (not color) then
        return
    end

    r, g, b = color[1], color[2], color[3]
    hex = RGBToHex(r, g, b)

    return hex, r, g, b
end

local function onTooltipSetUnit(self)
    local numLines = self:NumLines()
    local getMouseFocus = GetMouseFocus()
    local unit = (select(2, self:GetUnit())) or (getMouseFocus and getMouseFocus.GetAttribute and getMouseFocus:GetAttribute("unit"))

    if (not unit) and (UnitExists("mouseover")) then
        unit = "mouseover"
    end

    if (not unit) then
        self:Hide()

        return
    end

    if (UnitIsUnit(unit, "mouseover")) then
        unit = "mouseover"
    end

    local rating, runs = LibChallengeInfo:GetChallengeTables(unit)
    local line1 = GameTooltipTextLeft1
    local race = UnitRace(unit)
    local class = UnitClass(unit)
    local level = UnitLevel(unit)
    local guild, guildRankName, _, guildRealm = GetGuildInfo(unit)
    local name, realm = UnitName(unit)
    local creatureType = UnitCreatureType(unit)
    local creatureClassification = UnitClassification(unit)
    local relationship = UnitRealmRelationship(unit);
    local title = UnitPVPName(unit)
    local isEnemy = UnitIsEnemy("player", unit)
    local color = Tooltip:GetTextColor(unit) or "|CFFFFFFFF"
    local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b

    if name then
        local extra = ""

        if (UnitIsPlayer(unit) and not realm) then
            realm = ''
        end

        if realm and realm ~= '' then
            local realmColor = isEnemy and "|cffDE5E5E" or "|cff4AAB4D"
            local flag = RealmFlag:GetFlagText(realm)

            extra = flag .. realmColor .. "[" .. realm .. "]|r"
        end

        if DisplayTitle and title then
            name = title
        end

        line1:SetFormattedText("%s%s%s %s", color, name, "|r", extra)
    end

    if (UnitIsPlayer(unit) and UnitIsFriend("player", unit)) then
        if (UnitIsAFK(unit)) then
            self:AppendText((" %s"):format(CHAT_FLAG_AFK))
        elseif UnitIsDND(unit) then
            self:AppendText((" %s"):format(CHAT_FLAG_DND))
        end
    end

    local offset = 2

    local line, text
    for i = offset, numLines do
        line = _G["GameTooltipTextLeft" .. i]

        if (UnitIsPlayer(unit) and guild) then
            text = line:GetText()
            if text and text:find(guild) then
                line:SetText("|cff00ff00" .. guild .. "|r")
            end
        end

        if (line and text and text:find("^" .. LEVEL)) then
            if (UnitIsPlayer(unit) and race) then
                line:SetFormattedText("|cff%02x%02x%02x%s|r %s %s%s", r * 255, g * 255, b * 255, level > 0 and level or "|cffAF5050??|r", race, color, class .. "|r")
            else
                line:SetFormattedText("|cff%02x%02x%02x%s|r %s%s", r * 255, g * 255, b * 255, level > 0 and level or "|cffAF5050??|r", Classification[creatureClassification] or "", creatureType or "" .. "|r")
            end

            break
        end
    end

    if (UnitExists(unit .. "target")) then
        local unitTarget = unit .. "target"
        local class = select(2, UnitClass(unitTarget))
        local reaction = UnitReaction(unitTarget, "player")
        local r, g, b

        if (UnitIsPlayer(unitTarget)) then
            r, g, b = GetClassColor(class)
        elseif reaction then
            r, g, b = 1, 0, 0 --unpack(Colors.Reaction[reaction])
        else
            r, g, b = 1, 1, 1
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(UnitName(unit .. "target"), r, g, b)
    end

    if rating then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Mythic Rating: " .. rating)
        if IsShiftKeyDown() and runs then
            GameTooltip:AddLine(" ")
            for _, r in ipairs(runs) do
                GameTooltip:AddLine(format('|T%s:0:1.5|t %s - |c%s%s|r', r[3], r[1], r[5]:GenerateHexColor(), r[2]))
            end
            GameTooltip:AddLine(" ")
        end
    end

    if (UnitHealthText) then
        Tooltip.SetHealthValue(HealthBar, unit)
    end

end

local function setUnitBorderColor(self)
    local unit = self
    local r, g, b
    local gameTooltip = GameTooltip

    local reaction = unit and UnitReaction(unit, "player")
    local player = unit and UnitIsPlayer(unit)
    local friend = unit and UnitIsFriend("player", unit)

    if player and friend then
        local class = select(2, UnitClass(unit))
        local color = { GetClassColor(class) }

        r, g, b = color[1], color[2], color[3]

        HealthBar:SetStatusBarColor(r, g, b)
        --HealthBar.Backdrop:SetBackdropBorderColor(r, g, b)
        HealthBar:SetBorderColor({r,g,b})

        --gameTooltip.Backdrop:SetBackdropBorderColor(r, g, b)
        gameTooltip:SetBorderColor({r,g,b})
    elseif reaction then
        local color = {1, 0, 0} --Colors.Reaction[reaction]

        r, g, b = color[1], color[2], color[3]

        HealthBar:SetStatusBarColor(r, g, b)
        --HealthBar.Backdrop:SetBackdropBorderColor(r, g, b)
        HealthBar:SetBorderColor({r,g,b})

        --gameTooltip.Backdrop:SetBackdropBorderColor(r, g, b)
        gameTooltip:SetBorderColor({r,g,b})
    end
end

local function skin(self)
    if self:IsForbidden() then
        return
    end

    if (not self.IsSkinned) then

        self:StripTextures()
        --self:CreateBackdrop()
        --self.Backdrop:SetBackdropColor(0.2, 0.4, 0.6)
        self.Background = self:CreateBackground({0.1, 0.2, 0.3, 1})
        self:CreateBorder(1)

        if self.NineSlice then
            self.NineSlice:SetAlpha(0)
        end

        self.IsSkinned = true
    end
end

function Tooltip:SkinHealthBar()
    HealthBar:SetScript("OnValueChanged", self.OnValueChanged)
    HealthBar:SetStatusBarTexture(Medias:GetStatusBar('VorkuiDefault'))
    --HealthBar:CreateBackdrop()
    HealthBar.Background = HealthBar:CreateBackground()
    HealthBar:CreateBorder(1)

    HealthBar:ClearAllPoints()
    HealthBar:SetPoint("BOTTOMLEFT", HealthBar:GetParent(), "TOPLEFT", 0, 4)
    HealthBar:SetPoint("BOTTOMRIGHT", HealthBar:GetParent(), "TOPRIGHT", 0, 4)
    --HealthBar.Backdrop:CreateShadow()

    if UnitHealthText then
        HealthBar.Text = HealthBar:CreateFontString(nil, "OVERLAY")
        HealthBar.Text:SetFontObject('Tooltip_Small')
        HealthBar.Text:SetPoint("CENTER", HealthBar, "CENTER", 0, 10)
    end
end

local function setItemBorderColor(self)
    local link = select(2, self:GetItem())
    local r, g, b
    local bg = self.Background

    if bg then
        if link then
            local itemInfo = select(3, GetItemInfo(link))

            if itemInfo then
                r, g, b = GetItemQualityColor(itemInfo)
            else
                r, g, b = 0.2, 0.4, 0.6
            end
            self:SetBorderColor({ r, g, b })
            --backdrop:SetBorderColor(r, g, b)
        else
            self:SetBorderColor({0.2, 0.4, 0.6})
            --backdrop:SetBorderColor(0.2, 0.4, 0.6)
        end
    end
end

local function onTooltipSetItem(self)
    if IsShiftKeyDown() then
        local _, link = self:GetItem()

        if link then
            local id = "|cFFCA3C3CID|r " .. link:match(":(%w+)")
            local levelInfo = GetDetailedItemLevelInfo(link) or 1
            local string = "|cFFCA3C3C" .. ITEM_LEVEL_ABBR .. "|r " .. levelInfo

            self:AddLine(" ")
            self:AddDoubleLine(id, string)
        end
    end

    if ItemBorderColor then
        setItemBorderColor(self)
    end
end

function Tooltip:SetHealthValue(unit)
    if (UnitIsDeadOrGhost(unit)) then
        self.Text:SetText(DEAD)
    else
        local health, healthMax = UnitHealth(unit), UnitHealthMax(unit)
        local string = (health and healthMax and ShortValue(health) .. " / " .. ShortValue(healthMax)) or "???"

        if not self.Text:IsShown() then
            self.Text:Show()
        end

        self.Text:SetText(string)
    end
end

function Tooltip:OnValueChanged()
    if (not UnitHealthText) then
        return
    end

    local unit = select(2, self:GetParent():GetUnit())

    if (not unit) then
        local GMF = GetMouseFocus()

        if (GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
            unit = GMF:GetAttribute("unit")
        end
    end

    if not unit then
        return
    end

    Tooltip.SetHealthValue(HealthBar, unit)
end

function Tooltip:HideInCombat(event)
    if (event == "PLAYER_REGEN_DISABLED" or InCombatLockdown()) then
        GameTooltip_Hide()
    end
end

local function setCompareItemBorderColor(self, anchorFrame)

    local shoppingTooltip
    for i = 1, 2 do
        shoppingTooltip = _G["ShoppingTooltip" .. i]

        if shoppingTooltip:IsShown() then
            local frameLevel = GameTooltip:GetFrameLevel()
            local item = shoppingTooltip:GetItem()

            if frameLevel == shoppingTooltip:GetFrameLevel() then
                shoppingTooltip:SetFrameLevel(i + 1)
            end

            if item then
                local itemInfo = select(3, GetItemInfo(item))

                if itemInfo then
                    local r, g, b = GetItemQualityColor(itemInfo)
                    shoppingTooltip:SetBorderColor({ r, g, b})
                else
                    shoppingTooltip:SetBorderColor({ 0.2, 0.4, 0.6})
                end
            end
        end
    end
end

local function resetBorderColor(self)
    if self ~= GameTooltip then
        return
    end

    if self.Background then
        self:SetBorderColor({0.2, 0.4, 0.6})
    end


    if HealthBar then
        HealthBar:SetBorderColor({0, 1, 0})

        if HealthBar.Text then
            HealthBar.Text:Hide()
        end

        HealthBar:SetStatusBarColor(1, 0, 0)
    end
end

function Tooltip:SetBackdropStyle()
    self.Background:SetColorTexture(0.1, 0.2, 0.3, 1)
    self:SetBorderColor({0.2, 0.4, 0.6})
end

function Tooltip:AddHooks()
    hooksecurefunc("GameTooltip_SetDefaultAnchor", setTooltipDefaultAnchor)

    if UnitBorderColor then
        hooksecurefunc("GameTooltip_UnitColor", setUnitBorderColor)
        hooksecurefunc("GameTooltip_ShowCompareItem", setCompareItemBorderColor)
    end

    if UnitBorderColor or ItemBorderColor then
        hooksecurefunc("GameTooltip_ClearMoney", resetBorderColor)
    end

    GameTooltip:HookScript("OnTooltipSetUnit", onTooltipSetUnit)
    GameTooltip:HookScript("OnTooltipSetItem", onTooltipSetItem)
end

function Tooltip:Enable()

    self:CreateAnchor()
    self:AddHooks()
    self:SkinHealthBar()

    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

    self:SetScript("OnEvent", Tooltip.HideInCombat)

    --if C.Tooltips.AlwaysCompareItems then
    SetCVar("alwaysCompareItems", 1)
    --else
    --    SetCVar("alwaysCompareItems", 0)
    --end

    skin(GameTooltip)
    skin(ItemRefTooltip)
    skin(EmbeddedItemTooltip)
    skin(ShoppingTooltip1)
    skin(ShoppingTooltip2)

    HealthBar:SetStatusBarColor(1,0,0)
    HealthBar:Hide()

    --if T.Retail then
    --    ItemRefTooltip.CloseButton:SkinCloseButton()
    --end

    --T.Movers:RegisterFrame(self.Anchor, "Tooltip")
end

function Tooltip:Disable()

end
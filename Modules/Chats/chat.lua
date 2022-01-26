local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local UIParent = UIParent
local _G = _G
local format = format
local unpack = unpack
local ipairs = ipairs
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc
local C_Timer = C_Timer
local SlashCmdList = SlashCmdList
local SetCVar = SetCVar
local CreateFrame = CreateFrame
local CHAT_FONT_HEIGHTS = CHAT_FONT_HEIGHTS
local CHAT_FRAME_TEXTURES = CHAT_FRAME_TEXTURES
local GENERAL_CHAT_DOCK = GENERAL_CHAT_DOCK
local GLOBAL_CHANNELS = GLOBAL_CHANNELS
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local IsShiftKeyDown = IsShiftKeyDown
local ChangeChatColor = ChangeChatColor
local IsAltKeyDown = IsAltKeyDown
local ToggleFrame = ToggleFrame
local UIFrameFadeRemoveFrame = UIFrameFadeRemoveFrame
local EnumerateServerChannels = EnumerateServerChannels
local FCF_GetCurrentChatFrame = FCF_GetCurrentChatFrame
local FCF_DockFrame = FCF_DockFrame
local FCFDock_GetChatFrames = FCFDock_GetChatFrames
local FCF_UnDockFrame = FCF_UnDockFrame
local FCF_SetTabPosition = FCF_SetTabPosition
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_SetLocked = FCF_SetLocked
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SetWindowName = FCF_SetWindowName
local FCF_SelectDockFrame = FCF_SelectDockFrame
local FCF_UpdateButtonSide = FCF_UpdateButtonSide
local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups
local ChatFrame_RemoveAllChannels = ChatFrame_RemoveAllChannels
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatEdit_DeactivateChat = ChatEdit_DeactivateChat

local Module = V.Module
local Chat = Module:GetModule('ChatFrames')
local DataFrames = Module:GetModule('DataFrames')

local texture = [[Interface/Tooltips/UI-Tooltip-Background]]
local position = { 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 32, 32 }
local size = { 500, 280 }
local textFadingTime = 60
local currentTab

CHAT_FONT_HEIGHTS = {
    8,10,11,12,13,14,16,18
}

local function onMouseWheel(self, delta)

    local scrollFct
    local scrollToFct

    if delta < 0 then
        scrollFct = self.ScrollDown
        scrollToFct = self.ScrollToBottom
    else
        scrollFct = self.ScrollUp
        scrollToFct = self.ScrollToTop
    end

    if IsShiftKeyDown() then
        scrollToFct(self)
    else
        for i = 1, 3 do
            scrollFct(self)
        end
    end
end

function Chat:StyleFrame(frame)

    if frame.isSkinned == true then
        return
    end

    local id = frame:GetID()
    local name = frame:GetName()
    local tab = _G[name .. 'Tab']
    local tabText = _G[name .. 'TabText']
    local scroll = frame.ScrollBar
    local scrollBottom = frame.ScrollToBottomButton
    local scrollTex = _G[name .. 'ThumbTexture']
    local editbox = _G[name .. 'EditBox']

    if tab.conversationIcon then
        tab.conversationIcon:Kill()
    end

    tab:HookScript('OnClick', function(t)
        editbox:Hide()

        if currentTab then
            currentTab.Borders[1]:Hide()
        end
        t.Borders[1]:Show()
        currentTab = t
    end)

    if scroll then
        scroll:Kill()
        scrollBottom:Kill()
        --scrollBottom:StripTextures()
        scrollTex:Kill()
    end

    tab:SetAlpha(1)
    tab.SetAlpha = UIFrameFadeRemoveFrame
    tab:CreateOneBorder('bottom', 2, {0.2, 0.4, 0.6})
    if id > 1 then
        tab.Borders[1]:Hide()
    else
        currentTab = tab
    end

    frame:SetClampRectInsets(0, 0, 0, 0)
    frame:SetClampedToScreen(false)
    frame:SetFading(true)
    frame:SetTimeVisible(textFadingTime)

    editbox:ClearAllPoints()
    editbox:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 0)
    editbox:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 0, 32)
    editbox:SetAltArrowKeyMode(false)
    editbox:Hide()
    editbox:HookScript('OnEditFocusLost', function(self)
        self:Hide()
    end)
    editbox:CreateOneBorder('top', 1, {0.2, 0.4, 0.6})
    editbox:CreateBackground({0.2, 0.4, 0.6, 0.75})

    for i = 1, #CHAT_FRAME_TEXTURES do
        _G[name .. CHAT_FRAME_TEXTURES[i]]:SetTexture(nil)
    end

    -- Remove default chatframe tab textures
    _G[format("ChatFrame%sTabLeft", id)]:Kill()
    _G[format("ChatFrame%sTabMiddle", id)]:Kill()
    _G[format("ChatFrame%sTabRight", id)]:Kill()
    _G[format("ChatFrame%sTabSelectedLeft", id)]:Kill()
    _G[format("ChatFrame%sTabSelectedMiddle", id)]:Kill()
    _G[format("ChatFrame%sTabSelectedRight", id)]:Kill()
    _G[format("ChatFrame%sTabHighlightLeft", id)]:Kill()
    _G[format("ChatFrame%sTabHighlightMiddle", id)]:Kill()
    _G[format("ChatFrame%sTabHighlightRight", id)]:Kill()
    _G[format("ChatFrame%sTabSelectedLeft", id)]:Kill()
    _G[format("ChatFrame%sTabSelectedMiddle", id)]:Kill()
    _G[format("ChatFrame%sTabSelectedRight", id)]:Kill()
    _G[format("ChatFrame%sButtonFrameMinimizeButton", id)]:Kill()
    _G[format("ChatFrame%sButtonFrame", id)]:Kill()
    _G[format("ChatFrame%sEditBoxLeft", id)]:Kill()
    _G[format("ChatFrame%sEditBoxMid", id)]:Kill()
    _G[format("ChatFrame%sEditBoxRight", id)]:Kill()
    _G[format("ChatFrame%sEditBoxFocusLeft", id)]:Kill()
    _G[format("ChatFrame%sEditBoxFocusMid", id)]:Kill()
    _G[format("ChatFrame%sEditBoxFocusRight", id)]:Kill()

    frame:SetScript('OnMouseWheel', onMouseWheel)

    frame.isSkinned = true
end

function Chat:StyleTempFrame()
    local frame = FCF_GetCurrentChatFrame()

    if frame.IsSkinned == true then
        return
    end

    Chat:StyleFrame(frame)
end

function Chat:Dock(frame)
    FCF_DockFrame(frame, #FCFDock_GetChatFrames(GENERAL_CHAT_DOCK) + 1, true)
end

function Chat:Undock(frame)
    FCF_UnDockFrame(frame)
    FCF_SetTabPosition(frame, 0)
end

local function setChatFramePosition(self)
    local id = self:GetID()
    local tab = _G['ChatFrame' .. id .. 'Tab']
    local isMovable = self:IsMovable()

    if tab:IsShown() then
        if id == 1 then
            self:SetUserPlaced(true)
            self:ClearAllPoints()
            --self:SetSize(unpack(size))
            --self:SetAllPoints()
            self:SetPoint('BOTTOMLEFT', self:GetParent(), 'BOTTOMLEFT', 2, 2)
            self:SetPoint('TOPRIGHT', self:GetParent(), 'TOPRIGHT', -2, -32)
        end

        FCF_SavePositionAndDimensions(self)
    end
end

function Chat:Reset()
    local isPublicChannelFound = EnumerateServerChannels()

    if not isPublicChannelFound then
        C_Timer.After(1, Chat.Reset)
        return
    end

    FCF_ResetChatWindows()
    FCF_SetLocked(ChatFrame1, 1)
    FCF_DockFrame(ChatFrame2)
    FCF_SetLocked(ChatFrame2, 1)
    FCF_DockFrame(ChatFrame3)
    FCF_SetLocked(ChatFrame3, 1)
    FCF_DockFrame(ChatFrame4)
    FCF_SetLocked(ChatFrame4, 1)
    FCF_OpenNewWindow(NPC_NAMES_DROPDOWN_ALL)
    FCF_SetLocked(ChatFrame5, 1)
    FCF_DockFrame(ChatFrame5)
    FCF_OpenNewWindow(GLOBAL_CHANNELS)
    FCF_SetLocked(ChatFrame6, 1)
    FCF_DockFrame(ChatFrame6)
    FCF_SetWindowName(ChatFrame1, "Community")
    FCF_SetWindowName(ChatFrame2, "Log")
    FCF_SetWindowName(ChatFrame4, "Gain")
    FCF_SetWindowName(ChatFrame5, "Monster")
    FCF_SetWindowName(ChatFrame6, "Global Channel")

    FCF_SetChatWindowFontSize(nil, ChatFrame1, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame2, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame3, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame4, 14)
    FCF_SetChatWindowFontSize(nil, ChatFrame5, 14)

    DEFAULT_CHAT_FRAME:SetUserPlaced(true)

    local chatGroup = {}
    local channels = {}

    for i = 1, select("#", EnumerateServerChannels()), 1 do
        channels[i] = select(i, EnumerateServerChannels())
    end

    -- Remove everything in first 4 chat windows
    for i = 1, 6 do
        if i ~= 2 and i ~= 3 then
            local chatFrame = _G["ChatFrame" .. i]
            ChatFrame_RemoveAllMessageGroups(chatFrame)
            ChatFrame_RemoveAllChannels(chatFrame)
        end
    end

    -- Join public channels
    for i = 1, #channels do
        SlashCmdList["JOIN"](channels[i])
    end

    -- Fix a editbox texture
    ChatEdit_ActivateChat(ChatFrame1EditBox)
    ChatEdit_DeactivateChat(ChatFrame1EditBox)

    -----------------------
    -- ChatFrame 1 Setup --
    -----------------------

    chatGroup = {
        'SAY',
        'EMOTE',
        'YELL',
        'GUILD',
        'OFFICER',
        'GUILD_ACHIEVEMENT',
        'WHISPER',
        'PARTY',
        'PARTY_LEADER',
        'RAID',
        'RAID_LEADER',
        'RAID_WARNING',
        'INSTANCE_CHAT',
        'INSTANCE_CHAT_LEADER',
        'BG_HORDE',
        'BG_ALLIANCE',
        'BG_NEUTRAL',
        'AFK',
        'DND',
        'ACHIEVEMENT',
        'BN_WHISPER',
        'BN_CONVERSATION',
    }

    for _, v in ipairs(chatGroup) do
        ChatFrame_AddMessageGroup(_G.ChatFrame1, v)
    end

    FCF_SelectDockFrame(ChatFrame1)

    -----------------------
    -- ChatFrame 4 Setup --
    -----------------------

    local tab4 = ChatFrame4Tab
    local chat4 = ChatFrame4

    chatGroup = {
        'COMBAT_XP_GAIN',
        'COMBAT_HONOR_GAIN',
        'COMBAT_FACTION_CHANGE',
        'LOOT',
        'MONEY',
        'SYSTEM',
        'ERRORS',
        'IGNORED',
        'SKILL',
        'CURRENCY',
    }

    for _, v in ipairs(chatGroup) do
        ChatFrame_AddMessageGroup(_G.ChatFrame4, v)
    end

    -----------------------
    -- ChatFrame 5 Setup --
    -----------------------

    chatGroup = {
        "MONSTER_SAY",
        "MONSTER_EMOTE",
        "MONSTER_YELL",
        "MONSTER_WHISPER",
        "MONSTER_BOSS_EMOTE",
        "MONSTER_BOSS_WHISPER"
    }

    for _, v in ipairs(chatGroup) do
        ChatFrame_AddMessageGroup(_G.ChatFrame5, v)
    end

    -----------------------
    -- ChatFrame 6 Setup --
    -----------------------

    for i = 1, #channels do
        ChatFrame_RemoveChannel(ChatFrame1, channels[i])
        ChatFrame_AddChannel(ChatFrame6, channels[i])
    end

    -- Adjust Chat Colors
    ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255)
    ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255)
    ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255)
    ChangeChatColor("CHANNEL4", 232 / 255, 228 / 255, 121 / 255)
    ChangeChatColor("CHANNEL5", 0 / 255, 228 / 255, 121 / 255)
    ChangeChatColor("CHANNEL6", 0 / 255, 228 / 255, 0 / 255)

end

function Chat:SwitchSpokenDialect(button)
    if IsAltKeyDown() and button == 'LeftButton' then
        ToggleFrame(ChatMenu)
    end
end

function Chat:AddMessage(text, ...)
    text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")

    return self.DefaultAddMessage(self, text, ...)
end

function Chat:Setup()
    local frame
    local tab
    for i = 1, NUM_CHAT_WINDOWS do
        frame = _G['ChatFrame' .. i]
        tab = _G['ChatFrame' .. i .. 'Tab']

        tab.noMouseAlpha = 0
        tab:SetAlpha(0)
        tab:HookScript('OnClick', self.SwitchSpokenDialect)
        tab:SetFrameLevel(6)

        self:StyleFrame(frame)

        if i == 2 then
            CombatLogQuickButtonFrame_Custom:StripTextures()
            frame.DefaultAddMessage = frame.AddMessage
            frame.AddMessage = Chat.AddMessage
        end
    end

    ChatConfigFrameDefaultButton:Kill()
    ChatFrameMenuButton:Kill()
    QuickJoinToastButton:Kill()

    ChatMenu:ClearAllPoints()
    ChatMenu:SetPoint("BOTTOMLEFT", self.Panel, "TOPLEFT", -1, 16)

    --VoiceChatPromptActivateChannel:CreateBackdrop
    VoiceChatPromptActivateChannel:SetPoint('BOTTOMLEFT', self.Panel, 'TOPLEFT', 0, 12)

    -- Remember last channel
    ChatTypeInfo.WHISPER.sticky = 1
    ChatTypeInfo.BN_WHISPER.sticky = 1
    ChatTypeInfo.OFFICER.sticky = 1
    ChatTypeInfo.RAID_WARNING.sticky = 1
    ChatTypeInfo.CHANNEL.sticky = 1

    -- Enable nicknames classcolor
    SetCVar("chatClassColorOverride", 0)

    --guild
    CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
    CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "

    --raid
    CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
    CHAT_RAID_WARNING_GET = "RW %s "
    CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "

    --party
    CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
    CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|hPL|h %s "
    CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|hPG|h %s "

    --raids, bgs, dungeons
    CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|hR|h %s: ";
    CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|hRL|h %s: ";

    --whisper
    CHAT_WHISPER_INFORM_GET = "to %s "
    CHAT_WHISPER_GET = "from %s "
    CHAT_BN_WHISPER_INFORM_GET = "to %s "
    CHAT_BN_WHISPER_GET = "from %s "

    --say / yell
    CHAT_SAY_GET = "%s "
    CHAT_YELL_GET = "%s "

    --flags
    CHAT_FLAG_AFK = "[AFK] "
    CHAT_FLAG_DND = "[DND] "
    CHAT_FLAG_GM = "[GM] "

end

local function createPanel(self)
    local panel = CreateFrame('frame', 'ChatPanel', UIParent)
    panel:SetSize(unpack(size))
    panel:SetPoint(unpack(position))

    --panel:SetBackdropColor( 0.2, 0.4, 0.6, 0.5 )

    panel.Background = panel:CreateTexture(nil, 'BACKGROUND')
    panel.Background:SetAllPoints()
    panel.Background:SetTexture(texture)
    panel.Background:SetGradientAlpha('VERTICAL', 0.2, 0.4, 0.6, 0.5,  0.2, 0.4, 0.6, 0.25)

    panel:CreateBorderBySides(2, {0.2, 0.4, 0.6}, 'bottom', 'left', 'right')
    --panel.Borders[1]:SetColorTexture(0.2,0.4,0.6)
    --panel.Borders[2]:SetColorTexture(0.2,0.4,0.6)
    --panel.Borders[3]:SetColorTexture(0.2,0.4,0.6)

    local dFrames
    dFrames = DataFrames:CreatePanel({ 'TOPLEFT', panel, 'BOTTOMLEFT', -32, 0 }, 4, 'RIGHT', {(size[1]/2-25), 32}, {0, 0}, true, true)
    DataFrames:AddData('micromenu', dFrames, 1, true, true, false, true)
    DataFrames:AddData('covenant', dFrames, 2, true, true, false, true)
    DataFrames:AddData('specialization', dFrames, 3, true, true, false, true)
    DataFrames:AddData('legendary', dFrames, 4, true, true, false, true)

    local data1, data2 = dFrames:GetChildren()
    data1:ClearAllPoints()
    data1:SetPoint('BOTTOMLEFT', dFrames, 'BOTTOMLEFT')
    data2:ClearAllPoints()
    data2:SetPoint('BOTTOMLEFT', data1, 'BOTTOMRIGHT', 0, 0)

    self.DataFramePanel = dFrames
    self.Panel = panel
end

local function addToast(self, parent)
     --TESTING CMD : /run BNToastFrame:AddToast(BN_TOAST_TYPE_ONLINE, 1)

    if not self.isSkinned then
        local Glow = BNToastFrameGlowFrame
        Glow:SetParent(parent)
        self:SetBackdrop(nil)
        self.Background = self:CreateTexture(nil, 'BACKGROUND')
        self.Background:SetAllPoints()
        self.Background:SetTexture(texture)
        self.Background:SetGradientAlpha('VERTICAL', 0.2, 0.4, 0.6, 0.5, 0.2, 0.4, 0.6, 0.25)
        self:CreateBorder(2, {0.2, 0.4, 0.6})
        self.isSkinned = true
    end

    self:ClearAllPoints()
    self:SetPoint('BOTTOMLEFT', parent, 'TOPLEFT', 0, 16)
end

local function noMouseAlpha(self)
    local name = self:GetName()
    local tab = _G[name .. "Tab"]

    if (tab.noMouseAlpha == 0.4) or (tab.noMouseAlpha == 0.2) then
        tab:SetAlpha(0)
        tab.noMouseAlpha = 0
    end
end

function Chat:Enable()
    createPanel(self)
    self:Setup()
    self.Chats = {}

    --local font = Medias:GetFontAddress('Montserrat', true)
    local chatFrame
    for i=1, NUM_CHAT_WINDOWS do
        chatFrame = _G['ChatFrame'..i]
        tinsert(self.Chats, chatFrame)
        chatFrame:SetParent(self.Panel)
        chatFrame:SetFontObject(ChatFontNormal)
        chatFrame:SetJustifyH('LEFT')
        setChatFramePosition(chatFrame)
    end

    --ChatFrame1Tab:Click()
    ChatFrameChannelButton:Kill()

    --hooksecurefunc("ChatEdit_UpdateHeader", Chat.UpdateEditBoxColor)
    hooksecurefunc("FCF_OpenTemporaryWindow", Chat.StyleTempFrame)
    hooksecurefunc("FCF_RestorePositionAndDimensions", setChatFramePosition)
    --hooksecurefunc("FCF_SavePositionAndDimensions", Chat.SaveChatFramePositionAndDimensions)
    hooksecurefunc("FCFTab_UpdateAlpha", noMouseAlpha)
    hooksecurefunc(BNToastFrame, "AddToast", function(toast)
       addToast(toast, self.Panel)
    end)

    FCF_UpdateButtonSide = function()
    end
    --FCF_ToggleLock = self.LockChat
    --FCF_ToggleLockOnDockedFrame = self.LockChat

    --if (not C.Chat.WhisperSound) then
    --    return
    --end
    --local Whisper = CreateFrame("Frame")
    --Whisper:RegisterEvent("CHAT_MSG_WHISPER")
    --Whisper:RegisterEvent("CHAT_MSG_BN_WHISPER")
    --Whisper:SetScript("OnEvent", function(self, event)
    --    Chat:PlayWhisperSound()
    --end)

    self.Link:Enable()
    self.Copy:Enable()
end

function Chat:Disable()

end
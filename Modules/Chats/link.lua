local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local CreateFrame = CreateFrame
local unpack = unpack
local gsub = gsub
local strsub = strsub
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local ItemRefTooltip = ItemRefTooltip

local Chat = V['ChatFrames']
local Link = CreateFrame('frame')
local currentLink
local linkColor = { 0.7, 0.4, 0.8 }
local RGBToHex = V.Utils.Functions.RGBToHex

local function create(self, url)
    url = RGBToHex(unpack(linkColor)).."|Hurl:"..url.."|h["..url.."]|h|r "

    return url
end

local function find(self, event, msg, ...)
    local NewMsg, Found = gsub(msg, "(%a+)://(%S+)%s?", create(self, "%1://%2"))

    if (Found > 0) then
        return false, NewMsg, ...
    end

    NewMsg, Found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", create(self, "www.%1.%2"))

    if (Found > 0) then
        return false, NewMsg, ...
    end

    NewMsg, Found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", create(self, "%1@%2%3%4"))

    if (Found > 0) then
        return false, NewMsg, ...
    end
end

local function setHyperLink(self, data, ...)
    if (strsub(data, 1, 3) == "url") then
        local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()

        currentLink = (data):sub(5)

        if (not ChatFrameEditBox:IsShown()) then
            ChatEdit_ActivateChat(ChatFrameEditBox)
        end

        ChatFrameEditBox:Insert(currentLink)
        ChatFrameEditBox:HighlightText()
        currentLink = nil
    else
        setHyperlink(self, data, ...)
    end
end

function Link:Enable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", find)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", find)

    ItemRefTooltip.SetHyperlink = setHyperLink
end

function Link:Disable()

end

Chat.Link = Link
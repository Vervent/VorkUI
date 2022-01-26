local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local UIParent = UIParent
local CreateFrame = CreateFrame
local gsub = gsub
local format = format
local tconcat = table.concat
local ipairs = ipairs
local SELECTED_CHAT_FRAME = SELECTED_CHAT_FRAME
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize

local Module = V.Module
local Chat = Module:GetModule('ChatFrames')
local Utils = Module:GetModule('Utils')
local Copy = CreateFrame('frame')
local RGBToHex = Utils.Functions.RGBToHex

local function onTextCopied(self)
    self:SetTextCopyable(false)
    self:EnableMouse(true)
    self:SetOnTextCopiedCallback(nil)
    self.canCopy = false
end

local function select(chatFrame)
    local frame = chatFrame or SELECTED_CHAT_FRAME

    frame:SetTextCopyable(true)
    frame:SetOnTextCopiedCallback(onTextCopied)
end

local function getLines(self)
    local lines = {}
    for i = 1, self:GetNumMessages() do
        local message, r, g, b = self:GetMessageInfo(i)
        if message and not (message ~= gsub(message, '(:?|?)|K(.-)|k', function(arg1, id)
            if id and arg1 == '' then
                return id
            end
        end)) then
            r = r or 1
            g = g or 1
            b = b or 1

            lines[#lines + 1] = format('%s%s|r', RGBToHex(r, g, b), message)
        end
    end
    return lines
end

local function copyChat(chatFrame)
    local copyFrame = Copy.CopyFrame
    if not copyFrame:IsShown() then
        local _, fontSize = FCF_GetChatWindowInfo(chatFrame:GetID())
        if fontSize < 10 then
            fontSize = 12
        end
        FCF_SetChatWindowFontSize(chatFrame, chatFrame, 0.01)
        copyFrame:Show()
        local lines = getLines(chatFrame)
        FCF_SetChatWindowFontSize(chatFrame, chatFrame, fontSize)
        copyFrame.Editbox:SetText(tconcat(lines, '\n'))
    else
        copyFrame:Hide()
    end

end

local function onMouseUp(btn)

    local chat = btn.ChatFrame

    copyChat(chat)


end

local function onEnter(self)
    local btn = self.Copy or self

    btn:SetAlpha(1)
end

local function onLeave(self)
    local btn = self.Copy or self

    btn:SetAlpha(0)
end

function Copy:Enable()

    local window = CreateFrame('frame', 'CopyChatFrame', UIParent)
    window:SetSize(600, 500)
    window:SetPoint('CENTER', UIParent)
    window:SetMovable(true)
    window:EnableMouse(true)
    window:SetResizable(true)
    window:SetMinResize(350, 100)
    window:SetScript('OnMouseDown', function(chat, btn)
        if btn == 'LeftButton' and not chat.isMoving then
            chat:StartMoving()
            chat.isMoving = true
        elseif btn == 'RightButton' and not chat.isSizing then
            chat:StartSizing()
            chat.isSizing = true
        end
    end)

    window:SetScript('OnMouseUp', function(chat, btn)
        if btn == 'LeftButton' and chat.isMoving then
            chat:StopMovingOrSizing()
            chat.isMoving = false
        elseif btn == 'RightButton' and chat.isSizing then
            chat:StopMovingOrSizing()
            chat.isSizing = false
        end
    end)

    window:SetScript('OnHide', function(chat)
        if chat.isMoving or chat.isSizing then
            chat:StopMovingOrSizing()
            chat.isMoving = false
            chat.isSizing = false
        end
    end)
    window:SetFrameStrata('DIALOG')

    window.Title = window:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    window.Title:SetText('Copy Chat Frame')
    window.Title:SetPoint('TOP', 0, -8)
    window.Background = window:CreateTexture(nil, 'BACKGROUND')
    window.Background:SetColorTexture(0.2, 0.4, 0.6, 0.5)
    window.Background:SetAllPoints()

    local scrollFrame = CreateFrame('ScrollFrame', 'CopyChatFrameScrollFrame', window, 'UIPanelScrollFrameTemplate')
    scrollFrame:SetPoint('TOPLEFT', 4, -30)
    scrollFrame:SetPoint('BOTTOMRIGHT', -30, 4)

    local editbox = CreateFrame('Editbox', 'CopyChatFrameEditBox', window)
    editbox:SetMultiLine(true)
    editbox:SetMaxLetters(99999)
    editbox:EnableMouse(true)
    editbox:SetAutoFocus(false)
    editbox:SetFontObject('ChatFontNormal')
    editbox:SetSize(scrollFrame:GetSize())
    editbox:SetScript('OnEscapePressed', function()
        window:Hide()
    end)
    editbox:SetScript('OnTextChanged', function(_, input)
        if input then
            return
        end

        local _, Max = _G.CopyChatFrameScrollFrameScrollBar:GetMinMaxValues()
        for idx = 1, Max do
            _G.ScrollFrameTemplate_OnMouseWheel(scrollFrame, -1)
        end
    end)
    scrollFrame:SetScrollChild(editbox)
    scrollFrame:SetScript('OnSizeChanged', function(scroll)
        editbox:SetSize(scroll:GetSize())
    end)
    scrollFrame:HookScript('OnVerticalScroll', function(scroll, offset)
        editbox:SetHitRectInsets(0, 0, offset, editbox:GetHeight() - offset - scroll:GetHeight())
    end)

    scrollFrame:CreateOneBorder('top', 2, {0.2, 0.4, 0.6}, 6)

    window.ScrollFrame = scrollFrame
    window.Editbox = editbox

    local closeBtn = CreateFrame('Button', 'CopyChatFrameCloseButton', window, 'UIPanelCloseButton')
    closeBtn:Point('TOPRIGHT')
    closeBtn:SetFrameLevel(closeBtn:GetFrameLevel() + 1)
    closeBtn:EnableMouse(true)
    window.Close = closeBtn

    window:Hide()
    self.CopyFrame = window

    local btn
    for _, chat in ipairs(Chat.Chats) do
        btn = CreateFrame('Button', nil, chat)
        btn:SetPoint('TOPRIGHT')
        btn:SetSize(20, 20)
        btn:SetNormalTexture([[interface/icons/inv_misc_paperbundle02a]])
        btn:SetAlpha(0)
        btn.ChatFrame = chat
        btn.Window = window

        btn:SetScript('OnMouseUp', onMouseUp)
        btn:SetScript('OnEnter', onEnter)
        btn:SetScript('OnLeave', onLeave)

        chat.Copy = btn
        chat:HookScript('OnEnter', onEnter)
        chat:HookScript('OnLeave', onLeave)
    end

end

function Copy:Disable()

end

Chat.Copy = Copy
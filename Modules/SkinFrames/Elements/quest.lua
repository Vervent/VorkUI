local select = select
local ipairs = ipairs
local _G = _G
local V, C, L = select(2, ...):unpack()

local Module = V.Module
local SkinFrames = Module:GetModule('SkinFrames')

local frame = _G['QuestFrame']

local QuestFrame_SetTitleTextColor = QuestFrame_SetTitleTextColor
local QuestFrame_SetTextColor = QuestFrame_SetTextColor

local function skinPanel(panelName, scrollName, scrollChildName, skinChildButton, skinFct)
    local w = frame:GetWidth()-10
    local detailPanel = _G[panelName]

    detailPanel.Bg:SetAlpha(0)
    detailPanel.MaterialBotLeft:SetAlpha(0)
    detailPanel.MaterialBotRight:SetAlpha(0)
    detailPanel.MaterialTopLeft:SetAlpha(0)
    detailPanel.MaterialTopRight:SetAlpha(0)
    detailPanel.SealMaterialBG:SetAlpha(0)

    local scroll = _G[scrollName]
    local child = _G[scrollChildName]
    scroll.ScrollBar:SetAlpha(0)

    local r
    for i=1, scroll:GetNumRegions() do
        r = select(i, scroll:GetRegions())
        r:Kill()
    end

    scroll:SetWidth(w)
    child:SetWidth(w)

    if skinChildButton then
        for _, btn in ipairs({child:GetChildren()}) do
            if btn:IsObjectType('Button') then
                skinFct(btn)
            end
        end
    end
end

local function skinQuestProgressItem(item)
    item.NameFrame:SetAlpha(0)
    item.IconBorder:SetAlpha(0)
end

local function skinFrame()
    local name = frame:GetName()

    local questNpcNameFrame = _G['QuestNpcNameFrame']

    frame.Bg:SetAlpha(0)
    frame.Inset:SetAlpha(0)
    frame.NineSlice:SetAlpha(0)
    frame.TitleBg:SetAlpha(0)
    frame.TopTileStreaks:SetAlpha(0)

    questNpcNameFrame:ClearAllPoints()
    questNpcNameFrame:SetPoint('TOPLEFT', frame.portrait, 'TOPRIGHT', 2, 0)
    questNpcNameFrame:SetWidth(frame:GetWidth()-100)
    _G['QuestFrameNpcNameText']:SetJustifyH('LEFT')

    frame.portrait:SetSize(40, 40)
    frame.portrait:ClearAllPoints()
    frame.portrait:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)

    frame.Background = frame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    frame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    skinPanel('QuestFrameDetailPanel', 'QuestDetailScrollFrame', 'QuestDetailScrollChildFrame')
    skinPanel('QuestFrameGreetingPanel', 'QuestGreetingScrollFrame', 'QuestGreetingScrollChildFrame')
    skinPanel('QuestFrameProgressPanel', 'QuestProgressScrollFrame', 'QuestProgressScrollChildFrame', true, skinQuestProgressItem)
    skinPanel('QuestFrameRewardPanel', 'QuestRewardScrollFrame', 'QuestRewardScrollChildFrame')
end

local function enable()
    skinFrame()

    --Remove Blizzard Function to not change Color using material
    QuestFrame_SetTitleTextColor = function(...)  end
    QuestFrame_SetTextColor = function(...)  end
end

local function disable()

end

SkinFrames:RegisterSkin(frame, enable, disable)
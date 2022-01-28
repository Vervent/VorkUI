local select = select

local V, C, L = select(2, ...):unpack()

local Module = V.Module
local SkinFrames = Module:GetModule('SkinFrames')

local _G = _G
local frame = _G['GossipFrame']

local function skinFriendship()
    local f = _G['NPCFriendshipStatusBar']

    f.BarCircle:SetAlpha(0)
    f.icon:ClearAllPoints()
    f.icon:SetPoint('TOPLEFT', f, 'TOPLEFT', -26, 14)
end

local function skinScrollFrame()
    local w = frame:GetWidth()-10
    local f = _G['GossipFrameGreetingPanel']

    local scroll = _G['GossipGreetingScrollFrame']
    local scrollBar = scroll.ScrollBar
    local scrollChild = _G['GossipGreetingScrollChildFrame']

    scrollBar:SetAlpha(0)
    local r
    for i=1, scroll:GetNumRegions() do
        r = select(i, scroll:GetRegions())
        r:Kill()
    end

    scroll:SetWidth(w)
    scrollChild:SetWidth(w)
end

local function skinFrame()
    local name = frame:GetName()

    local gossipNpcNameFrame = _G['GossipNpcNameFrame']

    frame.Bg:SetAlpha(0)
    frame.Background:SetAlpha(0)
    frame.Inset:SetAlpha(0)
    frame.NineSlice:SetAlpha(0)
    frame.TitleBg:SetAlpha(0)
    frame.TopTileStreaks:SetAlpha(0)

    gossipNpcNameFrame:ClearAllPoints()
    gossipNpcNameFrame:SetPoint('TOPLEFT', frame.portrait, 'TOPRIGHT', 2, 0)
    gossipNpcNameFrame:SetWidth(frame:GetWidth()-100)
    _G['GossipFrameNpcNameText']:SetJustifyH('LEFT')

    frame.portrait:SetSize(40, 40)
    frame.portrait:ClearAllPoints()
    frame.portrait:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)

    frame.BackgroundTexture = frame:CreateBackground({ 0.1, 0.2, 0.3, 0.85 })
    frame:CreateBorder(1, { 0.2, 0.4, 0.6, 0.75 })

    skinFriendship()
    skinScrollFrame(frame)
end

local function enable()
    skinFrame()
end

local function disable()

end

SkinFrames:RegisterSkin(frame, enable, disable)
local V, C, L = select(2, ...):unpack()

local LibSlant = LibStub:GetLibrary("LibSlant")
local Module = V.Module
local Medias = Module:GetModule('Medias')
local SkinFrames = Module:GetModule('SkinFrames')

local frame = _G['GossipFrame']

local function skinFriendship()
    local f = _G['NPCFriendshipStatusBar']

    f.BarCircle:SetAlpha(0)
    f.icon:ClearAllPoints()
    f.icon:SetPoint('TOPLEFT', f, 'TOPLEFT', -26, 14)
end

local function skinScrollFrame()
    local f = _G['GossipFrameGreetingPanel']

    local scroll = _G['GossipGreetingScrollFrame']

    Module:GetModule('DebugFrames'):Log(scroll)
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
    skinScrollFrame()
end

local function enable()
    skinFrame()
end

local function disable()

end

SkinFrames:RegisterSkin(frame, enable, disable)
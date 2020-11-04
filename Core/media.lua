---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by flori.
--- DateTime: 01/11/2020 22:11
---

local V,C,L = select(2,...):unpack()

local LibAtlas = LibStub:GetLibrary("LibAtlas")
local LibSharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local Medias = CreateFrame("Frame")

local Fonts = {
}

local StatusBar = {}
local Particles = {}

function Medias:GetLSM()
    return LibSharedMedia
end

function Medias:PushFontObject(name, adress, size, ...)
    if type(size) == 'table' then
        for _, s in ipairs(size) do
            Fonts[name..s] = CreateFont("Vorkaui" .. name .. s)
            Fonts[name..s]:SetFont(LibSharedMedia:Fetch('font', name), s, ...)
        end
    else
        Fonts[name..size] = CreateFont("Vorkaui"..name)
        Fonts[name..size]:SetFont(LibSharedMedia:Fetch('font', name), size, ...)
    end
end

function Medias:GetFont(name, partial)
    if Fonts[name] then
        return Fonts[name]
    end

    --return partial find, parse order not assured
    if partial then
        for k, v in pairs(Fonts) do
            if k:find(name) ~= nil then
                return v
            end
        end
    end

    return nil
end

function Medias:LoadFont(name, adress, size, ...)

    LibSharedMedia:Register('font', name, self.MediaPath["Fonts"] .. adress)
    self:PushFontObject(name, adress, size, ...)
end

function Medias:GetLibAtlas()
    return LibAtlas
end

function Medias:LoadAtlas(name, adress, settings)
    LibAtlas:RegisterAtlas(name, self.MediaPath["Icons"]..adress, settings)
end

function Medias:GetStatusBar(name)
    return StatusBar[name] or LibSharedMedia:Fetch('statusbar', name)
end

function Medias:LoadStatusBar(name, adress)
    LibSharedMedia:Register('statusbar', name, self.MediaPath["Textures"]..adress)
    StatusBar[name] = self.MediaPath["Textures"]..adress
end

function Medias:GetParticle(name)
    print (name, Particles[name])
    return Particles[name] or nil
end

function Medias:LoadParticle(name, adress)
    if Particles[name] then
        return
    end

    Particles[name] = self.MediaPath["Icons"]..adress
end

local function alterFont(globalName, fontName, size, flags, colors, shadow)

    local font = _G[globalName]
    if not font then
        --print ("UNABLE TO CATCH SYSTEM FONT", globalName)
        return
    end

    local address = Medias:GetFontAddress(fontName, true) or LibSharedMedia:Fetch('font', fontName)
    font:SetFont( address, size, flags )

    if colors and type(colors) == 'table' then
        font:SetTextColor(unpack(colors))
    end

    if shadow then
        font:SetShadowColor(0, 0, 0, 0.75)
        font:SetShadowOffset(2, -2)
    end

end

function Medias:ChangeSystemFonts()

    _G["STANDARD_TEXT_FONT"] = Medias:GetFontAddress('Montserrat', true)
    _G["UNIT_NAME_FONT"] = Medias:GetFontAddress('Montserrat', true)
    _G["DAMAGE_TEXT_FONT"] = Medias:GetFontAddress('Montserrat Extra Bold', true)
    _G["NAMEPLATE_FONT"] = Medias:GetFontAddress('Montserrat', true)
    _G["NAMEPLATE_SPELLCAST_FONT"] = Medias:GetFontAddress('Montserrat', true)

    alterFont('Game11Font', 'Montserrat SemiBold', 11)
    alterFont('Game11Font_o1', 'Montserrat SemiBold', 11, "OUTLINE")
    alterFont('Game12Font', 'Montserrat SemiBold', 12)
    alterFont('Game12Font_o1', 'Montserrat SemiBold', 12, "OUTLINE")
    alterFont('Game13Font', 'Montserrat', 13)
    alterFont('Game13Font_o1', 'Montserrat', 13, "OUTLINE")
    alterFont('Game13FontShadow', 'Montserrat', 13, "OUTLINE", nil, true)
    alterFont('Game15Font', 'Montserrat', 15)
    alterFont('Game15Font_o1', 'Montserrat', 15, "OUTLINE")
    alterFont('Game16Font', 'Montserrat', 16)
    alterFont('Game18Font', 'Montserrat Light', 18)
    alterFont('Game20Font', 'Montserrat Light', 20)
    alterFont('Game24Font', 'Montserrat Light', 24)
    alterFont('Game27Font', 'Montserrat Light', 27)
    alterFont('Game30Font', 'Montserrat Light', 30)
    alterFont('Game32Font', 'Montserrat Light', 32)
    alterFont('Game36Font', 'Montserrat Light', 36)
    alterFont('Game46Font', 'Montserrat Light', 46)
    alterFont('Game48Font', 'Montserrat Light', 48)
    alterFont('Game48FontShadow', 'Montserrat Light', 48, "OUTLINE", nil, true)
    alterFont('Game60Font', 'Montserrat Extra Light', 60)
    alterFont('Game72Font', 'Montserrat Extra Light', 72)
    alterFont('Game120Font', 'Montserrat Extra Light', 120)
    alterFont('GameFont_Gigantic', 'Montserrat Light', 32, "OUTLINE")

    alterFont( 'Fancy12Font', 'Montserrat Bold', 12)
    alterFont( 'Fancy14Font', 'Montserrat', 14)
    alterFont( 'Fancy16Font', 'Montserrat', 16)
    alterFont( 'Fancy18Font', 'Montserrat Light', 18)
    alterFont( 'Fancy20Font', 'Montserrat Light', 20)
    alterFont( 'Fancy22Font', 'Montserrat Light', 22)
    alterFont( 'Fancy24Font', 'Montserrat Light', 24)
    alterFont( 'Fancy27Font', 'Montserrat Light', 27)
    alterFont( 'Fancy30Font', 'Montserrat Light', 30)
    alterFont( 'Fancy32Font', 'Montserrat Light', 32)
    alterFont( 'Fancy48Font', 'Montserrat Light', 48)

    alterFont('NumberFont_GameNormal', 'Montserrat Bold Italic', 10, "OUTLINE")
    alterFont('NumberFont_Normal_Med', 'Montserrat Italic', 14, "OUTLINE")
    --Affect Keybind/Macro text
    alterFont('NumberFont_OutlineThick_Mono_Small', 'Montserrat Bold Italic', 12, "OUTLINE", nil, true)
    alterFont('NumberFont_Outline_Huge', 'Montserrat Light Italic', 30, "OUTLINE")
    alterFont('NumberFont_Outline_Large', 'Montserrat Italic', 16, "OUTLINE")
    alterFont('NumberFont_Outline_Med', 'Montserrat Italic', 14, "OUTLINE")
    alterFont('NumberFont_Shadow_Med', 'Montserrat Italic', 14, "OUTLINE")
    alterFont('NumberFont_Shadow_Small', 'Montserrat Bold Italic', 12, "OUTLINE")
    alterFont('NumberFont_Shadow_Tiny', 'Montserrat Extra Bold Italic', 10, "OUTLINE")

    alterFont('QuestFont_Enormous', 'Montserrat Light', 30, "OUTLINE")
    alterFont('QuestFont_Huge', 'Montserrat Light', 18, 'NONE')
    alterFont('QuestFont_Large', 'Montserrat', 15)
    alterFont('QuestFont_Outline_Huge', 'Montserrat Light', 18)
    alterFont('QuestFont_Shadow_Small', 'Montserrat', 14, "NONE", nil, true)
    alterFont('QuestFont_Super_Huge', 'Montserrat Light', 24)
    alterFont('QuestFont_Super_Huge_Outline', 'Montserrat Light', 24)

    alterFont('SystemFont_Huge1' ,'Montserrat Light', 20)
    alterFont('SystemFont_Huge1_Outline' ,'Montserrat Light', 20, "OUTLINE")
    alterFont('SystemFont_Huge2' ,'Montserrat Light', 24)
    alterFont('SystemFont_InverseShadow_Small' ,'Montserrat Extra Bold', 10)
    alterFont('SystemFont_Large' ,'Montserrat', 16)
    alterFont('SystemFont_LargeNamePlate' ,'Montserrat Bold', 12)
    alterFont('SystemFont_LargeNamePlateFixed' ,'Montserrat Light', 20)
    alterFont('SystemFont_Med1' ,'Montserrat Bold', 12)
    alterFont('SystemFont_Med2' ,'Montserrat', 13)
    alterFont('SystemFont_Med3' ,'Montserrat', 14)
    alterFont('SystemFont_NamePlate' ,'Montserrat Extra Bold', 9)
    alterFont('SystemFont_NamePlateCastBar' ,'Montserrat Extra Bold', 10)
    alterFont('SystemFont_NamePlateFixed' ,'Montserrat', 14)
    alterFont('SystemFont_Outline' ,'Montserrat', 13, "OUTLINE")
    alterFont('SystemFont_OutlineThick_Huge2' ,'Montserrat Light', 22, "OUTLINE")
    alterFont('SystemFont_OutlineThick_Huge4' ,'Montserrat Light', 26, "OUTLINE")
    alterFont('SystemFont_OutlineThick_WTF' ,'Montserrat Light', 32, "OUTLINE")
    alterFont('SystemFont_Outline_Small' ,'Montserrat Extra Bold', 10, "OUTLINE")
    alterFont('SystemFont_Outline_WTF2' ,'Montserrat Light', 36, "OUTLINE")
    alterFont('SystemFont_Shadow_Huge1' ,'Montserrat Light', 20, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Huge2' ,'Montserrat Light', 24, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Huge3' ,'Montserrat Light', 25, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Large' ,'Montserrat', 16, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Large2' ,'Montserrat', 18, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Large_Outline' ,'Montserrat', 16, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Med1' ,'Montserrat Bold', 12, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Med1_Outline' ,'Montserrat Bold', 12, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Med2' ,'Montserrat', 14, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Med3' ,'Montserrat', 14, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Outline_Huge2' ,'Montserrat Light', 22, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Outline_Huge3' ,'Montserrat Light', 25, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Small' ,'Montserrat Extra Bold', 10, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Small2' ,'Montserrat Extra Bold', 11, "NONE", nil, true)
    alterFont('SystemFont_Small' ,'Montserrat Extra Bold', 10)
    alterFont('SystemFont_Small2' ,'Montserrat Extra Bold', 11)
    alterFont('SystemFont_WTF2' ,'Montserrat Light', 36, "OUTLINE")
    alterFont('SystemFont_World' ,'Montserrat Extra Light', 64, "OUTLINE")
    alterFont('SystemFont_World_ThickOutline' ,'Montserrat Extra Light', 64, "OUTLINE")
    alterFont('System_IME' ,'Montserrat', 16)

    alterFont('Tooltip_Med', 'Montserrat Bold', 12)
    alterFont('Tooltip_Small', 'Montserrat', 10)

    alterFont('FriendsFont_Large', 'Montserrat', 14)
    alterFont('FriendsFont_Normal', 'Montserrat Bold', 12)
    alterFont('FriendsFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('FriendsFont_UserText', 'Montserrat Extra Bold', 11)
  
    alterFont('DestinyFontHuge', 'Montserrat Light', 32)
    alterFont('DestinyFontLarge', 'Montserrat', 18)
    alterFont('DestinyFontMed', 'Montserrat', 14)

    alterFont('AchievementFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('ChatBubbleFont', 'Montserrat Bold', 13)
    alterFont('CoreAbilityFont', 'Montserrat Light', 32)
    alterFont('GameTooltipHeader', 'Montserrat', 14)
    alterFont('InvoiceFont_Med', 'Montserrat Bold', 12)
    alterFont('InvoiceFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('MailFont_Large', 'Montserrat', 15)
    alterFont('ReputationDetailFont', 'Montserrat Extra Bold', 10)
    alterFont('SpellFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('SplashHeaderFont', 'Montserrat Light', 24)

end



V["Medias"] = Medias
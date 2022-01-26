---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by flori.
--- DateTime: 01/11/2020 22:11
---

local V,C,L = select(2,...):unpack()

local LibAtlas = LibStub:GetLibrary("LibAtlas")
local LibSharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local Module = V.Module
local Medias = Module:GetModule('Medias')

local Fonts = {
}

local StatusBar = {}
local Background = {}
local Particles = {}
local Flags = {}

function Medias:GetLSM()
    return LibSharedMedia
end

function Medias:GetParticleDropDown()
    local data = {}

    local list = LibAtlas:ListParticle()

    for _, p in ipairs(list) do
        tinsert(data, { text = p })
    end

    return data
end

function Medias:GetAtlasDropDown()
    local data = {}

    local list = LibAtlas:ListAtlas()

    for _, e in ipairs(list) do
        tinsert(data, { text = e })
    end

    return data
end

function Medias:GetLSMDropDown(mediatype)
    local data = {}

    local list = LibSharedMedia:List(mediatype)

    if #list > 20 then
        --split list
        local entry = {
            '0-9', 'A-D', 'E-H', 'I-L', 'M-P', 'Q-T', 'U-X', 'Y-Z'
        }

        for _, e in ipairs(entry) do
            tinsert(data, { text = e, menuList = {} })
        end

        local c
        for _, m in ipairs(list) do
            c = m:sub(1,1)
            if c:match("[0-9]") then
                tinsert(data[1].menuList, {text = m})
            elseif c:match("[A-Da-d]") then
                tinsert(data[2].menuList, {text = m})
            elseif c:match("[E-He-h]") then
                tinsert(data[3].menuList, {text = m})
            elseif c:match("[I-Li-l]") then
                tinsert(data[4].menuList, {text = m})
            elseif c:match("[M-Pm-p]") then
                tinsert(data[5].menuList, {text = m})
            elseif c:match("[Q-Tq-t]") then
                tinsert(data[6].menuList, {text = m})
            elseif c:match("[U-Xu-x]") then
                tinsert(data[7].menuList, {text = m})
            elseif c:match("[Y-Zy-z]") then
                tinsert(data[8].menuList, {text = m})
            end
        end
    else
        for _,m in ipairs(list) do
            tinsert(data, { text = m })
        end
    end

    return data
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

function Medias:GetFlag(name)
    return Flags[name]
end

function Medias:LoadFlag(name, adress)
    if not Flags[name] then
        Flags[name] = self.MediaPath['Icons']..adress
    end
end

function Medias:LoadAtlas(name, adress, settings)
    LibAtlas:RegisterAtlas(name, self.MediaPath["Icons"]..adress, settings)
end

function Medias:GetBackground(name)
    return Background[name] or LibSharedMedia:Fetch('background', name)
end

function Medias:GetBorder(name)
    return LibSharedMedia:Fetch('border', name)
end

function Medias:GetStatusBar(name)
    return StatusBar[name] or LibSharedMedia:Fetch('statusbar', name)
end

function Medias:LoadTexture(name, adress)
    LibSharedMedia:Register('background', name, self.MediaPath['Textures']..adress)
    Background[name] = self.MediaPath['Textures']..adress
end

function Medias:LoadStatusBar(name, adress)
    LibSharedMedia:Register('statusbar', name, self.MediaPath["Textures"]..adress)
    StatusBar[name] = self.MediaPath["Textures"]..adress
end

function Medias:GetParticle(name)
    --print (name, Particles[name])
    return LibAtlas:GetAtlas(name)
end

function Medias:LoadParticle(name, adress, settings)
    LibAtlas:RegisterAtlas(name, self.MediaPath["Icons"]..adress, settings)
end

local function alterFont(globalName, fontName, size, flags, colors, shadow)

    local font = _G[globalName]
    if not font then
        print ("UNABLE TO CATCH SYSTEM FONT", globalName)
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
    _G["DAMAGE_TEXT_FONT"] = Medias:GetFontAddress('Montserrat Italic', true)
    _G["NAMEPLATE_FONT"] = Medias:GetFontAddress('Montserrat', true)
    _G["NAMEPLATE_SPELLCAST_FONT"] = Medias:GetFontAddress('Montserrat', true)

    alterFont( 'Game10Font_o1', 'Montserrat SemiBold', 10, "OUTLINE" )
    alterFont('Game11Font', 'Montserrat SemiBold', 11)
    alterFont('Game11Font_o1', 'Montserrat SemiBold', 11, "OUTLINE")
    alterFont('Game12Font', 'Montserrat SemiBold', 12)
    alterFont('Game12Font_o1', 'Montserrat SemiBold', 12, "OUTLINE")
    alterFont('Game13Font', 'Montserrat Medium', 13)
    alterFont('Game13Font_o1', 'Montserrat Medium', 13, "OUTLINE")
    alterFont('Game13FontShadow', 'Montserrat Medium', 13, "OUTLINE", nil, true)
    alterFont('Game15Font', 'Montserrat Medium', 15)
    alterFont('Game15Font_o1', 'Montserrat Medium', 15, "OUTLINE")
    alterFont('Game16Font', 'Montserrat Medium', 16)
    alterFont( 'Game17Font_Shadow', 'Montserrat Medium', 17, "NONE", nil, true )
    alterFont('Game18Font', 'Montserrat Medium', 18)
    alterFont('Game20Font', 'Montserrat Medium', 20)
    alterFont('Game24Font', 'Montserrat Bold', 24)
    alterFont('Game27Font', 'Montserrat Bold', 27)
    alterFont('Game30Font', 'Montserrat Bold', 30)
    alterFont('Game32Font', 'Montserrat Bold', 32)
    alterFont( 'Game32Font_Shadow2', 'Montserrat Bold', 32, "NONE", nil, true )
    alterFont('Game36Font', 'Montserrat Bold', 36)
    alterFont( 'Game36Font_Shadow2', 'Montserrat Bold', 36, "NONE", nil, true )
    alterFont( 'Game40Font_Shadow2', 'Montserrat Bold', 40, "NONE", nil, true )
    alterFont( 'Game42Font', 'Montserrat Bold', 42 )
    alterFont('Game46Font', 'Montserrat Bold', 46)
    alterFont( 'Game46Font_Shadow2', 'Montserrat Bold', 46, "NONE", nil, true )
    alterFont('Game48Font', 'Montserrat Bold', 48)
    alterFont('Game48FontShadow', 'Montserrat Bold', 48, "OUTLINE", nil, true)
    alterFont( 'Game52Font_Shadow2', 'Montserrat Extra Bold', 52, "NONE", nil, true )
    alterFont( 'Game58Font_Shadow2', 'Montserrat Extra Bold', 58, "NONE", nil, true )
    alterFont('Game60Font', 'Montserrat Extra Bold', 60)
    alterFont('Game72Font', 'Montserrat Extra Bold', 72)
    alterFont( 'Game69Font_Shadow2', 'Montserrat Extra Bold', 69, "NONE", nil, true )
    alterFont( 'Game72Font_Shadow', 'Montserrat Extra Bold', 72, "NONE", nil, true )
    alterFont('Game120Font', 'Montserrat Extra Bold', 120)
    alterFont('GameFont_Gigantic', 'Montserrat Bold', 32, "OUTLINE")

    alterFont( 'Fancy12Font', 'Montserrat SemiBold', 12)
    alterFont( 'Fancy14Font', 'Montserrat Medium', 14)
    alterFont( 'Fancy16Font', 'Montserrat Medium', 16)
    alterFont( 'Fancy18Font', 'Montserrat Medium', 18)
    alterFont( 'Fancy20Font', 'Montserrat Medium', 20)
    alterFont( 'Fancy22Font', 'Montserrat Bold', 22)
    alterFont( 'Fancy24Font', 'Montserrat Bold', 24)
    alterFont( 'Fancy27Font', 'Montserrat Bold', 27)
    alterFont( 'Fancy30Font', 'Montserrat Bold', 30)
    alterFont( 'Fancy32Font', 'Montserrat Bold', 32)
    alterFont( 'Fancy48Font', 'Montserrat Bold', 48)

    alterFont( 'NumberFont_Small', 'Montserrat SemiBold', 12 )
    alterFont( 'Number11Font', 'Montserrat SemiBold', 11 )
    alterFont( 'Number12Font', 'Montserrat SemiBold', 12 )
    alterFont( 'Number12Font_o1', 'Montserrat SemiBold', 12, "OUTLINE" )
    alterFont( 'Number13Font', 'Montserrat Medium', 13 )
    alterFont( 'Number15Font', 'Montserrat Medium', 15 )
    alterFont( 'Number16Font', 'Montserrat Medium', 16 )
    alterFont( 'Number18Font', 'Montserrat Medium', 18 )
    alterFont( 'NumberFont_Shadow_Large', 'Montserrat Medium', 20, "NONE", nil, true )

    alterFont('NumberFont_GameNormal', 'Montserrat Bold Italic', 10, "OUTLINE")
    alterFont('NumberFont_Normal_Med', 'Montserrat Italic', 14, "OUTLINE")
    --Affect Keybind/Macro text
    alterFont('NumberFont_OutlineThick_Mono_Small', 'Montserrat Bold Italic', 12, "OUTLINE", nil, true)
    alterFont('NumberFont_Outline_Huge', 'Montserrat Bold Italic', 30, "OUTLINE")
    alterFont('NumberFont_Outline_Large', 'Montserrat Medium Italic', 16, "OUTLINE")
    alterFont('NumberFont_Outline_Med', 'Montserrat Medium Italic', 14, "OUTLINE")
    alterFont('NumberFont_Shadow_Med', 'Montserrat', 14)
    alterFont('NumberFont_Shadow_Small', 'Montserrat', 12)
    alterFont('NumberFont_Shadow_Tiny', 'Montserrat Bold', 10)

    alterFont( 'QuestFont_30', 'Montserrat Medium', 30)
    alterFont( 'QuestFont_39', 'Montserrat Medium', 39)
    alterFont('QuestFont_Enormous', 'Montserrat Bold', 30, "OUTLINE")
    alterFont('QuestFont_Huge', 'Montserrat Medium', 18, 'NONE')
    alterFont('QuestFont_Large', 'Montserrat Medium', 15)
    alterFont('QuestFont_Outline_Huge', 'Montserrat Medium', 18)
    alterFont('QuestFont_Shadow_Small', 'Montserrat Medium', 14, "NONE", nil, true)
    alterFont('QuestFont_Super_Huge', 'Montserrat Bold', 24)
    alterFont('QuestFont_Super_Huge_Outline', 'Montserrat Bold', 24)

    alterFont( 'System15Font', 'Montserrat Medium', 15)
    alterFont( 'SystemFont22_Outline', 'Montserrat Bold', 22, "OUTLINE")
    alterFont( 'SystemFont22_Shadow_Outline', 'Montserrat Bold', 22, "OUTLINE", nil, true)
    alterFont( 'SystemFont_Tiny', 'Montserrat Extra Bold', 9)
    alterFont( 'SystemFont_Tiny2', 'Montserrat Extra Bold', 8)
    alterFont('SystemFont_Huge1' ,'Montserrat Medium', 20)
    alterFont('SystemFont_Huge1_Outline' ,'Montserrat Medium', 20, "OUTLINE")
    alterFont('SystemFont_Huge2' ,'Montserrat Light', 24)
    alterFont('SystemFont_InverseShadow_Small' ,'Montserrat Extra Bold', 10)
    alterFont('SystemFont_Large' ,'Montserrat Medium', 16)
    alterFont('SystemFont_LargeNamePlate' ,'Montserrat Bold', 12)
    alterFont('SystemFont_LargeNamePlateFixed' ,'Montserrat Medium', 20)
    alterFont('SystemFont_Med1' ,'Montserrat Bold', 12)
    alterFont('SystemFont_Med2' ,'Montserrat Medium', 13)
    alterFont('SystemFont_Med3' ,'Montserrat Medium', 14)
    alterFont('SystemFont_NamePlate' ,'Montserrat Extra Bold', 9)
    alterFont('SystemFont_NamePlateCastBar' ,'Montserrat Extra Bold', 10)
    alterFont('SystemFont_NamePlateFixed' ,'Montserrat Medium', 14)
    alterFont('SystemFont_Outline' ,'Montserrat Medium', 13, "OUTLINE")
    alterFont('SystemFont_OutlineThick_Huge2' ,'Montserrat Bold', 22, "OUTLINE")
    alterFont('SystemFont_OutlineThick_Huge4' ,'Montserrat Bold', 26, "OUTLINE")
    alterFont('SystemFont_OutlineThick_WTF' ,'Montserrat Bold', 32, "OUTLINE")
    alterFont('SystemFont_Outline_Small' ,'Montserrat Extra Bold', 10, "OUTLINE")
    alterFont('SystemFont_Outline_WTF2' ,'Montserrat Bold', 36, "OUTLINE")
    alterFont('SystemFont_Shadow_Huge1' ,'Montserrat Bold', 20, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Huge2' ,'Montserrat Bold', 24, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Huge3' ,'Montserrat Bold', 25, "NONE", nil, true)
    alterFont( 'SystemFont_Huge4', 'Montserrat Medium', 27)
    alterFont( 'SystemFont_Shadow_Huge4', 'Montserrat Medium', 27, "NONE", nil, true)
    alterFont( 'SystemFont_Shadow_Huge4_Outline', 'Montserrat Medium', 27, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Large' ,'Montserrat Medium', 16, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Large2' ,'Montserrat Medium', 18, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Large_Outline' ,'Montserrat Medium', 16, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Med1' ,'Montserrat Bold', 12, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Med1_Outline' ,'Montserrat Bold', 12, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Med2' ,'Montserrat Medium', 14, "NONE", nil, true)
    alterFont( 'SystemFont_Shadow_Med2_Outline', 'Montserrat', 14, "OUTLINE")
    alterFont('SystemFont_Shadow_Med3' ,'Montserrat Medium', 14, "NONE", nil, true)
    alterFont( 'SystemFont_Shadow_Med3_Outline', 'Montserrat Medium', 14, "OUTLINE")
    alterFont('SystemFont_Shadow_Huge2_Outline' ,'Montserrat Bold', 22, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Outline_Huge3' ,'Montserrat Bold', 25, "OUTLINE", nil, true)
    alterFont('SystemFont_Shadow_Small' ,'Montserrat Extra Bold', 10, "NONE", nil, true)
    alterFont('SystemFont_Shadow_Small2' ,'Montserrat Extra Bold', 11, "NONE", nil, true)
    alterFont('SystemFont_Small' ,'Montserrat Extra Bold', 10)
    alterFont('SystemFont_Small2' ,'Montserrat Extra Bold', 11)
    alterFont('SystemFont_WTF2' ,'Montserrat Bold', 36, "OUTLINE")
    alterFont('SystemFont_World' ,'Montserrat Bold', 100, "OUTLINE")
    alterFont('SystemFont_World_ThickOutline' ,'Montserrat Bold', 100, "OUTLINE")
    alterFont('System_IME' ,'Montserrat Medium', 16)

    alterFont('GameTooltipHeader', 'Montserrat Bold', 14)
    alterFont('Tooltip_Med', 'Montserrat Bold', 12)
    alterFont('Tooltip_Small', 'Montserrat SemiBold', 10)

    alterFont('FriendsFont_Large', 'Montserrat Medium', 14)
    alterFont('FriendsFont_Normal', 'Montserrat Bold', 12)
    alterFont('FriendsFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('FriendsFont_UserText', 'Montserrat Extra Bold', 11)

    alterFont('DestinyFontHuge', 'Montserrat Bold', 32)
    alterFont('DestinyFontLarge', 'Montserrat Medium', 18)
    alterFont('DestinyFontMed', 'Montserrat Medium', 14)

    alterFont( 'PriceFont', 'Montserrat Medium', 14)
    alterFont('AchievementFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('ChatBubbleFont', 'Montserrat Bold', 13)
    alterFont('CoreAbilityFont', 'Montserrat Bold', 32)
    alterFont('InvoiceFont_Med', 'Montserrat Bold', 12)
    alterFont('InvoiceFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('MailFont_Large', 'Montserrat Medium', 15)
    alterFont('ReputationDetailFont', 'Montserrat Extra Bold', 10)
    alterFont('SpellFont_Small', 'Montserrat Extra Bold', 10)
    alterFont('SplashHeaderFont', 'Montserrat Bold', 24)

    alterFont('ChatFontNormal', 'Montserrat Semi Bold', 13, 'OUTLINE')
    alterFont('GameFontNormalSmall', 'Montserrat Medium', 10)
    alterFont('NumberFontNormal', 'Montserrat Extra Bold Italic', 12, 'OUTLINE')
    --GameFontNormalLarge
end
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local Medias = Module:GetModule('Medias')
local RealmFlag = Module:RegisterModule('RealmFlag', false)

local realmLocale = {
    ['Aegwynn'] = "german",
    ['AeriePeak'] = "british",
    ["Agamaggan"] = "british",
    ["Aggra(Português)"] = "portuguese",
    ["Aggramar"] = "british",
    ["Ahn'Qiraj"] = "british",
    ["Al'Akir"] = "british",
    ["Alexstrasza"] = "german",
    ["Alleria"] = "german",
    ["Alonsus"] = "british",
    ["Aman'Thul"] = "german",
    ["Ambossar"] = "german",
    ["Anachronos"] = "british",
    ["Anetheron"] = "german",
    ["Antonidas"] = "german",
    ["Anub'arak"] = "german",
    ["Arakarahm"] = "french",
    ["Arathi"] = "french",
    ["Arathor"] = "british",
    ["Archimonde"] = "french",
    ["Area52"] = "german",
    ["ArenaPass"] = "british",
    ["ArenaPass1"] = "british",
    ["ArgentDawn"] = "british",
    ["Arthas"] = "german",
    ["Arygos"] = "german",
    ["Aszune"] = "british",
    ["Auchindoun"] = "british",
    ["AzjolNerub"] = "british",
    ["Azshara"] = "german",
    ["Azuremyst"] = "british",
    ["Baelgun"] = "german",
    ["Balnazzar"] = "british",
    ["Blackhand"] = "german",
    ["Blackmoore"] = "german",
    ["Blackrock"] = "german",
    ["Blade'sEdge"] = "british",
    ["Bladefist"] = "british",
    ["Bloodfeather"] = "british",
    ["Bloodhoof"] = "british",
    ["Bloodscalp"] = "british",
    ["Blutkessel"] = "german",
    ["Boulderfist"] = "british",
    ["BronzeDragonflight"] = "british",
    ["Bronzebeard"] = "british",
    ["BurningBlade"] = "british",
    ["BurningLegion"] = "british",
    ["BurningSteppes"] = "british",
    ["C'Thun"] = "spanish",
    ["ChamberofAspects"] = "british",
    ["Chantséternels"] = "french",
    ["Cho’gall"] = "french",
    ["Cho'gall"] = "french",
    ["Chromaggus"] = "british",
    ["ColinasPardas"] = "spanish",
    ["ConfrérieduThorium"] = "french",
    ["ConseildesOmbres"] = "french",
    ["Crushridge"] = "british",
    ["CultedelaRivenoire"] = "french",
    ["Daggerspine"] = "british",
    ["Dalaran"] = "french",
    ["Dalvengyr"] = "german",
    ["DarkmoonFaire"] = "british",
    ["Darksorrow"] = "british",
    ["Darkspear"] = "british",
    ["DasKonsortium"] = "german",
    ["DasSyndikat"] = "german",
    ["Deathwing"] = "british",
    ["DefiasBrotherhood"] = "british",
    ["Dentarg"] = "british",
    ["DerMithrilorden"] = "german",
    ["DerRatvonDalaran"] = "german",
    ["DerAbyssischeRat"] = "german",
    ["Destromath"] = "german",
    ["Dethecus"] = "german",
    ["DieAldor"] = "german",
    ["DieArguswacht"] = "german",
    ["DieNachtwache"] = "german",
    ["DieSilberneHand"] = "german",
    ["DieTodeskrallen"] = "german",
    ["DieewigeWacht"] = "german",
    ["Doomhammer"] = "british",
    ["Draenor"] = "british",
    ["Dragonblight"] = "british",
    ["Dragonmaw"] = "british",
    ["Drak'thul"] = "british",
    ["Drek’Thar"] = "french",
    ["Drek'Thar"] = "french",
    ["DunModr"] = "spanish",
    ["DunMorogh"] = "german",
    ["Dunemaul"] = "british",
    ["Durotan"] = "german",
    ["EarthenRing"] = "british",
    ["Echsenkessel"] = "german",
    ["Eitrigg"] = "french",
    ["Eldre’Thalas"] = "french",
    ["Eldre'Thalas"] = "french",
    ["Elune"] = "french",
    ["EmeraldDream"] = "british",
    ["Emeriss"] = "british",
    ["Eonar"] = "british",
    ["Eredar"] = "german",
    ["EuskalEncounter"] = "spanish",
    ["Executus"] = "british",
    ["Exodar"] = "spanish",
    ["FestungderStürme"] = "german",
    ["Forscherliga"] = "german",
    ["Frostmane"] = "british",
    ["Frostmourne"] = "german",
    ["Frostwhisper"] = "british",
    ["Frostwolf"] = "german",
    ["Garona"] = "french",
    ["Garrosh"] = "german",
    ["Genjuros"] = "british",
    ["Ghostlands"] = "british",
    ["Gilneas"] = "german",
    ["Gorgonnash"] = "german",
    ["GrimBatol"] = "british",
    ["Gul'dan"] = "german",
    ["Hakkar"] = "british",
    ["Haomarush"] = "british",
    ["Hellfire"] = "british",
    ["Hellscream"] = "british",
    ["Hyjal"] = "french",
    ["Illidan"] = "french",
    ["Jaedenar"] = "british",
    ["Kael’thas"] = "french",
    ["Kael'thas"] = "french",
    ["Karazhan"] = "british",
    ["Kargath"] = "german",
    ["Kazzak"] = "british",
    ["Kel'Thuzad"] = "german",
    ["Khadgar"] = "british",
    ["Khaz'goroth"] = "german",
    ["KhazModan"] = "french",
    ["Kil'jaeden"] = "german",
    ["Kilrogg"] = "british",
    ["KirinTor"] = "french",
    ["Kor'gall"] = "british",
    ["Krag'jin"] = "german",
    ["Krasus"] = "french",
    ["KulTiras"] = "british",
    ["KultderVerdammten"] = "german",
    ["LaCroisadeécarlate"] = "french",
    ["LaughingSkull"] = "british",
    ["LesClairvoyants"] = "french",
    ["LesSentinelles"] = "french",
    ["Lightbringer"] = "british",
    ["Lightning'sBlade"] = "british",
    ["Lordaeron"] = "german",
    ["LosErrantes"] = "spanish",
    ["Lothar"] = "german",
    ["Madmortem"] = "german",
    ["Magtheridon"] = "british",
    ["Mal'Ganis"] = "german",
    ["Malfurion"] = "german",
    ["Malorne"] = "german",
    ["Malygos"] = "german",
    ["Mannoroth"] = "german",
    ["MarécagedeZangar"] = "french",
    ["Mazrigos"] = "british",
    ["Medivh"] = "french",
    ["Minahonda"] = "spanish",
    ["Moonglade"] = "british",
    ["Mug'thol"] = "german",
    ["Nagrand"] = "british",
    ["Nathrezim"] = "german",
    ["Naxxramas"] = "french",
    ["Nazjatar"] = "german",
    ["Nefarian"] = "german",
    ["Nemesis"] = "italian",
    ["Neptulon"] = "british",
    ["Ner’zhul"] = "french",
    ["Ner'zhul"] = "french",
    ["Nera'thor"] = "german",
    ["Nethersturm"] = "german",
    ["Nordrassil"] = "british",
    ["Norgannon"] = "german",
    ["Nozdormu"] = "german",
    ["Onyxia"] = "german",
    ["Outland"] = "british",
    ["Perenolde"] = "german",
    ["Pozzodell'Eternità"] = "italian",
    ["Proudmoore"] = "german",
    ["Quel'Thalas"] = "british",
    ["Ragnaros"] = "british",
    ["Rajaxx"] = "german",
    ["Rashgarroth"] = "french",
    ["Ravencrest"] = "british",
    ["Ravenholdt"] = "british",
    ["Rexxar"] = "german",
    ["Runetotem"] = "british",
    ["Sanguino"] = "spanish",
    ["Sargeras"] = "french",
    ["Saurfang"] = "british",
    ["ScarshieldLegion"] = "british",
    ["Sen'jin"] = "german",
    ["Shadowsong"] = "british",
    ["ShatteredHalls"] = "british",
    ["ShatteredHand"] = "british",
    ["Shattrath"] = "german",
    ["Shen'dralar"] = "spanish",
    ["Silvermoon"] = "british",
    ["Sinstralis"] = "french",
    ["Skullcrusher"] = "british",
    ["Spinebreaker"] = "british",
    ["Sporeggar"] = "british",
    ["SteamwheedleCartel"] = "british",
    ["Stormrage"] = "british",
    ["Stormreaver"] = "british",
    ["Stormscale"] = "british",
    ["Sunstrider"] = "british",
    ["Suramar"] = "french",
    ["Sylvanas"] = "british",
    ["Taerar"] = "german",
    ["Talnivarr"] = "british",
    ["TarrenMill"] = "british",
    ["Teldrassil"] = "german",
    ["Templenoir"] = "french",
    ["Terenas"] = "british",
    ["Terokkar"] = "british",
    ["Terrordar"] = "german",
    ["TheMaelstrom"] = "british",
    ["TheSha'tar"] = "british",
    ["TheVentureCo"] = "british",
    ["Theradras"] = "german",
    ["Thrall"] = "german",
    ["Throk’Feroth"] = "french",
    ["Throk'Feroth"] = "french",
    ["Thunderhorn"] = "british",
    ["Tichondrius"] = "german",
    ["Tirion"] = "german",
    ["Todeswache"] = "german",
    ["Trollbane"] = "british",
    ["Turalyon"] = "british",
    ["Twilight'sHammer"] = "british",
    ["TwistingNether"] = "british",
    ["Tyrande"] = "spanish",
    ["Uldaman"] = "french",
    ["Ulduar"] = "german",
    ["Uldum"] = "spanish",
    ["Un'Goro"] = "german",
    ["Varimathras"] = "french",
    ["Vashj"] = "british",
    ["Vek'lor"] = "german",
    ["Vek'nilash"] = "british",
    ["Vol’jin"] = "french",
    ["Vol'jin"] = "french",
    ["Wildhammer"] = "british",
    ["Wrathbringer"] = "german",
    ["Xavius"] = "british",
    ["Ysera"] = "german",
    ["Ysondre"] = "french",
    ["Zenedar"] = "british",
    ["ZirkeldesCenarius"] = "german",
    ["Zul'jin"] = "spanish",
    ["Zuluhed"] = "german",
    ["Азурегос"] = "russian",
    ["Борейскаятундра"] = "russian",
    ["ВечнаяПесня"] = "russian",
    ["Галакронд"] = "russian",
    ["Голдринн"] = "russian",
    ["Гордунни"] = "russian",
    ["Гром"] = "russian",
    ["Дракономор"] = "russian",
    ["Корольлич"] = "russian",
    ["Пиратскаябухта"] = "russian",
    ["Подземье"] = "russian",
    ["ПропускнаАрену1"] = "russian",
    ["Разувий"] = "russian",
    ["Ревущийфьорд"] = "russian",
    ["СвежевательДуш"] = "russian",
    ["Седогрив"] = "russian",
    ["СтражСмерти"] = "russian",
    ["Термоштепсель"] = "russian",
    ["ТкачСмерти"] = "russian",
    ["ЧерныйШрам"] = "russian",
    ["Ясеневыйлес"] = "russian",
}

function RealmFlag:GetFlagText(serverName)
    local locale = realmLocale[serverName]

    if not locale then
        return ''
    end

    local path = Medias:GetFlag(locale)
    if not path then
        return ''
    end

    return '|T'..path..':9:15|t'

end

function RealmFlag:GetFlagIcon(serverName)
    local locale = realmLocale[serverName]

    if not locale then
        return nil
    end

    return Medias:GetFlag(locale)
end

function RealmFlag:Enable()

end

function RealmFlag:Disable()

end
local V, C, L = select(2, ...):unpack()

local Editor = V.Editor
local AuraFilter = Editor.AuraFilter
local deepCopyTable = AuraFilter.DeepCopyTable

------------------------------------------------------------------------------------
-- Locales functions and tables
------------------------------------------------------------------------------------
local function AddBuff(table, spellID, priority, position, texturedIcon, color)

    if table.Whitelist == nil then
        table.Whitelist = { [spellID] = true }
        table.Position = { [spellID] = position or 0 }
        table.Priority = { [spellID] = priority or 0 }
        table.TexturedIcon = { [spellID] = texturedIcon and true }
        table.Color = { [spellID] = color or nil }
    else
        table.Whitelist[spellID] = true
        table.Position[spellID] = position or 0
        table.Priority[spellID] = priority or 0
        table.TexturedIcon[spellID] = texturedIcon and true
        table.Color[spellID] = color or nil
    end
end

local function SetDefaultAuraData(priority, position, texturedIcon, color)

    if color ~= nil then
        local r,g,b,a = unpack(color)
        color = {r,g,b,a}
    end
    return {
        ["Priority"] = priority or 0,
        ["Position"] = position or 1,
        ["TexturedIcon"] = texturedIcon or true,
        ["Color"] = color,
    }
end

local colorTable = {
    ['monk'] = { 0 / 255, 255 / 255, 150 / 255, 255 / 255 },
    ['priest'] = { 255 / 255, 255 / 255, 255 / 255, 255 / 255 },
    ['warrior'] = { 199 / 255, 156 / 255, 110 / 255, 255 / 255 },
    ['hunter'] = { 171 / 255, 212 / 255, 115 / 255, 255 / 255 },
    ['druid'] = { 255 / 255, 125 / 255, 10 / 255, 255 / 255 },
    ['warlock'] = { 148 / 255, 130 / 255, 201 / 255, 255 / 255 },
    ['dh'] = { 163 / 255, 48 / 255, 201 / 255, 255 / 255 },
    ['shaman'] = { 0 / 255, 112 / 255, 222 / 255, 255 / 255 },
    ['rogue'] = { 255 / 255, 245 / 255, 105 / 255, 255 / 255 },
    ['mage'] = { 105 / 255, 204 / 255, 240 / 255, 255 / 255 },
    ['dk'] = { 196 / 255, 31 / 255, 59 / 255, 255 / 255 },
}

local function Color(colorName)
    return colorTable[colorName] or { 1, 1, 1, 1 }
end

local function Priority(enableOverride, priorityOverride)
    return { ["enable"] = enableOverride or true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0 }
end

local function fusionTable(...)
    local result = {}
    local max = select('#', ...)
    local val
    for i = 1, max do
        val = select(i, ...)
        for spellID, data in pairs(val) do
            result[spellID] = data
        end
    end
    return result
end

local blacklist = {
    --Heroism/Lust/Warp debuff
    [57724] = true, -- Sated
    [57723] = true, -- Exhaustion
    [80354] = true, -- Temporal Displacement
    [95809] = true, -- Insanity (hunter pet heroism: ancient hysteria)
    [264689] = true, -- Fatigued
    --Mythic Keystone debuff
    [206151] = true, -- Challenger's Burden
    --Environnement buffs
    [292361] = true, -- Embrace of Pa'ku
    [186406] = true, -- Sign of the Critter
    [269083] = true, -- Enlisted
    --[]355462]= true, -- Reliquary Sight
    --[]347600]= true, -- Infused Ruby Tracking
    --[]332842]= true, -- Built for War
    --[]355794]= true, -- Worthy Trinket

    [36900] = true, -- Soul Split: Evil!
    [36901] = true, -- Soul Split: Good
    [36893] = true, -- Transporter Malfunction
    [97821] = true, -- Void-Touched
    [36032] = true, -- Arcane Charge
    [8733] = true, -- Blessing of Blackfathom
    [58539] = true, -- Watcher's Corpse
    [26013] = true, -- Deserter
    [71041] = true, -- Dungeon Deserter
    [41425] = true, -- Hypothermia
    [55711] = true, -- Weakened Heart
    [8326] = true, -- Ghost
    [23445] = true, -- Evil Twin
    [24755] = true, -- Tricked or Treated
    [25163] = true, -- Oozeling's Disgusting Aura
    [12427] = true, -- Stagger
    [12427] = true, -- Stagger
    [12427] = true, -- Stagger
    [11787] = true, -- Touch of The Titans
    [12398] = true, -- Perdition
    [15007] = true, -- Ress Sickness
    [89140] = true, -- Demonic Rebirth: Cooldown
    [28782] = true, -- Lethargy debuff (fight or flight)
    [20666] = true, -- Experience Eliminated (in range)
    [30660] = true, -- Experience Eliminated (oor - 5m)
    [34844] = true, -- Experience Eliminated
    [20615] = true, -- Challenger's Burden
    [32269] = true, -- Drained
}

local playerWhitelist = {
    -- Death Knight
    [48707] = SetDefaultAuraData(), -- Anti-Magic Shell
    [81256] = SetDefaultAuraData(), -- Dancing Rune Weapon
    [55233] = SetDefaultAuraData(), -- Vampiric Blood
    [193320] = SetDefaultAuraData(), -- Umbilicus Eternus
    [219809] = SetDefaultAuraData(), -- Tombstone
    [48792] = SetDefaultAuraData(), -- Icebound Fortitude
    [207319] = SetDefaultAuraData(), -- Corpse Shield
    [194844] = SetDefaultAuraData(), -- BoneStorm
    [145629] = SetDefaultAuraData(), -- Anti-Magic Zone
    [194679] = SetDefaultAuraData(), -- Rune Tap
    [51271] = SetDefaultAuraData(), -- Pillar of Frost
    [207256] = SetDefaultAuraData(), -- Obliteration
    [152279] = SetDefaultAuraData(), -- Breath of Sindragosa
    [233411] = SetDefaultAuraData(), -- Blood for Blood
    [212552] = SetDefaultAuraData(), -- Wraith Walk
    [215711] = SetDefaultAuraData(), -- Soul Reaper
    [194918] = SetDefaultAuraData(), -- Blighted Rune Weapon
    [48265] = SetDefaultAuraData(), -- Death's Advance
    [49039] = SetDefaultAuraData(), -- Lichborne
    [47568] = SetDefaultAuraData(), -- Empower Rune Weapon
    -- Demon Hunter
    [207811] = SetDefaultAuraData(), -- Nether Bond (DH)
    [207810] = SetDefaultAuraData(), -- Nether Bond (Target)
    [187827] = SetDefaultAuraData(), -- Metamorphosis
    [263648] = SetDefaultAuraData(), -- Soul Barrier
    [209426] = SetDefaultAuraData(), -- Darkness
    [196555] = SetDefaultAuraData(), -- Netherwalk
    [212800] = SetDefaultAuraData(), -- Blur
    [188499] = SetDefaultAuraData(), -- Blade Dance
    [203819] = SetDefaultAuraData(), -- Demon Spikes
    [206804] = SetDefaultAuraData(), -- Rain from Above
    [211510] = SetDefaultAuraData(), -- Solitude
    [162264] = SetDefaultAuraData(), -- Metamorphosis
    [205629] = SetDefaultAuraData(), -- Demonic Trample
    [188501] = SetDefaultAuraData(), -- Spectral Sight
    -- Druid
    [102342] = SetDefaultAuraData(), -- Ironbark
    [61336] = SetDefaultAuraData(), -- Survival Instincts
    [210655] = SetDefaultAuraData(), -- Protection of Ashamane
    [22812] = SetDefaultAuraData(), -- Barkskin
    [200851] = SetDefaultAuraData(), -- Rage of the Sleeper
    [234081] = SetDefaultAuraData(), -- Celestial Guardian
    [202043] = SetDefaultAuraData(), -- Protector of the Pack (it's this one or the other)
    [201940] = SetDefaultAuraData(), -- Protector of the Pack
    [201939] = SetDefaultAuraData(), -- Protector of the Pack (Allies)
    [192081] = SetDefaultAuraData(), -- Ironfur
    [29166] = SetDefaultAuraData(), -- Innervate
    [208253] = SetDefaultAuraData(), -- Essence of G'Hanir
    [194223] = SetDefaultAuraData(), -- Celestial Alignment
    [102560] = SetDefaultAuraData(), -- Incarnation: Chosen of Elune
    [102543] = SetDefaultAuraData(), -- Incarnation: King of the Jungle
    [102558] = SetDefaultAuraData(), -- Incarnation: Guardian of Ursoc
    [117679] = SetDefaultAuraData(), -- Incarnation
    [106951] = SetDefaultAuraData(), -- Berserk (Feral)
    [50334] = SetDefaultAuraData(), -- Berserk (Guardian)
    [5217] = SetDefaultAuraData(), -- Tiger's Fury
    [1850] = SetDefaultAuraData(), -- Dash
    [137452] = SetDefaultAuraData(), -- Displacer Beast
    [102416] = SetDefaultAuraData(), -- Wild Charge
    [77764] = SetDefaultAuraData(), -- Stampeding Roar (Cat)
    [77761] = SetDefaultAuraData(), -- Stampeding Roar (Bear)
    [305497] = SetDefaultAuraData(), -- Thorns
    [233756] = SetDefaultAuraData(), -- Moon and Stars (not used?)
    [234084] = SetDefaultAuraData(), -- Moon and Stars (PvP)
    [22842] = SetDefaultAuraData(), -- Frenzied Regeneration
    -- Hunter
    [186265] = SetDefaultAuraData(), -- Aspect of the Turtle
    [53480] = SetDefaultAuraData(), -- Roar of Sacrifice
    [202748] = SetDefaultAuraData(), -- Survival Tactics
    [62305] = SetDefaultAuraData(), -- Master's Call (it's this one or the other)
    [54216] = SetDefaultAuraData(), -- Master's Call
    [288613] = SetDefaultAuraData(), -- Trueshot
    [193530] = SetDefaultAuraData(), -- Aspect of the Wild
    [19574] = SetDefaultAuraData(), -- Bestial Wrath
    [186289] = SetDefaultAuraData(), -- Aspect of the Eagle
    [186257] = SetDefaultAuraData(), -- Aspect of the Cheetah
    [118922] = SetDefaultAuraData(), -- Posthaste
    [90355] = SetDefaultAuraData(), -- Ancient Hysteria (Pet)
    [160452] = SetDefaultAuraData(), -- Netherwinds (Pet)
    [266779] = SetDefaultAuraData(), -- Coordinated Assault
    -- Mage
    [45438] = SetDefaultAuraData(), -- Ice Block
    [113862] = SetDefaultAuraData(), -- Greater Invisibility
    [198111] = SetDefaultAuraData(), -- Temporal Shield
    [198065] = SetDefaultAuraData(), -- Prismatic Cloak
    [11426] = SetDefaultAuraData(), -- Ice Barrier
    [190319] = SetDefaultAuraData(), -- Combustion
    [80353] = SetDefaultAuraData(), -- Time Warp
    [12472] = SetDefaultAuraData(), -- Icy Veins
    [12042] = SetDefaultAuraData(), -- Arcane Power
    [116014] = SetDefaultAuraData(), -- Rune of Power
    [198144] = SetDefaultAuraData(), -- Ice Form
    [108839] = SetDefaultAuraData(), -- Ice Floes
    [205025] = SetDefaultAuraData(), -- Presence of Mind
    [198158] = SetDefaultAuraData(), -- Mass Invisibility
    [221404] = SetDefaultAuraData(), -- Burning Determination
    [110909] = SetDefaultAuraData(), -- Alter Time
    -- Monk
    [122783] = SetDefaultAuraData(), -- Diffuse Magic
    [122278] = SetDefaultAuraData(), -- Dampen Harm
    [125174] = SetDefaultAuraData(), -- Touch of Karma
    [201318] = SetDefaultAuraData(), -- Fortifying Elixir
    [201325] = SetDefaultAuraData(), -- Zen Moment
    [202248] = SetDefaultAuraData(), -- Guided Meditation
    [120954] = SetDefaultAuraData(), -- Fortifying Brew
    [116849] = SetDefaultAuraData(), -- Life Cocoon
    [202162] = SetDefaultAuraData(), -- Guard
    [215479] = SetDefaultAuraData(), -- Ironskin Brew
    [152173] = SetDefaultAuraData(), -- Serenity
    [137639] = SetDefaultAuraData(), -- Storm, Earth, and Fire
    [216113] = SetDefaultAuraData(), -- Way of the Crane
    [213664] = SetDefaultAuraData(), -- Nimble Brew
    [201447] = SetDefaultAuraData(), -- Ride the Wind
    [195381] = SetDefaultAuraData(), -- Healing Winds
    [116841] = SetDefaultAuraData(), -- Tiger's Lust
    [119085] = SetDefaultAuraData(), -- Chi Torpedo
    [199407] = SetDefaultAuraData(), -- Light on Your Feet
    [209584] = SetDefaultAuraData(), -- Zen Focus Tea
    -- Paladin
    [642] = SetDefaultAuraData(), -- Divine Shield
    [498] = SetDefaultAuraData(), -- Divine Protection
    [205191] = SetDefaultAuraData(), -- Eye for an Eye
    [184662] = SetDefaultAuraData(), -- Shield of Vengeance
    [1022] = SetDefaultAuraData(), -- Blessing of Protection
    [6940] = SetDefaultAuraData(), -- Blessing of Sacrifice
    [204018] = SetDefaultAuraData(), -- Blessing of Spellwarding
    [199507] = SetDefaultAuraData(), -- Spreading The Word: Protection
    [216857] = SetDefaultAuraData(), -- Guarded by the Light
    [228049] = SetDefaultAuraData(), -- Guardian of the Forgotten Queen
    [31850] = SetDefaultAuraData(), -- Ardent Defender
    [86659] = SetDefaultAuraData(), -- Guardian of Ancien Kings
    [212641] = SetDefaultAuraData(), -- Guardian of Ancien Kings (Glyph of the Queen)
    [209388] = SetDefaultAuraData(), -- Bulwark of Order
    [204335] = SetDefaultAuraData(), -- Aegis of Light
    [152262] = SetDefaultAuraData(), -- Seraphim
    [132403] = SetDefaultAuraData(), -- Shield of the Righteous
    [31884] = SetDefaultAuraData(), -- Avenging Wrath
    [105809] = SetDefaultAuraData(), -- Holy Avenger
    [231895] = SetDefaultAuraData(), -- Crusade
    [200652] = SetDefaultAuraData(), -- Tyr's Deliverance
    [216331] = SetDefaultAuraData(), -- Avenging Crusader
    [1044] = SetDefaultAuraData(), -- Blessing of Freedom
    [210256] = SetDefaultAuraData(), -- Blessing of Sanctuary
    [199545] = SetDefaultAuraData(), -- Steed of Glory
    [210294] = SetDefaultAuraData(), -- Divine Favor
    [221886] = SetDefaultAuraData(), -- Divine Steed
    [31821] = SetDefaultAuraData(), -- Aura Mastery
    [203538] = SetDefaultAuraData(), -- Greater Blessing of Kings
    [203539] = SetDefaultAuraData(), -- Greater Blessing of Wisdom
    -- Priest
    [81782] = SetDefaultAuraData(), -- Power Word: Barrier
    [47585] = SetDefaultAuraData(), -- Dispersion
    [19236] = SetDefaultAuraData(), -- Desperate Prayer
    [213602] = SetDefaultAuraData(), -- Greater Fade
    [27827] = SetDefaultAuraData(), -- Spirit of Redemption
    [197268] = SetDefaultAuraData(), -- Ray of Hope
    [47788] = SetDefaultAuraData(), -- Guardian Spirit
    [33206] = SetDefaultAuraData(), -- Pain Suppression
    [200183] = SetDefaultAuraData(), -- Apotheosis
    [10060] = SetDefaultAuraData(), -- Power Infusion
    [47536] = SetDefaultAuraData(), -- Rapture
    [194249] = SetDefaultAuraData(), -- Voidform
    [193223] = SetDefaultAuraData(), -- Surrdender to Madness
    [197862] = SetDefaultAuraData(), -- Archangel
    [197871] = SetDefaultAuraData(), -- Dark Archangel
    [197874] = SetDefaultAuraData(), -- Dark Archangel
    [215769] = SetDefaultAuraData(), -- Spirit of Redemption
    [213610] = SetDefaultAuraData(), -- Holy Ward
    [121557] = SetDefaultAuraData(), -- Angelic Feather
    [214121] = SetDefaultAuraData(), -- Body and Mind
    [65081] = SetDefaultAuraData(), -- Body and Soul
    [197767] = SetDefaultAuraData(), -- Speed of the Pious
    [210980] = SetDefaultAuraData(), -- Focus in the Light
    [221660] = SetDefaultAuraData(), -- Holy Concentration
    [15286] = SetDefaultAuraData(), -- Vampiric Embrace
    -- Rogue
    [5277] = SetDefaultAuraData(), -- Evasion
    [31224] = SetDefaultAuraData(), -- Cloak of Shadows
    [1966] = SetDefaultAuraData(), -- Feint
    [199754] = SetDefaultAuraData(), -- Riposte
    [45182] = SetDefaultAuraData(), -- Cheating Death
    [199027] = SetDefaultAuraData(), -- Veil of Midnight
    [121471] = SetDefaultAuraData(), -- Shadow Blades
    [13750] = SetDefaultAuraData(), -- Adrenaline Rush
    [51690] = SetDefaultAuraData(), -- Killing Spree
    [185422] = SetDefaultAuraData(), -- Shadow Dance
    [198368] = SetDefaultAuraData(), -- Take Your Cut
    [198027] = SetDefaultAuraData(), -- Turn the Tables
    [213985] = SetDefaultAuraData(), -- Thief's Bargain
    [197003] = SetDefaultAuraData(), -- Maneuverability
    [212198] = SetDefaultAuraData(), -- Crimson Vial
    [185311] = SetDefaultAuraData(), -- Crimson Vial
    [209754] = SetDefaultAuraData(), -- Boarding Party
    [36554] = SetDefaultAuraData(), -- Shadowstep
    [2983] = SetDefaultAuraData(), -- Sprint
    [202665] = SetDefaultAuraData(), -- Curse of the Dreadblades (Self Debuff)
    -- Shaman
    [204293] = SetDefaultAuraData(), -- Spirit Link
    [204288] = SetDefaultAuraData(), -- Earth Shield
    [210918] = SetDefaultAuraData(), -- Ethereal Form
    [207654] = SetDefaultAuraData(), -- Servant of the Queen
    [108271] = SetDefaultAuraData(), -- Astral Shift
    [98007] = SetDefaultAuraData(), -- Spirit Link Totem
    [207498] = SetDefaultAuraData(), -- Ancestral Protection
    [204366] = SetDefaultAuraData(), -- Thundercharge
    [209385] = SetDefaultAuraData(), -- Windfury Totem
    [208963] = SetDefaultAuraData(), -- Skyfury Totem
    [204945] = SetDefaultAuraData(), -- Doom Winds
    [205495] = SetDefaultAuraData(), -- Stormkeeper
    [208416] = SetDefaultAuraData(), -- Sense of Urgency
    [2825] = SetDefaultAuraData(), -- Bloodlust
    [16166] = SetDefaultAuraData(), -- Elemental Mastery
    [167204] = SetDefaultAuraData(), -- Feral Spirit
    [114050] = SetDefaultAuraData(), -- Ascendance (Elem)
    [114051] = SetDefaultAuraData(), -- Ascendance (Enh)
    [114052] = SetDefaultAuraData(), -- Ascendance (Resto)
    [79206] = SetDefaultAuraData(), -- Spiritwalker's Grace
    [58875] = SetDefaultAuraData(), -- Spirit Walk
    [157384] = SetDefaultAuraData(), -- Eye of the Storm
    [192082] = SetDefaultAuraData(), -- Wind Rush
    [2645] = SetDefaultAuraData(), -- Ghost Wolf
    [32182] = SetDefaultAuraData(), -- Heroism
    [108281] = SetDefaultAuraData(), -- Ancestral Guidance
    -- Warlock
    [108416] = SetDefaultAuraData(), -- Dark Pact
    [113860] = SetDefaultAuraData(), -- Dark Soul: Misery
    [104773] = SetDefaultAuraData(), -- Unending Resolve
    [221715] = SetDefaultAuraData(), -- Essence Drain
    [212295] = SetDefaultAuraData(), -- Nether Ward
    [212284] = SetDefaultAuraData(), -- Firestone
    [196098] = SetDefaultAuraData(), -- Soul Harvest
    [221705] = SetDefaultAuraData(), -- Casting Circle
    [111400] = SetDefaultAuraData(), -- Burning Rush
    [196674] = SetDefaultAuraData(), -- Planeswalker
    -- Warrior
    [118038] = SetDefaultAuraData(), -- Die by the Sword
    [184364] = SetDefaultAuraData(), -- Enraged Regeneration
    [209484] = SetDefaultAuraData(), -- Tactical Advance
    [97463] = SetDefaultAuraData(), -- Commanding Shout
    [213915] = SetDefaultAuraData(), -- Mass Spell Reflection
    [199038] = SetDefaultAuraData(), -- Leave No Man Behind
    [223658] = SetDefaultAuraData(), -- Safeguard
    [147833] = SetDefaultAuraData(), -- Intervene
    [198760] = SetDefaultAuraData(), -- Intercept
    [12975] = SetDefaultAuraData(), -- Last Stand
    [871] = SetDefaultAuraData(), -- Shield Wall
    [23920] = SetDefaultAuraData(), -- Spell Reflection
    [216890] = SetDefaultAuraData(), -- Spell Reflection (PvPT)
    [227744] = SetDefaultAuraData(), -- Ravager
    [203524] = SetDefaultAuraData(), -- Neltharion's Fury
    [190456] = SetDefaultAuraData(), -- Ignore Pain
    [132404] = SetDefaultAuraData(), -- Shield Block
    [1719] = SetDefaultAuraData(), -- Battle Cry
    [107574] = SetDefaultAuraData(), -- Avatar
    [227847] = SetDefaultAuraData(), -- Bladestorm (Arm)
    [46924] = SetDefaultAuraData(), -- Bladestorm (Fury)
    [12292] = SetDefaultAuraData(), -- Bloodbath
    [118000] = SetDefaultAuraData(), -- Dragon Roar
    [199261] = SetDefaultAuraData(), -- Death Wish
    [18499] = SetDefaultAuraData(), -- Berserker Rage
    [202164] = SetDefaultAuraData(), -- Bounding Stride
    [215572] = SetDefaultAuraData(), -- Frothing Berserker
    [199203] = SetDefaultAuraData(), -- Thirst for Battle
    -- Racials
    [65116] = SetDefaultAuraData(), -- Stoneform
    [59547] = SetDefaultAuraData(), -- Gift of the Naaru
    [20572] = SetDefaultAuraData(), -- Blood Fury
    [26297] = SetDefaultAuraData(), -- Berserking
    [68992] = SetDefaultAuraData(), -- Darkflight
    [58984] = SetDefaultAuraData(), -- Shadowmeld
    -- Consumables
    [251231] = SetDefaultAuraData(), -- Steelskin Potion (BfA Armor)
    [251316] = SetDefaultAuraData(), -- Potion of Bursting Blood (BfA Melee)
    [269853] = SetDefaultAuraData(), -- Potion of Rising Death (BfA Caster)
    [279151] = SetDefaultAuraData(), -- Battle Potion of Intellect (BfA Intellect)
    [279152] = SetDefaultAuraData(), -- Battle Potion of Agility (BfA Agility)
    [279153] = SetDefaultAuraData(), -- Battle Potion of Strength (BfA Strength)
    [178207] = SetDefaultAuraData(), -- Drums of Fury
    [230935] = SetDefaultAuraData(), -- Drums of the Mountain (Legion)
    [256740] = SetDefaultAuraData(), -- Drums of the Maelstrom (BfA)
    [298155] = SetDefaultAuraData(), -- Superior Steelskin Potion
    [298152] = SetDefaultAuraData(), -- Superior Battle Potion of Intellect
    [298146] = SetDefaultAuraData(), -- Superior Battle Potion of Agility
    [298154] = SetDefaultAuraData(), -- Superior Battle Potion of Strength
    [298153] = SetDefaultAuraData(), -- Superior Battle Potion of Stamina
    [298836] = SetDefaultAuraData(), -- Greater Flask of the Currents
    [298837] = SetDefaultAuraData(), -- Greater Flask of Endless Fathoms
    [298839] = SetDefaultAuraData(), -- Greater Flask of the Vast Horizon
    [298841] = SetDefaultAuraData(), -- Greater Flask of the Undertow
    -- Shadowlands Consumables
    [307159] = SetDefaultAuraData(), -- Potion of Spectral Agility
    [307160] = SetDefaultAuraData(), -- Potion of Hardened Shadows
    [307161] = SetDefaultAuraData(), -- Potion of Spiritual Clarity
    [307162] = SetDefaultAuraData(), -- Potion of Spectral Intellect
    [307163] = SetDefaultAuraData(), -- Potion of Spectral Stamina
    [307164] = SetDefaultAuraData(), -- Potion of Spectral Strength
    [307165] = SetDefaultAuraData(), -- Spiritual Anti-Venom
    [307185] = SetDefaultAuraData(), -- Spectral Flask of Power
    [307187] = SetDefaultAuraData(), -- Spectral Flask of Stamina
    [307195] = SetDefaultAuraData(), -- Potion of Hidden Spirit
    [307196] = SetDefaultAuraData(), -- Potion of Shaded Sight
    [307199] = SetDefaultAuraData(), -- Potion of Soul Purity
    [307494] = SetDefaultAuraData(), -- Potion of Empowered Exorcisms
    [307495] = SetDefaultAuraData(), -- Potion of Phantom Fire
    [307496] = SetDefaultAuraData(), -- Potion of Divine Awakening
    [307497] = SetDefaultAuraData(), -- Potion of Deathly Fixation
    [307501] = SetDefaultAuraData(), -- Potion of Specter Swiftness
    [308397] = SetDefaultAuraData(), -- Butterscotch Marinated Ribs
    [308402] = SetDefaultAuraData(), -- Surprisingly Palatable Feast
    [308404] = SetDefaultAuraData(), -- Cinnamon Bonefish Stew
    [308412] = SetDefaultAuraData(), -- Meaty Apple Dumplings
    [308425] = SetDefaultAuraData(), -- Sweet Silvergrill Sausages
    [308434] = SetDefaultAuraData(), -- Phantasmal Souffle and Fries
    [308488] = SetDefaultAuraData(), -- Tenebrous Crown Roast Aspic
    [308506] = SetDefaultAuraData(), -- Crawler Ravioli with Apple Sauce
    [308514] = SetDefaultAuraData(), -- Steak a la Mode
    [308525] = SetDefaultAuraData(), -- Banana Beef Pudding
    [308637] = SetDefaultAuraData(), -- Smothered Shank
    [322302] = SetDefaultAuraData(), -- Potion of Sacrificial Anima
    [327708] = SetDefaultAuraData(), -- Feast of Gluttonous Hedonism
    [327715] = SetDefaultAuraData(), -- Fried Bonefish
    [327851] = SetDefaultAuraData(), -- Seraph Tenders
}

local defensiveWhitelist = {
    --DK
    [48707] = SetDefaultAuraData(2, 1), -- Anti-Magic Shell
    [81256] = SetDefaultAuraData(2, 2), -- Dancing Rune Weapon
    [55233] = SetDefaultAuraData(2, 2), -- Vampiric Blood
    [193320] = SetDefaultAuraData(2, 3), -- Umbilicus Eternus
    [219809] = SetDefaultAuraData(2, 3), -- Tombstone
    [48792] = SetDefaultAuraData(2, 2), -- Icebound Fortitude
    [207319] = SetDefaultAuraData(2, 3), -- Corpse Shield
    [194844] = SetDefaultAuraData(2, 4), -- BoneStorm
    [145629] = SetDefaultAuraData(3, 1), -- Anti-Magic Zone
    [194679] = SetDefaultAuraData(2, 4), -- Rune Tap
    --DH
    [187827] = SetDefaultAuraData(2, 1), -- Metamorphosis
    [263648] = SetDefaultAuraData(2, 2), -- Soul Barrier
    [209426] = SetDefaultAuraData(3, 1), -- Darkness
    [196555] = SetDefaultAuraData(10, 1), -- Netherwalk
    [212800] = SetDefaultAuraData(4, 1), -- Blur
    [203819] = SetDefaultAuraData(2, 2), -- Demon Spikes
    --Druid
    [61336] = SetDefaultAuraData(4, 2), -- Survival Instincts
    [210655] = SetDefaultAuraData(2, 2), -- Protection of Ashamane
    [22812] = SetDefaultAuraData(3, 2), -- Barkskin
    [192081] = SetDefaultAuraData(3, 1), -- Ironfur
    [102558] = SetDefaultAuraData(2, 4), -- Incarnation: Guardian of Ursoc
    [22842] = SetDefaultAuraData(2, 3), -- Frenzied Regeneration
    --Hunter
    [186265] = SetDefaultAuraData(10, 1), -- Aspect of the Turtle
    -- Mage
    [45438] = SetDefaultAuraData(10, 1), -- Ice Block
    [110909] = SetDefaultAuraData(3, 1), -- Alter Time
    -- Monk
    [122783] = SetDefaultAuraData(5, 1), -- Diffuse Magic
    [122278] = SetDefaultAuraData(5, 1), -- Dampen Harm
    [125174] = SetDefaultAuraData(5, 1), -- Touch of Karma
    [201318] = SetDefaultAuraData(3, 2), -- Fortifying Elixir
    [201325] = SetDefaultAuraData(3, 1), -- Zen Moment
    [202248] = SetDefaultAuraData(3, 1), -- Guided Meditation
    [120954] = SetDefaultAuraData(4, 2), -- Fortifying Brew
    [202162] = SetDefaultAuraData(3, 1), -- Guard
    [215479] = SetDefaultAuraData(2, 1), -- Ironskin Brew
    -- Paladin
    [642] = SetDefaultAuraData(10, 1), -- Divine Shield
    [498] = SetDefaultAuraData(4, 1), -- Divine Protection
    [184662] = SetDefaultAuraData(3, 1), -- Shield of Vengeance
    [1022] = SetDefaultAuraData(4, 1), -- Blessing of Protection
    [6940] = SetDefaultAuraData(5, 2), -- Blessing of Sacrifice
    [204018] = SetDefaultAuraData(5, 1), -- Blessing of Spellwarding
    [31850] = SetDefaultAuraData(4, 1), -- Ardent Defender
    [86659] = SetDefaultAuraData(4, 2), -- Guardian of Ancien Kings
    [212641] = SetDefaultAuraData(4, 2), -- Guardian of Ancien Kings (Glyph of the Queen)
    [31821] = SetDefaultAuraData(5, 3), -- Aura Mastery
    [1044] = SetDefaultAuraData(2, 1), -- Blessing of Freedom
    -- Priest
    [47585] = SetDefaultAuraData(5, 1), -- Dispersion
    [62618] = SetDefaultAuraData(5, 2), -- Power Word: Barrier
    -- Rogue
    [5277] = SetDefaultAuraData(5, 1), -- Evasion
    [31224] = SetDefaultAuraData(5, 2), -- Cloak of Shadows
    [1966] = SetDefaultAuraData(3, 1), -- Feint
    [199754] = SetDefaultAuraData(5, 1), -- Riposte
    -- Shaman
    [108271] = SetDefaultAuraData(3, 1), -- Astral Shift
    [98008] = SetDefaultAuraData(5, 1), -- Spirit Link Totem
    [20608] = SetDefaultAuraData(5, 1), -- Reincarnation
    -- Warlock
    [108416] = SetDefaultAuraData(2, 1), -- Dark Pact
    [104773] = SetDefaultAuraData(4, 1), -- Unending Resolve
    -- Warrior
    [118038] = SetDefaultAuraData(4, 1), -- Die by the Sword
    [184364] = SetDefaultAuraData(3, 2), -- Enraged Regeneration
    [213915] = SetDefaultAuraData(5, 1), -- Mass Spell Reflection
    [12975] = SetDefaultAuraData(5, 2), -- Last Stand
    [871] = SetDefaultAuraData(5, 1), -- Shield Wall
    [23920] = SetDefaultAuraData(4, 2), -- Spell Reflection
    [216890] = SetDefaultAuraData(4, 2), -- Spell Reflection (PvPT)
    [190456] = SetDefaultAuraData(5, 3), -- Ignore Pain
    [132404] = SetDefaultAuraData(5, 4), -- Shield Block
    [97462] = SetDefaultAuraData(5, 1), -- Rallying Cry
}

local externalWhitelist = {
    [102342] = SetDefaultAuraData(8, 1), -- Iron Bark
    [116849] = SetDefaultAuraData(8, 1), -- Life Cocoon
    [1022] = SetDefaultAuraData(8, 1), -- Blessing of Protection
    [6940] = SetDefaultAuraData(8, 1), -- Blessing of Sacrifice
    [204018] = SetDefaultAuraData(8, 1), -- Blessing of spellwarding
    [47788] = SetDefaultAuraData(8, 1), -- Guardian Spirit
    [33206] = SetDefaultAuraData(8, 1), -- Pain Suppression
    [207399] = SetDefaultAuraData(8, 1), -- Ancestral Protection Totem
    [3411] = SetDefaultAuraData(8, 1), -- Intervene
}

local healWhitelist = {
    --Priest
    [139] = SetDefaultAuraData(1, 3, true, Color('dk')), -- Renew
    [17] = SetDefaultAuraData(1, 2, true, Color('druid')), -- Shield
    [194384] = SetDefaultAuraData(1, 1, true, Color('dh')), -- Atonement
    [214206] = SetDefaultAuraData(1, 1, true, Color('dh')), -- Atonement(PVP)
    --Druid
    [774] = SetDefaultAuraData(2, 1, true, Color('dh')), -- Rejuv
    --[155777] = SetDefaultAuraData(1, 1, true, Color('dh')), -- Germination
    [8936] = SetDefaultAuraData(2, 2, true, Color('druid')), -- Regrowth
    [33763] = SetDefaultAuraData(2, 3, true, Color('dk')), -- Lifebloom
    [188550] = SetDefaultAuraData(2, 3, true, Color('dk')), -- Lifebloom (SL leg)
    [48438] = SetDefaultAuraData(2, 4, true, Color('shaman')), -- Wild Growth
    --[207386] = SetDefaultAuraData(1, 1, true, Color('dh')), -- Spring Blossom
    [102351] = SetDefaultAuraData(2, 5, true, Color('warlock')), -- Cenarion Ward
    [102352] = SetDefaultAuraData(2, 5, true, Color('warlock')), -- Cenarion Ward
    --[200389] = SetDefaultAuraData(1, 2, true, Color('rogue')), -- Cultivation
    --[203554] = SetDefaultAuraData(2, 4, true, Color('shaman')), -- Focused Growth
    --Paladin
    [53563] = SetDefaultAuraData(2, 1, true, Color('dh')), -- Beacon of Light
    [156910] = SetDefaultAuraData(2, 1, true, Color('dh')), -- Beacon of Faith
    [200025] = SetDefaultAuraData(2, 1, true, Color('dh')), -- Beacon of Virtue
    [223306] = SetDefaultAuraData(2, 2, true, Color('druid')), -- Bestow Faith
    [287280] = SetDefaultAuraData(2, 3, true, Color('dk')), -- Glimmer of Light
    [157047] = SetDefaultAuraData(2, 4, true, Color('shaman')), -- Saved by the Light
    --Shaman
    [61295] = SetDefaultAuraData(2, 2, true, Color('druid')), -- Riptide
    [974] = SetDefaultAuraData(2, 1, true, Color('dh')), -- Earth Shield
    --Monk
    [119611] = SetDefaultAuraData(2, 1, true, Color('dh')), -- Renewing Mist
    [124682] = SetDefaultAuraData(2, 2, true, Color('druid')), -- Enveloping Mist
    [191840] = SetDefaultAuraData(2, 3, true, Color('dk')), -- Essence Font
    [325209] = SetDefaultAuraData(2, 4, true, Color('shaman')), -- Enveloping Breath
}

local pveDebuff = {
    -- Mythic+ Dungeons
    -- General Affix
    [209858] = SetDefaultAuraData(5, 1), -- Necrotic
    [226512] = SetDefaultAuraData(), -- Sanguine
    [240559] = SetDefaultAuraData(5, 1), -- Grievous
    [240443] = SetDefaultAuraData(5, 1), -- Bursting
    -- Shadowlands Affix
    [342494] = SetDefaultAuraData(), -- Belligerent Boast (Prideful)

    -- Shadowlands Dungeons
    -- Halls of Atonement
    [335338] = SetDefaultAuraData(), -- Ritual of Woe
    [326891] = SetDefaultAuraData(), -- Anguish
    [329321] = SetDefaultAuraData(), -- Jagged Swipe 1
    [344993] = SetDefaultAuraData(), -- Jagged Swipe 2
    [319603] = SetDefaultAuraData(), -- Curse of Stone
    [319611] = SetDefaultAuraData(), -- Turned to Stone
    [325876] = SetDefaultAuraData(), -- Curse of Obliteration
    [326632] = SetDefaultAuraData(), -- Stony Veins
    [323650] = SetDefaultAuraData(), -- Haunting Fixation
    [326874] = SetDefaultAuraData(), -- Ankle Bites
    [340446] = SetDefaultAuraData(), -- Mark of Envy
    -- Mists of Tirna Scithe
    [325027] = SetDefaultAuraData(), -- Bramble Burst
    [323043] = SetDefaultAuraData(), -- Bloodletting
    [322557] = SetDefaultAuraData(), -- Soul Split
    [331172] = SetDefaultAuraData(), -- Mind Link
    [322563] = SetDefaultAuraData(), -- Marked Prey
    [322487] = SetDefaultAuraData(), -- Overgrowth 1
    [322486] = SetDefaultAuraData(), -- Overgrowth 2
    [328756] = SetDefaultAuraData(), -- Repulsive Visage
    [325021] = SetDefaultAuraData(), -- Mistveil Tear
    [321891] = SetDefaultAuraData(), -- Freeze Tag Fixation
    [325224] = SetDefaultAuraData(), -- Anima Injection
    [326092] = SetDefaultAuraData(), -- Debilitating Poison
    [325418] = SetDefaultAuraData(), -- Volatile Acid
    -- Plaguefall
    [336258] = SetDefaultAuraData(), -- Solitary Prey
    [331818] = SetDefaultAuraData(), -- Shadow Ambush
    [329110] = SetDefaultAuraData(), -- Slime Injection
    [325552] = SetDefaultAuraData(), -- Cytotoxic Slash
    [336301] = SetDefaultAuraData(), -- Web Wrap
    [322358] = SetDefaultAuraData(), -- Burning Strain
    [322410] = SetDefaultAuraData(), -- Withering Filth
    [328180] = SetDefaultAuraData(), -- Gripping Infection
    [320542] = SetDefaultAuraData(), -- Wasting Blight
    [340355] = SetDefaultAuraData(), -- Rapid Infection
    [328395] = SetDefaultAuraData(), -- Venompiercer
    [320512] = SetDefaultAuraData(), -- Corroded Claws
    [333406] = SetDefaultAuraData(), -- Assassinate
    [332397] = SetDefaultAuraData(), -- Shroudweb
    [330069] = SetDefaultAuraData(), -- Concentrated Plague
    -- The Necrotic Wake
    [321821] = SetDefaultAuraData(), -- Disgusting Guts
    [323365] = SetDefaultAuraData(), -- Clinging Darkness
    [338353] = SetDefaultAuraData(), -- Goresplatter
    [333485] = SetDefaultAuraData(), -- Disease Cloud
    [338357] = SetDefaultAuraData(), -- Tenderize
    [328181] = SetDefaultAuraData(), -- Frigid Cold
    [320170] = SetDefaultAuraData(), -- Necrotic Bolt
    [323464] = SetDefaultAuraData(), -- Dark Ichor
    [323198] = SetDefaultAuraData(), -- Dark Exile
    [343504] = SetDefaultAuraData(), -- Dark Grasp
    [343556] = SetDefaultAuraData(), -- Morbid Fixation 1
    [338606] = SetDefaultAuraData(), -- Morbid Fixation 2
    [324381] = SetDefaultAuraData(), -- Chill Scythe
    [320573] = SetDefaultAuraData(), -- Shadow Well
    [333492] = SetDefaultAuraData(), -- Necrotic Ichor
    [334748] = SetDefaultAuraData(), -- Drain FLuids
    [333489] = SetDefaultAuraData(), -- Necrotic Breath
    [320717] = SetDefaultAuraData(), -- Blood Hunger
    -- Theater of Pain
    [333299] = SetDefaultAuraData(), -- Curse of Desolation 1
    [333301] = SetDefaultAuraData(), -- Curse of Desolation 2
    [319539] = SetDefaultAuraData(), -- Soulless
    [326892] = SetDefaultAuraData(), -- Fixate
    [321768] = SetDefaultAuraData(), -- On the Hook
    [323825] = SetDefaultAuraData(), -- Grasping Rift
    [342675] = SetDefaultAuraData(), -- Bone Spear
    [323831] = SetDefaultAuraData(), -- Death Grasp
    [330608] = SetDefaultAuraData(), -- Vile Eruption
    [330868] = SetDefaultAuraData(), -- Necrotic Bolt Volley
    [323750] = SetDefaultAuraData(), -- Vile Gas
    [323406] = SetDefaultAuraData(), -- Jagged Gash
    [330700] = SetDefaultAuraData(), -- Decaying Blight
    [319626] = SetDefaultAuraData(), -- Phantasmal Parasite
    [324449] = SetDefaultAuraData(), -- Manifest Death
    [341949] = SetDefaultAuraData(), -- Withering Blight
    -- Sanguine Depths
    [326827] = SetDefaultAuraData(), -- Dread Bindings
    [326836] = SetDefaultAuraData(), -- Curse of Suppression
    [322554] = SetDefaultAuraData(), -- Castigate
    [321038] = SetDefaultAuraData(), -- Burden Soul
    [328593] = SetDefaultAuraData(), -- Agonize
    [325254] = SetDefaultAuraData(), -- Iron Spikes
    [335306] = SetDefaultAuraData(), -- Barbed Shackles
    [322429] = SetDefaultAuraData(), -- Severing Slice
    [334653] = SetDefaultAuraData(), -- Engorge
    -- Spires of Ascension
    [338729] = SetDefaultAuraData(), -- Charged Stomp
    [338747] = SetDefaultAuraData(), -- Purifying Blast
    [327481] = SetDefaultAuraData(), -- Dark Lance
    [322818] = SetDefaultAuraData(), -- Lost Confidence
    [322817] = SetDefaultAuraData(), -- Lingering Doubt
    [324205] = SetDefaultAuraData(), -- Blinding Flash
    [331251] = SetDefaultAuraData(), -- Deep Connection
    [328331] = SetDefaultAuraData(), -- Forced Confession
    [341215] = SetDefaultAuraData(), -- Volatile Anima
    [323792] = SetDefaultAuraData(), -- Anima Field
    [317661] = SetDefaultAuraData(), -- Insidious Venom
    [330683] = SetDefaultAuraData(), -- Raw Anima
    [328434] = SetDefaultAuraData(), -- Intimidated
    -- De Other Side
    [320786] = SetDefaultAuraData(), -- Power Overwhelming
    [334913] = SetDefaultAuraData(), -- Master of Death
    [325725] = SetDefaultAuraData(), -- Cosmic Artifice
    [328987] = SetDefaultAuraData(), -- Zealous
    [334496] = SetDefaultAuraData(), -- Soporific Shimmerdust
    [339978] = SetDefaultAuraData(), -- Pacifying Mists
    [323692] = SetDefaultAuraData(), -- Arcane Vulnerability
    [333250] = SetDefaultAuraData(), -- Reaver
    [330434] = SetDefaultAuraData(), -- Buzz-Saw 1
    [320144] = SetDefaultAuraData(), -- Buzz-Saw 2
    [331847] = SetDefaultAuraData(), -- W-00F
    [327649] = SetDefaultAuraData(), -- Crushed Soul
    [331379] = SetDefaultAuraData(), -- Lubricate
    [332678] = SetDefaultAuraData(), -- Gushing Wound
    [322746] = SetDefaultAuraData(), -- Corrupted Blood
    [323687] = SetDefaultAuraData(), -- Arcane Lightning
    [323877] = SetDefaultAuraData(), -- Echo Finger Laser X-treme
    [334535] = SetDefaultAuraData(), -- Beak Slice

    -- Castle Nathria
    -- Shriekwing
    [328897] = SetDefaultAuraData(), -- Exsanguinated
    [330713] = SetDefaultAuraData(), -- Reverberating Pain
    [329370] = SetDefaultAuraData(), -- Deadly Descent
    [336494] = SetDefaultAuraData(), -- Echo Screech
    [342074] = SetDefaultAuraData(), -- Echolocation
    -- Huntsman Altimor
    [335304] = SetDefaultAuraData(), -- Sinseeker
    [334971] = SetDefaultAuraData(), -- Jagged Claws
    [335111] = SetDefaultAuraData(), -- Huntsman's Mark 1
    [335112] = SetDefaultAuraData(), -- Huntsman's Mark 2
    [335113] = SetDefaultAuraData(), -- Huntsman's Mark 3
    [334945] = SetDefaultAuraData(), -- Bloody Thrash
    [334939] = SetDefaultAuraData(), --Vicious Lunge
    -- Hungering Destroyer
    [334228] = SetDefaultAuraData(), -- Volatile Ejection
    [329298] = SetDefaultAuraData(), -- Gluttonous Miasma
    -- Lady Inerva Darkvein
    [325936] = SetDefaultAuraData(), -- Shared Cognition
    [335396] = SetDefaultAuraData(), -- Hidden Desire
    [324983] = SetDefaultAuraData(), -- Shared Suffering
    [324982] = SetDefaultAuraData(), -- Shared Suffering (Partner)
    [332664] = SetDefaultAuraData(), -- Concentrate Anima
    [325382] = SetDefaultAuraData(), -- Warped Desires
    -- Sun King's Salvation
    [333002] = SetDefaultAuraData(), -- Vulgar Brand
    [326078] = SetDefaultAuraData(), -- Infuser's Boon
    [325251] = SetDefaultAuraData(), -- Sin of Pride
    -- Artificer Xy'mox
    [327902] = SetDefaultAuraData(), -- Fixate
    [326302] = SetDefaultAuraData(), -- Stasis Trap
    [325236] = SetDefaultAuraData(), -- Glyph of Destruction
    [327414] = SetDefaultAuraData(), -- Possession
    [340860] = SetDefaultAuraData(), -- Withering Touch
    -- The Council of Blood
    [327052] = SetDefaultAuraData(), -- Drain Essence 1
    [327773] = SetDefaultAuraData(), -- Drain Essence 2
    [346651] = SetDefaultAuraData(), -- Drain Essence Mythic
    [328334] = SetDefaultAuraData(), -- Tactical Advance
    [330848] = SetDefaultAuraData(), -- Wrong Moves
    [331706] = SetDefaultAuraData(), -- Scarlet Letter
    [331636] = SetDefaultAuraData(), -- Dark Recital 1
    [331637] = SetDefaultAuraData(), -- Dark Recital 2
    -- Sludgefist
    [335470] = SetDefaultAuraData(), -- Chain Slam
    [339181] = SetDefaultAuraData(), -- Chain Slam (Root)
    [331209] = SetDefaultAuraData(), -- Hateful Gaze
    [335293] = SetDefaultAuraData(), -- Chain Link
    [335270] = SetDefaultAuraData(), -- Chain This One!
    [335295] = SetDefaultAuraData(), -- Shattering Chain
    -- Stone Legion Generals
    [334498] = SetDefaultAuraData(), -- Seismic Upheaval
    [337643] = SetDefaultAuraData(), -- Unstable Footing
    [334765] = SetDefaultAuraData(), -- Heart Rend
    [334771] = SetDefaultAuraData(), -- Heart Hemorrhage
    [333377] = SetDefaultAuraData(), -- Wicked Mark
    [333913] = SetDefaultAuraData(), -- Wicked Laceration
    [334616] = SetDefaultAuraData(), -- Petrified
    [334541] = SetDefaultAuraData(), -- Curse of Petrification
    [339690] = SetDefaultAuraData(), -- Crystalize
    [342655] = SetDefaultAuraData(), -- Volatile Anima Infusion
    [342698] = SetDefaultAuraData(), -- Volatile Anima Infection
    -- Sire Denathrius
    [326851] = SetDefaultAuraData(), -- Blood Price
    [327796] = SetDefaultAuraData(), -- Night Hunter
    [327992] = SetDefaultAuraData(), -- Desolation
    [328276] = SetDefaultAuraData(), -- March of the Penitent
    [326699] = SetDefaultAuraData(), -- Burden of Sin
    [329181] = SetDefaultAuraData(), -- Wracking Pain
    [335873] = SetDefaultAuraData(), -- Rancor
    [329951] = SetDefaultAuraData(), -- Impale
    --------------------------------------------------------
    ---------------- Sanctum of Domination -----------------
    --------------------------------------------------------
    -- The Tarragrue
    [347283] = SetDefaultAuraData(5, 1), -- Predator's Howl
    [347286] = SetDefaultAuraData(5, 1), -- Unshakeable Dread
    [346986] = SetDefaultAuraData(3, 1), -- Crushed Armor
    [347269] = SetDefaultAuraData(6, 1), -- Chains of Eternity
    [346985] = SetDefaultAuraData(3, 1), -- Overpower
    -- Eye of the Jailer           
    [350606] = SetDefaultAuraData(4, 1), -- Hopeless Lethargy
    [355240] = SetDefaultAuraData(5, 1), -- Scorn
    [355245] = SetDefaultAuraData(5, 1), -- Ire
    [349979] = SetDefaultAuraData(2, 1), -- Dragging Chains
    [348074] = SetDefaultAuraData(3, 1), -- Assailing Lance
    [351827] = SetDefaultAuraData(6, 1), -- Spreading Misery
    [355143] = SetDefaultAuraData(6, 1), -- Deathlink
    [350763] = SetDefaultAuraData(6, 1), -- Annihilating Glare
    -- The Nine
    [350287] = SetDefaultAuraData(2, 1), -- Song of Dissolution
    [350542] = SetDefaultAuraData(6, 1), -- Fragments of Destiny
    [350202] = SetDefaultAuraData(3, 1), -- Unending Strike
    [350475] = SetDefaultAuraData(5, 1), -- Pierce Soul
    [350555] = SetDefaultAuraData(3, 1), -- Shard of Destiny
    [350109] = SetDefaultAuraData(5, 1), -- Brynja's Mournful Dirge
    [350483] = SetDefaultAuraData(6, 1), -- Link Essence
    [350039] = SetDefaultAuraData(5, 1), -- Arthura's Crushing Gaze
    [350184] = SetDefaultAuraData(5, 1), -- Daschla's Mighty Impact
    [350374] = SetDefaultAuraData(5, 1), -- Wings of Rage
    -- Remnant of Ner'zhul
    [350073] = SetDefaultAuraData(2, 1), -- Torment
    [349890] = SetDefaultAuraData(5, 1), -- Suffering
    [350469] = SetDefaultAuraData(6, 1), -- Malevolence
    [354634] = SetDefaultAuraData(6, 1), -- Spite 1
    [354479] = SetDefaultAuraData(6, 1), -- Spite 2
    [354534] = SetDefaultAuraData(6, 1), -- Spite 3
    -- Soulrender Dormazain
    [353429] = SetDefaultAuraData(2, 1), -- Tormented
    [353023] = SetDefaultAuraData(3, 1), -- Torment
    [351787] = SetDefaultAuraData(5, 1), -- Agonizing Spike
    [350647] = SetDefaultAuraData(5, 1), -- Brand of Torment
    [350422] = SetDefaultAuraData(6, 1), -- Ruinblade
    [350851] = SetDefaultAuraData(6, 1), -- Vessel of Torment
    [354231] = SetDefaultAuraData(6, 1), -- Soul Manacles
    [348987] = SetDefaultAuraData(6, 1), -- Warmonger Shackle 1
    [350927] = SetDefaultAuraData(6, 1), -- Warmonger Shackle 2
    -- Painsmith Raznal            , 1
    [356472] = SetDefaultAuraData(5, 1), -- Lingering Flames
    [355505] = SetDefaultAuraData(6, 1), -- Shadowsteel Chains 1
    [355506] = SetDefaultAuraData(6, 1), -- Shadowsteel Chains 2
    [348456] = SetDefaultAuraData(6, 1), -- Flameclasp Trap
    [356870] = SetDefaultAuraData(2, 1), -- Flameclasp Eruption
    [355568] = SetDefaultAuraData(6, 1), -- Cruciform Axe
    [355786] = SetDefaultAuraData(5, 1), -- Blackened Armor
    [348255] = SetDefaultAuraData(6, 1), -- Spiked
    -- Guardian of the First Ones  , 1
    [352394] = SetDefaultAuraData(5, 1), -- Radiant Energy
    [350496] = SetDefaultAuraData(6, 1), -- Threat Neutralization
    [347359] = SetDefaultAuraData(6, 1), -- Suppression Field
    [355357] = SetDefaultAuraData(6, 1), -- Obliterate
    [350732] = SetDefaultAuraData(5, 1), -- Sunder
    [352833] = SetDefaultAuraData(6, 1), -- Disintegration
    -- Fatescribe Roh-Kalo         , 1
    [354365] = SetDefaultAuraData(5, 1), -- Grim Portent
    [350568] = SetDefaultAuraData(5, 1), -- Call of Eternity
    [353435] = SetDefaultAuraData(6, 1), -- Overwhelming Burden
    [351680] = SetDefaultAuraData(6, 1), -- Invoke Destiny
    [353432] = SetDefaultAuraData(6, 1), -- Burden of Destiny
    [353693] = SetDefaultAuraData(6, 1), -- Unstable Accretion
    [350355] = SetDefaultAuraData(6, 1), -- Fated Conjunction
    [353931] = SetDefaultAuraData(2, 1), -- Twist Fate
    -- Kel'Thuzad                  , 1
    [346530] = SetDefaultAuraData(2, 1), -- Frozen Destruction
    [354289] = SetDefaultAuraData(2, 1), -- Sinister Miasma
    [347454] = SetDefaultAuraData(6, 1), -- Oblivion's Echo 1
    [347518] = SetDefaultAuraData(6, 1), -- Oblivion's Echo 2
    [347292] = SetDefaultAuraData(6, 1), -- Oblivion's Echo 3
    [348978] = SetDefaultAuraData(6, 1), -- Soul Exhaustion
    [355389] = SetDefaultAuraData(6, 1), -- Relentless Haunt (Fixate)
    [357298] = SetDefaultAuraData(6, 1), -- Frozen Binds
    [355137] = SetDefaultAuraData(5, 1), -- Shadow Pool
    [348638] = SetDefaultAuraData(4, 1), -- Return of the Damned
    [348760] = SetDefaultAuraData(6, 1), -- Frost Blast
    -- Sylvanas Windrunner         , 1
    [349458] = SetDefaultAuraData(2, 1), -- Domination Chains
    [347704] = SetDefaultAuraData(2, 1), -- Veil of Darkness
    [347607] = SetDefaultAuraData(5, 1), -- Banshee's Mark
    [347670] = SetDefaultAuraData(5, 1), -- Shadow Dagger
    [351117] = SetDefaultAuraData(5, 1), -- Crushing Dread
    [351870] = SetDefaultAuraData(5, 1), -- Haunting Wave
    [351253] = SetDefaultAuraData(5, 1), -- Banshee Wail
    [351451] = SetDefaultAuraData(6, 1), -- Curse of Lethargy
    [351092] = SetDefaultAuraData(6, 1), -- Destabilize 1
    [351091] = SetDefaultAuraData(6, 1), -- Destabilize 2
    [348064] = SetDefaultAuraData(6, 1), -- Wailing Arrow
}

local pvpDebuff = {
    -- Death Knight
    [204085] = SetDefaultAuraData(5), -- Deathchill
    [233395] = SetDefaultAuraData(5), -- Frozen Center
    -- Demon Hunter
    [217832] = SetDefaultAuraData(5), -- Imprison
    [179057] = SetDefaultAuraData(5), -- Chaos Nova
    [205630] = SetDefaultAuraData(5), -- Illidan's Grasp
    [208618] = SetDefaultAuraData(5), -- Illidan's Grasp (Afterward)
    -- Druid
    [102359] = SetDefaultAuraData(5), -- Mass Entanglement
    [339] = SetDefaultAuraData(5), -- Entangling Roots
    [2637] = SetDefaultAuraData(5), -- Hibernate
    -- Hunter
    [3355] = SetDefaultAuraData(5), -- Freezing Trap
    [203337] = SetDefaultAuraData(5), -- Freezing Trap (Survival PvP)
    [209790] = SetDefaultAuraData(5), -- Freezing Arrow
    [117526] = SetDefaultAuraData(5), -- Binding Shot
    -- Mage
    [61721] = SetDefaultAuraData(5), -- Rabbit (Poly)
    [61305] = SetDefaultAuraData(5), -- Black Cat (Poly)
    [28272] = SetDefaultAuraData(5), -- Pig (Poly)
    [28271] = SetDefaultAuraData(5), -- Turtle (Poly)
    [126819] = SetDefaultAuraData(5), -- Porcupine (Poly)
    [161354] = SetDefaultAuraData(5), -- Monkey (Poly)
    [161353] = SetDefaultAuraData(5), -- Polar bear (Poly)
    [61780] = SetDefaultAuraData(5), -- Turkey (Poly)
    [161355] = SetDefaultAuraData(5), -- Penguin (Poly)
    [161372] = SetDefaultAuraData(5), -- Peacock (Poly)
    [277787] = SetDefaultAuraData(5), -- Direhorn (Poly)
    [277792] = SetDefaultAuraData(5), -- Bumblebee (Poly)
    [118] = SetDefaultAuraData(5), -- Polymorph
    [82691] = SetDefaultAuraData(5), -- Ring of Frost
    [31661] = SetDefaultAuraData(5), -- Dragon's Breath
    [122] = SetDefaultAuraData(5), -- Frost Nova
    [33395] = SetDefaultAuraData(5), -- Freeze
    [157997] = SetDefaultAuraData(5), -- Ice Nova
    [198121] = SetDefaultAuraData(5), -- Forstbite
    -- Monk
    [198909] = SetDefaultAuraData(5), -- Song of Chi-Ji
    [202274] = SetDefaultAuraData(5), -- Incendiary Brew
    --[123407] = Priority(5), -- Spinning Fire Blossom
    -- Paladin
    [853] = SetDefaultAuraData(5), -- Hammer of Justice
    [20066] = SetDefaultAuraData(5), -- Repentance
    [105421] = SetDefaultAuraData(5), -- Blinding Light
    [31935] = SetDefaultAuraData(5), -- Avenger's Shield
    [217824] = SetDefaultAuraData(5), -- Shield of Virtue
    [205290] = SetDefaultAuraData(5), -- Wake of Ashes
    -- Priest
    [9484] = SetDefaultAuraData(5), -- Shackle Undead
    [226943] = SetDefaultAuraData(5), -- Mind Bomb
    [605] = SetDefaultAuraData(5), -- Mind Control
    [8122] = SetDefaultAuraData(5), -- Psychic Scream
    [15487] = SetDefaultAuraData(5), -- Silence
    [64044] = SetDefaultAuraData(5), -- Psychic Horror
    -- Rogue
    -- Nothing to track
    -- Shaman
    [51514] = SetDefaultAuraData(5), -- Hex
    [211015] = SetDefaultAuraData(5), -- Hex (Cockroach)
    [211010] = SetDefaultAuraData(5), -- Hex (Snake)
    [211004] = SetDefaultAuraData(5), -- Hex (Spider)
    [210873] = SetDefaultAuraData(5), -- Hex (Compy)
    [196942] = SetDefaultAuraData(5), -- Hex (Voodoo Totem)
    [269352] = SetDefaultAuraData(5), -- Hex (Skeletal Hatchling)
    [277778] = SetDefaultAuraData(5), -- Hex (Zandalari Tendonripper)
    [277784] = SetDefaultAuraData(5), -- Hex (Wicker Mongrel)
    [118905] = SetDefaultAuraData(5), -- Static Charge
    [204399] = SetDefaultAuraData(5), -- Earthfury
    [64695] = SetDefaultAuraData(5), -- Earthgrab
    -- Warlock
    [710] = SetDefaultAuraData(5), -- Banish
    [6789] = SetDefaultAuraData(5), -- Mortal Coil
    [118699] = SetDefaultAuraData(5), -- Fear
    [6358] = SetDefaultAuraData(5), -- Seduction (Succub)
    [30283] = SetDefaultAuraData(5), -- Shadowfury
    [233582] = SetDefaultAuraData(5), -- Entrenched in Flame
    -- Warrior
    -- Nothing to track
}

local pvpCC = {
    -- Death Knight
    [47476] = SetDefaultAuraData(2, 1), -- Strangulate
    [108194] = SetDefaultAuraData(4, 1), -- Asphyxiate UH
    [221562] = SetDefaultAuraData(4, 1), -- Asphyxiate Blood
    [207171] = SetDefaultAuraData(4, 1), -- Winter is Coming
    [206961] = SetDefaultAuraData(3, 1), -- Tremble Before Me
    [207167] = SetDefaultAuraData(4, 1), -- Blinding Sleet
    [212540] = SetDefaultAuraData(1, 1), -- Flesh Hook (Pet)
    [91807] = SetDefaultAuraData(1, 1), -- Shambling Rush (Pet)
    [204085] = SetDefaultAuraData(1, 1), -- Deathchill
    [233395] = SetDefaultAuraData(1, 1), -- Frozen Center
    [212332] = SetDefaultAuraData(4, 1), -- Smash (Pet)
    [212337] = SetDefaultAuraData(4, 1), -- Powerful Smash (Pet)
    [91800] = SetDefaultAuraData(4, 1), -- Gnaw (Pet)
    [91797] = SetDefaultAuraData(4, 1), -- Monstrous Blow (Pet)
    [210141] = SetDefaultAuraData(3, 1), -- Zombie Explosion
    -- Demon Hunter
    [207685] = SetDefaultAuraData(4, 1), -- Sigil of Misery
    [217832] = SetDefaultAuraData(3, 1), -- Imprison
    [221527] = SetDefaultAuraData(5, 1), -- Imprison (Banished version)
    [204490] = SetDefaultAuraData(2, 1), -- Sigil of Silence
    [179057] = SetDefaultAuraData(3, 1), -- Chaos Nova
    [211881] = SetDefaultAuraData(4, 1), -- Fel Eruption
    [205630] = SetDefaultAuraData(3, 1), -- Illidan's Grasp
    [208618] = SetDefaultAuraData(3, 1), -- Illidan's Grasp (Afterward)
    [213491] = SetDefaultAuraData(4, 1), -- Demonic Trample (it's this one or the other)
    [208645] = SetDefaultAuraData(4, 1), -- Demonic Trample
    -- Druid
    [81261] = SetDefaultAuraData(2, 1), -- Solar Beam
    [5211] = SetDefaultAuraData(4, 1), -- Mighty Bash
    [163505] = SetDefaultAuraData(4, 1), -- Rake
    [203123] = SetDefaultAuraData(4, 1), -- Maim
    [202244] = SetDefaultAuraData(4, 1), -- Overrun
    [99] = SetDefaultAuraData(4, 1), -- Incapacitating Roar
    [33786] = SetDefaultAuraData(5, 1), -- Cyclone
    [209753] = SetDefaultAuraData(5, 1), -- Cyclone Balance
    [45334] = SetDefaultAuraData(1, 1), -- Immobilized
    [102359] = SetDefaultAuraData(1, 1), -- Mass Entanglement
    [339] = SetDefaultAuraData(1, 1), -- Entangling Roots
    [2637] = SetDefaultAuraData(1, 1), -- Hibernate
    [102793] = SetDefaultAuraData(1, 1), -- Ursol's Vortex
    -- Hunter
    [202933] = SetDefaultAuraData(2, 1), -- Spider Sting (it's this one or the other)
    [233022] = SetDefaultAuraData(2, 1), -- Spider Sting
    [213691] = SetDefaultAuraData(4, 1), -- Scatter Shot
    [19386] = SetDefaultAuraData(3, 1), -- Wyvern Sting
    [3355] = SetDefaultAuraData(3, 1), -- Freezing Trap
    [203337] = SetDefaultAuraData(5, 1), -- Freezing Trap (Survival PvPT)
    [209790] = SetDefaultAuraData(3, 1), -- Freezing Arrow
    [24394] = SetDefaultAuraData(4, 1), -- Intimidation
    [117526] = SetDefaultAuraData(4, 1), -- Binding Shot
    [190927] = SetDefaultAuraData(1, 1), -- Harpoon
    [201158] = SetDefaultAuraData(1, 1), -- Super Sticky Tar
    [162480] = SetDefaultAuraData(1, 1), -- Steel Trap
    [212638] = SetDefaultAuraData(1, 1), -- Tracker's Net
    [200108] = SetDefaultAuraData(1, 1), -- Ranger's Net
    -- Mage
    [61721] = SetDefaultAuraData(3, 1), -- Rabbit (Poly)
    [61305] = SetDefaultAuraData(3, 1), -- Black Cat (Poly)
    [28272] = SetDefaultAuraData(3, 1), -- Pig (Poly)
    [28271] = SetDefaultAuraData(3, 1), -- Turtle (Poly)
    [126819] = SetDefaultAuraData(3, 1), -- Porcupine (Poly)
    [161354] = SetDefaultAuraData(3, 1), -- Monkey (Poly)
    [161353] = SetDefaultAuraData(3, 1), -- Polar bear (Poly)
    [61780] = SetDefaultAuraData(3, 1), -- Turkey (Poly)
    [161355] = SetDefaultAuraData(3, 1), -- Penguin (Poly)
    [161372] = SetDefaultAuraData(3, 1), -- Peacock (Poly)
    [277787] = SetDefaultAuraData(3, 1), -- Direhorn (Poly)
    [277792] = SetDefaultAuraData(3, 1), -- Bumblebee (Poly)
    [118] = SetDefaultAuraData(3, 1), -- Polymorph
    [82691] = SetDefaultAuraData(3, 1), -- Ring of Frost
    [31661] = SetDefaultAuraData(3, 1), -- Dragon's Breath
    [122] = SetDefaultAuraData(1, 1), -- Frost Nova
    [33395] = SetDefaultAuraData(1, 1), -- Freeze
    [157997] = SetDefaultAuraData(1, 1), -- Ice Nova
    [228600] = SetDefaultAuraData(1, 1), -- Glacial Spike
    [198121] = SetDefaultAuraData(1, 1), -- Forstbite
    -- Monk
    [119381] = SetDefaultAuraData(4, 1), -- Leg Sweep
    [202346] = SetDefaultAuraData(4, 1), -- Double Barrel
    [115078] = SetDefaultAuraData(4, 1), -- Paralysis
    [198909] = SetDefaultAuraData(3, 1), -- Song of Chi-Ji
    [202274] = SetDefaultAuraData(3, 1), -- Incendiary Brew
    [233759] = SetDefaultAuraData(2, 1), -- Grapple Weapon
    [123407] = SetDefaultAuraData(1, 1), -- Spinning Fire Blossom
    [116706] = SetDefaultAuraData(1, 1), -- Disable
    [232055] = SetDefaultAuraData(4, 1), -- Fists of Fury (it's this one or the other)
    -- Paladin
    [853] = SetDefaultAuraData(3, 1), -- Hammer of Justice
    [20066] = SetDefaultAuraData(3, 1), -- Repentance
    [105421] = SetDefaultAuraData(3, 1), -- Blinding Light
    [31935] = SetDefaultAuraData(2, 1), -- Avenger's Shield
    [217824] = SetDefaultAuraData(2, 1), -- Shield of Virtue
    [205290] = SetDefaultAuraData(3, 1), -- Wake of Ashes
    -- Priest
    [9484] = SetDefaultAuraData(3, 1), -- Shackle Undead
    [200196] = SetDefaultAuraData(4, 1), -- Holy Word: Chastise
    [200200] = SetDefaultAuraData(4, 1), -- Holy Word: Chastise
    [226943] = SetDefaultAuraData(3, 1), -- Mind Bomb
    [605] = SetDefaultAuraData(5, 1), -- Mind Control
    [8122] = SetDefaultAuraData(3, 1), -- Psychic Scream
    [15487] = SetDefaultAuraData(2, 1), -- Silence
    [64044] = SetDefaultAuraData(1, 1), -- Psychic Horror
    -- Rogue
    [2094] = SetDefaultAuraData(4, 1), -- Blind
    [6770] = SetDefaultAuraData(4, 1), -- Sap
    [1776] = SetDefaultAuraData(4, 1), -- Gouge
    [1330] = SetDefaultAuraData(2, 1), -- Garrote - Silence
    [207777] = SetDefaultAuraData(2, 1), -- Dismantle
    [199804] = SetDefaultAuraData(4, 1), -- Between the Eyes
    [408] = SetDefaultAuraData(4, 1), -- Kidney Shot
    [1833] = SetDefaultAuraData(4, 1), -- Cheap Shot
    [207736] = SetDefaultAuraData(5, 1), -- Shadowy Duel (Smoke effect)
    [212182] = SetDefaultAuraData(5, 1), -- Smoke Bomb
    -- Shaman
    [51514] = SetDefaultAuraData(3, 1), -- Hex
    [211015] = SetDefaultAuraData(3, 1), -- Hex (Cockroach)
    [211010] = SetDefaultAuraData(3, 1), -- Hex (Snake)
    [211004] = SetDefaultAuraData(3, 1), -- Hex (Spider)
    [210873] = SetDefaultAuraData(3, 1), -- Hex (Compy)
    [196942] = SetDefaultAuraData(3, 1), -- Hex (Voodoo Totem)
    [269352] = SetDefaultAuraData(3, 1), -- Hex (Skeletal Hatchling)
    [277778] = SetDefaultAuraData(3, 1), -- Hex (Zandalari Tendonripper)
    [277784] = SetDefaultAuraData(3, 1), -- Hex (Wicker Mongrel)
    [118905] = SetDefaultAuraData(3, 1), -- Static Charge
    [77505] = SetDefaultAuraData(4, 1), -- Earthquake (Knocking down)
    [118345] = SetDefaultAuraData(4, 1), -- Pulverize (Pet)
    [204399] = SetDefaultAuraData(3, 1), -- Earthfury
    [204437] = SetDefaultAuraData(3, 1), -- Lightning Lasso
    [157375] = SetDefaultAuraData(4, 1), -- Gale Force
    [64695] = SetDefaultAuraData(1, 1), -- Earthgrab
    -- Warlock
    [710] = SetDefaultAuraData(5, 1), -- Banish
    [6789] = SetDefaultAuraData(3, 1), -- Mortal Coil
    [118699] = SetDefaultAuraData(3, 1), -- Fear
    [6358] = SetDefaultAuraData(3, 1), -- Seduction (Succub)
    [171017] = SetDefaultAuraData(4, 1), -- Meteor Strike (Infernal)
    [22703] = SetDefaultAuraData(4, 1), -- Infernal Awakening (Infernal CD)
    [30283] = SetDefaultAuraData(3, 1), -- Shadowfury
    [89766] = SetDefaultAuraData(4, 1), -- Axe Toss
    [233582] = SetDefaultAuraData(1, 1), -- Entrenched in Flame
    -- Warrior
    [5246] = SetDefaultAuraData(4, 1), -- Intimidating Shout
    [132169] = SetDefaultAuraData(4, 1), -- Storm Bolt
    [132168] = SetDefaultAuraData(4, 1), -- Shockwave
    [199085] = SetDefaultAuraData(4, 1), -- Warpath
    [105771] = SetDefaultAuraData(1, 1), -- Charge
    [199042] = SetDefaultAuraData(1, 1), -- Thunderstruck
    [236077] = SetDefaultAuraData(2, 1), -- Disarm
    -- Racial
    [20549] = SetDefaultAuraData(4, 1), -- War Stomp
    [107079] = SetDefaultAuraData(4, 1), -- Quaking Palm
}

local defaultTracking = {
    ["player"] = {
        [1] = { --Buff
            Blacklist = blacklist,
            Whitelist = playerWhitelist,
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'PLAYER HELPFUL',
            HasTooltip = true,
        },
        [2] = { --Debuff
            Blacklist = blacklist,
            TexturedIcon = true,
            Filter = 'HARMFUL',
            HasTooltip = true,
        },
    },
    ["pet"] = {
        [1] = { --Buff
            Blacklist = blacklist,
            Whitelist = playerWhitelist,
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'HELPFUL',
            HasTooltip = true,
        },
        [2] = { --Debuff
            Blacklist = blacklist,
            TexturedIcon = true,
            Filter = 'HARMFUL',
            HasTooltip = true,
        },
    },
    ["target"] = {
        [1] = { --Buff
            Blacklist = blacklist,
            Whitelist = playerWhitelist,
            TexturedIcon = true,
            Filter = 'HELPFUL',
            HasTooltip = true,
        },
        [2] = { --Debuff
            Blacklist = blacklist,
            Whitelist = fusionTable(pveDebuff, pvpDebuff, pvpCC),
            TexturedIcon = true,
            Filter = 'HARMFUL',
            HasTooltip = true,
        },
    },
    ["party"] = {
        [1] = { -- Defensive Buff
            Blacklist = blacklist,
            Whitelist = fusionTable(defensiveWhitelist, externalWhitelist),
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'HELPFUL',
            HasTooltip = false,
        },
        [2] = { -- Debuff
            Blacklist = blacklist,
            Whitelist = fusionTable(pveDebuff, pvpDebuff, pvpCC),
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'HARMFUL',
            HasTooltip = false,
        },
        [3] = { -- Beacon/heal
            Blacklist = blacklist,
            Whitelist = healWhitelist,
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'PLAYER HELPFUL',
            HasTooltip = false,
        }
    },
    ["raid"] = {
        [1] = { -- Beacon/heal
            Blacklist = blacklist,
            Whitelist = healWhitelist,
            TexturedIcon = false,
            OnlyShowWhitelist = true,
            Filter = 'PLAYER HELPFUL',
            HasTooltip = false,
        },
        [2] = { -- Defensive Buff
            Blacklist = blacklist,
            Whitelist = fusionTable(defensiveWhitelist, externalWhitelist),
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'HELPFUL',
            HasTooltip = false,
        },
        [3] = { -- Debuff
            Blacklist = blacklist,
            Whitelist = fusionTable(pveDebuff, pvpDebuff, pvpCC),
            TexturedIcon = true,
            OnlyShowWhitelist = true,
            Filter = 'HARMFUL',
            HasTooltip = false,
        }
    }
}

local baseAuraList = {
    ['Ignore'] = blacklist,
    ['Player'] = playerWhitelist,
    ['Defensive'] = defensiveWhitelist,
    ['External'] = externalWhitelist,
    ['Healing'] = healWhitelist,
    ['PveDebuff'] = pveDebuff,
    ['PvpDebuff'] = pvpDebuff,
    ['PvpCrowdControl'] = pvpCC,
}

function AuraFilter:FusionList(...)
    local result = {}
    local max = select('#', ...)
    local val
    for i = 1, max do
        val = select(i, ...)
        for spellID, data in pairs(val) do
            result[spellID] = data
        end
    end
    return result
end

function AuraFilter:GetMaxItem(t)
    local max = 0
    for _, v in pairs(t) do
        local count = 0
        for _ in pairs(v) do
            count = count + 1
        end

        if count > max then
            max = count
        end
    end

    return max
end

local function hasProperties(table)
    for _, d in pairs(table) do
        return type(d) ~= 'boolean'
    end
end

function AuraFilter:GetSortedSpellID(table, sortingOption)
    local result = {}
    if sortingOption ~= 'Priority' and sortingOption ~= 'Position' then
        return result
    end

    if hasProperties(table) then
        for currentPriority = -10, 10, 1 do
            for spellID, data in pairs(table) do
                if data[sortingOption] == currentPriority then
                    tinsert(result, spellID)
                end
            end
        end
    else
        for spellID, _ in pairs(table) do
            tinsert(result, spellID)
        end
    end

    return result
end

function AuraFilter:GetBaseAuraList()
    return {
        ['Ignore'] = blacklist,
        ['Player'] = playerWhitelist,
        ['Defensive'] = defensiveWhitelist,
        ['External'] = externalWhitelist,
        ['Healing'] = healWhitelist,
        ['PveDebuff'] = pveDebuff,
        ['PvpDebuff'] = pvpDebuff,
        ['PvpCrowdControl'] = pvpCC,
    }
end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by f.guilleminot.
--- DateTime: 31/12/2020 09:32
---

local V, C = select(2, ...):unpack()

local Themes = V.Themes
local Profiles = V.Profiles

local function registers(module, submodule, object, table)
    for _, item in ipairs(table) do
        Profiles:RegisterOption(module, submodule, object, unpack(item))
    end
end

local function absorbOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 232, 8 },
        { nil, 'Point', 'TOPRIGHT', 'Frame', 'TOPRIGHT' },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'FillInverse', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiBubbles', 'ARTWORK' },
        { 'Rendering', nil, { 0, 0, 0, 1 }, 'BACKGROUND', 1 },
        --TAGS
        { 'Value', 'Layer', 'OVERLAY' },
        { 'Value', 'Font', 'ValueFont' },
        { 'Value', 'Point', "TOPLEFT", 'Health', "TOP" },
        { 'Value', 'Tag', '[Vorkui:HealthColor][Vorkui:Absorb]' },
    }

    registers(module, submodule, 'Absorb', data)

end

local function healthOption(module, submodule)
    local data = {
        --TRANSFORM
        { nil, 'Size', 256, 32 },
        { nil, 'Point', 'TOPRIGHT', 'Absorb', 'BOTTOMRIGHT', -8, 0 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK' },
        { 'Rendering', nil, 'VorkuiBackground', 'BACKGROUND', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
        --TAGS
        { 'Value', 'Layer', 'OVERLAY' },
        { 'Value', 'Font', 'ValueFont' },
        { 'Value', 'Point', 'TOPRIGHT', 'Health', 'TOP' },
        { 'Value', 'Tag', '[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp]' },

        { 'Percent', 'Layer', 'OVERLAY' },
        { 'Percent', 'Font', 'BigValueFont' },
        { 'Percent', 'Point', 'BOTTOMRIGHT', 'Frame', 'BOTTOMRIGHT' },
        { 'Percent', 'Tag', '[Vorkui:HealthColor(true)][Vorkui:PerHP]' },
    }

    registers(module, submodule, 'Health', data)

end

local function healthPredictionOption(module, submodule)
    local data = {
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
    }

    registers(module, submodule, 'HealthPrediction', data)

end

local function castbarOption(module, submodule)
    local data = {
        --TRANSFORM
        { nil, 'Size', 300, 20 },
        { nil, 'Point', 'TOP', 'Frame', 'BOTTOM', 0, -2 },
        { nil, 'StatusBarColor', { 0, 0.5, 1, 1 } },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK' },
        { 'Rendering', nil, 'VorkuiBackground', 'BACKGROUND', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
        --SPARK
        { 'Spark', 'Layer', 'OVERLAY' },
        { 'Spark', 'Size', 20, 20 },
        { 'Spark', 'BlendMode', 'ADD' },
        { 'CastSettings', 'AtlasName', 'Muzzle' },
        { 'CastSettings', 'Point', 'RIGHT', nil, 'RIGHT', 5, 0 },
        { 'ChannelSettings', 'AtlasName', 'Spark' },
        { 'ChannelSettings', 'Point', 'CENTER', nil, 'RIGHT' },
        --TAGS
        { 'Time', 'Layer', 'OVERLAY' },
        { 'Time', 'Font', 'DurationFont' },
        { 'Time', 'Point', 'RIGHT' },

        { 'Text', 'Layer', 'OVERLAY' },
        { 'Text', 'Font', 'NormalFont' },
        { 'Text', 'Point', 'CENTER' },

        --ICON
        { 'Icon', 'Size', 20, 20 },
        { 'Icon', 'Point', 'TOPLEFT' },

        --SHIELD
        { 'Shield', 'Size', 20, 20 },
        { 'Shield', 'Point', 'LEFT', 'Text' },
        { 'Shield', 'Texture', 'GlobalIcon' },
        { 'Shield', 'TexCoord', 'DEFENSE' },

        --SAFEZONE
        { 'SafeZone', 'Layer', 'OVERLAY' },
        { 'SafeZone', 'BlendMode', 'ADD' },
        { 'SafeZone', 'VertexColor', { 255 / 255, 246 / 255, 0, 0.75 } },
    }

    registers(module, submodule, 'CastBar', data)

end

local function nameOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TAGS
        { nil, 'Layer', 'OVERLAY' },
        { nil, 'Font', 'NameFont' },
        { nil, 'Point', 'BOTTOMLEFT', nil, 'TOPLEFT', 0, 2 },
        { nil, 'Tag', '[classification] [name] [difficulty][level]' },
    }

    registers(module, submodule, 'Name', data)
end

local function powerOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 235, 10 },
        { nil, 'Point', 'TOPLEFT', 'Health', 'BOTTOMLEFT', -10, 0 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK' },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
        --TAGS
        { 'Value', 'Layer', 'OVERLAY' },
        { 'Value', 'Font', 'StackFont' },
        { 'Value', 'Point', 'BOTTOM' },
        { 'Value', 'Tag', '[powercolor][missingpp]' },
    }

    registers(module, submodule, 'Power', data)

end

local function powerPredictionOption(module, submodule)
    local data = {
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'FillInverse', true },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
    }

    registers(module, submodule, 'PowerPrediction', data)

end

local function portraitOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 49, 49 },
        { nil, 'Point', 'TOPLEFT', 'Frame', 'TOPLEFT' },
        { nil, 'Type', '3D' },
        { nil, 'ModelDrawLayer', 'BACKGROUND' },

        { 'PostUpdate', 'Position', { 0.2, 0, 0 } },
        { 'PostUpdate', 'Rotation', -math.pi / 5 },
        { 'PostUpdate', 'CamDistance', 2 },
    }

    registers(module, submodule, 'Portrait', data)

end

local function indicatorOption(module, submodule, indicator, size, point, texture, texcoord, vertexcolor, gradientalpha, blendmode)
    local data = {
        { nil, 'Size', unpack(size) },
        { nil, 'Point', unpack(point) },
        { nil, 'Texture', texture },
        { nil, 'TexCoord', texcoord },
        { nil, 'VertexColor', vertexcolor },
        { nil, 'GradientAlpha', gradientalpha },
        { nil, 'BlendMode', blendmode },
    }

    registers(module, submodule, indicator, data)
end

--(module, submodule, object, component, type, optionName, defaultValue)
Themes["Default"].SetPlayerProfile = function()

    local module = 'UnitFrames'
    local submodule = 'PlayerLayout'

    --Global OPTION
    Profiles:RegisterOption(module, submodule, nil, nil, 'Size', 300, 62)
    Profiles:RegisterOption(module, submodule, nil, nil, 'Point', "CENTER", 'UIParent', "CENTER", -450, -350)
    --HEALTH OPTION
    healthOption(module, submodule)
    healthPredictionOption(module, submodule)
    absorbOption(module, submodule)
    powerOption(module, submodule)
    powerPredictionOption(module, submodule)
    portraitOption(module, submodule)

    indicatorOption(module, submodule, 'ClassIndicator',
            { 16, 16 },
            { 'TOPLEFT', 'Frame', 'TOPRIGHT', -4, -2 },
            'ClassIcon',
            select(2, UnitClass("player")),
            nil,
            nil,
            nil
    )

    indicatorOption(module, submodule, 'RaidIndicator',
            { 16, 16 },
            { 'LEFT', 'Health', 'LEFT', 10, 0 },
            'RaidIcon',
            nil,
            nil,
            nil,
            nil
    )

    indicatorOption(module, submodule, 'LeaderIndicator',
            { 64 / 4, 53 / 4 },
            { 'RIGHT', 'Frame', 'LEFT' },
            'GlobalIcon',
            'LEADER',
            { 163 / 255, 220 / 255, 255 / 255 },
            nil,
            nil
    )

    indicatorOption(module, submodule, 'RestingIndicator',
            { 64 / 2, 60 / 2 },
            { 'BOTTOMRIGHT', 'Frame', 'BOTTOMRIGHT' },
            'GlobalIcon',
            'RESTING',
            nil,
            { "VERTICAL", 163 / 255, 220 / 255, 255 / 255, 0.75, 0, 0, 0, 1 },
            'ADD'
    )

    indicatorOption(module, submodule, 'CombatIndicator',
            { 39 / 3, 64 / 3 },
            { 'BOTTOMRIGHT', 'Frame', 'TOPRIGHT' },
            'GlobalIcon',
            'MAELSTROM',
            nil,
            { "VERTICAL", 255 / 255, 246 / 255, 0 / 255, 0.75, 255 / 255, 50 / 255, 0 / 255, 1 },
            'ADD'
    )

    indicatorOption(module, submodule, 'DeadOrGhostIndicator',
            { 40, 40 },
            { 'BOTTOMRIGHT', 'Frame', 'BOTTOMRIGHT' },
            'Status',
            'DIED',
            { 255 / 255, 68 / 255, 91 / 255 },
            nil,
            nil
    )

    indicatorOption(module, submodule, 'ResurrectIndicator',
            { 40, 40 },
            { 'BOTTOMRIGHT', 'Frame', 'BOTTOMRIGHT', 0, 0 },
            'Status',
            'RESURRECT',
            { 30 / 255, 223 / 255, 100 / 255 },
            nil,
            nil
    )

    indicatorOption(module, submodule, 'SummonIndicator',
            { 32, 32 },
            { 'CENTER', 'Health', 'CENTER' },
            'Phasing',
            'SUMMON',
            { 0 / 255, 204 / 255, 255 / 255 },
            nil,
            nil
    )

    indicatorOption(module, submodule, 'PhaseIndicator',
            { 32, 32 },
            { 'CENTER', 'Health', 'CENTER' },
            'Phasing',
            'PHASE',
            { 0 / 255, 204 / 255, 255 / 255 },
            nil,
            nil
    )

    nameOption(module, submodule)
    castbarOption(module, submodule)

    --[[ TODO TEMPORARY FONT TO KEEP COMPATIBILTY WITH OLD EDITOR
    ["NameFont"] = {
				"Montserrat Medium", -- [1]
				20, -- [2]
				"OUTLINE", -- [3]
			},
    ["NormalFont"] = {
				"Montserrat Medium", -- [1]
				12, -- [2]
				"OUTLINE", -- [3]
			},
    ["StackFont"] = {
				"Montserrat Medium Italic", -- [1]
				16, -- [2]
				"OUTLINE", -- [3]
			},
	["DurationFont"] = {
				"Montserrat Medium", -- [1]
				12, -- [2]
				"OUTLINE", -- [3]
			},
	["BigValueFont"] = {
				"Montserrat Medium Italic", -- [1]
				18, -- [2]
				"OUTLINE", -- [3]
			},
	["ValueFont"] = {
				"Montserrat Medium Italic", -- [1]
				14, -- [2]
				"OUTLINE", -- [3]
			},

	["Submodules"] = {
				["Absorb"] = true,
				["Portrait"] = true,
				["Power"] = true,
				["LeaderIndicator"] = true,
				["Debuffs"] = true,
				["ResurrectIndicator"] = true,
				["SummonIndicator"] = true,
				["CastBar"] = true,
				["RestingIndicator"] = true,
				["CombatIndicator"] = true,
				["ClassIndicator"] = true,
				["DeadOrGhostIndicator"] = true,
				["Buffs"] = true,
				["FightIndicator"] = true,
				["RaidIndicator"] = true,
			},
    ]]--

    Profiles:RegisterOption(module, submodule, nil, nil, 'NameFont', 'Montserrat Medium', 20, 'OUTLINE')
    Profiles:RegisterOption(module, submodule, nil, nil, 'NormalFont', 'Montserrat Medium', 12, 'OUTLINE')
    Profiles:RegisterOption(module, submodule, nil, nil, 'StackFont', 'Montserrat Medium Italic', 16, 'OUTLINE')
    Profiles:RegisterOption(module, submodule, nil, nil, 'DurationFont', 'Montserrat Medium', 12, 'OUTLINE')
    Profiles:RegisterOption(module, submodule, nil, nil, 'BigValueFont', 'Montserrat Medium Italic', 18, 'OUTLINE')
    Profiles:RegisterOption(module, submodule, nil, nil, 'ValueFont', 'Montserrat Medium Italic', 14, 'OUTLINE')

    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'Absorb', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'Portrait', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'Power', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'LeaderIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'Debuffs', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'ResurrectIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'SummonIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'CastBar', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'RestingIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'CombatIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'ClassIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'DeadOrGhostIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'Buffs', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'FightIndicator', true)
    Profiles:RegisterOption(module, submodule, 'Submodules', nil, 'RaidIndicator', true)


    --["Theme"] = "default",
    Profiles:RegisterOption('Theme', nil, nil, nil, 'Name', 'default')
    Profiles:RegisterOption('PartyLayout', nil, nil, nil, 'Layout', 'Expanded')
    Profiles:RegisterOption('RaidLayout', nil, nil, nil, 'Layout', 'Minimalist')
    --["PartyLayout"] = "Expanded",
    --["RaidLayout"] = "Minimalist",

    Profiles:UpdateDB()

end
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
        { nil, 'Point', 'TOPLEFT', 'Frame', 'TOPLEFT' },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'FillInverse', true },
        { 'SlantingSettings', 'Inverse', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiBubbles', 'ARTWORK' },
        { 'Rendering', nil, { 0, 0, 0, 1 }, 'BACKGROUND', 1 },
    }

    registers(module, submodule, 'Absorb', data)

end

local function healthOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 256, 32 },
        { nil, 'Point', 'TOPLEFT', 'Absorb', 'BOTTOMLEFT', 8, 0 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'Inverse', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK' },
        { 'Rendering', nil, 'VorkuiBackground', 'BACKGROUND', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },

        --ATTRIBUTES
        { 'Attributes', 'colorSmooth', true },
    }

    registers(module, submodule, 'Health', data)

end

local function healthPredictionOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 256, 32 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'Inverse', true },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
    }

    registers(module, submodule, 'HealthPrediction', data)

end

local function castbarOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
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
        { 'CastSettings', 'Point', 'LEFT', nil, 'LEFT', -5, 0 },
        { 'ChannelSettings', 'AtlasName', 'Spark' },
        { 'ChannelSettings', 'Point', 'CENTER', nil, 'LEFT', 0, 0 },
        --TAGS
        { 'Time', 'Layer', 'OVERLAY' },
        { 'Time', 'Font', 'DurationFont' },
        { 'Time', 'Point', 'LEFT' },

        { 'Text', 'Layer', 'OVERLAY' },
        { 'Text', 'Font', 'NormalFont' },
        { 'Text', 'Point', 'CENTER' },

        --ICON
        { 'Icon', 'Size', 20, 20 },
        { 'Icon', 'Point', 'TOPRIGHT' },

        --SHIELD
        { 'Shield', 'Size', 20, 20 },
        { 'Shield', 'Point', 'LEFT', 'Text' },
        { 'Shield', 'Texture', 'GlobalIcon' },
        { 'Shield', 'TexCoord', 'DEFENSE' },

        --SAFEZONE
        { 'SafeZone', 'Layer', 'OVERLAY' },
        { 'SafeZone', 'BlendMode', 'ADD' },
        { 'SafeZone', 'VertexColor', { 255 / 255, 246 / 255, 0, 0.75 } },

        { nil, 'ReverseFill', true },
    }

    registers(module, submodule, 'Castbar', data)

end

local function textOption(module, submodule, name, layer, font, point, tag)

    local data = {
        { name, 'Layer', layer },
        { name, 'Font', font },
        { name, 'Point', unpack(point) },
        { name, 'Tag', tag },
    }

    registers(module, submodule, 'Texts', data)
end

local function powerOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 235, 10 },
        { nil, 'Point', 'TOPRIGHT', 'Health', 'BOTTOMRIGHT', 10, 0 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'Inverse', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK' },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },

        { 'Attributes', 'colorPower', true },
        { 'Attributes', 'frequentUpdates', true },
    }

    registers(module, submodule, 'Power', data)

end

local function portraitOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 49, 49 },
        { nil, 'Point', 'TOPRIGHT', 'Frame', 'TOPRIGHT' },
        { nil, 'Type', '3D' },
        { nil, 'ModelDrawLayer', 'BACKGROUND' },

        { 'PostUpdate', 'Position', { 0.1, 0, 0 } },
        { 'PostUpdate', 'Rotation', -math.pi / 5 },
        { 'PostUpdate', 'CamDistance', 2 },
    }

    registers(module, submodule, 'Portrait', data)

end

local function indicatorOption(module, submodule, indicator, size, point, texture, texcoord, vertexcolor, gradientalpha, blendmode)
    local data = {
        { indicator, 'Enable', true },
        { indicator, 'Size', unpack(size) },
        { indicator, 'Point', unpack(point) },
        { indicator, 'Texture', texture },
        { indicator, 'TexCoord', texcoord },
        { indicator, 'VertexColor', vertexcolor },
        { indicator, 'GradientAlpha', gradientalpha },
        { indicator, 'BlendMode', blendmode },
    }

    registers(module, submodule, 'Indicators', data)
end

local function buffOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Point', 'BOTTOMRIGHT', 'Frame', 'BOTTOMLEFT', -2, 0 },
        { nil, 'Dimension', 2, 3 }, --column, row
        ----ATTRIBUTES
        { 'Attributes', 'size', 18 },
        { 'Attributes', 'disableMouse', false },
        { 'Attributes', 'disableCooldown', false },
        { 'Attributes', 'onlyShowPlayer', false },
        { 'Attributes', 'showStealableBuffs', true },
        { 'Attributes', 'spacing', 2 },
        { 'Attributes', 'growth-x', 'LEFT' },
        { 'Attributes', 'growth-y', 'UP' },
        { 'Attributes', 'initialAnchor', 'BOTTOMRIGHT' },
        { 'Attributes', 'filter', 'HELPFUL' },
        { 'Attributes', 'tooltipAnchor', 'ANCHOR_BOTTOMRIGHT' },
        { 'Attributes', 'num', 6 },
    }

    registers(module, submodule, 'Buffs', data)

end

local function debuffOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Point', 'BOTTOMLEFT', 'Frame', 'TOPLEFT', 0, 2 },
        { nil, 'Dimension', 3, 2 }, --column, row
        ----ATTRIBUTES
        { 'Attributes', 'size', 48 },
        { 'Attributes', 'onlyShowPlayer', true },
        { 'Attributes', 'disableMouse', false },
        { 'Attributes', 'disableCooldown', false },
        { 'Attributes', 'spacing', 2 },
        { 'Attributes', 'growth-x', 'LEFT' },
        { 'Attributes', 'growth-y', 'UP' },
        { 'Attributes', 'initialAnchor', 'BOTTOMRIGHT' },
        { 'Attributes', 'filter', 'HARMFUL' },
        { 'Attributes', 'tooltipAnchor', 'ANCHOR_BOTTOMRIGHT' },
        { 'Attributes', 'num', 6 },
    }

    registers(module, submodule, 'Debuffs', data)

end

local function generalOption(module, submodule)
    local data = {
        { nil, 'Size', 300, 62 },
        { nil, 'Point', "CENTER", 'UIParent', "CENTER", 450, -350 },
        { 'Background', 'Enable', true },
        { 'Background', 'Color', 33 / 255, 44 / 255, 79 / 255, 0.75 },
        { nil, 'NameFont', 'Montserrat Medium', 20, 'OUTLINE'},
        { nil, 'NormalFont', 'Montserrat Medium', 12, 'OUTLINE'},
        { nil, 'StackFont', 'Montserrat Medium Italic', 16, 'OUTLINE'},
        { nil, 'DurationFont', 'Montserrat Medium', 12, 'OUTLINE'},
        { nil, 'BigValueFont', 'Montserrat Medium Italic', 18, 'OUTLINE'},
        { nil, 'ValueFont', 'Montserrat Medium Italic', 14, 'OUTLINE'},
    }

    registers(module, submodule, 'General', data)
end

--(module, submodule, object, component, type, optionName, defaultValue)
Themes["Default"].SetTargetProfile = function()

    local module = 'UnitFrames'
    local submodule = 'TargetLayout'

    --Global OPTION
    generalOption(module, submodule)
    --HEALTH OPTION
    healthOption(module, submodule)
    healthPredictionOption(module, submodule)
    absorbOption(module, submodule)
    powerOption(module, submodule)
    portraitOption(module, submodule)
    buffOption(module, submodule)
    debuffOption(module, submodule)

    indicatorOption(module, submodule, 'ClassIndicator',
            { 24, 24 },
            { 'TOPRIGHT', 'Frame', 'TOPRIGHT', -51, -2 },
            'ClassIcon'
    )

    indicatorOption(module, submodule, 'RaidTargetIndicator',
            { 24, 24 },
            { 'TOPLEFT', 'Frame', 'TOPLEFT', 2, -10 },
            'RaidIcon'
    )

    indicatorOption(module, submodule, 'LeaderIndicator',
            { 64 / 4, 53 / 4 },
            { 'LEFT', 'Frame', 'RIGHT' },
            'GlobalIcon',
            'LEADER',
            { 163 / 255, 220 / 255, 255 / 255 }
    )

    indicatorOption(module, submodule, 'DeadOrGhostIndicator',
            { 40, 40 },
            { 'BOTTOMLEFT', 'Frame', 'BOTTOMLEFT' },
            'Status',
            'DIED',
            { 255 / 255, 68 / 255, 91 / 255 }
    )

    indicatorOption(module, submodule, 'ResurrectIndicator',
            { 40, 40 },
            { 'BOTTOMLEFT', 'Frame', 'BOTTOMLEFT' },
            'Status',
            'RESURRECT',
            { 30 / 255, 223 / 255, 100 / 255 }
    )

    indicatorOption(module, submodule, 'SummonIndicator',
            { 32, 32 },
            { 'CENTER', 'Health', 'CENTER' },
            'Phasing',
            'SUMMON',
            { 0 / 255, 204 / 255, 255 / 255 }
    )

    indicatorOption(module, submodule, 'PhaseIndicator',
            { 32, 32 },
            { 'CENTER', 'Health', 'CENTER' },
            'Phasing',
            'PHASE',
            { 0 / 255, 204 / 255, 255 / 255 }
    )

    textOption(module, submodule, 'HealthValue',
            'OVERLAY',
            'ValueFont',
            {'TOPLEFT', 'Health', 'TOP'},
            '[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp-Max]'
    )

    textOption(module, submodule, 'HealthPercent',
            'OVERLAY',
            'BigValueFont',
            {'BOTTOMLEFT', 'Frame', 'BOTTOMLEFT'},
            '[Vorkui:HealthColor(true)][Vorkui:PerHP]'
    )

    textOption(module, submodule, 'AbsorbValue',
            'OVERLAY',
            'ValueFont',
            {'TOPRIGHT', 'Health', 'TOP'},
            '[Vorkui:HealthColor][Vorkui:Absorb]'
    )

    textOption(module, submodule, 'PowerValue',
            'OVERLAY',
            'StackFont',
            {'BOTTOM', 'Frame'},
            '[powercolor][missingpp]'
    )

    textOption(module, submodule, 'Name',
            'OVERLAY',
            'NameFont',
            { 'BOTTOMRIGHT', 'Frame', 'TOPRIGHT', 0, 2 },
            '[difficulty][level] [Vorkui:Name(8)] [classification]'
    )

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

end
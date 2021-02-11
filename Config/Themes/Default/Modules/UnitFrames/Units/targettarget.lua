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
        { nil, 'Size', 145, 4 },
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
        --TAGS
        { 'Value', 'Layer', 'OVERLAY' },
        { 'Value', 'Font', 'ValueFont' },
        { 'Value', 'Point', "TOPRIGHT", 'Health', "TOP" },
        { 'Value', 'Tag', '[Vorkui:HealthColor][Vorkui:Absorb]' },
    }

    registers(module, submodule, 'Absorb', data)

end

local function healthOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 156, 16 },
        { nil, 'Point', 'TOPLEFT', 'Absorb', 'BOTTOMLEFT', 4, 0 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
        { 'SlantingSettings', 'Inverse', true },
        { 'SlantingSettings', 'StaticLayer', 'BACKGROUND' },
        --RENDERING
        { 'Rendering', nil, 'VorkuiDefault', 'ARTWORK' },
        { 'Rendering', nil, 'VorkuiBackground', 'BACKGROUND', 1 },
        { 'Rendering', nil, 'VorkuiBorder', 'OVERLAY' },
        --TAGS
        { 'Value', 'Layer', 'OVERLAY' },
        { 'Value', 'Font', 'ValueFont' },
        { 'Value', 'Point', 'TOPLEFT', 'Health', 'TOP' },
        { 'Value', 'Tag', '[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp-Max]' },

        { 'Percent', 'Layer', 'OVERLAY' },
        { 'Percent', 'Font', 'BigValueFont' },
        { 'Percent', 'Point', 'BOTTOMLEFT', 'Frame', 'BOTTOMLEFT' },
        { 'Percent', 'Tag', '[Vorkui:HealthColor(true)][Vorkui:PerHP]' },
    }

    registers(module, submodule, 'Health', data)

end

local function healthPredictionOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
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

local function nameOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TAGS
        { nil, 'Layer', 'OVERLAY' },
        { nil, 'Font', 'NameFont' },
        { nil, 'Point', 'TOPRIGHT', nil, 'BOTTOMRIGHT', -20, 10 },
        { nil, 'Tag', '[level][difficulty] [name] [classification]' },
    }

    registers(module, submodule, 'Name', data)
end

local function portraitOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 31, 31 },
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
        { nil, 'Enable', true },
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

local function buffOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Point', 'BOTTOMLEFT', 'Frame', 'BOTTOMRIGHT', 2, 0 },
        ----ATTRIBUTES
        { 'Attributes', 'size', 18 },
        { 'Attributes', 'disableMouse', false },
        { 'Attributes', 'disableCooldown', false },
        { 'Attributes', 'onlyShowPlayer', true },
        { 'Attributes', 'showStealableBuffs', false },
        { 'Attributes', 'spacing', 2 },
        { 'Attributes', 'growth-x', 'LEFT' },
        { 'Attributes', 'growth-y', 'TOP' },
        { 'Attributes', 'initialAnchor', 'BOTTOMLEFT' },
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
        { nil, 'Point', 'BOTTOMLEFT', 'Frame', 'TOPRIGHT', 0, 2 },
        ----ATTRIBUTES
        { 'Attributes', 'size', 48 },
        { 'Attributes', 'onlyShowPlayer', false },
        { 'Attributes', 'spacing', 2 },
        { 'Attributes', 'growth-x', 'LEFT' },
        { 'Attributes', 'growth-y', 'TOP' },
        { 'Attributes', 'initialAnchor', 'BOTTOMRIGHT' },
        { 'Attributes', 'showStealableBuffs', false },
        { 'Attributes', 'filter', 'HARMFUL' },
        { 'Attributes', 'tooltipAnchor', 'ANCHOR_BOTTOMRIGHT' },
        { 'Attributes', 'num', 6 },
    }

    registers(module, submodule, 'Debuffs', data)

end

--(module, submodule, object, component, type, optionName, defaultValue)
Themes["Default"].SetTargetTargetProfile = function()

    local module = 'UnitFrames'
    local submodule = 'TargetTargetLayout'

    --Global OPTION
    Profiles:RegisterOption(module, submodule, nil, nil, 'Size', 200, 31)
    Profiles:RegisterOption(module, submodule, nil, nil, 'Point', "LEFT", 'UIParent', "CENTER", 550, -450)
    --HEALTH OPTION
    healthOption(module, submodule)
    healthPredictionOption(module, submodule)
    absorbOption(module, submodule)
    portraitOption(module, submodule)

    indicatorOption(module, submodule, 'ClassIndicator',
            { 16, 16 },
            { 'TOPRIGHT', 'Frame', 'TOPLEFT', 4, -2 },
            'ClassIcon',
            nil,
            nil,
            nil,
            nil
    )

    indicatorOption(module, submodule, 'RaidIndicator',
            { 16, 16 },
            { 'RIGHT', 'Health', 'RIGHT', -10, 0 },
            'RaidIcon',
            nil,
            nil,
            nil,
            nil
    )

    nameOption(module, submodule)

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

end
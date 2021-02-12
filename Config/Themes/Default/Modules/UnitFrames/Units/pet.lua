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

local function healthOption(module, submodule)
    local data = {
        { nil, 'Enable', true },
        --TRANSFORM
        { nil, 'Size', 256, 16 },
        { nil, 'Point', 'TOPRIGHT' },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
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
        { nil, 'Size', 256, 16 },
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
        { 'CastSettings', 'Point', 'RIGHT', nil, 'RIGHT', 5, 0 },
        { 'ChannelSettings', 'AtlasName', 'Spark' },
        { 'ChannelSettings', 'Point', 'CENTER', nil, 'RIGHT', 0, 0 },
        --TAGS
        { 'Time', 'Layer', 'OVERLAY' },
        { 'Time', 'Font', 'DurationFont' },
        { 'Time', 'Point', 'RIGHT', 'Castbar' },

        { 'Text', 'Layer', 'OVERLAY' },
        { 'Text', 'Font', 'NormalFont' },
        { 'Text', 'Point', 'CENTER', 'Castbar' },

        --ICON
        { 'Icon', 'Size', 20, 20 },
        { 'Icon', 'Point', 'TOPLEFT', 'Castbar' },

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
        { nil, 'Size', 240, 8 },
        { nil, 'Point', 'TOPLEFT', 'Health', 'BOTTOMLEFT', 0, 0 },
        ----SLANT
        { 'SlantingSettings', 'Enable', true },
        { 'SlantingSettings', 'IgnoreBackground', true },
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
        { nil, 'Size', 32, 32 },
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
        { nil, 'Point', 'BOTTOMLEFT', 'Frame', 'BOTTOMRIGHT', 2, 0 },
        { nil, 'Dimension', 2, 3 }, --column, row
        ----ATTRIBUTES
        { 'Attributes', 'size', 18 },
        { 'Attributes', 'disableMouse', false },
        { 'Attributes', 'disableCooldown', false },
        { 'Attributes', 'onlyShowPlayer', true },
        { 'Attributes', 'showStealableBuffs', false },
        { 'Attributes', 'spacing', 2 },
        { 'Attributes', 'growth-x', 'LEFT' },
        { 'Attributes', 'growth-y', 'UP' },
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
        { nil, 'Dimension', 3, 2 }, --column, row
        ----ATTRIBUTES
        { 'Attributes', 'size', 48 },
        { 'Attributes', 'onlyShowPlayer', false },
        { 'Attributes', 'spacing', 2 },
        { 'Attributes', 'growth-x', 'LEFT' },
        { 'Attributes', 'growth-y', 'UP' },
        { 'Attributes', 'initialAnchor', 'BOTTOMRIGHT' },
        { 'Attributes', 'showStealableBuffs', false },
        { 'Attributes', 'filter', 'HARMFUL' },
        { 'Attributes', 'tooltipAnchor', 'ANCHOR_BOTTOMRIGHT' },
        { 'Attributes', 'num', 6 },
    }

    registers(module, submodule, 'Debuffs', data)

end

local function generalOption(module, submodule)
    local data = {
        { nil, 'Size', 300, 32 },
        { nil, 'Point', "CENTER", 'UIParent', "CENTER", -450, -400 },
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
Themes["Default"].SetPetProfile = function()

    local module = 'UnitFrames'
    local submodule = 'PetLayout'

    --Global OPTION
    generalOption(module, submodule)
    --HEALTH OPTION
    healthOption(module, submodule)
    healthPredictionOption(module, submodule)
    powerOption(module, submodule)
    portraitOption(module, submodule)
    buffOption(module, submodule)
    debuffOption(module, submodule)

    indicatorOption(module, submodule, 'ClassIndicator',
            { 16, 16 },
            { 'TOPLEFT', 'Frame', 'TOPRIGHT', -4, -2 },
            'ClassIcon'
    )

    indicatorOption(module, submodule, 'RaidTargetIndicator',
            { 16, 16 },
            { 'LEFT', 'Health', 'LEFT', 10, 0 },
            'RaidIcon'
    )

    indicatorOption(module, submodule, 'CombatIndicator',
            { 39 / 3, 64 / 3 },
            { 'TOPRIGHT', 'Frame', 'TOPRIGHT' },
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
            { 255 / 255, 68 / 255, 91 / 255 }
    )

    indicatorOption(module, submodule, 'ResurrectIndicator',
            { 40, 40 },
            { 'BOTTOMRIGHT', 'Frame', 'BOTTOMRIGHT', 0, 0 },
            'Status',
            'RESURRECT',
            { 30 / 255, 223 / 255, 100 / 255 }
    )

    textOption(module, submodule, 'HealthValue',
            'OVERLAY',
            'ValueFont',
            {'TOPRIGHT', 'Health', 'TOP'},
            '[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp]'
    )

    textOption(module, submodule, 'HealthPercent',
            'OVERLAY',
            'BigValueFont',
            {'BOTTOMRIGHT', 'Frame', 'BOTTOMRIGHT'},
            '[Vorkui:HealthColor(true)][Vorkui:PerHP]'
    )

    textOption(module, submodule, 'AbsorbValue',
            'OVERLAY',
            'ValueFont',
            {'TOPLEFT', 'Health', 'TOP'},
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
            '[classification] [name]'
    )

    castbarOption(module, submodule)

end
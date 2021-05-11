local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()

local Editor = V.Editor

Editor.border = {
    size = 1,
    color = { 1, 1, 1, 0.4 }
}

Editor.TypeChecker = {
    ['number'] = function(val)
        if type(val) == 'number' then
            return true
        else
            -- try to cast in number
            -- we need to recheck the tostring with origin val because tonumber can cast to number specific string
            local cast = tonumber(val)
            return cast ~= nil and tostring(cast) == val
        end
    end,
    ['string'] = function(val)
        return type(val) == 'string'
    end,
    ['boolean'] = function(val)
        return val == 'true' or val == 'false'
    end,
}

Editor.menus = {}

--TEXTURE
Editor.menus.layers = {
    { text = 'BACKGROUND' },
    { text = 'BORDER' },
    { text = 'ARTWORK' },
    { text = 'OVERLAY' },
    { text = 'HIGHLIGHT' },
}

Editor.menus.orientation = {
    { text = 'VERTICAL' },
    { text = 'HORIZONTAL' },
}

Editor.menus.blendmode = {
    { text = 'DISABLE' },
    { text = 'BLEND' },
    { text = 'ALPHAKEY' },
    { text = 'ADD' },
    { text = 'MOD' },
}

--TAG
Editor.menus.fonts = {
    { text = 'NameFont' },
    { text = 'NormalFont' },
    { text = 'DurationFont' },
    { text = 'StackFont' },
    { text = 'ValueFont' },
    { text = 'BigValueFont' },
}

--FONT
Editor.menus.flags = {
    { text = 'NONE' },
    { text = 'OUTLINE' },
    { text = 'THICKOUTLINE' },
    { text = 'MONOCHROME' },
}

--PORTRAIT
Editor.menus.portrait = {
    { text = '2D' },
    { text = '3D' },
}

-- POINT
Editor.menus.anchors = { 'BOTTOMLEFT', 'LEFT', 'TOPLEFT', 'TOP', 'TOPRIGHT', 'RIGHT', 'BOTTOMRIGHT', 'BOTTOM', 'CENTER' }

--GROUP ATTRIBUTE
Editor.menus.groupingOrder = {
    { text='NONE' },
    { text='GROUP' },
    { text='CLASS' },
    { text='ROLE' },
    { text='ASSIGNEDROLE' },
}

Editor.menus.sortingOrder = {
    { text='INDEX' },
    { text='NAME' },
    { text='NAMELIST' },
}

Editor.menus.sortingDirection = {
    { text='ASC' },
    { text='DESC' },
}

Editor.menus.growDirectionX = {
    { text='RIGHT' },
    { text='LEFT' },
}

Editor.menus.growDirectionY = {
    { text='UP' },
    { text='BOTTOM' },
}

Editor.menus.roleFilter = {
    { text='MT, MA, Tank, Healer, DPS' },
    { text='MT, Tank, MA, Healer, DPS' },
    { text='MA, MT, Tank, Healer, DPS' },
    { text='MA, Healer, MT, Tank, DPS' },
}

Editor.menus.helpfulFilter = {
    'HELPFUL',
    'PLAYER',
    'RAID',
    'CANCELABLE',
    'NOT_CANCELABLE',
    'MAW',
    'INCLUDE_NAME_PLATE_ONLY'
}

Editor.menus.harmfulFilter = {
    'HARMFUL',
    'PLAYER',
    'RAID',
    'CANCELABLE',
    'NOT_CANCELABLE',
    'MAW',
    'INCLUDE_NAME_PLATE_ONLY'
}

Editor.menus.auraFilter = {
    { text='REMAINING' },
    { text='DURATION' },
    { text='PLAYER' },
}

Editor.attributes = {}
Editor.attributes.health = { --all booleans
    ['colorDisconnected'] = 'boolean',
    ['colorTapping'] = 'boolean',
    ['colorThreat'] = 'boolean',
    ['colorClass'] = 'boolean',
    ['colorClassNPC'] = 'boolean',
    ['colorClassPet'] = 'boolean',
    ['colorSelection'] = 'boolean',
    ['colorReaction'] = 'boolean',
    ['colorSmooth'] = 'boolean',
    ['colorHealth'] = 'boolean',
}

Editor.attributes.power = { --all booleans
    ['frequentUpdates'] = 'boolean',
    ['displayAltPower'] = 'boolean',
    ['considerSelectionInCombatHostile'] = 'boolean',
    ['colorDisconnected'] = 'boolean',
    ['colorTapping'] = 'boolean',
    ['colorThreat'] = 'boolean',
    ['colorPower'] = 'boolean',
    ['colorClass'] = 'boolean',
    ['colorClassNPC'] = 'boolean',
    ['colorClassPet'] = 'boolean',
    ['colorSelection'] = 'boolean',
    ['colorReaction'] = 'boolean',
    ['colorSmooth'] = 'boolean',
}

Editor.attributes.auras = {
    ['disableMouse'] = 'boolean',
    ['disableCooldown'] = 'boolean',
    ['size'] = 'number',
    ['onlyShowPlayer'] = 'boolean',
    ['showStealableBuffs'] = 'boolean',
    ['spacing'] = 'number',
    ['spacing-x'] = 'number',
    ['spacing-y'] = 'number',
    ['growth-x'] = 'string',
    ['growth-y'] = 'string',
    ['initialAnchor'] = 'string',
    ['filter'] = 'string',
    ['tooltipAnchor'] = 'string',
    ['numBuffs'] = 'number',
    ['numDebuffs'] = 'number',
    ['numTotal'] = 'number',
    ['gap'] = 'number',
    ['buffFilter'] = 'string',
    ['debuffFilter'] = 'string',
    ['num'] = 'number',
}
Editor.attributes.buffs = Editor.attributes.auras
Editor.attributes.debuffs = Editor.attributes.auras

Editor.attributes.party = {
    ['template'] = 'string',
    ['templateType'] = 'string',
    ['showParty'] = 'boolean',
    ['showRaid'] = 'boolean',
    ['showPlayer'] = 'boolean',
    ['showSolo'] = 'boolean',
    ['point'] = 'string',
    ['xOffset'] = 'number',
    ['yOffset'] = 'number',
    ['maxColumns'] = 'number',
    ['unitsPerColumn'] = 'number',
    ['columnSpacing'] = 'number',
    ['columnAnchorPoint'] = 'string',
    ['nameList'] = 'string',
    ['groupFilter'] = 'string',
    ['roleFilter'] = 'string',
    ['strictFiltering'] = 'boolean',
    ['sortMethod'] = 'string',
    ['sortDir'] = 'string',
    ['startingIndex'] = 'number',
    ['groupBy'] = 'string',
    ['groupingOrder'] = 'string',
}

Editor.attributes.raid = Editor.attributes.party
local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()

local Editor = V.Editor

Editor.border = {
    size = 1,
    color = { 1, 1, 1, 0.4 }
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
    { text = 'Name Font' },
    { text = 'Normal Font' },
    { text = 'Duration Font' },
    { text = 'Stack Font' },
    { text = 'Value Font' },
    { text = 'Big Value Font' },
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
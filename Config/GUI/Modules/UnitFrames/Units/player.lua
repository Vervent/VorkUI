local V = select(2, ...):unpack()

local Install = V.Install

local borderColor = { 1, 1, 1, 0.2 }
local borderSize = 1

local dropdownAnchorData = {
    { text = 'CENTER' },
    { text = 'TOPLEFT' },
    { text = 'TOP' },
    { text = 'TOPRIGHT' },
    { text = 'RIGHT' },
    { text = 'BOTTOMRIGHT' },
    { text = 'BOTTOM' },
    { text = 'BOTTOMLEFT' },
    { text = 'LEFT' }
}

local dropdownFontFlagData = {
    { text = "NONE"},
    { text = "OUTLINE"},
    { text = "THICKOUTLINE"},
    { text = "MONOCHROME" }
}

local scrollButtonClick = function(self)
    local container = self:GetParent()
    local parent = container:GetParent()
    local txt = self:GetText() or ''
    for i, c in ipairs(parent.Childs) do
        if i > 1 then
            if string.match(c:GetName(), txt)  then
                c:Show()
            else
                c:Hide()
            end
        end
    end
end

local function getPath(...)
    local res = {
        'UnitFrames',
        'PlayerLayout'
    }

    local arg
    for i = 1, select('#', ...) do
        arg = select(i, ...)
        tinsert(res, arg)
    end

    return res
end

local page = {
    params = {
        name = 'PlayerPage',
        title = 'Player',
        headerSize = { 100, 25 },
        enableAllChilds = false,
        AfterEnable = function(self)
            for i, f in ipairs(self.Childs) do
                if i < 3 then
                    f:Show()
                end
            end
        end
    },
    widgets = {
        {
            type = 'label',
            params = {
                size = { 250, 30 },
                point = { 'TOP' },
            },
            data = {
                nil, 'Game18Font', 'Player Frame Settings'
            },
        },
    },
    childs = {
        {
            type = 'scrolluniformlist',
            params = {
                name = 'PlayerPageScrollList',
                size = { 200, 490 },
                point = { 'TOPLEFT', 2, -30 },
            },
            widgets = {
            }
        },
    }
}

local generalEntry = {
    type = 'empty',
    params = {
        name = 'PlayerFrameGeneralSettings',
        size = { 554, 490 },
        point = { 'TOPRIGHT', -2, -30 },
    },
    widgets = {},
    childs = {
        {
            type = 'empty',
            params = {
                name = 'PlayerFrameSize',
                size = { 200, 90},
                point = { 'TOPLEFT', 0, -30 },
                border = { borderSize, borderColor },
            },
            widgets = {
                {
                    type = 'label',
                    params = {
                        size = { 200, 30 },
                        point = { 'TOP', 0, 15 }
                    },
                    data = {
                        'OVERLAY',
                        nil,
                        'Frame Size'
                    }
                }, --SECTION LABEL
                {
                    type = 'label',
                    params = {
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 0, -15 }
                    },
                    data = {
                        'OVERLAY',
                        'GameFontNormal',
                        'Width'
                    }
                }, --WIDTH LABEL
                {
                    type = 'editbox',
                    params = {
                        size = { 50, 25 },
                        point = { 'TOPLEFT', 110, -15 },
                        template = 'NumericInputSpinnerTemplate',
                        dboption = getPath('Size', 1)
                    },
                    data = { nil, nil, nil, {0, 500} }
                }, --WIDTH EDIT
                {
                    type = 'label',
                    params = {
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 0, -45 }
                    },
                    data = {
                        'OVERLAY',
                        'GameFontNormal',
                        'Height'
                    }
                }, --HEIGHT LABEL
                {
                    type = 'editbox',
                    params = {
                        size = { 50, 25 },
                        point = { 'TOPLEFT', 110, -45 },
                        template = 'NumericInputSpinnerTemplate',
                        dboption = getPath('Size', 2)
                    },
                    data = { nil, nil, nil, {0, 500} }
                }, --HEIGHT EDIT
            },
            childs = {}
        }, --SUBFRAME SIZE
        {
            type = 'empty',
            params = {
                name = 'PlayerFramePosition',
                size = { 500, 90},
                point = { 'TOPLEFT', 0, -140 },
                border = { borderSize, borderColor },
            }, --SUBFRAME PARAMS
            widgets = {
                {
                    type = 'label',
                    params = {
                        size = { 400, 30 },
                        point = { 'TOP', 0, 15 }
                    },
                    data = {
                        'OVERLAY',
                        nil,
                        'Frame Position'
                    }
                }, --SECTION LABEL
                {
                    type = 'label',
                    params = {
                        size = { 125, 25 },
                        point = { 'TOPLEFT', 10, -15 }
                    },
                    data = {
                        'OVERLAY',
                        'GameFontNormal',
                        'Local Anchor'
                    }
                }, --LOCAL ANCHOR LABEL
                {
                    type = 'dropdownmenu',
                    params = {
                        size = { 125, 25 },
                        point = { 'TOPLEFT', 130, -15 },
                        dboption = getPath('Point', 1)
                    },
                    data = dropdownAnchorData,
                }, --LOCAL ANCHOR DROPDOWN
                {
                    type = 'label',
                    params = {
                        size = { 125, 25 },
                        point = { 'TOPLEFT', 10, -45 }
                    },
                    data = {
                        'OVERLAY',
                        'GameFontNormal',
                        'Parent Anchor'
                    }
                }, --PARENT ANCHOR LABEL
                {
                    type = 'dropdownmenu',
                    params = {
                        size = { 125, 25 },
                        point = { 'TOPLEFT', 130, -45 },
                        dboption = getPath('Point', 3)
                    },
                    data = dropdownAnchorData,
                }, --PARENT ANCHOR DROPDOWN
                { --X-OFFSET
                    type = 'label',
                    params = {
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 290, -15 }
                    },
                    data = {
                        'OVERLAY',
                        'GameFontNormal',
                        'X-offset'
                    }
                }, --X-OFFSET LABEL
                {
                    type = 'editbox',
                    params = {
                        size = { 50, 25 },
                        point = { 'TOPLEFT', 400, -15 },
                        template = 'NumericInputSpinnerTemplate',
                        dboption = getPath('Point', 4)
                    },
                    data = { nil, nil, nil, {-500, 500} }
                }, --X-OFFSET EDITBOX
                {
                    type = 'label',
                    params = {
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 290, -45 }
                    },
                    data = {
                        'OVERLAY',
                        'GameFontNormal',
                        'Y-offset'
                    }
                }, --Y-OFFSET LABEL
                {
                    type = 'editbox',
                    params = {
                        size = { 50, 25 },
                        point = { 'TOPLEFT', 400, -45 },
                        template = 'NumericInputSpinnerTemplate',
                        dboption = getPath('Point', 5)
                    },
                    data = { nil, nil, nil, {-500, 500} }
                }, --Y-OFFSET EDITBOX
            },
            childs = {}
        }, -- SUBFRAME POSITION
        {
            type = 'empty',
            params = {
                name = 'PlayerSubmodule',
                size = { 545, 150},
                point = { 'TOPLEFT', 0, -250 },
                border = { borderSize, borderColor },
                updateWidgetsLayout = 2,
            },
            widgets = {
                {
                    type = 'label',
                    params = {
                        size = { 200, 30 },
                        point = { 'TOP', 0, 15 },
                    },
                    data = {
                        nil,
                        nil,
                        'Enable/Disable Submodule'
                    },
                },
            },
            childs = {}
        }
    }
}

local fontEntry = {
    type = 'empty',
    params = {
        name = 'PlayerFrameFontSettings',
        size = { 554, 490 },
        point = { 'TOPRIGHT', -2, -30 },
    },
    widgets = {},
    childs = {
        --{
        --    type = "empty",
        --    params = {
        --        name = "PlayerFrameNameFont",
        --        size = { 545, 70 },
        --        point = { "TOPLEFT", 0, -30 },
        --        border = { borderSize, borderColor },
        --    },
        --    widgets = {
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 400, 30 },
        --                point = { 'TOP', 0, 15 }
        --            },
        --            data = {
        --                nil,
        --                nil,
        --                'Name Font'
        --            }
        --        }, --SECTION LABEL
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 100, 25 },
        --                point = { 'TOPLEFT', 20, -10 }
        --            },
        --            data = {
        --                nil,
        --                'GameFontNormal',
        --                'Font Object'
        --            }
        --        }, --FONT OBJECT LABEL
        --        {
        --            type = 'dropdownmenu',
        --            params = {
        --                size = { 200, 25 },
        --                point = { 'TOPLEFT', 5, -30 },
        --                dboption = getPath( 'NameFont' , 1),
        --                mediatype = 'font'
        --            },
        --            data = { },
        --        }, --FONT OBJECT DROPDOWN
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 100, 25 },
        --                point = { 'TOPLEFT', 255, -10 }
        --            },
        --            data = {
        --                nil,
        --                'GameFontNormal',
        --                'Font Flag'
        --            }
        --        }, --FONT FLAG LABEL
        --        {
        --            type = 'dropdownmenu',
        --            params = {
        --                size = { 125, 25 },
        --                point = { 'TOPLEFT', 250, -30 },
        --                dboption = getPath( 'NameFont' , 3),
        --            },
        --            data = dropdownFontFlagData,
        --        }, --FONT FLAG DROPDOWN
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 100, 25 },
        --                point = { 'TOPLEFT', 430, -10 }
        --            },
        --            data = {
        --                nil,
        --                'GameFontNormal',
        --                'Font Size'
        --            }
        --        }, --FONT SIZE LABEL
        --        {
        --            type = 'editbox',
        --            params = {
        --                size = { 40, 25 },
        --                point = { 'TOPLEFT', 460, -30 },
        --                template = 'NumericInputSpinnerTemplate',
        --                dboption = getPath( 'NameFont' , 2),
        --            },
        --            data = { nil, nil, nil, {8, 36} },
        --        }, --FONT SIZE EDITBOX
        --    },
        --    childs = {}
        --}, --SUBFRAME NAME
        --{
        --    type = "empty",
        --    params = {
        --        name = "PlayerFrameNormalFont",
        --        size = { 545, 70 },
        --        point = { "TOPLEFT", 0, -30 },
        --        border = { borderSize, borderColor },
        --    },
        --    widgets = {
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 400, 30 },
        --                point = { 'TOP', 0, 15 }
        --            },
        --            data = {
        --                nil,
        --                nil,
        --                'Normal Font'
        --            }
        --        }, --SECTION LABEL
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 100, 25 },
        --                point = { 'TOPLEFT', 20, -10 }
        --            },
        --            data = {
        --                nil,
        --                'GameFontNormal',
        --                'Font Object'
        --            }
        --        }, --FONT OBJECT LABEL
        --        {
        --            type = 'dropdownmenu',
        --            params = {
        --                size = { 200, 25 },
        --                point = { 'TOPLEFT', 5, -30 },
        --                dboption = getPath( 'NormalFont' , 1),
        --                mediatype = 'font'
        --            },
        --            data = { },
        --        }, --FONT OBJECT DROPDOWN
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 100, 25 },
        --                point = { 'TOPLEFT', 255, -10 }
        --            },
        --            data = {
        --                nil,
        --                'GameFontNormal',
        --                'Font Flag'
        --            }
        --        }, --FONT FLAG LABEL
        --        {
        --            type = 'dropdownmenu',
        --            params = {
        --                size = { 125, 25 },
        --                point = { 'TOPLEFT', 250, -30 },
        --                dboption = getPath( 'NormalFont' , 3),
        --            },
        --            data = dropdownFontFlagData,
        --        }, --FONT FLAG DROPDOWN
        --        {
        --            type = 'label',
        --            params = {
        --                size = { 100, 25 },
        --                point = { 'TOPLEFT', 430, -10 }
        --            },
        --            data = {
        --                nil,
        --                'GameFontNormal',
        --                'Font Size'
        --            }
        --        }, --FONT SIZE LABEL
        --        {
        --            type = 'editbox',
        --            params = {
        --                size = { 40, 25 },
        --                point = { 'TOPLEFT', 460, -30 },
        --                template = 'NumericInputSpinnerTemplate',
        --                dboption = getPath( 'NormalFont' , 2),
        --            },
        --            data = { nil, nil, nil, {8, 36} },
        --        }, --FONT SIZE EDITBOX
        --    },
        --    childs = {}
        --}, --SUBFRAME NormalFont
    }
}

local healthEntry = {
    type = 'empty',
    params = {
        name = 'HealthSettings',
        size = { 500, 490 },
        point = { 'TOPRIGHT', -2, -30 },
    },
    widgets = {
        {
            type = 'label',
            params = {
                size = { 200, 25 },
                point = { 'TOP' },
            },
            data = {
                'OVERLAY',
                'GameFontNormal',
                'Party Settings'
            },
        },
        {
            type = 'dropdownmenu',
            params = {
                size = { 200, 25 },
                point = { 'TOP', 0, -50 },
                dboption = 'PartyLayout'
            },
            data = {
                { text = 'Expanded' },
                { text = 'Minimalist' },
                { text = 'Compact' },
            },
        }
    },
    childs = {

    }
}
local powerEntry = {
    type = 'empty',
    params = {
        name = 'PowerSettings',
        size = { 500, 490 },
        point = { 'TOPRIGHT', -2, -30 },
    },
    widgets = {
        {
            type = 'label',
            params = {
                size = { 200, 25 },
                point = { 'TOP' },
            },
            data = {
                'OVERLAY',
                'GameFontNormal',
                'Raid Settings'
            },
        },
        {
            type = 'dropdownmenu',
            params = {
                size = { 200, 25 },
                point = { 'TOP', 0, -50 },
                dboption = 'RaidLayout'
            },
            data = {
                { text = 'Expanded' },
                { text = 'Minimalist' },
                { text = 'Compact' },
            },
        }
    },
    childs = {

    }
}

local subModules = {
    'Power',
    'Absorb',
    'Portrait',
    'ClassIndicator',
    'RaidIndicator',
    'LeaderIndicator',
    'FightIndicator',
    'RestingIndicator',
    'CombatIndicator',
    'DeadOrGhostIndicator',
    'ResurrectIndicator',
    'SummonIndicator',
    'CastBar',
    'Buffs',
    'Debuffs',
    --'RôleIndicator', --TODO ADD ROLEINDICATOR
}
local playerFonts = {
    "NameFont",
    "NormalFont",
    "ValueFont",
    "BigValueFont",
    "DurationFont",
    "StackFont",
}

local function addFontSubFrame(name)

    local anchor = { "TOPLEFT", 0, -20 + -80 * #fontEntry.childs }
    local subframe = {
        type = "empty",
        params = {
            name = "PlayerFrame"..name,
            size = { 545, 70 },
            point = anchor,
            border = { borderSize, borderColor },
        },
        widgets = {
            {
                type = 'label',
                params = {
                    size = { 400, 30 },
                    point = { 'TOP', 0, 15 }
                },
                data = {
                    nil,
                    nil,
                    name
                }
            }, --SECTION LABEL
            {
                type = 'label',
                params = {
                    size = { 100, 25 },
                    point = { 'TOPLEFT', 20, -10 }
                },
                data = {
                    nil,
                    'GameFontNormal',
                    'Font Object'
                }
            }, --FONT OBJECT LABEL
            {
                type = 'dropdownmenu',
                params = {
                    size = { 200, 25 },
                    point = { 'TOPLEFT', 5, -30 },
                    dboption = getPath( name , 1),
                    mediatype = 'font'
                },
                data = { },
            }, --FONT OBJECT DROPDOWN
            {
                type = 'label',
                params = {
                    size = { 100, 25 },
                    point = { 'TOPLEFT', 255, -10 }
                },
                data = {
                    nil,
                    'GameFontNormal',
                    'Font Flag'
                }
            }, --FONT FLAG LABEL
            {
                type = 'dropdownmenu',
                params = {
                    size = { 125, 25 },
                    point = { 'TOPLEFT', 250, -30 },
                    dboption = getPath( name , 3),
                },
                data = dropdownFontFlagData,
            }, --FONT FLAG DROPDOWN
            {
                type = 'label',
                params = {
                    size = { 100, 25 },
                    point = { 'TOPLEFT', 430, -10 }
                },
                data = {
                    nil,
                    'GameFontNormal',
                    'Font Size'
                }
            }, --FONT SIZE LABEL
            {
                type = 'editbox',
                params = {
                    size = { 40, 25 },
                    point = { 'TOPLEFT', 460, -30 },
                    template = 'NumericInputSpinnerTemplate',
                    dboption = getPath( name , 2),
                },
                data = { nil, nil, nil, {8, 36} },
            }, --FONT SIZE EDITBOX
        },
        childs = {}
    }
    tinsert(fontEntry.childs, subframe)
end

local function addCheckBox(parent, name)

    local box = {
        type = 'checkbox',
        params = {
            name = name..'SubmoduleCheckbox',
            size = { 25, 25 },
            point = { "TOPLEFT", 2, -2 },
            template = 'UICheckButtonTemplate',
            dboption = getPath('Submodules', name)
        },
        data = { name },
    }

    tinsert(parent, box)
end
local function addCheckboxTo(entry, dataTable)
    for idx = 1, #dataTable do
        addCheckBox(entry.widgets, dataTable[idx])
    end

end
local function addEntryToScroll(name, entry)
    local scrollItem = {
        type = 'widget',
        subtype = 'button',
        params = {
            size = { 200, 25 },
            point = {"TOP"},
            template = 'UIPanelButtonTemplate',
        },
        data = {
            name,
            scrollButtonClick
        },
    }
    tinsert(page.childs[1].widgets, scrollItem)
    tinsert(page.childs, entry)
end

addEntryToScroll('General', generalEntry)
addCheckboxTo(generalEntry.childs[ #generalEntry.childs ], subModules)

addEntryToScroll('Font', fontEntry)
addEntryToScroll('Tags', healthEntry)
addEntryToScroll('Health', healthEntry)

for _, mod in ipairs(subModules) do
    addEntryToScroll(mod, nil)
end

for _, f in ipairs(playerFonts) do
    addFontSubFrame(f)
end
--addEntryToScroll('Power', powerEntry)

Install:RegisterModule('Player', page)
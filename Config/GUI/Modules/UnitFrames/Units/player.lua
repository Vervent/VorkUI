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

local scrollButtonClick = function(self)
    local container = self:GetParent()
    local parent = container:GetParent()
    local txt = self:GetText()..'Settings' or ''
    for i, c in ipairs(parent.Childs) do
        if i > 1 then
            if c:GetName() == txt then
                c:Show()
            else
                c:Hide()
            end
        end
    end
end

local function getPath(...)
    local res = {
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
                size = { 100, 490 },
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
        name = 'GeneralSettings',
        size = { 654, 490 },
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
                size = { 435, 90},
                point = { 'TOPLEFT', 210, -30 },
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
                        size = { 105, 25 },
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
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 110, -15 },
                        dboption = getPath('Point', 1)
                    },
                    data = dropdownAnchorData,
                }, --LOCAL ANCHOR DROPDOWN
                {
                    type = 'label',
                    params = {
                        size = { 105, 25 },
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
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 110, -45 },
                        dboption = getPath('Point', 3)
                    },
                    data = dropdownAnchorData,
                }, --PARENT ANCHOR DROPDOWN
                { --X-OFFSET
                    type = 'label',
                    params = {
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 235, -15 }
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
                        point = { 'TOPLEFT', 345, -15 },
                        template = 'NumericInputSpinnerTemplate',
                        dboption = getPath('Point', 4)
                    },
                    data = { nil, nil, nil, {-250, 250} }
                }, --X-OFFSET EDITBOX
                {
                    type = 'label',
                    params = {
                        size = { 100, 25 },
                        point = { 'TOPLEFT', 235, -45 }
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
                        point = { 'TOPLEFT', 345, -45 },
                        template = 'NumericInputSpinnerTemplate',
                        dboption = getPath('Point', 5)
                    },
                    data = { nil, nil, nil, {-250, 250} }
                }, --Y-OFFSET EDITBOX
            },
            childs = {}
        }, -- SUBFRAME POSITION
        {
            type = 'empty',
            params = {
                name = 'PlayerSubmodule',
                size = { 645, 250},
                point = { 'TOPLEFT', 0, -132 },
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
    'Name',
    --'RôleIndicator', --TODO ADD ROLEINDICATOR
}

local function addCheckBox(parent, name)

    local box = {
        type = 'checkbox',
        params = {
            name = name..'SubmoduleCheckbox',
            size = { 25, 25 },
            point = { "TOPLEFT", 2, -2 },
            template = 'UICheckButtonTemplate',
            dboption = getPath(name..'Submodule')
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
            size = { 100, 25 },
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
addCheckboxTo(generalEntry.childs[3], subModules)

addEntryToScroll('Fonts', healthEntry)
addEntryToScroll('Health', healthEntry)
addEntryToScroll('Power', powerEntry)

Install:RegisterModule('Player', page)
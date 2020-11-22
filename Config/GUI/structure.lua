local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()

local Install = V.Install

local LibGUI = Plugin.LibGUI

local mainPage = {
    params = {
        name = 'MainPage',
        title = 'Home',
        headerSize = { 100, 25 },
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
                'Game18Font',
                'Welcome to Vorkui'
            },
        },
        {
            type = 'label',
            params = {
                size = { 400, 500 },
                point = { 'TOP' },
            },
            data = {
                'OVERLAY',
                'Game12Font_o1',
                [[Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum...
                Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum...
                Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum...
                Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum...
                Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum... Lorem ipsum...]]
            },
        }
    ,
        {
            type = 'label',
            params = {
                size = { 400, 50 },
                point = { 'BOTTOM', 0, 10 },
            },
            data = {
                'OVERLAY',
                'Game15Font',
                [[Thank you everyone, special thanks to Keivamp for his help and All Nasa's Family :)]]
            },
        }
    },
}




local modulePage = {
    params = {
        name = 'ModulePage',
        title = 'Modules',
        headerSize = { 100, 25 },
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
                'Active or Disable Modules'
            },
        },
        {
            type = 'checkbox',
            params = {
                name = 'CHECKBOX',
                --size = { 25, 25 },
                point = {'CENTER'},
                template = 'UICheckButtonTemplate',
            },
            data = {
                'Unit Frame',
            },
        }
    },
}

--UICheckButtonTemplate

local unitFramePage = {
    params = {
        name = 'UnitFramePage',
        title = 'Unit Frame',
        headerSize = { 100, 25 },
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
                'Unit Frame Options'
            },
        }
    },
    childs = {
        {
            type = 'scrolluniformlist',
            params = {
                name = 'ScrollList',
                size = { 100, 490 },
                point = { 'TOPLEFT', 2, -30 },
            },
            widgets = {
                {
                    type = 'widget',
                    subtype = 'button',
                    params = {
                        size = { 100, 25 },
                        template = 'UIPanelButtonTemplate',
                    },
                    data = {
                        'player',
                        function(self)
                            print(self)
                        end
                    },
                }
            }
        },
        {
            type = 'empty',
            params = {
                name = 'PlayerSettings',
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
                        'Player Settings'
                    },
                }
            },
            childs = {

            }
        }
    }
}

local config = {
    root = {
        type = 'frame',
        params = {
            parent = UIParent,
            name = 'VorkuiConfigUI',
            title = 'Vorkui Options',
            size = { 600, 600 },
            point = { 'CENTER' },
        },
        childs = {
            {
                type = 'tabframe',
                params = {
                    name = 'TabFrame',
                    size = { 600, 570 },
                    point = { 'TOP', 0, -30 }
                },
                pages = {
                    mainPage,
                    modulePage,
                    unitFramePage
                }
            },
        }
    }
}

local function parseEmpty(parent, frameconfig)

    local frame = LibGUI:NewContainer(
            frameconfig.type,
            parent,
            frameconfig.params.name,
            frameconfig.params.size,
            frameconfig.params.point
    )

    local item
    for _, w in ipairs(frameconfig.widgets) do
        item = LibGUI:NewWidget(w.type, frame, w.params.name, w.params.point, w.params.size, w.params.layer or w.params.template)
        item:Update(w.data)
    end
end

local function parseScrollUniformList(parent, scrollconfig)

    local scroll = LibGUI:NewContainer(
            'scrolluniformlist',
            parent,
            scrollconfig.params.name,
            scrollconfig.params.size,
            scrollconfig.params.point
    )

    for _, w in ipairs(scrollconfig.widgets) do
        scroll:AddWidget(
                w.type,
                w.subtype,
                w.params.size,
                w.data,
                w.params.layer or w.params.template
        )
    end
    scroll:CreateWidgets()

end

local function parsePage(tabParent, page)
    local header, content = tabParent:AddEmptyPage(page.params.name, page.params.headerSize)
    header:ChangeText(page.params.title)
    local item

    if page.widgets then
        for _, w in ipairs(page.widgets) do
            item = tabParent:AddWidgetToPage(content, w.type, w.params.name, w.params.point, w.params.size, w.params.layer or w.params.template)
            if w.data then
                item:Update(w.data)
            end
        end
    end

    if page.childs then
        for _, c in ipairs(page.childs) do
            if c.type == 'scrolluniformlist' then
                parseScrollUniformList(content, c)
            elseif c.type == 'empty' then
                parseEmpty(content, c)
            end
        end
    end

end

local function parseChild(parent, child)

    local c = LibGUI:NewContainer(
            child.type,
            parent,
            parent:GetName() .. child.params.name,
            child.params.size,
            child.params.point
    )

    if child.pages then
        for _, p in ipairs(child.pages) do
            parsePage(c, p)
        end
    end

end

local function parseConfig()
    local root = config.root

    Install.ConfigUI = LibGUI:NewContainer(root.type,
            root.params.parent,
            root.params.name,
            root.params.size,
            root.params.point,
            'BasicFrameTemplate'
    )
    Install.ConfigUI.TitleText:SetText(root.params.title)

    for _, v in ipairs(root.childs) do
        parseChild(Install.ConfigUI, v)
    end

end

function Install:RegisterOptions()
    parseConfig()

end

function Install:GetStructure()
    --return descriptor
end

--[[
    USEFUL BLIZZARD TEMPLATE

    FRAME
    BaseBasicFrameTemplate
    BasicFrameTemplate
    BasicFrameTemplateWithInset
    ThinBorderTemplate
    GlowBorderTemplate

    BUTTON
    UIPanelButtonTemplate
    GameMenuButtonTemplate
    UIServiceButtonTemplate
    UIPanelInfoButton
    UIPanelSquareButton
    UIPanelBorderedButtonTemplate
    UIPanelDynamicResizeButtonTemplate
    UIPanelCloseButtonNoScripts
    UIPanelHideButtonNoScripts
    UIPanelCloseButto

    EDITBOX
    NumericInputSpinnerTemplate
    InputBoxTemplate
    LargeInputBoxTemplate
    SharedEditBoxTemplate

    SCROLLFRAME
    ScrollListTemplate
    HybridScrollFrameTemplate
    FauxScrollFrameTemplate
    UIPanelScrollFrameTemplate
    UIPanelScrollFrameCodeTemplate

    CHECKBOX
    UIRadioButtonTemplate
    UICheckButtonTemplate
    ResizeCheckButtonTemplate

]]--
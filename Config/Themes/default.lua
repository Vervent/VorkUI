local V, C, L = select(2, ...):unpack()

if not V.Themes then
    V.Themes = {}
end

local Themes = V["Themes"]

Themes.Default = {
    UnitFrames = {
        Player = {
            Enable = true,
            Size = { 300, 62 },
            Point = { "CENTER", UIParent, "CENTER", -400, -250 },
            Config = {
                Absorb = {
                    Textures ={
                        {
                            "Bubbles", "ARTWORK"
                        },
                        {
                            {0,0,0,1}, "BACKGROUND", 1
                        }
                    },
                    Size = { 232, 8 },
                    Point = { "TOPRIGHT", "Frame", "TOPRIGHT", 0, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPLEFT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                    },
                },
                Health = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 256, 32 },
                    Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPRIGHT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor(false)][missinghp]"
                    },
                    Percent = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic30",
                        Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                        Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                    }
                },
                HealthPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 256, 32 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    }
                },
                Power = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Border", "BACKGROUND", 1
                        }
                    },
                    Size =  { 235, 10 },
                    Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -10, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic22",
                        Point = { "BOTTOM", nil, "BOTTOM" },
                        Tag = "[powercolor][missingpp]"
                    }
                },
                PowerPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 235, 10 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true
                    }
                },
                Portrait = {
                    Type = "3D",
                    Size = {49, 49},
                    Point = {"TOPLEFT", nil, "TOPLEFT" },
                    ModelDrawLayer = "BACKGROUND",
                    PostUpdate =
                    {
                        Position = { 0.2, 0, 0 },
                        Rotation = - math.pi/5,
                        CamDistance = 2
                    }
                },
                ClassIndicator = {
                    Size = {16, 16},
                    Point = { "TOPLEFT", nil, "TOPRIGHT", -4, -2 },
                    Texture = "ClassIcon",
                    TexCoord = select(2, UnitClass("player"))
                },
                RaidIndicator = {
                    Size = { 16, 16 },
                    Point = { "LEFT", nil, "LEFT", 10, 0 },
                    Texture = "RaidIcon"
                },
                LeaderIndicator = {
                    Size = { 64/4, 53/4 },
                    Point = { "RIGHT", nil, "LEFT" },
                    Texture = "GlobalIcon",
                    TexCoord = "LEADER",
                    VertexColor = { 163/255, 220/255, 255/255 }
                },
                RestingIndicator = {
                    Size = { 64/3, 60/3 },
                    Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                    Texture = "GlobalIcon",
                    TexCoord = "RESTING",
                    GradientAlpha = { "VERTICAL", 163/255, 220/255, 255/255, 0.75, 0, 0, 0, 1 },
                    BlendMode = "ADD"
                },
                CombatIndicator = {
                    Size = { 39/3, 64/3 },
                    Point = { "BOTTOMRIGHT", nil, "TOPRIGHT" },
                    Texture = "GlobalIcon",
                    TexCoord = "MAELSTROM",
                    GradientAlpha = { "VERTICAL", 255/255, 246/255, 0/255, 0.75, 255/255, 50/255, 0/255, 1 },
                    BlendMode = "ADD"
                },
                Name = {
                    Layer = "OVERLAY",
                    FontName = "Montserrat14",
                    Point = { "TOPLEFT", nil, "BOTTOMLEFT", 20, 10 },
                    Tag = "[classification] [name] [difficulty][level]"
                },
                CastBar = {
                    Textures = {
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 300, 20 },
                    Point =  { "TOP", nil, "BOTTOM", 0, -2 },
                    StatusBarColor = { 0, 0.5, 1, 1 },
                    Spark = {
                        Layer = "OVERLAY",
                        Size = { 20, 20 },
                        BlendMode = "ADD",
                        CastSettings = {
                            AtlasName = 'Muzzle',
                            Point = {'RIGHT', nil, 'RIGHT', 5, 0},
                        },
                        ChannelSettings = {
                            AtlasName = 'Spark',
                            Point = { 'CENTER', nil, 'RIGHT', 0, 0 },
                        }
                    },
                    Time = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'RIGHT', nil}
                    },
                    Text = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'CENTER', nil}
                    },
                    Icon = {
                        Size = {20, 20},
                        Point = {'TOPLEFT', nil, 'TOPLEFT'}
                    },
                    Shield = {
                        Texture = 'GlobalIcon',
                        TexCoord = 'DEFENSE',
                        Size = {20, 20},
                        Point = {'CENTER', nil}
                    },
                    SafeZone = {
                        Layer = "OVERLAY",
                        BlendMode = "ADD",
                        VertexColor = {255/255, 246/255, 0, 0.75}
                    }
                }
            }
        },
        Pet = {
            Enable = true,
            Size = { 190, 31 },
            Point = { "TOPLEFT", UIParent, "BOTTOMLEFT", 0, -25 },
            Config = {
                Absorb = {
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPLEFT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                    },
                },
                Health = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 156, 16 },
                    Point =  { "TOPRIGHT", "Frame", "TOPRIGHT", 0, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPRIGHT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor(false)][missinghp]"
                    },
                    Percent = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic22",
                        Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                        Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                    }
                },
                HealthPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 156, 16 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    }
                },
                Power = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Border", "BACKGROUND", 1
                        }
                    },
                    Size =  { 145, 4 },
                    Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -4, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    },
                    StaticLayer = "BACKGROUND",
                    --Value = {
                    --    Layer = "OVERLAY",
                    --    FontName = "Montserrat Italic22",
                    --    Point = { "BOTTOM", nil, "BOTTOM" },
                    --    Tag = "[powercolor][missingpp]"
                    --}
                },
                PowerPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 145, 4 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true
                    }
                },
                Portrait = {
                    Type = "3D",
                    Size = {31, 31},
                    Point = {"TOPLEFT", nil, "TOPLEFT" },
                    ModelDrawLayer = "BACKGROUND",
                    PostUpdate =
                    {
                        Position = { 0.2, 0, 0 },
                        Rotation = - math.pi/5,
                        CamDistance = 2
                    }
                },
                RaidIndicator = {
                    Size = { 16, 16 },
                    Point = { "LEFT", nil, "LEFT", 10, 0 },
                    Texture = "RaidIcon"
                },
                Name = {
                    Layer = "OVERLAY",
                    FontName = "Montserrat14",
                    Point = { "TOPLEFT", nil, "BOTTOMLEFT", 23, 10 },
                    Tag = "[classification] [name] [difficulty][level]"
                },
                CastBar = {
                    Textures = {
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 190, 16 },
                    Point =  { "TOP", nil, "BOTTOM", 0, -2 },
                    StatusBarColor = { 0, 0.5, 1, 1 },
                    Spark = {
                        Layer = "OVERLAY",
                        Size = { 16, 16 },
                        BlendMode = "ADD",
                        CastSettings = {
                            AtlasName = 'Muzzle',
                            Point = {'RIGHT', nil, 'RIGHT', 5, 0},
                        },
                        ChannelSettings = {
                            AtlasName = 'Spark',
                            Point = { 'CENTER', nil, 'RIGHT', 0, 0 },
                        }
                    },
                    Time = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'RIGHT', nil}
                    },
                    Text = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'CENTER', nil}
                    },
                    Icon = {
                        Size = {16, 16},
                        Point = {'TOPLEFT', nil, 'TOPLEFT'}
                    },
                    --Shield = {
                    --    Texture = 'GlobalIcon',
                    --    TexCoord = 'DEFENSE',
                    --    Size = {10, 10},
                    --    Point = {'CENTER', nil}
                    --},
                    SafeZone = {
                        Layer = "OVERLAY",
                        BlendMode = "ADD",
                        VertexColor = {255/255, 246/255, 0, 0.75}
                    }
                }
            }
        },
        Target = {
            Enable = true,
            Size = { 300, 62 },
            Point = { "CENTER", UIParent, "CENTER", 400, -250 },
            Config = {
                Absorb = {
                    Textures ={
                        {
                            "Bubbles", "ARTWORK"
                        },
                        {
                            {0,0,0,1}, "BACKGROUND", 1
                        }
                    },
                    Size = { 232, 8 },
                    Point = { "TOPLEFT", "Frame", "TOPLEFT", 0, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPRIGHT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                    },
                },
                Health = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 256, 32 },
                    Point =  { "TOPLEFT", "Absorb", "BOTTOMLEFT", 8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPLEFT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp-Max]"
                    },
                    Percent = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic30",
                        Point = { "BOTTOMLEFT", nil, "BOTTOMLEFT" },
                        Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                    }
                },
                HealthPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 256, 32 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    }
                },
                Power = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Border", "BACKGROUND", 1
                        }
                    },
                    Size =  { 235, 10 },
                    Point =  { "TOPRIGHT", "Health", "BOTTOMRIGHT", 10, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic22",
                        Point = { "BOTTOM", nil, "BOTTOM" },
                        Tag = "[powercolor][missingpp]"
                    }
                },
                PowerPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 235, 10 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true,
                        ["Inverse"] = true
                    }
                },
                Portrait = {
                    Type = "3D",
                    Size = {49, 49},
                    Point = {"TOPRIGHT", nil, "TOPRIGHT" },
                    ModelDrawLayer = "BACKGROUND",
                    PostUpdate =
                    {
                        Position = { 0.1, 0, 0 },
                        Rotation = -math.pi/5,
                        CamDistance = 2
                    }
                },
                ClassIndicator = {
                    Size = {16, 16},
                    Point = { "TOPRIGHT", nil, "TOPLEFT", 4, -2 },
                    Texture = "ClassIcon",
                    TexCoord = select(2, UnitClass("player"))
                },
                RaidIndicator = {
                    Size = { 16, 16 },
                    Point = { "RIGHT", nil, "RIGHT", -10, 0 },
                    Texture = "RaidIcon"
                },
                LeaderIndicator = {
                    Size = { 64/4, 53/4 },
                    Point = { "LEFT", nil, "RIGHT" },
                    Texture = "GlobalIcon",
                    TexCoord = "LEADER",
                    VertexColor = { 163/255, 220/255, 255/255 }
                },
                Name = {
                    Layer = "OVERLAY",
                    FontName = "Montserrat14",
                    Point = { "TOPRIGHT", nil, "BOTTOMRIGHT", -20, 10 },
                    Tag = "[level][difficulty] [name] [classification]"
                },
                CastBar = {
                    Textures = {
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 300, 20 },
                    Point =  { "TOP", nil, "BOTTOM", 0, -2 },
                    StatusBarColor = { 0, 0.5, 1, 1 },
                    Spark = {
                        Layer = "OVERLAY",
                        Size = { 20, 20 },
                        BlendMode = "ADD",
                        CastSettings = {
                            AtlasName = 'Muzzle',
                            Point = {'LEFT', nil, 'LEFT', -5, 0},
                        },
                        ChannelSettings = {
                            AtlasName = 'Spark',
                            Point = { 'CENTER', nil, 'LEFT', 0, 0 },
                        }
                    },
                    Time = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'LEFT', nil}
                    },
                    Text = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'CENTER', nil}
                    },
                    Icon = {
                        Size = {20, 20},
                        Point = {'TOPRIGHT', nil, 'TOPRIGHT'}
                    },
                    Shield = {
                        Texture = 'GlobalIcon',
                        TexCoord = 'DEFENSE',
                        VertexColor = { 163/255, 220/255, 255/255 },
                        Size = {16, 16},
                        Point = {'LEFT', nil}
                    },
                    SafeZone = {
                        Layer = "OVERLAY",
                        BlendMode = "ADD",
                        VertexColor = {255/255, 246/255, 0, 0.75}
                    },
                    ReverseFill = true
                }
            }
        },
        TargetTarget = {
            Enable = true,
            Size = { 200, 31 },
            Point = { "LEFT", UIParent, "CENTER", 560, -250 },
            Config = {
                Absorb = {
                    Textures ={
                        {
                            "Bubbles", "ARTWORK"
                        },
                        {
                            {0,0,0,1}, "BACKGROUND", 1
                        }
                    },
                    Size = { 145, 4 },
                    Point = { "TOPLEFT", "Frame", "TOPLEFT", 0, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPRIGHT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                    },
                },
                Health = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 156, 16 },
                    Point =  { "TOPLEFT", "Absorb", "BOTTOMLEFT", 4, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPLEFT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp-Max]"
                    },
                    Percent = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic22",
                        Point = { "BOTTOMLEFT", nil, "BOTTOMLEFT" },
                        Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                    }
                },
                HealthPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 156, 16 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    }
                },
                Portrait = {
                    Type = "3D",
                    Size = {31, 31},
                    Point = {"TOPRIGHT", nil, "TOPRIGHT" },
                    ModelDrawLayer = "BACKGROUND",
                    PostUpdate =
                    {
                        Position = { 0.1, 0, 0 },
                        Rotation = -math.pi/5,
                        CamDistance = 2
                    }
                },
                ClassIndicator = {
                    Size = {16, 16},
                    Point = { "TOPRIGHT", nil, "TOPLEFT", 4, -2 },
                    Texture = "ClassIcon",
                    TexCoord = select(2, UnitClass("player"))
                },
                RaidIndicator = {
                    Size = { 16, 16 },
                    Point = { "RIGHT", nil, "RIGHT", -10, 0 },
                    Texture = "RaidIcon"
                },
                Name = {
                    Layer = "OVERLAY",
                    FontName = "Montserrat14",
                    Point = { "TOPRIGHT", nil, "BOTTOMRIGHT", -20, 10 },
                    Tag = "[level][difficulty] [name] [classification]"
                },
            }
        },
        Focus = {
            Enable = true,
            Size = { 300, 62 },
            Point = { "CENTER", UIParent, "CENTER", -400, 0 },
            Config = {
                Absorb = {
                    Textures ={
                        {
                            "Bubbles", "ARTWORK"
                        },
                        {
                            {0,0,0,1}, "BACKGROUND", 1
                        }
                    },
                    Size = { 232, 8 },
                    Point = { "TOPRIGHT", "Frame", "TOPRIGHT", 0, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPLEFT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                    },
                },
                Health = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 256, 32 },
                    Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPRIGHT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp-Max]"
                    },
                    Percent = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic30",
                        Point = { "BOTTOMLEFT", nil, "BOTTOMLEFT" },
                        Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                    }
                },
                HealthPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 256, 32 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    }
                },
                Power = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Border", "BACKGROUND", 1
                        }
                    },
                    Size =  { 235, 10 },
                    Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -10, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic22",
                        Point = { "BOTTOM", nil, "BOTTOM" },
                        Tag = "[powercolor][missingpp]"
                    }
                },
                PowerPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 235, 10 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true,
                    }
                },
                Portrait = {
                    Type = "3D",
                    Size = {49, 49},
                    Point = {"TOPLEFT", nil, "TOPLEFT" },
                    ModelDrawLayer = "BACKGROUND",
                    PostUpdate =
                    {
                        Position = { 0.1, 0, 0 },
                        Rotation = -math.pi/5,
                        CamDistance = 2
                    }
                },
                ClassIndicator = {
                    Size = {16, 16},
                    Point = { "TOPLEFT", nil, "TOPRIGHT", -4, -2 },
                    Texture = "ClassIcon",
                    TexCoord = select(2, UnitClass("player"))
                },
                RaidIndicator = {
                    Size = { 16, 16 },
                    Point = { "LEFT", nil, "LEFT", 10, 0 },
                    Texture = "RaidIcon"
                },
                LeaderIndicator = {
                    Size = { 64/4, 53/4 },
                    Point = { "RIGHT", nil, "LEFT" },
                    Texture = "GlobalIcon",
                    TexCoord = "LEADER",
                    VertexColor = { 163/255, 220/255, 255/255 }
                },
                Name = {
                    Layer = "OVERLAY",
                    FontName = "Montserrat14",
                    Point = { "TOPLEFT", nil, "BOTTOMLEFT", 20, 10 },
                    Tag = "[level][difficulty] [name] [classification]"
                },
                CastBar = {
                    Textures = {
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 300, 20 },
                    Point =  { "TOP", nil, "BOTTOM", 0, -2 },
                    StatusBarColor = { 0, 0.5, 1, 1 },
                    Spark = {
                        Layer = "OVERLAY",
                        Size = { 20, 20 },
                        BlendMode = "ADD",
                        CastSettings = {
                            AtlasName = 'Muzzle',
                            Point = {'RIGHT', nil, 'RIGHT', 5, 0},
                        },
                        ChannelSettings = {
                            AtlasName = 'Spark',
                            Point = { 'CENTER', nil, 'RIGHT', 0, 0 },
                        }
                    },
                    Time = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'RIGHT', nil}
                    },
                    Text = {
                        Layer = "OVERLAY",
                        FontName = 'Montserrat Medium10',
                        Point = {'CENTER', nil}
                    },
                    Icon = {
                        Size = {20, 20},
                        Point = {'TOPLEFT', nil, 'TOPLEFT'}
                    },
                    Shield = {
                        Texture = 'GlobalIcon',
                        TexCoord = 'DEFENSE',
                        Size = {20, 20},
                        Point = {'CENTER', nil}
                    },
                    SafeZone = {
                        Layer = "OVERLAY",
                        BlendMode = "ADD",
                        VertexColor = {255/255, 246/255, 0, 0.75}
                    }
                }
            }
        },
        FocusTarget = {
            Enable = true,
            Size = { 200, 31 },
            Point = { "CENTER", UIParent, "CENTER", -140, 0 },
            Config = {
                Absorb = {
                    Textures ={
                        {
                            "Bubbles", "ARTWORK"
                        },
                        {
                            {0,0,0,1}, "BACKGROUND", 1
                        }
                    },
                    Size = { 145, 4 },
                    Point = { "TOPLEFT", "Frame", "TOPLEFT", 0, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["FillInverse"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPRIGHT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                    },
                },
                Health = {
                    Textures ={
                        {
                            "Default", "ARTWORK"
                        },
                        {
                            "Background", "BACKGROUND", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 156, 16 },
                    Point =  { "TOPLEFT", "Absorb", "BOTTOMLEFT", 4, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    },
                    StaticLayer = "BACKGROUND",
                    Value = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic14",
                        Point = { "TOPLEFT", nil, "TOP" },
                        Tag = "[Vorkui:HealthColor(false)][Vorkui:Deficit:Curhp-Max]"
                    },
                    Percent = {
                        Layer = "OVERLAY",
                        FontName = "Montserrat Italic22",
                        Point = { "BOTTOMLEFT", nil, "BOTTOMLEFT" },
                        Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                    }
                },
                HealthPrediction = {
                    Textures ={
                        {
                            "Default", "ARTWORK", 1
                        },
                        {
                            "Border", "OVERLAY"
                        }
                    },
                    Size =  { 156, 16 },
                    --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                    SlantSettings = {
                        ["IgnoreBackground"] = true,
                        ["Inverse"] = true
                    }
                },
                Portrait = {
                    Type = "3D",
                    Size = {31, 31},
                    Point = {"TOPRIGHT", nil, "TOPRIGHT" },
                    ModelDrawLayer = "BACKGROUND",
                    PostUpdate =
                    {
                        Position = { 0.1, 0, 0 },
                        Rotation = -math.pi/5,
                        CamDistance = 2
                    }
                },
                ClassIndicator = {
                    Size = {16, 16},
                    Point = { "TOPRIGHT", nil, "TOPLEFT", 4, -2 },
                    Texture = "ClassIcon",
                    TexCoord = select(2, UnitClass("player"))
                },
                RaidIndicator = {
                    Size = { 16, 16 },
                    Point = { "RIGHT", nil, "RIGHT", -10, 0 },
                    Texture = "RaidIcon"
                },
                Name = {
                    Layer = "OVERLAY",
                    FontName = "Montserrat14",
                    Point = { "TOPRIGHT", nil, "BOTTOMRIGHT", -20, 10 },
                    Tag = "[level][difficulty] [name] [classification]"
                },
            }
        },
        Party = {
            Enable = true,
            Config = {
                Header = {
                    Name = "VorkuiParty",
                    Template = nil,
                    Visibility = "custom [@raid6,exists] hide;show",
                    InitialConfigFunction = [[
                    local header = self:GetParent()
                    self:SetWidth(header:GetAttribute("initial-width"))
                    self:SetHeight(header:GetAttribute("initial-height"))
                    ]],
                },
                Expanded = {
                    Attributes = {
                        ["initial-width"] = 190,
                        ["initial-height"] = 58,
                        showRaid = false,
                        showParty = true,
                        showPlayer = true,
                        showSolo = false,
                        groupFilter = "1,2,3,4,5,6,7,8",
                        point = "LEFT",
                        xOffset = 2,
                        yOffset = 0,
                        sortMethod = "INDEX",
                        sortDir = "ASC",
                        groupBy = "GROUP",
                        groupingOrder = "1,2,3,4,5,6,7,8",
                    },
                    Unit = {
                        Absorb = {
                            Textures ={
                                {
                                    "Bubbles", "ARTWORK"
                                },
                                {
                                    {0,0,0,1}, "BACKGROUND", 1
                                }
                            },
                            Size = { 114, 6 },
                            Point = { "TOPRIGHT", "Frame", "TOPRIGHT", 0, -16 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                                ["FillInverse"] = true
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "TOPLEFT", nil, "TOP" },
                                Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                            },
                        },
                        Health = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 128, 24 },
                            Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "TOPRIGHT", nil, "TOP" },
                                Tag = "[Vorkui:HealthColor(false)][missinghp]"
                            },
                            Percent = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic22",
                                Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                                Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                            }
                        },
                        HealthPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 128, 24 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            }
                        },
                        Power = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Border", "BACKGROUND", 1
                                }
                            },
                            Size =  { 117, 12 },
                            Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -12, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "BOTTOM", nil, "BOTTOM" },
                                Tag = "[powercolor][missingpp]"
                            }
                        },
                        PowerPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 117, 12 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                                ["FillInverse"] = true
                            }
                        },
                        Portrait = {
                            Type = "3D",
                            Size = {58, 58},
                            Point = {"TOPLEFT", nil, "TOPLEFT" },
                            ModelDrawLayer = "BACKGROUND",
                            PostUpdate =
                            {
                                Position = { 0.2, 0, 0 },
                                Rotation = - math.pi/5,
                                CamDistance = 2
                            }
                        },
                        ClassIndicator = {
                            Size = {16, 16},
                            Point = { "TOPLEFT", nil, "TOPRIGHT", -4, -2 },
                            Texture = "ClassIcon",
                            TexCoord = select(2, UnitClass("player"))
                        },
                        RaidIndicator = {
                            Size = { 16, 16 },
                            Point = { "LEFT", nil, "RIGHT"},
                            Texture = "RaidIcon"
                        },
                        LeaderIndicator = {
                            Size = { 64/4, 53/4 },
                            Point = { "TOP", nil, "BOTTOM" },
                            Texture = "GlobalIcon",
                            TexCoord = "LEADER",
                            VertexColor = { 163/255, 220/255, 255/255 }
                        },
                        Name = {
                            Layer = "OVERLAY",
                            FontName = "Montserrat Medium12",
                            Point = { "TOPRIGHT", nil, "TOPRIGHT", -20, 0 },
                            Tag = "[classification] [name] [difficulty][level]"
                        },
                        CastBar = {
                            Textures = {
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size = { 190, 20 },
                            Point = { "TOP", nil, "BOTTOM", 0, -2 },
                            StatusBarColor = { 0, 0.5, 1, 1 },
                            Spark = {
                                Layer = "OVERLAY",
                                Size = { 20, 20 },
                                BlendMode = "ADD",
                                CastSettings = {
                                    AtlasName = 'Muzzle',
                                    Point = { 'RIGHT', nil, 'RIGHT', 5, 0 },
                                },
                                ChannelSettings = {
                                    AtlasName = 'Spark',
                                    Point = { 'CENTER', nil, 'RIGHT', 0, 0 },
                                }
                            },
                            Time = {
                                Layer = "OVERLAY",
                                FontName = 'Montserrat Medium10',
                                Point = { 'RIGHT', nil }
                            },
                            Text = {
                                Layer = "OVERLAY",
                                FontName = 'Montserrat Medium10',
                                Point = { 'CENTER', nil }
                            },
                            Icon = {
                                Size = { 20, 20 },
                                Point = { 'TOPLEFT', nil, 'TOPLEFT' }
                            },
                            Shield = {
                                Texture = 'GlobalIcon',
                                TexCoord = 'DEFENSE',
                                Size = { 20, 20 },
                                Point = { 'CENTER', nil }
                            },
                            SafeZone = {
                                Layer = "OVERLAY",
                                BlendMode = "ADD",
                                VertexColor = { 255 / 255, 246 / 255, 0, 0.75 }
                            }
                        }
                    }
                },
                Minimalist = {
                    Attributes = {
                        ["initial-width"] = 150,
                        ["initial-height"] = 44,
                        showRaid = false,
                        showParty = true,
                        showPlayer = true,
                        showSolo = false,
                        groupFilter = "1,2,3,4,5,6,7,8",
                        point = "TOP",
                        xOffset = 1,
                        yOffset = -25,
                        sortMethod = "INDEX",
                        sortDir = "ASC",
                        groupBy = "GROUP",
                        groupingOrder = "1,2,3,4,5,6,7,8",
                    },
                    Unit = {
                        Absorb = {
                            Textures ={
                                {
                                    "Bubbles", "ARTWORK"
                                },
                                {
                                    {0,0,0,1}, "BACKGROUND", 1
                                }
                            },
                            Size = { 116, 6 },
                            Point = { "TOPRIGHT", "Frame", "TOPRIGHT", 0, -10 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                                ["FillInverse"] = true
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "TOPLEFT", nil, "TOP" },
                                Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                            },
                        },
                        Health = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 126, 16 },
                            Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -4, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "TOPRIGHT", nil, "TOP" },
                                Tag = "[Vorkui:HealthColor(false)][missinghp]"
                            },
                            Percent = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic22",
                                Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                                Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                            }
                        },
                        HealthPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 126, 16 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            }
                        },
                        Power = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Border", "BACKGROUND", 1
                                }
                            },
                            Size =  { 118, 8 },
                            Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                        },
                        PowerPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 118, 8 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                                ["FillInverse"] = true
                            }
                        },
                        ClassIndicator = {
                            Size = {16, 16},
                            Point = { "TOPLEFT", nil, "TOPLEFT", 4, -2 },
                            Texture = "ClassIcon",
                            TexCoord = select(2, UnitClass("player"))
                        },
                        RaidIndicator = {
                            Size = { 16, 16 },
                            Point = { "LEFT", nil, "RIGHT", 2, 0},
                            Texture = "RaidIcon"
                        },
                        LeaderIndicator = {
                            Size = { 64/4, 53/4 },
                            Point = { "TOP", nil, "BOTTOM" },
                            Texture = "GlobalIcon",
                            TexCoord = "LEADER",
                            VertexColor = { 163/255, 220/255, 255/255 }
                        },
                        Name = {
                            Layer = "OVERLAY",
                            FontName = "Montserrat Medium12",
                            Point = { "TOPRIGHT", nil, "TOPRIGHT", -20, 0 },
                            Tag = "[classification] [name] [difficulty][level]"
                        },
                        CastBar = {
                            Textures = {
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size = { 150, 20 },
                            Point = { "TOP", nil, "BOTTOM", 0, -2 },
                            StatusBarColor = { 0, 0.5, 1, 1 },
                            Spark = {
                                Layer = "OVERLAY",
                                Size = { 20, 20 },
                                BlendMode = "ADD",
                                CastSettings = {
                                    AtlasName = 'Muzzle',
                                    Point = { 'RIGHT', nil, 'RIGHT', 5, 0 },
                                },
                                ChannelSettings = {
                                    AtlasName = 'Spark',
                                    Point = { 'CENTER', nil, 'RIGHT', 0, 0 },
                                }
                            },
                            Time = {
                                Layer = "OVERLAY",
                                FontName = 'Montserrat Medium10',
                                Point = { 'RIGHT', nil }
                            },
                            Text = {
                                Layer = "OVERLAY",
                                FontName = 'Montserrat Medium10',
                                Point = { 'CENTER', nil }
                            },
                            Icon = {
                                Size = { 20, 20 },
                                Point = { 'TOPLEFT', nil, 'TOPLEFT' }
                            },
                            Shield = {
                                Texture = 'GlobalIcon',
                                TexCoord = 'DEFENSE',
                                Size = { 20, 20 },
                                Point = { 'CENTER', nil }
                            },
                            SafeZone = {
                                Layer = "OVERLAY",
                                BlendMode = "ADD",
                                VertexColor = { 255 / 255, 246 / 255, 0, 0.75 }
                            }
                        }
                    }
                },
                Compact = {
                    Attributes = {
                        ["initial-width"] = 128,
                        ["initial-height"] = 24,
                        showRaid = false,
                        showParty = true,
                        showPlayer = true,
                        showSolo = false,
                        groupFilter = "1,2,3,4,5,6,7,8",
                        point = "TOP",
                        xOffset = 1,
                        yOffset = -1,
                        sortMethod = "INDEX",
                        sortDir = "ASC",
                        groupBy = "GROUP",
                        groupingOrder = "1,2,3,4,5,6,7,8",
                    },
                    Unit = {
                        Health = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 128, 24 },
                            Point =  { "TOPRIGHT", "Absorb", "TOPRIGHT", 0, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "CENTER", nil, "CENTER" },
                                Tag = "[Vorkui:HealthColor(false)][missinghp]"
                            },
                            Percent = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic22",
                                Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                                Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                            }
                        },
                        HealthPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 128, 24 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            }
                        },
                        ClassIndicator = {
                            Size = {16, 16},
                            Point = { "LEFT", nil, "LEFT" },
                            Texture = "ClassIcon",
                            TexCoord = select(2, UnitClass("player"))
                        },
                        RaidIndicator = {
                            Size = { 16, 16 },
                            Point = { "RIGHT", nil, "LEFT"},
                            Texture = "RaidIcon"
                        },
                        LeaderIndicator = {
                            Size = { 64/6, 53/6 },
                            Point = { "LEFT", nil, "RIGHT", 2, 0 },
                            Texture = "GlobalIcon",
                            TexCoord = "LEADER",
                            VertexColor = { 163/255, 220/255, 255/255 }
                        },
                        Name = {
                            Layer = "OVERLAY",
                            FontName = "Montserrat Medium12",
                            Point = { "LEFT", nil, "RIGHT", 20, 0 },
                            Tag = "[classification] [name] [difficulty][level]"
                        },
                    }
                }
            }
        },
        Raid = {
            Enable = true,
            Config = {
                Header = {
                    Name = "VorkuiRaid",
                    Template = nil,
                    Visibility = "custom [@raid6,exists] show; hide",
                    InitialConfigFunction = [[
                    local header = self:GetParent()
                    self:SetWidth(header:GetAttribute("initial-width"))
                    self:SetHeight(header:GetAttribute("initial-height"))
                    ]],
                },
                Minimalist = {
                    Attributes = {
                        ["initial-width"] = 150,
                        ["initial-height"] = 46,
                        showRaid = true,
                        showParty = false,
                        showPlayer = true,
                        showSolo = false,
                        groupFilter = "1,2,3,4,5,6,7,8",
                        point = "BOTTOM",
                        xOffset = 1,
                        yOffset = 1,
                        sortMethod = "INDEX",
                        sortDir = "ASC",
                        groupBy = "GROUP",
                        groupingOrder = "1,2,3,4,5,6,7,8",
                        unitsPerColumn = 5,
                        columnSpacing = 4,
                        columnAnchorPoint = "LEFT"
                    },
                    Unit = {
                        Absorb = {
                            Textures ={
                                {
                                    "Bubbles", "ARTWORK"
                                },
                                {
                                    {0,0,0,1}, "BACKGROUND", 1
                                }
                            },
                            Size = { 116, 6 },
                            Point = { "TOPRIGHT", "Frame", "TOPRIGHT", 0, -12 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                                ["FillInverse"] = true
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "TOPLEFT", nil, "TOP" },
                                Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                            },
                        },
                        Health = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 126, 16 },
                            Point =  { "TOPRIGHT", "Absorb", "BOTTOMRIGHT", -4, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "TOPRIGHT", nil, "TOP" },
                                Tag = "[Vorkui:HealthColor(false)][missinghp]"
                            },
                            Percent = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic16",
                                Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                                Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                            }
                        },
                        HealthPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 126, 16 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            }
                        },
                        Power = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Border", "BACKGROUND", 1
                                }
                            },
                            Size =  { 118, 8 },
                            Point =  { "TOPLEFT", "Health", "BOTTOMLEFT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                        },
                        PowerPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 118, 8 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                                ["FillInverse"] = true
                            }
                        },
                        ClassIndicator = {
                            Size = {16, 16},
                            Point = { "TOPLEFT", nil, "TOPLEFT", 4, -2 },
                            Texture = "ClassIcon",
                            TexCoord = select(2, UnitClass("player"))
                        },
                        RaidIndicator = {
                            Size = { 16, 16 },
                            Point = { "LEFT", nil, "RIGHT", 2, 0},
                            Texture = "RaidIcon"
                        },
                        LeaderIndicator = {
                            Size = { 64/4, 53/4 },
                            Point = { "TOP", nil, "BOTTOM" },
                            Texture = "GlobalIcon",
                            TexCoord = "LEADER",
                            VertexColor = { 163/255, 220/255, 255/255 }
                        },
                        Name = {
                            Layer = "OVERLAY",
                            FontName = "Montserrat Medium12",
                            Point = { "TOPRIGHT", nil, "TOPRIGHT", -20, 0 },
                            Tag = "[classification] [name] [difficulty][level]"
                        },
                    }
                },
                Compact = {
                    Attributes = {
                        ["initial-width"] = 128,
                        ["initial-height"] = 24,
                        showRaid = true,
                        showParty = false,
                        showPlayer = true,
                        showSolo = false,
                        groupFilter = "1,2,3,4,5,6,7,8",
                        point = "BOTTOM",
                        xOffset = 1,
                        yOffset = 1,
                        sortMethod = "INDEX",
                        sortDir = "ASC",
                        groupBy = "GROUP",
                        groupingOrder = "1,2,3,4,5,6,7,8",
                        unitsPerColumn = 10,
                        columnSpacing = 4,
                        columnAnchorPoint = "LEFT"
                    },
                    Unit = {
                        Absorb = {
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "LEFT", nil, "CENTER" },
                                Tag = "[Vorkui:HealthColor][Vorkui:Absorb]"
                            },
                        },
                        Health = {
                            Textures ={
                                {
                                    "Default", "ARTWORK"
                                },
                                {
                                    "Background", "BACKGROUND", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 128, 12 },
                            Point =  { "TOPRIGHT", "Absorb", "TOPRIGHT", 0, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            },
                            StaticLayer = "BACKGROUND",
                            Value = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic10",
                                Point = { "RIGHT", nil, "CENTER" },
                                Tag = "[Vorkui:HealthColor(false)][missinghp]"
                            },
                            Percent = {
                                Layer = "OVERLAY",
                                FontName = "Montserrat Medium Italic16",
                                Point = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT" },
                                Tag = "[Vorkui:HealthColor(true)][Vorkui:PerHP]"
                            }
                        },
                        HealthPrediction = {
                            Textures ={
                                {
                                    "Default", "ARTWORK", 1
                                },
                                {
                                    "Border", "OVERLAY"
                                }
                            },
                            Size =  { 128, 12 },
                            --Point =  { "TOPRIGHT", nil, "BOTTOMRIGHT", -8, 0 },
                            SlantSettings = {
                                ["IgnoreBackground"] = true,
                            }
                        },
                        ClassIndicator = {
                            Size = {12, 12},
                            Point = { "BOTTOMLEFT", nil, "BOTTOMLEFT" },
                            Texture = "ClassIcon",
                            TexCoord = select(2, UnitClass("player"))
                        },
                        RaidIndicator = {
                            Size = { 16, 16 },
                            Point = { "RIGHT", nil, "LEFT"},
                            Texture = "RaidIcon"
                        },
                        LeaderIndicator = {
                            Size = { 64/6, 53/6 },
                            Point = { "BOTTOM", nil, "TOP", 0, 2 },
                            Texture = "GlobalIcon",
                            TexCoord = "LEADER",
                            VertexColor = { 163/255, 220/255, 255/255 }
                        },
                        Name = {
                            Layer = "OVERLAY",
                            FontName = "Montserrat Medium12",
                            Point = { "BOTTOM", nil, "BOTTOM" },
                            Tag = "[Vorkui:Name(5)] [difficulty][level]"
                        },
                    }
                }
            }
        },
    }
}

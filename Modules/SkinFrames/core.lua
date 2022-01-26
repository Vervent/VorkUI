local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local DebugFrames = V['DebugFrames']
local SkinFrames = V['SkinFrames']

local skins = {}

function SkinFrames:Enable()
    for _, skin in pairs(skins) do
        skin.Enable(skin)
    end
end

function SkinFrames:EnableSkin(frame)
    if skins[frame] then
        skins[frame].Enable(skins[frame])
    else
        DebugFrames:LogInfo(debugstack())
        DebugFrames:LogError(frame, 'not exists in the Skin Table')
    end
end

function SkinFrames:DisableSkin(frame)

    if skins[frame] then
        skins[frame].Disable(skins[frame])
    else
        DebugFrames:LogInfo(debugstack())
        DebugFrames:LogError(frame, 'not exists in the Skin Table')
    end
end

function SkinFrames:RegisterSkin(frame, enableFct, disableFct)
    
    if not skins[frame] then
        skins[frame] = {
            Enable = enableFct or function()  end,
            Disable = disableFct or function()  end,
        }
    else
        DebugFrames:LogError(frame, 'exists yet in Skins Table')
    end
end

function SkinFrames:Disable()

    for _, skin in pairs(skins) do
        skin.Disable(skin)
    end

end
local select = select
local pairs = pairs

local V, C, L = select(2, ...):unpack()

local Module = V.Module
local DebugFrames = Module:GetModule('DebugFrames')
local SkinFrames = Module:RegisterModule('SkinFrames', false)


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

function SkinFrames:GetDebugNameFrames()
    local list = {}

    for frame, _ in pairs(skins) do

        if type(frame) == 'string' then
            tinsert(list, frame)
        elseif frame:GetObjectType() == 'Frame' then
            local name
            if frame.GetDebugName then
                name = frame:GetDebugName()
            else
                name = frame:GetName() or frame
            end

            tinsert(list, name)
        end
    end

    return list
end

function SkinFrames:GetFrames()
    local list = {}

    for frame, _ in pairs(skins) do
        tinsert(list, frame)
    end

    return list
end

function SkinFrames:Disable()

    for _, skin in pairs(skins) do
        skin.Disable(skin)
    end

end
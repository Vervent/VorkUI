local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local Module = V.Module
local DebugFrames = Module:RegisterModule('DebugFrames', false)

local ViragDevTool = _G['ViragDevTool']
function DebugFrames:Log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    else
        print (str, data)
    end
end

function DebugFrames:LogError(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, '|cFFFF0000'..(str or '')..'|r')
    else
        print ('|cFFFF0000'..(str or '')..'|r', data)
    end
end

function DebugFrames:LogWarning(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, '|cFFFFFF00'..(str or '')..'|r')
    else
        print ('|cFFFFFF00'..(str or '')..'|r', data)
    end
end

function DebugFrames:LogInfo(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, '|cFF0000FF'..(str or '')..'|r')
    else
        print ('|cFF0000FF'..(str or '')..'|r', data)
    end
end

function DebugFrames:LogSucess(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, '|cFF00FF00'..(str or '')..'|r')
    else
        print ('|cFF00FF00'..(str or '')..'|r', data)
    end
end

function DebugFrames:Enable()
end

function DebugFrames:Disable()
end
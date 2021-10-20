local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DebugFrames = V["DebugFrames"]

local ViragDevTool = _G['ViragDevTool']
function DebugFrames:Log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    else
        print (str, data)
    end
end
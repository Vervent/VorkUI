local AddOn = ...
local V, C = select(2, ...):unpack()

local Install = V.Install


function Install:RegisterOptions()

    print ("REGISTER", AddOn, res)
end

function Install:GetStructure()
    return descriptor
end
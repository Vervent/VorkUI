local AddOn = ...
local V = select(2, ...):unpack()

local Install = CreateFrame("Frame")

--TODO TABLE OF INSTALL FRAME
local function GenerateInstallFrame(self, db)

    db.Profile = {
        Theme = "Default",
        PartyLayout = "Compact",
        RaidLayout = "Minimalist"
    }

    Install.Frame = frame

end

function Install:Launch(db)
    GenerateInstallFrame(self, db)
end
V.Install = Install
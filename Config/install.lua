local AddOn, Plugin = ...
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

function Install:OnEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        print ("PLAYER_LOGIN", Install.ConfigUI.frame, Install.ConfigUI.frame:GetObjectType())
        Install.ConfigUI.frame:Show()
    end
end

Install:RegisterEvent('PLAYER_LOGIN')
Install:SetScript('OnEvent', Install.OnEvent)

V.Install = Install
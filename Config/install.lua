local AddOn, Plugin = ...
local V = select(2, ...):unpack()

local Install = CreateFrame("Frame")

--TODO TABLE OF INSTALL FRAME
local function GenerateInstallFrame(self, db)

    db.Profile = {
        Theme = "Default",
        PartyLayout = "Expanded",
        RaidLayout = "Minimalist",
        PlayerLayout = {
            Size = { 300, 62 },
            Point = { "CENTER", "UIParent", "CENTER", -450, -350 },
            Submodules = {
                ["Power"] = true,
                ["Absorb"] = true,
                ["Portrait"] = true,
                ["ClassIndicator"] = true,
                ["RaidIndicator"] = true,
                ["LeaderIndicator"] = true,
                ["FightIndicator"] = true,
                ["RestingIndicator"] = true,
                ["CombatIndicator"] = true,
                ["DeadOrGhostIndicator"] = true,
                ["ResurrectIndicator"] = true,
                ["SummonIndicator"] = true,
                ["CastBar"] = true,
                ["Name"] = true,
            }
        },
    }

    Install.Frame = frame

end

function Install:Launch(db)
    GenerateInstallFrame(self, db)
end

function Install:OnEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        print ("PLAYER_LOGIN", Install.ConfigUI:GetName(), Install.ConfigUI:GetObjectType())
        --Install.ConfigUI.Frame:Show()
    end
end

Install:RegisterEvent('PLAYER_LOGIN')
Install:SetScript('OnEvent', Install.OnEvent)

V.Install = Install
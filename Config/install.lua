local AddOn, Plugin = ...
local V = select(2, ...):unpack()

local Install = CreateFrame("Frame")

--TODO TABLE OF INSTALL FRAME
local function GenerateInstallFrame(self, db)

    db.Profile = {
        ["Theme"] = "Default",
        ["PartyLayout"] = "Expanded",
        ["RaidLayout"] = "Minimalist",
        ["PlayerLayout"] = {
            ["Size"] = { 300, 62 },
            ["Point"] = { "CENTER", "UIParent", "CENTER", -450, -350 },
            ["Submodules"] = {
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
                ["Buffs"] = true,
                ["Debuffs"] = true,
            },
            ["NameFont"] = { 'Montserrat Medium', 18, 'OUTLINE' },
            ["NormalFont"] = { 'Montserrat Medium', 12, 'OUTLINE' },
            ["ValueFont"] = { 'Montserrat Medium Italic', 14, 'OUTLINE' },
            ["BigValueFont"] = { 'Montserrat Medium Italic', 18, 'OUTLINE' },
            ["DurationFont"] = { 'Montserrat Medium', 12, 'OUTLINE' },
            ["StackFont"] = { 'Montserrat Medium Italic', 16, 'OUTLINE' },
        },
    }

    Install.Frame = frame

end

function Install:Launch(db)
    GenerateInstallFrame(self, db)

    self:GenerateConfigFrame()
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
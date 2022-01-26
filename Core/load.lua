local select = select

local V, C, L = select(2,...):unpack()

local Module = V.Module
local CreateFrame = CreateFrame
local _G = _G

local Load = CreateFrame("Frame")

local ViragDevTool = _G['ViragDevTool']
local function log(data, str)

    if ViragDevTool then
        ViragDevTool:ViragDevTool_AddData(data, str)
    end
end

local function moveBlizzardFrame()

    local extraAbilityContainer = _G.ExtraAbilityContainer
    --Prevent WoW from moving the frame around
    _G.UIPARENT_MANAGED_FRAME_POSITIONS.ExtraAbilityContainer = nil
    extraAbilityContainer:ClearAllPoints()
    extraAbilityContainer:SetPoint('CENTER', -400, 100)

    local belowMinimapContainer = _G.UIWidgetBelowMinimapContainerFrame
    belowMinimapContainer:ClearAllPoints()
    belowMinimapContainer:SetPoint("TOP", 0, -50)

end

function Load:OnEvent(event, ...)

    if (event == "PLAYER_LOGIN") then
        moveBlizzardFrame()
        --V["Utils"]:Enable()
        Module:EnableModule('Utils', true)
        --Now that all systems and medias are loaded, we can generate config frame
        if not V["Profiles"]:IsReady() then
            --print ("REGISTER DATA")
            --V["Themes"]:RegisterTheme("Default")
            --print ("LAUNCH INSTALLER")
            --V["Install"]:Launch(VorkuiDB)
        else
            --print ("GENERATE CONFIG FRAME")
            V["Install"]:GenerateConfigFrame()
            V["Editor"]:CreateGUI()
        end
        Module:EnableModules()
    elseif (event == 'ADDON_LOADED') then

        --secure check to avoid multiples enable (even if module handle this behaviour)
        --We want to load Medias as soon as possible
        if not Module:IsModuleEnabled('Medias') then
            Module:EnableModule('Medias', true)
        end

        if IsAddOnLoaded("Blizzard_DebugTools") then
            _G.TableAttributeDisplay:SetSize(800, 600)
            _G.TableAttributeDisplay.LinesScrollFrame:SetSize(740, 500)
        elseif IsAddOnLoaded("BugSack") then
            hooksecurefunc(BugSack, 'OpenSack', function()
                if BugSackFrame.IsResized then
                    return
                end
                BugSackFrame:SetSize(800, 600)
                BugSackFrame.IsResized = true
            end)
        end
    end
end

Load:RegisterEvent("PLAYER_LOGIN")
Load:RegisterEvent("ADDON_LOADED")
Load:SetScript("OnEvent", Load.OnEvent)

V["Loading"] = Load

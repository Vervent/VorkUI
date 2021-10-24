local select = select
local V, C, L = select(2, ...):unpack()
local AddOn, Plugin = ...

local DataFrames = V["DataFrames"]
local Medias = V["Medias"]
local LibAtlas = Medias:GetLibAtlas()
local DebugFrames = V['DebugFrames']

local ipairs = ipairs
local format = format
local tinsert = tinsert
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local C_Timer = C_Timer
local C_Covenants = C_Covenants
local C_Soulbinds = C_Soulbinds
local C_CovenantSanctumUI = C_CovenantSanctumUI
local GetClassColor = GetClassColor

local conversionTable = {
    [1] = 276, --Niya
    [2] = 275, --Dreamweaver
    [3] = 304, --Draven
    [4] = 325, --Marileth
    [5] = 330, --Emeni
    [6] = 334, --Korayn
    [7] = 357, --Pelagos
    [8] = 368, --Nadjia
    [9] = 392, --Theotar
    [10] = 349, --Heirmir
    [13] = 360, --Kleia
    [18] = 365, --Mikanikos
}

local maxRenownColor = select(4, GetClassColor('MONK'))

local function updateCovenant(self)
    local covenantID = C_Covenants.GetActiveCovenantID()
    local data = C_Covenants.GetCovenantData(covenantID)
    if not data then
        return
    end

    self.Icon:SetTexture([[interface\icons\ui_sigil_]] .. data.textureKit)
    --self.Text:SetText(data.name)
end

local function updateSoulbind(self)
    local soulbindID = C_Soulbinds.GetActiveSoulbindID()

    local level = C_CovenantSanctumUI.GetRenownLevel()
    local maxRenown = C_CovenantSanctumUI.HasMaximumRenown()
    local soulbindData = C_Soulbinds.GetSoulbindData(soulbindID)

    if maxRenown then
        self.Text:SetText(format('|c%s%s|r - %.11s', maxRenownColor, level, soulbindData.name:match('%a+')))
    else
        self.Text:SetText(format('%s - %.11s', level, soulbindData.name:match('%a+')))
    end

    local treeId = conversionTable[soulbindID]
    if not treeId then
        return
    end
    local tree = C_Soulbinds.GetTree(treeId)

    local idx = 1
    for i, node in ipairs(tree.nodes) do
        if node.state == 3 then
            --selected
            if node.spellID == 0 then
                local spellID = C_Soulbinds.GetConduitSpellID(node.conduitID, node.conduitRank)
                local name, _, icon = GetSpellInfo(spellID)
                self.Soulbinds[idx].Texture:SetTexture(icon)
            else
                self.Soulbinds[idx].Texture:SetTexture(node.icon)
            end
            idx = idx + 1
        end
    end
end

local function update(self, event)

    if event == 'PLAYER_ENTERING_WORLD' then
        updateCovenant(self)
        --We need to delay this because soulbind is not available on first login when PLAYER_ENTERING_WORLD ir fired
        C_Timer.After(1, function()
            updateSoulbind(self)
        end)
    elseif event == 'COVENANT_CHOSEN' then
        updateCovenant(self)
    else
        updateSoulbind(self)
    end

end

local function enable(self)
    self:SetSize(468, 30)
    --self.Icon:SetTexture([[INTERFACE\ICONS\ACHIEVEMENT_GUILDPERK_BOUNTIFULBAGS]])
    self.Icon:SetSize(25,25)
    --self.Icon:SetDesaturated(true)
    self.Icon:SetPoint('LEFT', 1, 0)

    self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 1, 0)

    self.Soulbinds = {}
    local btn
    for i = 1, 12 do
        btn = CreateFrame('button', nil, self)
        btn:SetSize(25, 25)
        if i == 1 then
            btn:SetPoint('RIGHT', self, 'RIGHT', -1, 0)
        else
            btn:SetPoint('RIGHT', self.Soulbinds[i - 1], 'LEFT', -1, 0)
        end

        btn.Texture = btn:CreateTexture('ARTWORK')
        btn.Texture:SetAllPoints()
        --btn.Texture:SetDesaturated(true)

        btn:Show()
        tinsert(self.Soulbinds, btn)
    end

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('COVENANT_CHOSEN')
    self:RegisterEvent('SOULBIND_ACTIVATED')
    self:RegisterEvent('SOULBIND_PATH_CHANGED')
    self:RegisterEvent('SOULBIND_NODE_UPDATED')
    self:SetScript('OnEvent', update)
end

local function disable(self)
    self:UnregisterEvent('SOULBIND_NODE_UPDATED')
    self:UnregisterEvent('SOULBIND_PATH_CHANGED')
    self:UnregisterEvent('SOULBIND_ACTIVATED')
    self:UnregisterEvent('COVENANT_CHOSEN')
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')

    for _, btn in ipairs(self.Soulbinds) do
        btn:Hide()
    end
end

DataFrames:RegisterElement('covenant', enable, disable, update)
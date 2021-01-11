local AddOn, Plugin = ...
local V, C = select(2, ...):unpack()
local LibGUI = Plugin.LibGUI

local Editor = V.Editor
local Inspector = CreateFrame("Frame")

local currentFrame = nil
local currentItem = nil

--[[
    INSPECTOR FRAME CONFIG
]]--
local inspector = {
    root = {
        type = 'frame',
        params = {
            parent = UIParent,
            name = 'VorkuiEditorInspector',
            title = 'Vorkui Inspector',
            size = {400, 1000},
            point = { 'TOPRIGHT' },
        },
        childs = {
        }
    }
}

--[[
    CORE FUNCTION
]]--

function Inspector:CreateGUI()
    local root = inspector.root

    local frame = LibGUI:NewContainer( root.type,
            root.params.parent,
            root.params.name,
            root.params.size,
            root.params.point,
            'BasicFrameTemplate'
    )

    frame.TitleText:SetText(root.params.title)

    LibGUI:BindScript(frame, 'OnHide', self.Disable)
    LibGUI:SetMovableContainer(frame)

    self.UI = frame;
    self:Hide()
end

function Inspector:Enable()
    self.UI:Show()
end

function Inspector:Disable()
    self:Hide()
end

function Inspector:Refresh()

end

function Inspector:LockItem(item)
    currentFrame = item
    currentItem = Editor:GetFrameOptions(item)
end

function Inspector:ReleaseItem()
    --release all widgets
    currentFrame = nil
    currentItem = nil
end

function Inspector:Inspect(item)
    if item == currentFrame then
        return
    end

    self:ReleaseItem()
    self:LockItem(item)
end

Inspector:SetScript('OnShow', Inspector.Enable)
Inspector:SetScript('OnHide', Inspector.Disable)

Editor.Inspector = Inspector
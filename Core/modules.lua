local select = select
local debugstack = debugstack

local V, C, L = select(2, ...):unpack()

local CreateFrame = CreateFrame

local modules = {}

local enabled = {}
local disabled = {}

local mods = {
    'DebugFrames',
    'Medias',
    'Utils',
    'UnitFrames',
    'DataFrames',
    'ChatFrames',
    'Tooltips',
    'RealmFlag',
    'ActionBars',
    'Bags',
    'Merchant',
    'SkinFrames',
}

local Module = CreateFrame('Frame')

local function log(...)

    if modules['DebugFrames'] then
        modules['DebugFrames']:LogError(...)
    else
        print (...)
    end

end

local function getIndexInTable(name, t)
    for idx, n in ipairs(t) do
        if n == name then
            return idx
        end
    end

    return nil
end

function Module:Enable()

end

function Module:Disable()

end

function Module:EnableModule(name, mustRemove)
    local idx = getIndexInTable(name, disabled)
    if modules[name] and idx ~= nil then
        modules[name]:Enable()

        tinsert(enabled, name)
        if mustRemove then
            tremove(disabled, idx)
        end
    else
        log(name, 'this module is not existing or yet enabled, you cannot enable it')
    end
end

function Module:DisableModule(name, mustRemove)
    local idx = getIndexInTable(name, enabled)
    if modules[name] and idx ~= nil then
        modules[name]:Disable()

        tinsert(disabled, name)
        if mustRemove then
            tremove(enabled, idx)
        end
    else
        log(name, 'this module is not existing or yet disabled, you cannot disable it')
    end
end

function Module:EnableModules()
    for i, n in ipairs(disabled) do
        self:EnableModule(n)
    end

    disabled = {}
end

function Module:DisableModules()
    for _, n in ipairs(enabled) do
        self:EnableModule(n)
    end
end

function Module:RegisterModule(name, isGlobalHook)
    if not modules[name] then
        if not isGlobalHook then
            modules[name] = CreateFrame('Frame')
        else
            modules[name] = _G[name]
        end
        --modulesStatus[name] = false

        tinsert(disabled, name)

        return modules[name]
    else
        log(name, 'this module is existing yet, you cannot register twice')
    end

    --By design we don't want that register return existing modules, use GetModule() instead
    return nil
end

function Module:RegisterModules(modulesName)
    for _, n in ipairs(modulesName) do
        self:RegisterModule(n)
    end
end

function Module:GetModuleAndStatus(name)
    return self:GetModule(name), self:GetModuleStatus(name)
end

function Module:GetModule(name)
    return modules[name] or nil
end

function Module:IsModuleEnabled(name)
    local idx = getIndexInTable(name, enabled)

    return idx ~= nil
end

function Module:GetModuleStatus(name)
    for _, n in ipairs(enabled) do
        if n == name then
            return 'Enabled'
        end
    end

    for _, n in ipairs(disabled) do
        if n == name then
            return 'Disabled'
        end
    end

    return nil
end

--We need to create frame as soon as possible to avoid loading issue
Module:RegisterModules(mods)

--Modules that need to hook Global Frames
Module:RegisterModule('Minimap', true)

V.Module = Module
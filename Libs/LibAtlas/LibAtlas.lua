---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by flori.
--- DateTime: 01/11/2020 20:58
---

local LibAtlas = LibStub:NewLibrary("LibAtlas", 1)

if not LibAtlas then
    return
end

local debug = 0

--Local caching for global function
local pairs = pairs
local tinsert = tinsert
local type = type
local unpack = unpack
local print = print

local Atlas = {}

function LibAtlas:ListParticle()
    local list = {}

    for k, v in pairs(Atlas) do
        if #v.Sprites > 0 then
            tinsert(list, k)
        end
    end

    return list
end

function LibAtlas:ListAtlas()
    local list = {}

    for k, v in pairs(Atlas) do
        if #v.Sprites == 0 then
            tinsert(list, k)
        end
    end

    return list
end

function LibAtlas:List()
    local list = {}
    for k, v in pairs(Atlas) do
        tinsert(list, k )
    end

    return list
end

function LibAtlas:RegisterAtlas(name, path, spriteSheet)

    if Atlas[name] then
        return
    end
    Atlas[name] = {
        Path = path,
        Sprites = { },
    }

    local tmp = false

    for k, v in pairs(spriteSheet) do
        if type(k) == 'number' then
            tinsert( Atlas[name].Sprites, k, v)
            tmp = true
        else
            Atlas[name].Sprites[k] = v
        end
    end

    if debug == 1 then
        Atlas[name].OnUse = false
    end

end

function LibAtlas:GetAtlas(key)

    --check if string is name or path
    if Atlas[key] then
        if debug == 1 then
            Atlas[key].OnUse = true
        end
        return Atlas[key]
    end

    for k,v in pairs (Atlas) do
        if v.Path == key then
            if debug == 1 then
                v.OnUse = true
            end
            return v
        end
    end

    return nil
end

function LibAtlas:GetPath(key)
    if Atlas[key] then
        if debug == 1 then
            Atlas[key].OnUse = true
        end
        return Atlas[key].Path
    end
end

function LibAtlas:GetSize(key)
    local atlas = self:GetAtlas(key)
    if atlas == nil then
        return nil
    end

    return atlas.Sprites.width, atlas.Sprites.height
end

function LibAtlas:GetSheet(key)
    local atlas = self:GetAtlas(key)
    if atlas == nil then
        return nil
    end

    return atlas.Sprites
end

function LibAtlas:GetTexCoord(key, spriteName, flip)

    local atlas = self:GetAtlas(key)

    if atlas == nil then
        return nil
    end

    local width = atlas.Sprites.width
    local height = atlas.Sprites.height
    local l, r, t, b = unpack(atlas.Sprites[spriteName])
    if flip then
        return 1-l/width, 1-r/width, t/height, b/height
    else
        return l/width, r/width, t/height, b/height
    end

end

function LibAtlas:GetSpriteCount(key)
    local atlas = self:GetAtlas(key)

    if atlas == nil then
        return 0
    end

    return #atlas.Sprites or 0
end

function LibAtlas:GetSpriteData(key, spriteName)
    local atlas = self:GetAtlas(key)

    if atlas == nil then
        return nil
    end

    return atlas.Sprites[spriteName] or nil
end

function LibAtlas:GetDebugInfo()
    if debug ~= 1 then
        return
    end

    local redcolor = "FFFF2200"
    print("----- DEBUG LIBATLAS -----")
    for k,v in pairs(Atlas) do
        if k.OnUse == false then
            print ("|c"..redcolor..v.Path.."is never used |r")
        else
            print(v.Path)
        end
        for n,s in pairs(v.Sprites) do
            local l,r,t,b = unpack(s)
            print ("\t"..n.."("..l..", "..r..", "..t..", "..b..")")
        end
    end
end
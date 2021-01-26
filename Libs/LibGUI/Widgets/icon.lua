--[[
    This widget embed just a label

    Widget Data :
    .type as internal kind of frame
    .icon

    Widget Methods :
    ChangeIcon (self, icon)
        icon the path of fileID of the new texture
    ChangeVertexColor(self, color)
    ApplyVertexGradient(self, colorStart, colorEnd, ratio)
]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {

    --TODO UPDATE THIS FUNC FOR MORE DATA
    Update = function (self, dataTable)
        local icon, colorStart, colorEnd, ratio = unpack(dataTable)
        self:ChangeIcon(icon)
        if colorEnd then
            self:ApplyVertexGradient(colorStart, colorEnd, ratio or 0.5)
        else
            self:ChangeVertexColor(colorStart)
        end
    end,

    ChangeIcon = function(self, icon)
        self.path = icon
        self:SetTexture(icon)
    end,

    ChangeColorTexture = function(self, color)
        print (self, unpack(color),self:GetObjectType())
        self:SetColorTexture(unpack(color))
    end,

    ChangeVertexColor = function(self, color)
        self:SetVertexColor(unpack(color))
    end,

    ApplyVertexGradient = function(self,  colorStart, colorEnd, ratio)
        local r ,g ,b, a

        if ratio < 0 then
            ratio = 0
        elseif ratio > 1 then
            ratio = 1
        end

        r = colorStart[1] * (1 - ratio) + ratio*colorEnd[1]
        g = colorStart[2] * (1 - ratio) + ratio*colorEnd[2]
        b = colorStart[3] * (1 - ratio) + ratio*colorEnd[3]
        if colorStart[4] and colorEnd[4] then
            a = colorStart[4] * (1 - ratio) + ratio*colorEnd[4]
        else
            a = 1
        end

        self:ChangeVertexColor( {r, g, b, a} )

    end
}

local function create(container, name, point, size, layer, ...)
    local icon = container:CreateTexture(name, layer, ...)

    if point then
        icon:SetPoint( unpack(point) )
    end

    if size then
        icon:SetSize( unpack(size) )
    end

    icon.path = ""

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(icon, { __index = setmetatable(Methods, getmetatable(icon))})

    return icon
end

local function enable(self)

end

local function disable(self)

end

LibGUI:RegisterWidget('icon', create, enable, disable )
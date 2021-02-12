----[[
-- Created by Vorka for Vorkui.
--	local LibAnim = LibStub:GetLibrary("LibSlant")
--
--	if (not LibSlant) then return end
--
--	local slant = LibSlant:CreateSlant(object) --> Create a system to slant textures in frame
--		object: The frame which hold textures
--
-- local texture = slant:AddTexture(layer) --> Create a texture and return it
--      layer: The layer to draw the texture ("BACKGROUND", "ARTWORK", ...)
--
-- slant:CalculateAutomaticSlant() --> calculate automatic ratio to slant using height/width
--
-- slant:PrintDebug() --> print debug information
--
-- slant:StaticSlant(layer) --> Slant a texture in the right layer
--      layer: The layer of the texture to slant ("BACKGROUND", "ARTWORK", ...)
--      The purpose of the StaticSlant is to do this only one times like for bg
--
-- slant:Slant(startProgress, endProgress) --> slant all textures of the frame
--      startProgress, endProgress the data for the progression
--
-- slant.IgnoreBackground = false   --> to ignore background during the dynamic slanting
-- slant.UniformSlanting = true     --> use for uniform slant, it implies that all textures have the same size
-- slant.Inverse = false            --> slant is now left oriented
-- slant.FillInverse = false        --> fill is now right to left
----]]
local LibSlant = LibStub:NewLibrary("LibSlant", 1)

if not LibSlant then
    return
end

local pairs = pairs

local defaultTexCoord = {
    ULx = 0,
    ULy = 0,
    LLx = 0,
    LLy = 1,
    URx = 1,
    URy = 0,
    LRx = 1,
    LRy = 1,
};

local moveCorner = function(width, height, corner, x, y, coord)
    local rx = defaultTexCoord[corner .. "x"] - x;
    local ry = defaultTexCoord[corner .. "y"] - y;
    coord[corner .. "vx"] = -rx * width;
    coord[corner .. "vy"] = ry * height;

    coord[corner .. "x"] = x;
    coord[corner .. "y"] = y;
end

local apply = function(self, coord)
    self:SetVertexOffset(UPPER_RIGHT_VERTEX, coord.URvx, coord.URvy);
    self:SetVertexOffset(UPPER_LEFT_VERTEX, coord.ULvx, coord.ULvy);
    self:SetVertexOffset(LOWER_RIGHT_VERTEX, coord.LRvx, coord.LRvy);
    self:SetVertexOffset(LOWER_LEFT_VERTEX, coord.LLvx, coord.LLvy);

    self:SetTexCoord(coord.ULx, coord.ULy, coord.LLx, coord.LLy, coord.URx, coord.URy, coord.LRx, coord.LRy);
end

local slant = function(self, startProgress, endProgress, coord, slantFactor, inverse)

    startProgress = startProgress * (1 - slantFactor);
    endProgress = endProgress * (1 -  slantFactor);

    if not inverse then
        local slant1 = inverse and 0 or slantFactor;
        local slant2 = inverse and slantFactor or 0;
        moveCorner(self:GetWidth(), self:GetHeight(), "UL", startProgress + slant1, 0, coord);
        moveCorner(self:GetWidth(), self:GetHeight(), "LL", startProgress + slant2, 1, coord );
        moveCorner(self:GetWidth(), self:GetHeight(), "UR", endProgress + slant1, 0, coord );
        moveCorner(self:GetWidth(), self:GetHeight(), "LR", endProgress + slant2, 1, coord );
    else
        local slant1 = inverse and slantFactor or 0;
        local slant2 = inverse and 0 or slantFactor;
        moveCorner(self:GetWidth(), self:GetHeight(), "UL", 1 - endProgress - slant1, 0, coord);
        moveCorner(self:GetWidth(), self:GetHeight(), "LL", 1 - endProgress - slant2, 1, coord );
        moveCorner(self:GetWidth(), self:GetHeight(), "UR", 1 - startProgress - slant1, 0, coord );
        moveCorner(self:GetWidth(), self:GetHeight(), "LR", 1 - startProgress - slant2, 1, coord );
    end
end

local Methods = {
    AddTexture = function(self, layer, sublayer, factor)
        local texture = self.Parent:CreateTexture(nil)

        texture:SetDrawLayer(layer, sublayer )
        local textureIndex = #self.Textures + 1

        if self.UseCustomSlantByTexture then
            self.CustomSlantByTexture[textureIndex] = (self.AutomaticSlantFactor and 0) or factor
        end

        self.Textures[textureIndex] = texture
        return texture
    end,

    PrintDebug = function (self)
        print ("---|cFF3333AALibSlant Debug|r---")
        print("Parent:", self.Parent:GetName())
        print("Uniform Slant", self.UniformSlanting)
        print("Inverse Slant", self.Inverse)
        print("FillInverse Slant", self.FillInverse)
        if self.UniformSlanting then
            print("Factor:", self.Factors[1])
        else
            print ("---Factors---")
            for _,v in pairs (self.Factors) do
                print(v)
            end
        end

        print ("---Textures---")
        for _,v in pairs (self.Textures) do
            print(v:GetTexture(), v:GetDrawLayer())
        end

    end,

    --Use this to slant a static texture on init (like background)
    StaticSlant = function(self, layer)
        if #self.Textures == 0 then
            print("|cFFFF0000NO TEXTURE TO SLANT|r")
            return
        end

        for _,v in pairs(self.Textures) do
            if v:GetDrawLayer() == layer then
                if self.UniformSlanting then
                    slant(v, 0, 1, self.Coord, self.Factors[1], self.Inverse)
                    apply(v, self.Coord)
                else
                    --TODO revamp this function to use index cause of textCoord per texture
                end
            end
        end
    end,

    Slant = function (self, startProgress, endProgress)
        if #self.Textures == 0 then
            print("|cFFFF0000NO TEXTURE TO SLANT|r")
            return
        end
        if self.FillInverse then
            startProgress = 1 - startProgress;
            endProgress = 1 - endProgress;
        end

        if self.UniformSlanting then
            slant(self.Textures[1], startProgress, endProgress, self.Coord, self.Factors[1], self.Inverse)
        end
        --Slant textures stuff
        for _,v in pairs(self.Textures) do
            if self.UniformSlanting then
                if not self.IgnoreBackground or v:GetDrawLayer() ~= "BACKGROUND" then
                    apply(v, self.Coord)
                end
            else
                --TODO For non uniform Slanting we need to have a texCoord per texture
            end
        end
    end,

    SetCustomSlantByTexture = function(self, texture, factor)
        if self.UniformSlanting then
            return
        end

        local textures = self.Textures

        for i = 1, #textures do
            if textures[i] == texture then
                self.Factors[i] = factor
            end
        end
    end,

    SetCustomSlant = function (self, factor)
        if self.UniformSlanting == false then
            return
        end

        local textures = self.Textures

        for i = 1, #textures do
            self.Factors[i] = factor
        end
    end,

    CalculateAutomaticSlant = function(self)
        local w, h

        if self.UniformSlanting then
            w, h =  self.Textures[1]:GetSize();
            self.Factors[1] = h / w
        else
            local textures = self.Textures
            for i = 1, #textures do
                w, h =  textures[i]:GetSize();
                self.Factors[i] = h / w
            end
        end
    end
}

function LibSlant:CreateSlant(parent)
    local Slant = {}
    setmetatable(Slant, { __index = Methods })

    Slant.Factors = {}
    Slant.IgnoreBackground = false
    Slant.UniformSlanting = true --use for uniform slant, it implies that all textures got same size
    Slant.Textures = {}
    Slant.Parent = parent
    Slant.Inverse = false --base slant is right-oriented, use this to inverse
    Slant.FillInverse = false
    Slant.Coord = {
        ULx = 0,
        ULy = 0,
        LLx = 0,
        LLy = 1,
        URx = 1,
        URy = 0,
        LRx = 1,
        LRy = 1,

        ULvx = 0,
        ULvy = 0,
        LLvx = 0,
        LLvy = 0,
        URvx = 0,
        URvy = 0,
        LRvx = 0,
        LRvy = 0,
    };

    return Slant
end
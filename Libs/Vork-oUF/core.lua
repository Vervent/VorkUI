
local _, ns = ...
local oUF = ns.oUF

local CreateFrame = CreateFrame

local VorkoUF = CreateFrame("Frame", "VORKOUF", UIParent)

VorkoUF.Easing={}

VorkoUF.defaultTexCoord = {
    ULx = 0,
    ULy = 0,
    LLx = 0,
    LLy = 1,
    URx = 1,
    URy = 0,
    LRx = 1,
    LRy = 1,
};

VorkoUF.MoveCorner = function(width, height, corner, x, y, coord)
    local rx = VorkoUF.defaultTexCoord[corner .. "x"] - x;
    local ry = VorkoUF.defaultTexCoord[corner .. "y"] - y;
    coord[corner .. "vx"] = -rx * width;
    coord[corner .. "vy"] = ry * height;

    coord[corner .. "x"] = x;
    coord[corner .. "y"] = y;
end

VorkoUF.Slant = function(self, startProgress, endProgress, coord)
    local slant = 0.2;
    startProgress = startProgress * (1 - slant);
    endProgress = endProgress * (1 -  slant);

    local slant1 = self.slantFirst and 0 or slant;
    local slant2 = self.slantFirst and slant or 0;

    VorkoUF.MoveCorner(self:GetWidth(), self:GetHeight(), "UL", startProgress + slant1, 0, coord);
    VorkoUF.MoveCorner(self:GetWidth(), self:GetHeight(), "LL", startProgress + slant2, 1, coord );
    VorkoUF.MoveCorner(self:GetWidth(), self:GetHeight(), "UR", endProgress + slant1, 0, coord );
    VorkoUF.MoveCorner(self:GetWidth(), self:GetHeight(), "LR", endProgress + slant2, 1, coord );
end

VorkoUF.SetValue = function(self, cur, max, coord)

    VorkoUF.Slant(self, 0, cur/max, coord)
    self:SetVertexOffset(UPPER_RIGHT_VERTEX, coord.URvx, coord.URvy);
    self:SetVertexOffset(UPPER_LEFT_VERTEX, coord.ULvx, coord.ULvy);
    self:SetVertexOffset(LOWER_RIGHT_VERTEX, coord.LRvx, coord.LRvy);
    self:SetVertexOffset(LOWER_LEFT_VERTEX, coord.LLvx, coord.LLvy);
    self:SetTexCoord(coord.ULx, coord.ULy, coord.LLx, coord.LLy, coord.URx, coord.URy, coord.LRx, coord.LRy);
end

VorkoUF.Easing["linear"] = function(t, b, c, d)
    return c * t / d + b
end

ns.VorkoUF = VorkoUF


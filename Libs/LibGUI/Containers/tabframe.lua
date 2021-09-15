--[[
    This container holds multiple tab
        Childs[1] = header frame
        Childs[2] = container frame
   header and container frames use the LibGUI frame. See Containers/frame.lua for more information

    Frame Data :
    .type as internal kind of frame
    .currentPage as internal link for the currentPage to show

]]--
local _, Plugin = ...

local LibGUI = Plugin.LibGUI

local Methods = {

    UpdateHeaderLayout = function(self)
        local header = self.Childs[1]
        local maxWidth, maxHeight = header:GetWidth(), header:GetHeight()

        local width = 0
        local height = 0
        local firstItem = 1
        local lineCount = 1
        local newWidth = 0

        for i, w in ipairs(header.Widgets) do
            height = max(height, w:GetHeight())
            newWidth = width + w:GetWidth()
            if newWidth > maxWidth then
                --cut to index i to end
                w:ClearAllPoints()
                w:SetPoint("TOPLEFT", header.Widgets[firstItem], "BOTTOMLEFT", 0, -2)
                firstItem = i
                lineCount = lineCount + 1
                width = newWidth - width
            else
                width = newWidth
            end
        end

        local newHeight = height * lineCount + 4
        if newHeight > maxHeight then
            header:SetHeight(newHeight)
            --We change header height, so we need to replace first item as every other button are anchored on it
            header.Widgets[1]:ClearAllPoints()
            header.Widgets[1]:SetPoint("TOPLEFT", 2, -2)

            --Update container height to not overflaw frame
            self.Childs[2]:SetHeight(self.Childs[2]:GetHeight() - (newHeight - maxHeight))
        end

    end,

    AddWidgetToPage = function(self, page, t, name, point, ...)

        if page == nil then
            return
        end

        return LibGUI:NewWidget(t, page, name, point, ...)
    end,

    DisableHeader = function(self, btn)
        local header = self.Childs[1]
        btn:Disable()

        for _, b in ipairs(header.Widgets) do
            if b ~= btn then
                b:Enable()
            end
        end
    end,

    AddEmptyPage = function(self, pageName, buttonSize)
        local header = self.Childs[1]
        local container = self.Childs[2]

        local anchor

        if #header.Widgets > 0 then
            anchor = { 'LEFT', header.Widgets[#header.Widgets], 'RIGHT', 2, 0 }
        else
            anchor = { 'LEFT', header, 'LEFT' }
        end

        local pageHeader = LibGUI:NewWidget('button',
                header,
                header:GetName() .. pageName,
                anchor,
                buttonSize,
                'UIPanelButtonTemplate'
        )

        local pageContent = LibGUI:NewContainer('empty',
                container,
                container:GetName() .. pageName
        )
        pageContent:SetAllPoints()

        pageHeader:Bind('OnClick',
                function(btn)
                    self:DisableHeader(btn)
                    if self.currentPage then
                        self.currentPage:Hide()
                    end
                    self.currentPage = pageContent
                    pageContent:Show()
                end
        )

        if self.currentPage == nil then
            self.currentPage = pageContent
            self:DisableHeader(pageHeader)
        end

        self:UpdateHeaderLayout()

        return pageHeader, pageContent
    end,

}

local function create(parent, name, size, point, headerTemplate, containerTemplate)

    local frame = LibGUI:NewContainer('empty', parent, name)

    frame.Childs = {}
    frame.currentPage = nil

    local header = LibGUI:NewContainer('frame', frame, name .. "HeaderFrame", nil, nil, headerTemplate)
    local container = LibGUI:NewContainer('frame', frame, name .. "ContainerFrame", nil, nil, containerTemplate)
    container.enableAllChilds = false

    if point then
        if type(point) == 'table' then
            if type(point[1]) == 'table' then
                --tricks to manage multi pointing anchor
                for _, p in pairs(point) do
                    frame:SetPoint(unpack(p))
                end
            else
                frame:SetPoint(unpack(point))
            end

        else
            frame:SetAllPoints()
        end
    end
    if size then
        local width, height = unpack(size)
        frame:SetSize(width, height)
        header:SetSize(width - 10, 20)
        container:SetSize(width - 10, height - 20)
    end

    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, 2)
    container:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)

    --push our internal Methods in the metatable, if it taints, need to wrap this
    setmetatable(frame, { __index = setmetatable(Methods, getmetatable(frame)) })

    return frame
end

local function enable(self)
    if self.type ~= 'tabframe' then
        return
    end

    for _, c in ipairs(self.Childs) do
        c:Show()
    end

    if self.currentPage then
        self.currentPage:Show()
    end

end

local function disable(self)
    if self.type ~= 'tabframe' then
        return
    end

    for i, c in pairs(self.Childs) do
        c:Hide()
    end
end

local function bindScript(self, event, fct)

    if self.type ~= 'tabframe' then
        return
    end
    self.Scripts[event] = fct
end

LibGUI:RegisterContainer('tabframe', create, enable, disable, bindScript)
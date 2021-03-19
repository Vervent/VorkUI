local LibObserver = LibStub:NewLibrary("LibObserver", 1)

if not LibObserver then
    return
end

local ObserversMethod = {
    OnNotify = nil
}

local SubjectMethod = {
    RegisterObserver = function(self, entity)
        tinsert(self.Observer, entity)
    end,

    UnregisterObserver = function(self, entity)
        for i, e in ipairs(self.Observer) do
            if e == entity then
                tremove(self.Observer, i)
                return
            end
        end
    end,

    UnregisterAllObserver = function(self)
        self.Observer={}
    end,

    Notify = function(self, event)
        for _,e in ipairs(self.Observer) do
            e.OnNotify(event)
        end
    end,

    NotifyOnce = function(self, event)
        for _,e in ipairs(self.Observer) do
            e.OnNotify(event)
        end
        UnregisterAllObserver(self)
    end,
}

function LibObserver:CreateObserver()

    local observer = {}
    setmetatable(observer, { __index = ObserversMethod })

    return observer
end

function LibObserver:CreateSubject()

    local subject = {}
    setmetatable(subject, { __index = SubjectMethod })
    subject.Observer = {}

    return subject
end
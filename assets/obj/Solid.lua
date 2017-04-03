Solid = {
}
Solid.__index = Solid

setmetatable(Solid, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init(...)
        return self
    end
})

function Solid:_init(x, y, w, h)
    self.x = x + w/2 or 0
    self.y = y + h/2  or 0
    self.width = w or 32
    self.height = h or 32
    self.xVel = 0
    self.yVel = 0
    self.gravity = false
end

function Solid.new(x, y, w, h)
    local self = setmetatable({}, Solid)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
    return self
end

function Solid:set_xywh(x, y, w, h)
end

function Solid:get_xywh()
end

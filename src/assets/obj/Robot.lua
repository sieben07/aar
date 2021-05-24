local Robot = {
    velocity = 0,
    gravity = 200
}

function Robot:getVelocity()
    return self.velocity
end

function Robot:setVelocity(value)
    self.velocity = value
end

function Robot:getIsFalling()
    return self.properties.falling
end

function Robot:setIsFalling(value)
    self.properties.falling = value
end

function Robot:getIsActive()
    return self.properties.active or false
end

function Robot:setIsActive(value)
    self.properties.active = value
end

function Robot:switchToActive()
    if self.type == "robot" and not self:getIsActive() then
        self:setIsActive(true)
    end
end

function Robot:updateVelocity(dt)
    self.velocity = self.velocity + (self.gravity * dt)
end

function Robot:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Robot

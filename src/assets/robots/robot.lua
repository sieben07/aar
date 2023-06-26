local root = require "assets.objects.root"
local colorUtil = require "assets.utils.color_util"
local COLORS = require "assets.styles.colors"
local fonts = require "assets.font.fonts"
local Projectile = require "assets.objects.projectile"

local projectileDirections = root.projectileDirections


local signal = root.signal
local transition = root.transition
local invertColor = colorUtil.invertColor

local Robot = {
    alpha = 1,
    xVelocity = 0,
    yVelocity = 0,
    gravity = 200,
    color = COLORS.WHITE,
    testColor = COLORS.ORANGE,
}

function Robot:setXVelocity(value)
    self.xVelocity = value
end

function Robot:setYVelocity(value)
    self.yVelocity = value
end

function Robot:getXVelocity()
    return self.xVelocity
end

function Robot:getYVelocity()
    return self.yVelocity
end

function Robot:resetXvelocity()
end

function Robot:resetYvelocity()
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

function Robot:activate()
    if not self:getIsActive() then
        self:setIsActive(true)
        self:setIsFalling(true)
        signal:emit("score", 7)
        self.color = colorUtil.nextColor()
    end
end

function Robot:update(dt)
end

function Robot:draw()
    self:_draw()
end

function Robot:_draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.deg)
    love.graphics.setColor(COLORS.BLACK)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- draw the robot's name
    love.graphics.setFont(fonts.ormont_middle)
    love.graphics.setColor(self.testColor)
    love.graphics.print(self.name, self.x + 14, self.y + 3)
end

function Robot:hit(normal)
end

function Robot:updatePositionY(dt)
    goalY = self.y + self:getYVelocity() * dt
    self:updateYVelocity(dt)
    return goalY
end

function Robot:updatePositionX(dt)
   goalX = self.x + self:getXVelocity() * dt
   self:updateXVelocity(dt)
   return goalX
end

function Robot:setXVelocity(value)
    self.xVelocity = value
end

function Robot:setYVelocity(value)
    self.yVelocity = value
end

function Robot:updateYVelocity(dt)
    self:setYVelocity(self:getYVelocity() + (self.gravity * dt))
end

function Robot:updateXVelocity(dt)
end

function Robot:new(o)
    o = o or {}
    o._id = os.time(os.date("!*t"))
    setmetatable(o, self)
    self.__index = self

    return o
end

return Robot

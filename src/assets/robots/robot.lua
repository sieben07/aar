local root = require "assets.objects.root"
local colorUtil = require "assets.utils.color_util"
local COLORS = require "assets.styles.colors"

local signal = root.signal
local fonts = require "assets.font.fonts"
local transition = root.transition
local invertColor = colorUtil.invertColor

local Robot = {
    alpha = 1,
    velocity = 0,
    gravity = 200,
    color = COLORS.WHITE,
    testColor = COLORS.ORANGE,
    properties = {
        collidable = true,
        visible = true
    }
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

function Robot:getIsVisible()
    return self.properties.visible or false
end

function Robot:setIsVisible(value)
    self.properties.visible = value
end

function Robot:getIsCollidable()
    return self.properties.collidable or true
end

function Robot:switchToActive()
    if not self:getIsActive() then
        self:setIsActive(true)
        self:setIsFalling(true)
        signal:emit("score", 7)
        self.color = colorUtil.nextColor()
    end
end

function Robot:updateVelocity(dt)
    self:setVelocity(self:getVelocity() + (self.gravity * dt))
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

function Robot:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

return Robot

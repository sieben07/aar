-- RESET

local global = require "assets.objects.global"
local Robot = require "assets.robots.robot"
local signal = global.signal

local ResetRobot = Robot:new()

ResetRobot.properties.collidable = false

function ResetRobot:switchToActive()
    if self.type == "robot" and not self:getIsActive() then
        self:setIsActive(true)
        signal:emit('reset')
    end
end

function ResetRobot:draw()
    if self:getIsVisible() then
        self:_draw()
    end
end

function ResetRobot:update(dt)
    if global.score <= 1 then
        self:setIsVisible(true)
    else
        self:setIsVisible(false)
    end
end

return ResetRobot

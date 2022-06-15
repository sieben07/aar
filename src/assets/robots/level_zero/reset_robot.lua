-- RESET
local global = require "assets.objects.global"

local Robot = require "assets.robots.robot"
local signal = global.signal

local resetRobotData = {
    id = 3,
    name = "Reset",
    type = "robot",
    shape = "rectangle",
    x = 848,
    y = 736,
    width = 32,
    height = 32,
    rotation = 0,
    visible = true,
    properties = {
        active = false,
        collidable = false,
        falling = false
    }
}

local ResetRobot = Robot:new(resetRobotData)

ResetRobot.properties.collidable = false

function ResetRobot:switchToActive()
    if self.type == "robot" and not self:getIsActive() then
        self:setIsActive(true)
        signal:emit('reset')
    end
end

function ResetRobot:draw()
    self:_draw()
end

function ResetRobot:update(dt)
end

return ResetRobot

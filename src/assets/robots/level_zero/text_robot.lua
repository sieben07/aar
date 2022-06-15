-- TEXT
local global = require "assets.objects.global"

local Robot = require "assets.robots.robot"
local signal = global.signal
local world = global.world
local fonts = global.fonts

local TextRobot = Robot:new()

function TextRobot:update(dt)
    -- maybe I will do something here
end

function TextRobot:getText()
    return self.properties.text
end

function TextRobot:draw()
    love.graphics.setColor(1 - global.background.color.red, 1 - global.background.color.green, 1 - global.background.color.blue, 1)
    love.graphics.setFont(fonts[self.properties.font])
    love.graphics.printf(self:getText(), self.x, self.y, love.graphics.getWidth(), self.properties.align)
end

return TextRobot

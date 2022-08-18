-- TEXT
local root = require "assets.objects.root"

local COLORS = require "assets.styles.colors"
local Robot = require "assets.robots.robot"
local signal = root.signal
local world = root.world
local fonts = root.fonts

local TextRobot = Robot:new()

function TextRobot:update(dt)
    -- maybe I will do something here
end

function TextRobot:getText()
    return self.properties.heading
end

function TextRobot:draw()
    love.graphics.setColor(self.color)
    love.graphics.setFont(fonts[self.font])
    love.graphics.printf(self:getText(), self.x, self.y, love.graphics.getWidth(), "center")
end

return TextRobot

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
    return self.properties.text
end

function TextRobot:draw()
    love.graphics.setColor(COLORS.WHITE)
    love.graphics.setFont(fonts[self.properties.font])
    love.graphics.printf(self:getText(), self.x, self.y, love.graphics.getWidth(), self.properties.align)
end

return TextRobot

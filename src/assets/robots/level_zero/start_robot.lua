-- START
local global = require "assets.objects.global"

local Robot = require "assets.robots.robot"
local signal = global.signal
local world = global.world

local StartRobot = Robot:new()

function StartRobot:switchToActive()
    self:setIsActive(true)
    self:setIsFalling(true)
end

function StartRobot:update(dt)
    if self:getIsFalling() == true then
      self.velocity = self.velocity + 33.3 * dt
      local goalY = self.y + self.velocity
      local _, len = world:m(self, self.x, goalY)

      if len ~= 0 then
         self:setIsFalling(false)
      end
   end
end

return StartRobot

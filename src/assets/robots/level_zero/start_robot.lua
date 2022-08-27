-- START
local root = require "assets.objects.root"

local Robot = require "assets.robots.robot"
local world = root.world

local StartRobot = Robot:new()

-- function StartRobot:activate()
--     self:setIsActive(true)
--     self:setIsFalling(true)
-- end

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

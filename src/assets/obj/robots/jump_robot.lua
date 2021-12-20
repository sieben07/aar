local Robot = require "assets.obj.robots.robot"
local global = require "assets.obj.global"
local world = global.world
local signal = global.signal

local JumpRobot = Robot:new()

local function filterUp(_ , other)
   if other.type == "hero" or other.type == "bullet" then
      return "cross"
   else
      return "slide"
   end
end

local function filterDown(_, other)
   if other.type == "bullet" then
      return "cross"
   else
      return "slide"
   end
end

function JumpRobot:update(dt)
   print(world)
    if self:getIsActive() then
        if self.velocity < 0 then
         local goalY = self.y + self.velocity * dt
         self:updateVelocity(dt)
         local cols, _ = world:m(self, self.x, goalY, filterUp)
         local dy

         for _, col in ipairs(cols) do
            if col.other.type == "self" then
               self:setVelocity(0)
            end

            dy = goalY - 32
            if col.other.type == "hero" then
               world:m(col.other, col.other.x, col.other.y + dy)
            end
         end
      end

      if self:getVelocity() >= 0 then
         local goalY = self.y + self.velocity * dt
         self:updateVelocity(dt)
         local _, len = world:m(self, self.x, goalY, filterDown)

         if len ~= 0 then
            signal:emit("bounce", self)
         end
      end
    end
end

return JumpRobot

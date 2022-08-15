local root = require "assets.objects.root"

local Robot = require "assets.robots.robot"
local world = root.world
local signal = root.signal

local GravityJumpRobot = Robot:new()

function GravityJumpRobot:new(o, jumpVelocity)
    o = o or {}

   o.jumpVelocity = jumpVelocity or 128
   o.gravity = -200

   setmetatable(o, self)
   self.__index = self

    return o
end

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

function GravityJumpRobot:update(dt)
    self:_update(dt)
end

function GravityJumpRobot:_update(dt)
   if self:getIsActive() then
        if self:getVelocity() > 0 then
         local goalY = self.y + self:getVelocity() * dt
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

      if self:getVelocity() <= 0 then
         local goalY = self.y + self:getVelocity() * dt
         self:updateVelocity(dt)
         local _, len = world:m(self, self.x, goalY, filterDown)

         if len ~= 0 then
            signal:emit("bounce", self)
         end
      end
    end
end

return GravityJumpRobot

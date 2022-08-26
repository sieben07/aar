local root = require "assets.objects.root"
local Robot = require "assets.robots.robot"

local colorUtil    = require "assets.utils.color_util"

local world = root.world
local signal = root.signal

local JumpRobot = Robot:new()

function JumpRobot:new(o, jumpVelocity)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

   o.jumpVelocity = jumpVelocity or -128

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

function JumpRobot:update(dt)
    self:_update(dt)
end

function JumpRobot:_update(dt)
   if self:getIsActive() then
         local goalY = self:updatePositionY(dt)
         local cols, len = world:m(self, self.x, goalY, filterUp)
         local dy

         if len ~= 0 then
            self.velocity = self.jumpVelocity
            self.color = colorUtil.nextColor()
            signal:emit("bounce", self.color)
         end

         for _, col in ipairs(cols) do
            if col.other.type == "hero" and col.normal.y == -1 then
               self.velocity = self.jumpVelocity
               self.color = colorUtil.nextColor()
               signal:emit("bounce", self.color)
            end
         end
    end
end

return JumpRobot

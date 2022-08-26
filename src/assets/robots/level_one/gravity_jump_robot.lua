local root = require "assets.objects.root"

local JumpRobot = require "assets.robots.level_one.jump_robot"
local world = root.world
local signal = root.signal

local GravityJumpRobot = JumpRobot:new()

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

return GravityJumpRobot

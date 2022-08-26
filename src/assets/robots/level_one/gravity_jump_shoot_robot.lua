local root = require "assets.objects.root"

local JumpShootRobot = require "assets.robots.level_one.jump_shoot_robot"
local Projectile = require "src.assets.objects.projectile"

local world = root.world
local signal = root.signal
local projectileDirections = root.projectileDirections

local GravityJumpShootRobot = JumpShootRobot:new()

function GravityJumpShootRobot:new(o)
    o = o or {}

    o.jumpVelocity = jumpVelocity or 128
    o.gravity = -200
    o.up = true

    setmetatable(o, self)
    self.__index = self

    return o
end

function GravityJumpShootRobot:getTurningPoint(velocity)
    return velocity > 0
end

return GravityJumpShootRobot

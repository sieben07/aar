local global = require "assets.objects.global"

local JumpRobot = require "assets.robots.level_one.jump_robot"
local Projectile = require "src.assets.objects.projectile"

local world = global.world
local signal = global.signal

local JumpShootRobot = JumpRobot:new()

function JumpShootRobot:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.shootTimer = 0

    return o
end

function JumpShootRobot:update(dt)
    self:_update(dt)
    if self:getIsActive() then
        if self.shootTimer >= 1 then
            self.shootTimer = 0
            self:_shoot(dt)
        else
            self.shootTimer = self.shootTimer + dt
        end
    end
end

function JumpShootRobot:_shoot(dt)
    local projectile = Projectile:new(self.x, self.y, 0, -1, 1)
    signal:emit("addProjectile", projectile)
end

return JumpShootRobot

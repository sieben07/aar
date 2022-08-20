local root = require "assets.objects.root"

local JumpRobot = require "assets.robots.level_one.jump_robot"
local Projectile = require "src.assets.objects.projectile"

local world = root.world
local signal = root.signal
local projectileDirections = root.projectileDirections

local JumpShootRobot = JumpRobot:new()

function JumpShootRobot:new(o)
    o = o or {}

    o.shootTimer = 0
    o.shouldShoot = false
    o.up = true

    setmetatable(o, self)
    self.__index = self

    return o
end

function JumpShootRobot:update(dt)
    self:_update(dt)

    if self:getIsActive() then
        if self.velocity < 0 then
            if self.up == false then
                self.up = true
                self.shouldShoot = true
            end
        else
            if self.up == true then
                self.up = false
                self:_shoot(dt)
                self.shouldShoot = false
            end
        end
    end
end

function JumpShootRobot:_shoot(dt)
    self:shoot()
end

function JumpShootRobot:shoot(dt)
    for n in self.properties.projectiles:gmatch "%d+" do
        local projectile = Projectile:new(self.x, self.y, projectileDirections[n], 1)
        signal:emit("addProjectile", projectile)
    end
end

return JumpShootRobot

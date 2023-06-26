local root = require "assets.objects.root"
local Robot = require "assets.robots.robot"
local Projectile = require "assets.objects.projectile"

local projectileDirections = root.projectileDirections

local MultiplyShootRobot = Robot:new()

function MultiplyShootRobot:new(o, jumpVelocity)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function MultiplyShootRobot:hit(normal)
    print(normal.x, normal.y)
    local shootDirections

    if normal.x == -1 and normal.y == 0 then
        shootDirections = {"7", "0", "1"}
    elseif normal.x == 1 and normal.y == 0 then
        shootDirections = {"3", "4", "5"}
    elseif normal.x == 0 and normal.y == 1 then
        shootDirections = {"1", "2", "3"}
    else
        shootDirections = {"5", "6", "7"}
    end

    for _, n in pairs(shootDirections)  do
        local projectile = Projectile:new(self.x, self.y, projectileDirections[n], 1,{}, self._id)
        signal:emit("addProjectile", projectile)
    end
end


return MultiplyShootRobot


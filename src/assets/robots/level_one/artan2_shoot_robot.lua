local root = require "assets.objects.root"

local JumpRobot = require "assets.robots.level_one.jump_shoot_robot"
local Projectile = require "src.assets.objects.projectile"

local world = root.world
local hero = root.hero
local signal = root.signal

local Artang2ShootRobot = JumpShootRobot:new()

function Artang2ShootRobot:shoot(dt) {
    local deg = math.deg(math.atan2(self.y - root.hero[1].y, self.x - root.hero[1].x))
    signal:emit("addProjectile", Projectile:new(self.x, self.y, deg, 1))
}

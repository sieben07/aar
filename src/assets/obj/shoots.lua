local global = require "assets.obj.global"
local SHOOT_WIDTH = global.SHOOT_WIDTH
local SHOOT_HEIGHT = global.SHOOT_HEIGHT
local bulletImage = love.graphics.newImage "assets/img/white.png"

local shoots = {}

local signal = global.signal
local world = global.world

local projectiles = {}

local addProjectileToWorld = function(projectile)
   projectile.x = projectile.x + 12 + (projectile.direction.x * 26)
   projectile.y = projectile.y + 12 + (projectile.direction.y * 26)
   projectile.x_vel = 8 * projectile.direction.x
   projectile.y_vel = 8 * projectile.direction.y
   table.insert(projectiles, projectile)
   world:add(projectile, projectile.x, projectile.y, SHOOT_WIDTH, SHOOT_HEIGHT)
end

function shoots.update()
   for i, projectile in ipairs(projectiles) do
      -- move them
      local goalX = projectile.x + projectile.x_vel
      local goalY = projectile.y + projectile.y_vel
      local actualX, actualY, cols, len = world:move(projectile, goalX, goalY, function(_, _) return "cross" end )
      projectile.x = actualX
      projectile.y = actualY
      for _, col in ipairs(cols) do
         signal:emit("hit", col.touch, projectile.direction)
         if col.other.type == "robot" and col.other.active == false then
            col.other.active = true
            signal:emit("score", 7)
         end

         -- This is wrong, every Robot should know
         -- by himself what to do if hit.
         if col.other.name == "Start" then
            col.other.falling = true
         end
         if col.other.name == "Jump" or col.other.name == "High Jump" then
            if col.other.jump ~= true then
               col.other.jump = true
               signal:emit("bounce", col.other)
            end
         end
      end

      if len ~= 0 then
         world:remove(projectile)
         table.remove(projectiles, i)
      end
   end
end

shoots.draw = function()
   for _, projectile in ipairs(projectiles) do
         love.graphics.draw(bulletImage, projectile.x, projectile.y)
   end
end

signal:register("addProjectile", function(projectile)
   addProjectileToWorld(projectile)
end)

signal:register("nextLevel", function ()
   projectiles = {}
end)

return shoots

local global = require "assets.objects.global"
local SHOOT_WIDTH = global.SHOOT_WIDTH
local SHOOT_HEIGHT = global.SHOOT_HEIGHT
local spriteSheet = global.world.spriteSheet
local Quad = love.graphics.newQuad

local cog = Quad(0, 32 * 4, 16, 16, 32 * 8, 32 *8)
local bolt = Quad(16, 32 * 4, 16, 16, 32 * 8, 32 * 8)
local nut = Quad(32, 32 * 4, 16, 16, 32 * 8, 32 * 8)
local items = {cog, bolt, nut}

local signal = global.signal
local world = global.world

local shoots = {}
local projectiles = {}

local addProjectileToWorld = function(projectile)
   table.insert(projectiles, projectile)
   world:add(projectile, projectile.x, projectile.y, SHOOT_WIDTH, SHOOT_HEIGHT)
end

function shoots.update()
   for i, projectile in ipairs(projectiles) do
      -- move them
      local goalX = projectile.x + projectile.x_vel
      local goalY = projectile.y + projectile.y_vel
      local actualX, actualY, cols, len = world:move(projectile, goalX, goalY)
      projectile.x = actualX
      projectile.y = actualY
      for _, col in ipairs(cols) do
         signal:emit("collision", col, projectile.direction)
      end

      if len ~= 0 then
         world:remove(projectile)
         table.remove(projectiles, i)
      end
   end
end

shoots.draw = function()
   for index, projectile in ipairs(projectiles) do
         love.graphics.setColor(1,1,1,1)
         if projectile.index == nil then projectile.index = index % 3 + 1 end
         love.graphics.draw(spriteSheet, items[projectile.index], projectile.x, projectile.y + 8, math.rad(projectile.x), 1.1, 1.1, 8, 8)
   end
end

signal:register("addProjectile", function(projectile)
   addProjectileToWorld(projectile)
end)

signal:register("nextLevel", function ()
   projectiles = {}
end)

return shoots

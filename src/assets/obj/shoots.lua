local global = require "assets.obj.global"
local SHOOT_WIDTH = global.SHOOT_WIDTH
local SHOOT_HEIGHT = global.SHOOT_HEIGHT
local bulletImage = love.graphics.newImage "assets/img/white.png"
local spriteSheet = global.world.spriteSheet
local Quad = love.graphics.newQuad

local cog = Quad(0, 32 * 4, 16, 16, 32 * 8, 32 *8)
local bolt = Quad(16, 32 * 4, 16, 16, 32 * 8, 32 * 8)

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
         local quad = index % 2 == 0 and cog or bolt;
         love.graphics.draw(spriteSheet, quad, projectile.x, projectile.y + 8, math.rad(projectile.x), 1.1, 1.1, 8, 8)
   end
end

signal:register("addProjectile", function(projectile)
   addProjectileToWorld(projectile)
end)

signal:register("nextLevel", function ()
   projectiles = {}
end)

return shoots

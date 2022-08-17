local root  = require "assets.objects.root"
local COLORS = require "assets.styles.colors"
local colorUtil = require  "assets.utils.color_util"
local flux  = require "assets.libs.flux.flux"

local tween = {}
local TweenWorld = {
   robots = {}
}

function TweenWorld:add(robot)
   table.insert(self.robots, robot)
end

function TweenWorld:draw()
   for _, robot in ipairs(self.robots) do
      robot:draw()
   end
end

function TweenWorld:remove(robot)
   for i, v in ipairs(self.robots) do
      if v == robot then
         table.remove(self.robots, i)
      end
   end
end

function tween.transitionNextLevel()
   root.countdown = 4
   local white = {1, 1, 1, 1}
   root.color = white;
   f = flux.to(root, 0.5, {countdown = 0})
   :onupdate(
      function()
         root.color = colorUtil.nextColor()
         root.robotColor = colorUtil.nextColor()
         root.backgroundColor = colorUtil.invertColor(root.robotColor)
      end)
   :oncomplete(
      function()
         root.heroColor = COLORS.HERO_COLOR
         root.color = COLORS.WHITE
         root.countdown = 4
         root.signal:emit("nextLevel")
      end)
end

function tween:transitionAddRobot(robot)
   local y = robot.y
   local x = robot.x
   local width = robot.width
   local height = robot.height

   robot.zoom = 50;
   robot.x = x - love.graphics.getWidth() / 4
   robot.y = y - love.graphics.getHeight() / 4
   robot.width = x + love.graphics.getWidth() / 4
   robot.height = y + love.graphics.getHeight() / 4
   robot.alpha = 0

   self.tweenWorld:add(robot)
   flux.to(robot, math.random(1,7), {x = x, y = y, width = width, height = height, alpha = 1, zoom = 1}):ease("elasticout")
   :oncomplete(
      function()
         self.tweenWorld:remove(robot)
         root.world:add(robot, robot.x, robot.y, robot.width, robot.height)
      end
   )
end

function tween.particles(particles, dt)
    for index, hit in ipairs(particles) do
        if hit.time >= 0 then
            hit.time = hit.time - dt
            hit.alpha = hit.alpha - dt
        else
            table.remove(particles, index)
        end
    end
end

function tween.update(dt)
   flux.update(dt)
end

tween.tweenWorld = TweenWorld

return tween
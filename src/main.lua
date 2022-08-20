local root         = require "assets.objects.root"
root.spriteSheet   = love.graphics.newImage "assets/img/minimega.png"

local colorUtil    = require "assets.utils.color_util"
local COLORS       = require "assets.styles.colors"
local Gamestate    = require "assets.libs.hump.gamestate"
local levels       = require "assets.maps.levels"
local screen       = require "assets.libs.shack.shack"
local sti          = require "assets.libs.Simple-Tiled-Implementation.sti"
local tween        = require "assets.utils.tween"
local util         = require "assets.utils.util"

local fonts        = root.fonts
local game         = root.game
local hitAnimation = root.hitAnimation
local particles    = root.hits
local signal       = root.signal;
local transition   = root.transition
local tweenWorld   = tween.tweenWorld
local world        = root.world

local hitImage    = love.graphics.newImage "assets/img/white.png"
local hitParticle = love.graphics.newParticleSystem(hitImage, 14)

local map
local robotsLayer
local solidLayer

function world:clear()
   local items, _ = self:getItems()
   for _, item in pairs(items) do
      world:remove(item)
   end
end

local merge = util.merge
local getSpritesFromMap = util.getSpritesFromMap
local tween = tween
local update = util.update
local currentLevel = root.level.current

hitParticle:setLinearAcceleration(5, -3, -50, 3)
hitParticle:setParticleLifetime(1, 3)
hitParticle:setSpeed(1, 3)
hitParticle:setSpin(3, 9)
hitParticle:setSizes(0.4, 0.5, 0.6)
hitParticle:setSpinVariation(0.7)
hitParticle:setSizeVariation(0.7)

function game:init()
   signal:register("addProjectile", function(projectile)
      world:add(projectile, projectile.x, projectile.y, projectile.width, projectile.height)
   end)

   signal:register("zero", function()
      local resetRobot = require "assets.robots.level_zero.reset_robot"
      tween:transitionAddRobot(resetRobot)
      signal:clear("zero")
   end)

   signal:register("nextLevel", function() Gamestate.switch(game) end)

   signal:register("score", function(value) root.score = root.score + value end)
   signal:register("reset", function() root.score = 0 end)
   signal:register("bounce", function(robot)
      robot.velocity = robot.jumpVelocity
      robot.color = colorUtil.nextColor()
      love.graphics.setBackgroundColor(colorUtil.invertColor(robot.color))
   end)

   signal:register("collision", function(col)
      if col.other.type == "robot" then
         col.other:switchToActive()
      end

      local touch = col.touch
      touch.normal = col.normal

      merge(touch, hitAnimation)
      table.insert(particles, touch)
      -- screen:setShake(7)
      -- screen:setRotation(.07)
      -- screen:setScale(1.007)
   end)
end

function game:enter()
   world:clear()
   root.hero = {}

   signal:register("allActive", function()
      tween.transitionNextLevel()
      love.graphics.setBackgroundColor(root.backgroundColor)

      signal:clear("allActive")
   end)

   love.graphics.setBackgroundColor(root.backgroundColor)
   map = sti("assets/maps/" .. levels[currentLevel] .. ".lua", {"bump"})

   if currentLevel < #levels then
      currentLevel = currentLevel + 1
   else
      currentLevel = 1
   end

   -- create the world from tiles
   map:addCustomLayer("Robot Layer")
   robotsLayer = map.layers["Robot Layer"]
   solidLayer = map.layers["Solid"]
   robotsLayer.robots = {}

   local robotsFromMap = getSpritesFromMap(map.objects)

   for _, robotAttribute in ipairs(robotsFromMap) do
      table.insert(robotsLayer.robots, robotAttribute)
   end

   function robotsLayer:draw()
      local items = world:getItems()

      for _, item in pairs(items) do
         if item.type ~= "" then
            item:draw()
         end
      end

      -- score
      love.graphics.setFont(fonts.orange_kid)
      love.graphics.setColor(root.scoreColor)
      if root.score ~= 1 then
         love.graphics.print(root.score .. " | points", 32, 4)
      else
         signal:emit("zero", resetRobot)
         love.graphics.print(". | one point left", 32, 4)
      end

      -- version
      love.graphics.setColor(root.versionColor)
      love.graphics.setFont(fonts.ormont_tiny)
      love.graphics.print(game.version, 32,  32)
   end

   function robotsLayer:update(dt)
      update(world:getItems(), dt)
   end

   map:removeLayer("Objects")

   for k, _ in pairs(map.layers) do
      if k == "Texts" then
         map:removeLayer("Texts")
      end
   end

   for _, robot in ipairs(robotsLayer.robots) do
      -- tween:transitionAddRobot(robot)
      world:add(robot, robot.x, robot.y, robot.width, robot.height)
   end

   map:bump_init(world)
   for _, robot in pairs(robotsLayer.robots) do
      print(robot.name)
      if robot.name == "Mini" then
         table.insert(root.hero, robot)
         print(root.hero[1].name)
      end
   end
end

function game:draw()
   screen:apply()
   love.graphics.setColor(root.color)
   solidLayer:draw()
   tweenWorld:draw()
   robotsLayer:draw()


   for _, hit in pairs(particles) do
      love.graphics.setColor(root.particleColor)
      if hit.normal.x == 1 then
         love.graphics.draw(hitParticle, hit.x, hit.y, 0, 1, 1)
      elseif hit.normal.x == -1 then
         love.graphics.draw(hitParticle, hit.x, hit.y, math.pi, 1, 1)
      end
   end
end

function game:update(dt)
   screen:update(dt)
   robotsLayer:update(dt)
   hitParticle:update(dt)
   hitParticle:emit(5)

   tween.particles(particles, dt)
   tween.update(dt)
end

-- register GAME
function love.load()
   Gamestate.registerEvents()
   Gamestate.switch(game)
end

-- keypressed and keyreleased
function love.keypressed(key)
   if key == "left" then
      signal:emit("leftPressed")
   end

   if key == "right" then
      signal:emit("rightPressed")
   end

   if (key == "up" or key == "a") then
      signal:emit("jumpPressed")
   end

   if key == "s" or key == "space" then
      signal:emit("shootPressed")
   end

   if key == "escape" then
      love.event.push("quit")
   end
end

function love.keyreleased(key)
   if key == "left" then
      signal:emit("leftReleased")
   end

   if key == "right" then
      signal:emit("rightReleased")
   end

   if (key == "up" or key == "a") then
      signal:emit("jumpReleased")
   end

   if key == "s" or key == "space" then
      signal:emit("shootReleased")
   end
end

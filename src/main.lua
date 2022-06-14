local global = require "assets.objects.global"

local fonts = global.fonts
local Gamestate = require "assets.libs.hump.gamestate"
global.world.spriteSheet = love.graphics.newImage "assets/img/minimega.png"
local levels = require "assets.maps.levels"
local screen = require "assets.libs.shack.shack"
local robotsHandler = require "assets.robots.robots_handler"
local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local util = require "assets.utils.util"

local game = global.game
local hitAnimation = global.hitAnimation
local hitImage = love.graphics.newImage "assets/img/white.png"
local hitParticle = love.graphics.newParticleSystem(hitImage, 14)
local map

local particles = global.hits
local robotsLayer
local signal = global.signal;
local solidLayer
local transition = global.transition
local world = global.world

function world:clear()
   local items, _ = self:getItems()
   for _, item in pairs(items) do
      world:remove(item)
   end
end

local merge = util.merge
local nextColor = util.nextColor
local getSpritesFromMap = util.getSpritesFromMap
local tween = util.tween
local update = util.update
local currentLevel = global.level.current

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

   signal:register("nextLevel", function() Gamestate.switch(game) end)
   signal:register("allActive", function()
      tween.start()
      global.color.red = 1;
      global.color.green = 1;
      global.color.blue = 1;
      love.graphics.setBackgroundColor(
         global.background.color.red,
         global.background.color.green,
         global.background.color.blue
      )
   end)
   signal:register("score", function(value) global.score = global.score + value end)
   signal:register("reset", function() global.score = 0 end)
   signal:register("bounce", function(robot)
      global.background.color = nextColor()
      robot.velocity = robot.properties.jumpVelocity
      love.graphics.setBackgroundColor(global.background.color.red, global.background.color.green, global.background.color.blue, 1)
   end)

   signal:register("collision", function(col, direction)
      if col.other.type == "robot" then
         col.other:switchToActive()
      end

      local touch = col.touch
         touch.direction = direction
         if direction.x == 1 then
            touch.x = touch.x + 14
            touch.y = touch.y + 7
         end
         merge(touch, hitAnimation)
         table.insert(particles, touch)
         screen:setShake(7)
         screen:setRotation(.07)
         screen:setScale(1.007)
   end)
end

function game:enter()
   world:clear()
   love.graphics.setBackgroundColor(global.background.color.red,global.background.color.green,global.background.color.blue, 1)
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
      print("length: " .. #items)
      for _, item in pairs(items) do
         if item.type ~= "" then
            item:draw()
         end
      end

      -- score
      love.graphics.setFont(fonts.orange_kid)
      love.graphics.setColor(1, 0.64, 0.02)
      if global.score ~= 1 then
         love.graphics.print(global.score .. " | points", 32, 4)
      else
         signal:emit("zero", resetRobot)
         love.graphics.print(". | one point left", 32, 4)
      end

      -- version
      love.graphics.setColor(0.7,0.7,0.7,1)
      love.graphics.setFont(fonts.ormont_tiny)
      love.graphics.print(game.version, 32,  32)
   end

   function robotsLayer:update(dt)
      local items = world:getItems()
      print("length: " .. #items)
      for _, item in pairs(items) do
         if item.type ~= "" then
            item:update(dt)
         end
      end
   end

   map:removeLayer("Objects")

   for k, _ in pairs(map.layers) do
      if k == "Texts" then
         map:removeLayer("Texts")
      end
   end

   for _, robot in ipairs(robotsLayer.robots) do
      world:add(robot, robot.x, robot.y, robot.width, robot.height)
   end

   map:bump_init(world)
end

function game:draw()
   screen:apply()
   love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
   solidLayer:draw()
   robotsLayer:draw()

   for _, hit in pairs(particles) do
      local hitColor = nextColor()
      love.graphics.setColor(hitColor.red, hitColor.green, hitColor.blue, hit.alpha)
      if hit.direction.x == 1 then
         love.graphics.draw(hitParticle, hit.x, hit.y, 0, 1, 1)
      else
         love.graphics.draw(hitParticle, hit.x, hit.y, math.pi, 1, 1)
      end

   end
end

function game:update(dt)
   screen:update(dt)
   robotsLayer:update(dt)
   hitParticle:update(dt)
   hitParticle:emit(3000)

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

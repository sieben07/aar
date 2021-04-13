local game = { version = "0.0.10" }
local global = require "assets.obj.global"
local screen = require "assets.libs.shack.shack"
local map
local robotsLayer
local hero = require "assets.obj.hero"
local shoots = require "assets.obj.shoots"
local particles = global.hits

-- libs
local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local Gamestate = require "assets.libs.hump.gamestate"
-- local Camera = require "assets.libs.hump.camera"
local signal = global.signal;
local world = global.world

-- Helper
local transitions = require "assets.helper.transitions"
local Helper = require "assets.helper.Helper"

-- levels
local levels = require "assets.maps.levels"
local level = ""

-- fonts
local fonts = require "assets.font.fonts"

-- particle system
local hitImage = love.graphics.newImage("assets/img/white.png")
local hitParticle = love.graphics.newParticleSystem(hitImage, 14)
hitParticle:setParticleLifetime(1, 5)
hitParticle:setLinearAcceleration(-20, -30, 20, 30)
hitParticle:setSpeed(20, 30)
hitParticle:setSpin(20, 50)
hitParticle:setSpinVariation(0.7)

local hitAnimation = {
   time = 0.5,
   alpha = 1
}

local function move(w, r, gx, gy, filter)
   local ax, ay, cs, l = w:move(r, gx, gy, filter)
   r.x, r.y = ax, ay
   return cs, l
end

local function clearWorld()
   local items, _ = world:getItems()
   for _, item in pairs(items) do
      world:remove(item)
   end
end

-- game
function game.init()
   signal:register("score", function(value) global.score = global.score + value end)
   signal:register("bounce", function(robot)
      global.background.color = Helper.nextColor()
      robot.velocity = robot.properties.jumpVelocity
      love.graphics.setBackgroundColor(global.background.color.red, global.background.color.green, global.background.color.blue, 1)
   end)
   signal:register("allActive", function() transitions.shouldstart = true end)
   signal:register("hit", function(touch, direction)
         touch.direction = direction
         if direction == "right" then
            touch.x = touch.x + 14
            touch.y = touch.y + 7
         end
         Helper.merge(touch, hitAnimation)
         table.insert(particles, touch)
         screen:setShake(7)
         screen:setRotation(.07)
         screen:setScale(1.007)
   end)
end

function game.enter()
   clearWorld()
   love.graphics.setBackgroundColor(global.background.color.red,global.background.color.green,global.background.color.blue, 1)
   level = levels[global.level.current]

   if global.level.current < #levels then
      global.level.current = global.level.current + 1
   else
      global.level.current = 1
   end

   -- create the world from tiles
   map = sti("assets/maps/" .. level .. ".lua", {"bump"})

   map:addCustomLayer("Robot Layer", 99)
   robotsLayer = map.layers["Robot Layer"]
   robotsLayer.robots = {}
   local heroFromMap, robotsFromMap, textsFromMap = Helper.getSpritesFromMap(map.objects)

   Helper.merge(hero, heroFromMap)

   table.insert(robotsLayer.robots, hero)
   for _, robotAttribute in ipairs(robotsFromMap) do
      table.insert(robotsLayer.robots, robotAttribute)
   end

   for _, text in ipairs(textsFromMap) do
      table.insert(robotsLayer.robots, text)
   end

   function robotsLayer:draw()
      for _, robot in ipairs(self.robots) do
         if robot.type == "hero" then
            love.graphics.draw(robot.image, robot.quads[robot.fsm.current][robot.quadIndex], robot.x, robot.y, robot.rotate, robot.zoom)
         end
         if robot.type == "robot" then
            if robot.active and transitions.shouldstart ~= true then
               love.graphics.setColor(1 - global.background.color.red,1 - global.background.color.green, 1 - global.background.color.blue)
            else
               love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
            end
            love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height)
            love.graphics.setFont(fonts.ormont_small)
            love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
            love.graphics.print(robot.name, robot.x + 40, robot.y)
         end
         if robot.type == "text" then
            love.graphics.setColor(1 - global.background.color.red, 1 - global.background.color.green, 1 - global.background.color.blue, 1)
            love.graphics.setFont(fonts[robot.properties.font])
            love.graphics.printf(robot.name, robot.x, robot.y, love.graphics.getWidth(), robot.properties.align)
         end
      end

      -- score
      love.graphics.setFont(fonts.orange_kid)
      love.graphics.setColor(1, 0.64, 0.02)
      if global.score ~= 1 then
         love.graphics.print(global.score .. " | points", 32, 4)
      else
         love.graphics.print(". | one point left", 32, 4)
      end

      -- version
      love.graphics.setColor(0.7,0.7,0.7,1)
      love.graphics.setFont(fonts.ormont_tiny)
      love.graphics.print(game.version, 32,  32)
   end

   --[[--
   robots:update updates the robots.
   @param dt delta time
   --]]
   function robotsLayer:update(dt)
      local allActive = {}
      local function filterUp(_ , other)
        if other.type == "hero" or other.type == "bullet" then
          return "cross"
        else
          return "slide"
        end
      end

      local function filterDown(_, other)
        if other.type == "bullet" then
          return nil
        else
          return "slide"
        end
      end

      for _, robot in ipairs(self.robots) do

         table.insert(allActive, robot.active)

         if robot.falling == true and robot.type ~= "hero" then
            robot.velocity = robot.velocity + 33.3 * dt
            local goalY = robot.y + robot.velocity
            local _, len = move(world, robot, robot.x, goalY)

            if len ~= 0 then
               robot.falling = false
            end
         end

         if robot.jump == true then
            if robot.velocity < 0 then
               local goalY = robot.y + robot.velocity * dt
               robot.velocity = robot.velocity - robot.gravity * dt
               local cols, _ = move(world, robot, robot.x, goalY, filterUp)
               local dy

               for _, col in ipairs(cols) do
                if col.other.type == "robot" then
                  robot.velocity = 0
                end

                dy = goalY - 32
                if col.other.type == "hero" then
                  move(world, col.other, col.other.x, col.other.y + dy)
                end
              end
            end

            if robot.velocity >= 0 then
               local goalY = robot.y + robot.velocity * dt
               robot.velocity = robot.velocity - robot.gravity * dt
               local _, len = move(world, robot, robot.x, goalY, filterDown)

               if len ~= 0 then
                  signal:emit("bounce", robot)
               end
            end
         end
      end

      if Helper.areAllRobotsActive(allActive) then
         signal:emit("allActive")
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

function game.draw()
   screen:apply()
   love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
   map:draw()
   map:drawLayer(robotsLayer)
   shoots.draw()

   for _, hit in pairs(particles) do
      local hitColor = Helper.nextColor()
      love.graphics.setColor(hitColor.red, hitColor.green, hitColor.blue, hit.alpha)
      if hit.direction == "right" then
         love.graphics.draw(hitParticle, hit.x, hit.y, 0, 0.3, 0.3)
      else
         love.graphics.draw(hitParticle, hit.x, hit.y, math.pi, 0.3, 0.3)
      end

   end
end

function game.update(_, dt)
   screen:update(dt)
   robotsLayer:update(dt)
   Helper.update(dt, hero, world)
   shoots.update()
   hitParticle:update(dt)
   hitParticle:emit(32)

   transitions.particlesTween(particles, dt)

   if transitions.shouldstart == true then
      transitions:selector(game, "randomColor", Gamestate, global, dt)
      love.graphics.setBackgroundColor(
         global.background.color.red,
         global.background.color.green,
         global.background.color.blue
      )
   end
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

   if (key == "up" or key == "a") and hero.fsm.can("jumpPressed") then
      signal:emit("jumpPressed")
   end

   if key == "s" or key == "space" then
      signal:emit("shootPressed", hero)
      signal:emit("score", -1)
   end

   if key == "escape" then
      love.event.push("quit")
   end
end

function love.keyreleased(key)
   if key == "left" and string.match(hero.fsm.current, "left") ~= nil then
      signal:emit("leftReleased")
   end

   if key == "right" and string.match(hero.fsm.current, "right") ~= nil then
      signal:emit("rightReleased")
   end

   if (key == "up" or key == "a") and hero.y_vel < 0 then
      signal:emit("jumpReleased")
   end

   if key == "s" or key == "space" then
      signal:emit("shootReleased")
   end
end

local game = { version = "0.0.6" }
local global = require "assets.obj.global"
local screen = require "assets.libs.shack.shack"
local map
local hero

-- libs
local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local bump = require "assets.libs.bump.bump"
local Gamestate = require "assets.libs.hump.gamestate"
Signal = require "assets.libs.hump.signal"
-- local Camera = require "assets.libs.hump.camera"


-- Helper
local transition = require "assets.helper.transitions"
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

-- game
function game.init()
   Signal.register("score", function(value) global.score = global.score + value end )
   Signal.register("bounce", function() global.background.color = Helper.randomColor() end )
   Signal.register("allActive", function() transition.shouldstart = true end )

   Signal.register("hit", function(touch, direction)
         touch.direction = direction
         if direction == "shootRight" then
            touch.x = touch.x + 14
            touch.y = touch.y + 7
         end
         Helper.merge(touch, hitAnimation)
         table.insert(global.hits, touch)
         screen:setShake(7)
         screen:setRotation(.07)
         screen:setScale(1.007)
      end
   )
end

function game.enter()
   local robotEntity = require "assets.obj.robot"
   local heroPrototype = require("assets.obj.hero")

   level = levels[global.level.current]

   if global.level.current < #levels then
      global.level.current = global.level.current + 1
   else
      global.level.current = 1
   end

   -- create the world from tiles
   map = sti("assets/maps/" .. level .. ".lua", {"bump"})
   world = bump.newWorld(32)
   love.graphics.setBackgroundColor(global.background.color.red,global.background.color.green,global.background.color.blue, 1)

   -- hero
   map:addCustomLayer("hero", 7)
   hero = map.layers["hero"]
   hero.draw = Helper.drawFactory(hero, world)

   -- robots
   map:addCustomLayer("robots", 8)
   robots = map.layers["robots"]

   -- text
   map:addCustomLayer("texts", 9)
   texts = map.layers["texts"]

   mapLayerSolid = map.layers["Solid"]


   local heroObjectFromMap = Helper.getHeroFromMapObjects(map.objects);
   local robotObjectsFromMap = Helper.getRobotsFromMapObjects(map.objects, robotEntity);
   local textObjectsFromMap = Helper.getTextsFromMapObjects(map.objects)

   -- merge hero object into hero
   Helper.merge(hero, heroPrototype) --for k,v in pairs(hero) do hero[k] = v end
   -- merge map info into hero
   Helper.merge(hero, heroObjectFromMap) --for k,v in pairs(player) do hero[k] = v end

   robots.robots = {}
   for _, robotAttribute in ipairs(robotObjectsFromMap) do
      table.insert(robots.robots, robotAttribute)
   end

   texts.texts = {}
   for _, text in ipairs(textObjectsFromMap) do
      table.insert(texts.texts, text)
   end

   function robots:draw()
      for _, robot in ipairs(self.robots) do
        if robot.active and transition.shouldstart ~= true then
         love.graphics.setColor(1 - global.background.color.red,1 - global.background.color.green, 1 - global.background.color.blue)
        else
         love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
        end
         love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height)

         love.graphics.setFont(fonts.ormont_small)
         love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
         love.graphics.print(robot.name, robot.x + 40, robot.y)
      end
   end

   --[[--
   robots:update updates the robots.
   @param dt delta time
   --]]
   function robots:update(dt)
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

         if robot.falling == true then
            robot.velocity = robot.velocity + 33.3 * dt
            local goalY = robot.y + robot.velocity
            local cols, len = move(world, robot, robot.x, goalY)

            if len ~= 0 then
               robot.falling = false
            end
         end

         if robot.jump == true then
            if robot.velocity < 0 then
               local goalY = robot.y + robot.velocity * dt
               robot.velocity = robot.velocity - robot.gravity * dt
               local cols, len = move(world, robot, robot.x, goalY, filterUp)
               local dx, dy

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
               local cols, len = move(world, robot, robot.x, goalY, filterDown)

               if len ~= 0 then
                  -- love.graphics.setBackgroundColor(1 - robot.properties.color.red, 1 - robot.properties.color.green, 1 - robot.properties.color.blue, 1)
                  Signal.emit("bounce", robot)
                  robot.velocity = robot.jumpVelocity
               end
            end
         end
      end

      if Helper.areAllRobotsActive(allActive) then
         Signal.emit("allActive")
      end
   end

   function texts:draw()
      for _, text in ipairs(self.texts) do
         love.graphics.setColor(1 - global.background.color.red, 1 - global.background.color.green, 1 - global.background.color.blue, 1)
         love.graphics.setFont(fonts[text.properties.font])
         love.graphics.printf(text.name, text.x, text.y, love.graphics.getWidth(), text.properties.align)
      end

      love.graphics.setFont(fonts.orange_kid)
      --  love.graphics.setColor(1, 0.64, 0.02)
      love.graphics.setColor(0.5, 0.5, 0.5)
       if global.score ~= 1 then
          love.graphics.print(global.score .. " | points", 32, 4)
       else
          love.graphics.print(". | one point left", 32, 4)
      end
   end

   map:removeLayer("Objects")
   for k, v in pairs(map.layers) do
      if k == "Texts" then
         map:removeLayer("Texts")
      end
   end

   world:add(hero, hero.x, hero.y, hero.width, hero.height)

   for _, robot in ipairs(robots.robots) do
      world:add(robot, robot.x, robot.y, robot.width, robot.height)
   end

   map:bump_init(world)
end

function game.draw()
   screen:apply()
   love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
   map:drawLayer(texts)
   map:drawLayer(mapLayerSolid)
   map:drawLayer(robots)
   map:drawLayer(hero)

   for _, hit in pairs(global.hits) do
      local hitColor = Helper.randomColor()
      love.graphics.setColor(hitColor.red, hitColor.green, hitColor.blue, hit.alpha)
      if hit.direction == "shootRight" then
         love.graphics.draw(hitParticle, hit.x, hit.y, 0, 0.3, 0.3)
      else
         love.graphics.draw(hitParticle, hit.x, hit.y, math.pi, 0.3, 0.3)
      end

   end

   love.graphics.setColor(0.7,0.7,0.7,1)
   love.graphics.setFont(fonts.ormont_tiny)
   love.graphics.print(game.version, 32,  32)
end

function game:update(dt)
   screen:update(dt)
   robots:update(dt)
   Helper.update(dt, hero, world)
   -- hero:update(dt)
   hitParticle:update(dt)
   hitParticle:emit(32)

   transition:hitsTween(global.hits, dt)

   if transition.shouldstart == true then
      transition:selector(game, "randomColor", Gamestate, global, dt)
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
function love.keypressed(key, code, isrepat)
   if key == "left" then
      hero.fsm.leftPress()
      hero.x_vel = -hero.vel
      hero.shootState = "shootLeft"
   end

   if key == "right" then
      hero.fsm.rightPress()
      hero.x_vel = hero.vel
      hero.shootState = "shootRight"
   end

   if (key == "up" or key == "a") and hero.fsm.can("jumpPress") then
      hero.fsm.jumpPress()
      hero.y_vel = hero.jump_vel
      hero.stick_to = ""
      hero.iterator = 1
   end

   if key == "s" or key == "space" then
      hero.fsm.shootPress()
      Helper.shoot(hero, world)
   end

   if key == "escape" then
      love.event.push("quit")
   end
end

function love.keyreleased(key)
   if key == "left" and string.match(hero.fsm.current, "left") ~= nil then
      hero.fsm.leftReleased()
      hero.x_vel = 0
   end

   if key == "right" and string.match(hero.fsm.current, "right") ~= nil then
      hero.fsm.rightReleased()
      hero.x_vel = 0
   end

   if key == "s" or key == "space" then
      hero.fsm.shootReleased()
   end

   if (key == "up" or key == "a") and hero.y_vel < 0 then
      hero.y_vel = 1
   end
end

function move(w, r, gx, gy, filter)
   local ax, ay, cs, l = w:move(r, gx, gy, filter)
   r.x, r.y = ax, ay
   return cs, l
end

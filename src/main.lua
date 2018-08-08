local game = { version = "0.0.6" }
local global = require "assets.obj.global"
local screen = require "assets.libs.shack.shack"
Signal = require "assets.libs.hump.signal"


-- libs
local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local bump = require "assets.libs.bump.bump"
local Gamestate = require "assets.libs.hump.gamestate"

-- Helper
local transition = require "assets.helper.transitions"
local Helper = require "assets.helper.Helper"

-- levels
local levels = require "assets.maps.levels"
local level = ""

-- fonts
local fonts = require "assets.font.fonts"

-- game
function game:init()
   file = love.filesystem.newFile( "global.lua" )
   love.success = love.filesystem.write("global.lua", table.tostring(global))
   Signal.register("score", function(value) global.score = global.score + value end )
   Signal.register("bounce", function(robot) robot.properties.color = Helper.randomColor() end )
   Signal.register("allActive", function() transition.shouldstart = true end )
   Signal.register("hit", function(touch)
      screen:setShake(20)
      screen:getRotation(.3)
      screen:setScale(1.005, 1.005)
   end )
end

function game:enter()
   local robotPrototype = require "assets.obj.robot"
   local heroPrototype = require("assets.obj.hero")

   level = levels[global.level.current]

   if global.level.current < #levels then
      global.level.current = global.level.current + 1
   else
      global.level.current = 1
   end

   -- create the world from triles
   map = sti("assets/maps/" .. level .. ".lua", {"bump"})
   world = bump.newWorld(32)
   love.graphics.setBackgroundColor(global.background.color.red,global.background.color.green,global.background.color.blue)

   -- hero
   map:addCustomLayer("hero", 7)
   hero = map.layers["hero"]

   -- robots
   map:addCustomLayer("robots", 8)
   robots = map.layers["robots"]

   -- text
   map:addCustomLayer("texts", 9)
   texts = map.layers["texts"]

   mySolid = map.layers["Solid"]


   local heroAttributeFromMap, robotAttributesFromMap, textAttributesFromMap = Helper.loadRobots(map.objects, robotPrototype)

   -- merge hero object into hero
   Helper.merge(hero, heroPrototype) --for k,v in pairs(hero) do hero[k] = v end
   -- merge map info into hero
   Helper.merge(hero, heroAttributeFromMap) --for k,v in pairs(player) do hero[k] = v end

   robots.robots = {}
   for _, robotAttribute in ipairs(robotAttributesFromMap) do
      table.insert(robots.robots, robotAttribute)
   end

   texts.texts = {}
   for _, text in ipairs(textAttributesFromMap) do
      table.insert(texts.texts, text)
   end

   function hero:push(dx, dy)
      local cols, len = move(world, self, self.x + dx, self.y + dy)
   end

   function hero:draw()
      -- player
      love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
      love.graphics.draw(self.image, self.quads[self.fsm.current][self.quadIndex], self.x, self.y, self.rotate, self.zoom)

      -- shoots
      local shoots, _ = world:getItems()

      for _, shoot in ipairs(shoots) do
         if shoot.type == "bullet" then
            love.graphics.draw(self.image, self.quads[shoot.dir][1], shoot.x, shoot.y, 0, 1)
         end
      end

      love.graphics.setFont(fonts.orange_kid)
      love.graphics.setColor(1, 0.64, 0.02)
      if global.score ~= 1 then
         love.graphics.print(global.score .. " | points", 32, 4)
      else
         love.graphics.print(". | one point left", 32, 4)
      end
   end

   function robots:draw()
      for _, robot in ipairs(self.robots) do
        if robot.active and  transition.shouldstart ~= true then
        love.graphics.setColor(robot.properties.color.red, robot.properties.color.green, robot.properties.color.blue)
        else
          love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
        end
         love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height)

         love.graphics.setFont(fonts.ormont_small)
         love.graphics.setColor(1, 0.647, 0.027, 1)
         love.graphics.print(robot.name, robot.x + 40, robot.y)
      end
   end

   --[[--
   robots:update updates the robots.
   @param dt delta time
   --]]
   function robots:update(dt)
      local allActive = {}
      local function filterUp(item , other)
        if other.type == "hero" or other.type == "bullet" then
          return "cross"
        else
          return "slide"
        end
      end

      local function filterDown(item, other)
        if other.type == "bullet" then
          return nil
        else
          return "slide"
        end
      end

      for _, robot in ipairs(self.robots) do
         table.insert(allActive, robot.active)

         if robot.falling == true then
            robot.velocity = robot.velocity + 40 / 1.2 * dt
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
                  col.other:push(0, dy)
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
         love.graphics.setColor(text.properties.color.red, text.properties.color.green, text.properties.color.blue, text.properties.color.alpha)
         love.graphics.setFont(fonts[text.properties.font])
         love.graphics.printf(text.name, text.x, text.y, love.graphics.getWidth(), text.properties.align)
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

function game:draw()
   screen:apply()
   love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
   map:drawLayer(texts)
   map:drawLayer(mySolid)
   map:drawLayer(robots)
   -- map:bump_draw(world,1,1,1,1)
   -- texts:draw()
   -- robots:draw()
   hero:draw()
   love.graphics.setColor(0.7,0.7,0.7,1)
   love.graphics.setFont(fonts.ormont_tiny)
   love.graphics.print(game.version, 32,  32)
end

function game:update(dt)
   screen:update(dt)
   robots:update(dt)
   hero:update(dt)

   if transition.shouldstart == true then
      transition:selector(game, "randomColor", Gamestate, global, dt)
      love.graphics.setBackgroundColor(
         global.background.color.red,
         global.background.color.red,
         global.background.color.red
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
      hero.jump = 8
      hero.stick_to = ""
      hero.iterator = 1
   end

   if key == "s" or key == "space" then
      hero.fsm.shootPress()
      hero:shoot()
      hero.shooting = true
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
      hero.shooting = false
   end

   if (key == "up" or key == "a") and hero.y_vel >= 0 and hero.jump > 0 then
      hero.jump = 1
   end
end

-- don"t repeat yourself
-- funtcions
function move(w, r, gx, gy, filter)
  local ax, ay, cs, l = w:move(r, gx, gy, filter)
  r.x, r.y = ax, ay
  return cs, l
end

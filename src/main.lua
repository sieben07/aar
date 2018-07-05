local game = {}
isInAir = false;
local global = require "assets.obj.global"
Signal = require "assets.libs.hump.signal"

-- HERO STATE MACHINE
local machine = require('assets.libs.lua-fsm.src.fsm')
heroState = machine.create({
  initial = "right",
  events = {
    { name = "jumpPress", from = "right", to = "rightInAir" },
    { name = "rightPress", from = "right", to = "rightMoving" },
    { name = "shootPress", from = "right", to = "rightShooting" },
    { name = "collisionGround", from = "rightInAir", to = "right" },
    { name = "rightPress", from = "rightInAir", to = "rightInAirMoving" },
    { name = "shootPress", from = "rightInAir", to = "rightInAirShooting" },
    { name = "rightReleased", from = "rightMoving", to = "right" },
    { name = "jumpPress", from = "rightMoving", to = "rightInAirMoving" },
    { name = "shootPress", from = "rightMoving", to = "rightMovingShooting" },
    { name = "shootReleased", from = "rightShooting", to = "right" },
    { name = "jumpPress", from = "rightShooting", to = "rightInAirShooting" },
    { name = "rightPress", from = "rightShooting", to = "rightMovingShooting" },
    { name = "rightReleased", from = "rightInAirMoving", to = "rightInAir" },
    { name = "shootPress", from = "rightInAirMoving", to = "rightInAirMovingShooting" },
    { name = "collisionGround", from = "rightInAirMoving", to = "rightMoving" },
    { name = "shootReleased", from = "rightInAirShooting", to = "rightInAir" },
    { name = "collisionGround", from = "rightInAirShooting", to = "rightShooting" },
    { name = "rightPress", from = "rightInAirShooting", to = "rightInAirMovingShooting" },
    { name = "rightReleased", from = "rightMovingShooting", to = "rightShooting" },
    { name = "shootReleased", from = "rightMovingShooting", to = "rightMoving" },
    { name = "jumpPress", from = "rightMovingShooting", to = "rightInAirMovingShooting" },
    { name = "shootReleased", from = "rightInAirMovingShooting", to = "rightInAirMoving" },
    { name = "rightReleased", from = "rightInAirMovingShooting", to = "rightInAirShooting" },
    { name = "collisionGround", from = "rightInAirMovingShooting", to = "rightMovingShooting" },
    { name = "jumpPress", from = "left", to = "leftInAir" },
    { name = "leftPress", from = "left", to = "leftMoving" },
    { name = "shootPress", from = "left", to = "leftShooting" },
    { name = "collisionGround", from = "leftInAir", to = "left" },
    { name = "leftPress", from = "leftInAir", to = "leftInAirMoving" },
    { name = "shootPress", from = "leftInAir", to = "leftInAirShooting" },
    { name = "leftReleased", from = "leftMoving", to = "left" },
    { name = "jumpPress", from = "leftMoving", to = "leftInAirMoving" },
    { name = "shootPress", from = "leftMoving", to = "leftMovingShooting" },
    { name = "shootReleased", from = "leftShooting", to = "left" },
    { name = "jumpPress", from = "leftShooting", to = "leftInAirShooting" },
    { name = "leftPress", from = "leftShooting", to = "leftMovingShooting" },
    { name = "leftReleased", from = "leftInAirMoving", to = "leftInAir" },
    { name = "shootPress", from = "leftInAirMoving", to = "leftInAirMovingShooting" },
    { name = "collisionGround", from = "leftInAirMoving", to = "leftMoving" },
    { name = "shootReleased", from = "leftInAirShooting", to = "leftInAir" },
    { name = "collisionGround", from = "leftInAirShooting", to = "leftShooting" },
    { name = "leftPress", from = "leftInAirShooting", to = "leftInAirMovingShooting" },
    { name = "leftReleased", from = "leftMovingShooting", to = "leftShooting" },
    { name = "shootReleased", from = "leftMovingShooting", to = "leftMoving" },
    { name = "jumpPress", from = "leftMovingShooting", to = "leftInAirMovingShooting" },
    { name = "shootReleased", from = "leftInAirMovingShooting", to = "leftInAirMoving" },
    { name = "leftReleased", from = "leftInAirMovingShooting", to = "leftInAirShooting" },
    { name = "collisionGround", from = "leftInAirMovingShooting", to = "leftMovingShooting" },
    { name = "leftPress", from = "right", to = "leftMoving" },
    { name = "leftPress", from = "rightInAir", to = "leftInAirMoving" },
    { name = "leftPress", from = "rightInAirMoving", to = "leftInAirMoving" },
    { name = "leftPress", from = "rightInAirMovingShooting", to = "leftInAirMovingShooting" },
    { name = "leftPress", from = "rightInAirShooting", to = "leftInAirMovingShooting" },
    { name = "leftPress", from = "rightMoving", to = "leftMoving" },
    { name = "leftPress", from = "rightMovingShooting", to = "leftMovingShooting" },
    { name = "leftPress", from = "rightShooting", to = "leftMovingShooting" },
    { name = "rightPress", from = "left", to = "rightMoving" },
    { name = "rightPress", from = "leftInAir", to = "rightInAirMoving" },
    { name = "rightPress", from = "leftInAirMoving", to = "rightInAirMoving" },
    { name = "rightPress", from = "leftInAirMovingShooting", to = "rightInAirMovingShooting" },
    { name = "rightPress", from = "leftInAirShooting", to = "rightInAirMovingShooting" },
    { name = "rightPress", from = "leftMoving", to = "rightMoving" },
    { name = "rightPress", from = "leftMovingShooting", to = "rightMovingShooting" },
    { name = "rightPress", from = "leftShooting", to = "rightMovingShooting" },
  }
})


-- libs
local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local bump = require "assets.libs.bump.bump"
local Gamestate = require "assets.libs.hump.gamestate"

-- helper
local transition = require "assets.helper.transitions"
local helper = require "assets.helper.Helper"

-- levels
local levels = require "assets.maps.levels"
local level = ""

-- fonts
local fonts = require "assets.font.fonts"

-- game
function game:init()
  file = love.filesystem.newFile( 'global.lua' )
  love.success = love.filesystem.write('global.lua', table.tostring(global))
  Signal.register('score', function(value) global.score = global.score + value end )
  Signal.register('bounce', function() end )
  Signal.register('allActive', function() transition.shouldstart = true end )
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

  love.graphics.setBackgroundColor(
    global.background.color.red,
    global.background.color.green,
    global.background.color.blue
  )

  -- hero
  map:addCustomLayer("hero", 7)
  hero = map.layers["hero"]

  -- robots
  map:addCustomLayer("robots", 8)
  robots = map.layers["robots"]


  -- text
  map:addCustomLayer("texts", 9)
  texts = map.layers["texts"]

  local heroAttributeFromMap, robotAttributesFromMap, textAttributesFromMap = helper.loadRobots(map.objects, robotPrototype)

  -- merge hero object into hero
  helper.merge(hero, heroPrototype) --for k,v in pairs(hero) do hero[k] = v end
  -- merge map info into hero
  helper.merge(hero, heroAttributeFromMap) --for k,v in pairs(player) do hero[k] = v end

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
    love.graphics.setColor(1,1,1,1)   --global.color.red, global.color.green, global.color.blue, global.color.alpha)
    love.graphics.rectangle("fill", self.x, self.y, 32, 32)
    love.graphics.draw(self.image, self.quads[self.state][self.quadIndex], self.x, self.y, self.rotate, self.zoom)

    -- shoots
    local shoots, _ = world:getItems()

    for _, shoot in pairs(shoots) do
      if shoot.type == "bullet" then
        love.graphics.draw(self.image, self.quads[shoot.dir][1], shoot.x, shoot.y, 0, 1)
      end
    end

    love.graphics.setFont(fonts.orangekid)
    love.graphics.setColor(1, 0.64, 0.02)
    if global.score > 1 then
      love.graphics.print(global.score .. " | points", 32, 4)
    else
      love.graphics.print(". | one point left", 32, 4)
    end
  end

  function robots:draw()
    for i, robot in ipairs(self.robots) do
      love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
      love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height)

      love.graphics.setFont(fonts.ormontSmall)
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

          local cols, len = move(world, robot, robot.x, goalY, "cross")

          local dx, dy
          for _, col in ipairs(cols) do
            -- dx = (1 - col.ti)
            dy = goalY - 32
            col.other:push(0, dy)
          end
        end

        if robot.velocity >= 0 then
          local goalY = robot.y + robot.velocity * dt
          robot.velocity = robot.velocity - robot.gravity * dt

          local cols, len = move(world, robot, robot.x, goalY)

          if len ~= 0 then
            Signal.emit('bounce')
            robot.velocity = robot.jumpVelocity
          end
        end
      end
    end

    if helper.areAllRobotsActive(allActive) then
      Signal.emit('allActive')
    end
  end

  function texts:draw()
    for i, text in ipairs(self.texts) do
      love.graphics.setColor(
        text.properties.color.red,
        text.properties.color.green,
        text.properties.color.blue,
        text.properties.color.alpha
      )
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
  for i, robot in ipairs(robots.robots) do
    world:add(robot, robot.x, robot.y, robot.width, robot.height)
  end

  map:bump_init(world)
end

function game:draw()
  love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
  map:draw()
  texts:draw()
  robots:draw()
  hero:draw()
end

function game:update(dt)
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
    heroState.leftPress()
    hero.x_vel = -hero.vel
    hero.shootState = "shootLeft"
  end

  if key == "right" then
    heroState.rightPress()
    hero.x_vel = hero.vel
    hero.shootState = "shootRight"
  end

  if (key == "up" or key == "a") and hero.y_vel == 0 then
    heroState.jumpPress()
    hero.jump = 7
    hero.iterator = 1
  end

  if key == "s" or key == "space" then
    heroState.shootPress()
    hero:shoot()
    hero.shooting = true
  end

  if key == "escape" then
    love.event.push("quit")
  end
end

function love.keyreleased(key)
  if key == "left" and string.match(heroState.current, "left") ~= nil then
    heroState.leftReleased()
    hero.x_vel = 0
  end

  if key == "right" and string.match(heroState.current, "right") ~= nil then
    heroState.rightReleased()
    hero.x_vel = 0
  end

  if key == "s" or key == "space" then
    heroState.shootReleased()
    hero.shooting = false
  end

  if (key == "up" or key == "a") and hero.y_vel >= 0 and hero.jump > 0 then
    hero.jump = 1
  end
end

-- don't repeat yourself
-- funtcions

function move (w, r, gx, gy, filter)
  if filter == nil then filter = "slide" end
  local ax, ay, cs, l = w:move(r, gx, gy, function(a, b) return filter end)
  r.x, r.y = ax, ay
  return cs, l
end

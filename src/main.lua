local game = {}
local global = require "assets.obj.global"
Signal = require "assets.libs.hump.signal"

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
  local robotObject = require "assets.obj.robot"
  local heroObject  = require("assets.obj.hero")

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
    global.background.color.red,
    global.background.color.red
  )

  -- hero
  map:addCustomLayer("playerLayer", 7)
  playerLayer = map.layers["playerLayer"]

  -- robots
  map:addCustomLayer("robotsLayer", 8)
  robotsLayer = map.layers["robotsLayer"]

  for k, v in pairs(robotsLayer) do
    print(k, v)
  end

  -- text
  map:addCustomLayer("textLayer", 9)
  textLayer = map.layers["textLayer"]

  local heroAttributeFromMap, robotAttributesFromMap, textAttributesFromMap = helper.loadRobots(map.objects, robotObject)

  -- merge hero object into playerLayer
  helper.merge(playerLayer, heroObject) --for k,v in pairs(hero) do playerLayer[k] = v end
  -- merge map info into playerLayer
  helper.merge(playerLayer, heroAttributeFromMap) --for k,v in pairs(player) do playerLayer[k] = v end

  robotsLayer.robots = {}
  for _, robotAttribute in ipairs(robotAttributesFromMap) do
    table.insert(robotsLayer.robots, robotAttribute)
  end

  textLayer.texts = {}
  for _, text in ipairs(textAttributesFromMap) do
    table.insert(textLayer.texts, text)
  end

  function playerLayer:push(dx, dy)
    local cols, len = move(world, self, self.x + dx, self.y + dy)
  end

  function playerLayer:draw()
    -- player
    love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
    love.graphics.draw(self.image, self.quads[self.direction][self.iterator], self.x, self.y, self.rotate, self.zoom)

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

  function robotsLayer:draw()
    for i, robot in ipairs(self.robots) do
      love.graphics.setColor(1 - global.color.red, 1 - global.color.green, 1 - global.color.blue)
      love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height)

      love.graphics.setFont(fonts.ormontSmall)
      love.graphics.setColor(1, 0.647, 0.027, 1)
      love.graphics.print(robot.name, robot.x + 40, robot.y)
    end
  end


  --[[--
  robotsLayer:update updates the robots.
  @param dt delta time
  --]]
  function robotsLayer:update(dt)
    local allActive = {}

    for i, robot in ipairs(self.robots) do
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

  function textLayer:draw()
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

  world:add(playerLayer, playerLayer.x, playerLayer.y, playerLayer.width, playerLayer.height)
  for i, robot in ipairs(robotsLayer.robots) do
    world:add(robot, robot.x, robot.y, robot.width, robot.height)
  end

  map:bump_init(world)
end

function game:draw()
  love.graphics.setColor(global.color.red, global.color.green, global.color.blue, global.color.alpha)
  map:draw()
  textLayer:draw()
  robotsLayer:draw()
  playerLayer:draw()
end

function game:update(dt)
  robotsLayer:update(dt)
  playerLayer:update(dt)

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
    playerLayer.x_vel = -playerLayer.vel
    playerLayer.status = "shootLeft"
  end

  if key == "right" then
    playerLayer.x_vel = playerLayer.vel
    playerLayer.status = "shootRight"
  end

  if (key == "up" or key == "a") and playerLayer.y_vel == 0 then
    playerLayer.jump = 7
    playerLayer.iterator = 1
  end

  if key == "space" or key == "s" then
    playerLayer:shoot()
    playerLayer.shooting = true
  end

  if key == "escape" then
    love.event.push("quit")
  end
end

function love.keyreleased(key)
  if key == "left" then
    playerLayer.x_vel = 0
  end

  if key == "right" then
    playerLayer.x_vel = 0
  end

  if key == "s" or key == "space" then
    playerLayer.shooting = false
  end

  if (key == "up" or key == "a") and playerLayer.y_vel >= 0 and playerLayer.jump > 0 then
    playerLayer.jump = 1
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

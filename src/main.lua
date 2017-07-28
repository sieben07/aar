--[[--
@author Orhan Kücükyilmaz
--]]
local game = {}
local global = {
  level = {
    current = 1
  },
  color = {
    red = 0,
    green = 0,
    blue = 0,
    alpha = 255
  },
  background = {
    color = {
      red = 77,
      green = 77,
      blue = 77
    }
  },
  countdown = 4
}

local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local bump = require "assets.libs.bump.bump"
local Gamestate = require "assets.libs.hump.gamestate"
local transition = require "assets.helper.transitions"

local levels = {'start', 'level01', 'level02', 'level03', 'level04'}
local level = ''

local Robot = require "assets.obj.Robot"
local helper = require "assets.helper.Helper"

-- fonts
fonts = {
  defaultFont = love.graphics.newFont("assets/font/Orial_Bold.otf", 24),
  orial = love.graphics.newFont("assets/font/Orial_Bold.otf", 57),
  ormont = love.graphics.newFont("assets/font/Ormont_Light.ttf", 38),
  ormontMiddle = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28),
  ormontSmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 18),
  orangekid = love.graphics.newFont("assets/font/orangekid.ttf", 23)
}

function game:enter( )
  local robotEntity = Robot.new();
  level = levels[global.level.current]
  global.level.current = global.level.current + 1

  local heroEntity = require('assets.obj.hero')
  map = sti("assets/maps/" .. level .. ".lua", {"bump"})
  world = bump.newWorld(32)

  love.graphics.setBackgroundColor(global.background.color.red, global.background.color.red, global.background.color.red)

  map:addCustomLayer("playerLayer", 7)
  playerLayer = map.layers["playerLayer"]
  map:addCustomLayer("robotsLayer", 8)
  robotsLayer = map.layers['robotsLayer']
  map:addCustomLayer("textLayer", 9)
  textLayer = map.layers['textLayer']

  local heroRobot, robots, texts = helper.loadRobots(map.objects, robotEntity);

  -- merge hero object into playerLayer
  helper.merge(playerLayer, heroEntity) --for k,v in pairs(hero) do playerLayer[k] = v end
  -- merge map info into playerLayer
  helper.merge(playerLayer, heroRobot) --for k,v in pairs(player) do playerLayer[k] = v end

  robotsLayer.robots = {}
  for i, robot in ipairs(robots) do
    table.insert(robotsLayer.robots, robot)
  end

  textLayer.texts = {}
  for i, text in ipairs(texts) do
    table.insert(textLayer.texts, text)
  end

  function playerLayer:draw()
    -- player
    love.graphics.draw(self.image, self.quads[self.direction][self.iterator], self.x,self.y, self.rotate, self.zoom)

    -- shoots
    local shoots, _ = world:getItems()

    for i, shoot in pairs(shoots) do
      if shoot.type == "bullet" then
        -- love.graphics.rectangle("fill", shoot.x, shoot.y, shoot.width, shoot.height )
        love.graphics.draw(self.image, self.quads[shoot.dir][1], shoot.x, shoot.y, 0, 1)
      end
    end


    love.graphics.setFont(fonts.orangekid)
    love.graphics.setColor(255, 165, 7)
    if self.score > 1 then
      love.graphics.print( self.score..' | points', 32,  4)
    else
      love.graphics.print( '. | one point left', 32,  4)
    end

  end

  function robotsLayer:draw()
    for i, robot in ipairs(self.robots) do
      love.graphics.setColor(248, 248, 255)
      love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height )


      love.graphics.setFont(fonts.ormontMiddle)
      love.graphics.setColor(255, 165, 7, 255)
      love.graphics.print( robot.name, robot.x, robot.y)
    end
  end

  --[[--
  robotsLayer:update updates the robots.
  @param dt delta time
  --]]
  function robotsLayer:update(dt)
    for i, robot in ipairs(self.robots) do

      if robot.falling == true then
        robot.velocity = robot.velocity + 40 / 1.2 * dt
        local goalY = robot.y + robot.velocity
        local actualX, actualY, cols, len = world:move(robot, robot.x, goalY)
        robot.y = actualY

        if len ~= 0 then
          robot.falling = false
        end
      end

      if robot.jump == true then
        if robot.velocity <= 0 then
          --robot.velocity = robot.jumpVelocity
        end

        if robot.velocity ~= 0 then
          robot.goalY = robot.y + robot.velocity * dt
          robot.velocity = robot.velocity - robot.gravity * dt

          local actualX, actualY, cols, len = world:move(robot, robot.x, robot.goalY)
          robot.y = actualY

          if len ~= 0 then
            robot.velocity = robot.jumpVelocity
          end
        end
      end

      if robot.move == true then
        print('should move')
        robot.move = false
      end

      if robot.shoot == true then
        print('should fire')
        robot.shoot = false
      end
    end
  end

  function textLayer:draw( )
    for i, text in ipairs(self.texts) do
      love.graphics.setColor(text.properties.color.red, text.properties.color.green, text.properties.color.blue, text.properties.color.alpha)
      love.graphics.setFont(fonts[text.properties.font])
      love.graphics.printf( text.name, text.x, text.y, love.graphics.getWidth() , text.properties.align)
    end
  end

  map:removeLayer("Objects")
  for k,v in pairs(map.layers) do
    if k == 'Texts' then
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
  love.graphics.setColor(global.color.red, global.color.green , global.color.blue, global.color.alpha)
  map:draw()
  playerLayer:draw()
  robotsLayer:draw()
  textLayer:draw()
end

function game:update(dt)
  playerLayer:update(dt)
  robotsLayer:update(dt)
  if transition.shouldstart == true then
    transition:selector(game, "randomColor", Gamestate, global, dt)
    love.graphics.setBackgroundColor(global.background.color.red, global.background.color.red, global.background.color.red)
  end
  --map:update(dt)
end

function love.load( )
 Gamestate.registerEvents()
 Gamestate.switch(game)
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key, code, isrepat)
    if key == 'return' then
        -- return Gamestate.switch(game)
        transition.shouldstart = true
    end

    if key == "left" then
        playerLayer.x_vel = -playerLayer.vel
        playerLayer.status = "shootLeft"
    end

    if key == "right" then
        playerLayer.x_vel = playerLayer.vel
        playerLayer.status = "shootRight"
    end

    if (key == "up" or key =="a") and playerLayer.y_vel == 0 then
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

    if (key == "up" or key =="a") and playerLayer.y_vel >= 0 and playerLayer.jump > 0 then
        playerLayer.jump = 1
    end
end

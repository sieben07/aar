local sti = require "assets.libs.Simple-Tiled-Implementation.sti"
local bump = require "assets.libs.bump.bump"
local flux = require "assets.libs.flux.flux"

local timer = 0 -- Zeit Variable fuer Animation

-- fonts
defaultFont = love.graphics.newFont("assets/font/Orial_Bold.otf", 24)
orial = love.graphics.newFont("assets/font/Orial_Bold.otf", 57)
ormont = love.graphics.newFont("assets/font/Ormont_Light.ttf", 38)
ormontMiddle = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28)
ormontSmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 18)
orangekid = love.graphics.newFont("assets/font/orangekid.ttf", 23)


function love.load( )
  local hero = require('assets.obj.hero')
  love.graphics.setBackgroundColor(102, 51, 0)
  map = sti("assets/maps/start.lua", {"bump"})
  world = bump.newWorld(32)

  map:addCustomLayer("playerLayer", 7)
  --playerLayer = map.layers["playerLayer"]
  map:addCustomLayer("robotsLayer", 8)
  robotsLayer = map.layers['robotsLayer']

  for k, object in pairs(map.objects) do
    if object.name == "Player" then
      player = object
    end

    if object.name == "Start" then
      start = object
    end
  end
  
  playerLayer         = hero
  playerLayer.falling = player.properties.falling
  playerLayer.name    = player.name
  playerLayer.x       = player.x
  playerLayer.y       = player.y
  playerLayer.height  = player.height
  playerLayer.width   = player.width
  playerLayer.title   = player.type

  robotsLayer.start = {
    name = start.name,
    x = start.x,
    y = start.y,
    height = start.height,
    width = start.width,
    title = start.type
  }

  colorFade = {
    red = 255,
    green = 255,
    blue = 255,
    alpha = 0
  }

  startPosition = {
    x = start.x,
    y = start.y
  }

  flux.to(startPosition, 4, {x = start.x + 16, y = start.y + 16}):ease('quadin'):delay(3)
  flux.to(colorFade, 4, {red = 30, green = 144, blue = 255, alpha = 255}):ease('quadin'):delay(3)

  function playerLayer:draw()
    -- player
    love.graphics.setColor(255, 255, 255)
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.image, self.quads[self.direction][self.iterator], self.x,self.y, self.rotate, self.zoom)
    love.graphics.setColor(173,212,88,125)
    love.graphics.draw(self.image, self.quads[self.direction][self.iterator], self.x/8 + 32, self.y/8 + 32, self.rotate, self.zoom/8)

    love.graphics.setFont(orangekid)
    love.graphics.setColor(205, 34, 77)
    if self.score > 1 then
      love.graphics.print( self.score..' | points', 32,  8)
    else
      love.graphics.print( '. | one point left', 32,  8)
    end

  end

  function robotsLayer:draw()
    -- start robot
    love.graphics.setFont(orial)
    love.graphics.setColor(colorFade.red, colorFade.green, colorFade.blue, colorFade.alpha)
    love.graphics.printf( "one point left", 0, 128, love.graphics.getWidth(), 'center')
    
    
    love.graphics.setColor(30, 144, 255)
    love.graphics.rectangle("fill", start.x, start.y, start.width, start.height )

    love.graphics.setFont(ormont)
    love.graphics.setColor(255, 165, 7)
    love.graphics.printf( "activate all robots", 0, 167, love.graphics.getWidth(), 'center')
    love.graphics.setFont(ormontMiddle)
    love.graphics.print( self.start.name, startPosition.x, startPosition.y)
  end

  map:removeLayer("Objects")
  world:add(playerLayer, playerLayer.x, playerLayer.y, playerLayer.width, playerLayer.height)
  world:add(robotsLayer.start, robotsLayer.start.x, robotsLayer.start.y, robotsLayer.start.width, robotsLayer.start.height)

  map:bump_init(world)
end

function love.update(dt)
  flux.update(dt)
  playerLayer:update(dt)
  map:update(dt)
end

function love.draw()
  love.graphics.setColor(179,89,0)
  map:draw()
  playerLayer:draw()
  robotsLayer:draw()

  ---[[ -- Collision map
  love.graphics.setColor(255, 255, 255, 50)
  map:bump_draw(world, 256,256,0.125, 0.125)
  --]]
end
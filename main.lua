local sti = require "libs.Simple-Tiled-Implementation.sti"
local bump = require "libs.bump.bump"

local timer = 0 -- Zeit Variable fuer Animation

-- fonts
ormontsmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28)


function love.load( )
  local hero = require('hero')
  love.graphics.setBackgroundColor(102, 51, 0)
  map = sti("assets/maps/start.lua", {"bump"})
  world = bump.newWorld(32)

  map:addCustomLayer("playerLayer", 7)
  playerLayer = map.layers["playerLayer"]
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
  
  playerLayer.hero         = hero
  playerLayer.hero.falling = player.properties.falling
  playerLayer.hero.name    = player.name
  playerLayer.hero.x       = player.x
  playerLayer.hero.y       = player.y
  playerLayer.hero.height  = player.height
  playerLayer.hero.width   = player.width
  playerLayer.hero.title   = player.type

  print(playerLayer.score)
  
  robotsLayer.start = {
    name = start.name,
    x = start.x,
    y = start.y,
    height = start.height,
    width = start.width,
    title = start.type
  }

  -- function layer:update(dt)
  --   local speed = 128
  --   -- Move player up
  --   for k, object in pairs(self) do
  --     if type(object) == "table" then

  --     end
  --   end

  --   -- Animation Framerate
  --   if self.player.x_vel ~= 0 and self.player.y_vel == 0  then
  --       timer = timer + dt
  --       if timer > 0.04 then
  --           timer = 0
  --           self.player.iterator = self.player.iterator + 1
  --           print(self.player.iterator)
  --           if self.player.iterator > self.player.max then
  --               self.player.iterator = 2
  --           end
  --       end
  --   end

  --   if love.keyboard.isDown("up") then
  --     goalY = self.player.y - speed * dt
  --     local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
  --     self.player.y = actualY
  --   end

  --   -- Move player down
  --   if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
  --       goalY = self.player.y + speed * dt
  --       local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
  --       self.player.y = actualY
  --   end

  --   -- Move player left
  --   if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
  --     goalX = self.player.x - speed * dt

  --     local actualX, actualY, cols, len = world:move(self.player, goalX, self.player.y)
  --     self.player.x = actualX
  --   end

  --   -- Move player right
  --   if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
  --     goalX = self.player.x + speed * dt
  --     local actualX, actualY, cols, len = world:move(self.player, goalX, self.player.y)
  --     self.player.x = actualX
  --   end

  --   -- Jump player
  --   if love.keyboard.isDown("space") or love.keyboard.isDown("w") then
  --     if self.player.jump == false then
  --       self.player.jump = true
  --       self.player.jumpVelocity = 128
  --     end
  --   end

  --   if self.player.jump == true then
  --     goalY = self.player.y - self.player.jumpVelocity * dt
  --     local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
  --     for i=1,len do -- If more than one simultaneous collision, they are sorted out by proximity
  --       for key,value in pairs(cols[i].normal) do
  --         print(cols[i].normal.y)
  --         if cols[i].normal.y == 1 then
  --           self.player.jumpVelocity = 0
  --         elseif cols[i].normal.y == -1 then
  --           self.player.jump = false
  --           self.player.jumpVelocity = 0
  --         end
  --       end
  --     end
  --     self.player.y = actualY
  --     self.player.jumpVelocity = self.player.jumpVelocity - 16 * dt
  --   end
  -- end

  function playerLayer:draw()
    -- player
    love.graphics.setColor(255, 255, 255)
    --love.graphics.draw(self.hero.sprite, self.hero.x, self.hero.y, 0, 1,1)
    -- draw the hero
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.hero.image, self.hero.quads[self.hero.direction][self.hero.iterator], self.hero.x,self.hero.y, self.hero.rotate, self.hero.zoom)
    love.graphics.setColor(173,212,88,125)
    --love.graphics.draw(self.player.sprite, hero.x/8 + 32,hero.y/8 + 32, hero.rotate, hero.zoom/8)

    -- start robot
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", start.x, start.y, start.width, start.height )

    love.graphics.setFont(ormontsmall)
    love.graphics.setColor(0, 51, 102)
    --love.graphics.print( self.start.name, self.start.x, self.start.y)
  end

  map:removeLayer("Objects")
  world:add(playerLayer.hero, playerLayer.hero.x, playerLayer.hero.y, playerLayer.hero.width, playerLayer.hero.height)
  world:add(robotsLayer.start, robotsLayer.start.x, robotsLayer.start.y, robotsLayer.start.width, robotsLayer.start.height)

  map:bump_init(world)
end

function love.update(dt)
  playerLayer.hero:update(dt)
  map:update(dt)
end

function love.draw()
  love.graphics.setColor(179,89,0)
  map:draw()
  playerLayer:draw()

  ---[[ -- Collision map
  love.graphics.setColor(255, 255, 255, 50)
  map:bump_draw(world, 256,256,0.125, 0.125)
  --]]
end
local sti = require "libs.Simple-Tiled-Implementation.sti"
local bump = require "libs.bump.bump"

-- fonts
ormontsmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28)


function love.load( )
  love.graphics.setBackgroundColor(102, 51, 0)
  map = sti("assets/maps/start.lua", {"bump"})
  world = bump.newWorld(32)

  map:addCustomLayer("GhostLayer", 7);
  layer = map.layers["GhostLayer"];

  for k, object in pairs(map.objects) do
    if object.name == "Player" then
      player = object
    end

    if object.name == "Start" then
      start = object
    end
  end

  local sprite = love.graphics.newImage("assets/img/player/orange.png")

  layer.player = {
    falling = player.properties.falling,
    name = player.name,
    sprite = sprite,
    x = player.x,
    y = player.y,
    height = player.height,
    width = player.width,
    title = player.type,
    jump = false,
    jumpVelocity = 128
  }

  layer.start = {
    name = start.name,
    x = start.x,
    y = start.y,
    height = start.height,
    width = start.width,
    title = start.type
  }

  function layer:update(dt)
    local speed = 128
    -- Move player up
    for k, object in pairs(self) do
      if type(object) == "table" then

      end
    end

    if love.keyboard.isDown("up") then
      goalY = self.player.y - speed * dt
      local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
      self.player.y = actualY
    end

    -- Move player down
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        goalY = self.player.y + speed * dt
        local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
        self.player.y = actualY
    end

    -- Move player left
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      goalX = self.player.x - speed * dt

      local actualX, actualY, cols, len = world:move(self.player, goalX, self.player.y)
      self.player.x = actualX
    end

    -- Move player right
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      goalX = self.player.x + speed * dt
      local actualX, actualY, cols, len = world:move(self.player, goalX, self.player.y)
      self.player.x = actualX
    end

    -- Jump player
    if love.keyboard.isDown("space") or love.keyboard.isDown("w") then
      if self.player.jump == false then
        self.player.jump = true
        self.player.jumpVelocity = 128
      end
    end

    if self.player.jump == true then
      goalY = self.player.y - self.player.jumpVelocity * dt
      local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
      for i=1,len do -- If more than one simultaneous collision, they are sorted out by proximity
        for key,value in pairs(cols[i].normal) do
          print(cols[i].normal.y)
          if cols[i].normal.y == 1 then
            self.player.jumpVelocity = 0
          elseif cols[i].normal.y == -1 then
            self.player.jump = false
            self.player.jumpVelocity = 0
          end
        end
      end
      self.player.y = actualY
      self.player.jumpVelocity = self.player.jumpVelocity - 16 * dt
    end
  end

  function layer:draw()
    -- player
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.player.sprite, self.player.x, self.player.y, 0, 1,1)

    -- start robot
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", start.x, start.y, start.width, start.height )

    love.graphics.setFont(ormontsmall)
    love.graphics.setColor(0, 51, 102)
    love.graphics.print( self.start.name, self.start.x, self.start.y)
  end

  map:removeLayer("Objects")
  world:add(layer.player, layer.player.x, layer.player.y, layer.player.width, layer.player.height)
  world:add(layer.start, layer.start.x, layer.start.y, layer.start.width, layer.start.height)

  map:bump_init(world)
end

function love.update(dt)
  layer:update(dt)
  map:update(dt)
end

function love.draw()
  love.graphics.setColor(179,89,0)
  map:draw()
  layer:draw()

  ---[[ -- Collision map
  love.graphics.setColor(255, 0, 0, 50)
  map:bump_draw(world, 32,32,0.25, 0.25)
  --]]
end
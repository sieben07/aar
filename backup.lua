local sti = require "libs.Simple-Tiled-Implementation.sti"
local bump = require "libs.bump.bump"
local Gamestate = require "libs.hump.gamestate"
local levels = {"start", "level0"}

local game = {}

-- Fonts
defaultFont = love.graphics.newFont("assets/font/Orial_Bold.otf", 24)
orial = love.graphics.newFont("assets/font/Orial_Bold.otf", 57)
ormont = love.graphics.newFont("assets/font/Ormont_Light.ttf", 38)
ormontsmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28)
orangekid = love.graphics.newFont("fonts/orangekid.ttf", 23)

function game:enter()
  love.graphics.setColor(255,255,255)
  love.graphics.setBackgroundColor(105, 105, 105)
end

function game:update(dt)
    
end

function game:draw()
  local level = levels[1]
  --table.remove(levels, 1)
  --local newLevel = levels[1]
  love.graphics.setColor(7, 0, 7)
  love.graphics.setFont(orial)
  love.graphics.printf( "One Point Left", 0, 128, love.graphics.getWidth() , "center")
  love.graphics.setFont(ormont)
  love.graphics.setColor(255, 165, 7)
  love.graphics.printf( "activate all robots", 0, 167, love.graphics.getWidth() , "center")
  love.graphics.printf( levels[2], 0, 128, love.graphics.getWidth() , "center")
  --love.graphics.printf( newLevel, 0, 256, love.graphics.getWidth() , "center")
  love.graphics.setColor(7, 0, 7)

end



function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(game)
  -- map = sti("assets/maps/start.lua", {"bump"})
  
  -- world = bump.newWorld(32);
  
  -- love.graphics.setBackgroundColor(   86, 86, 86 )
  
  -- map:addCustomLayer("Ghost Layer", 4)
  
  -- layer = map.layers["Ghost Layer"]
  
  -- local player
  
  -- local start
  
  -- for k, object in pairs(map.objects) do
    
  --   if object.name == "Player" then
  --     player = object
  --   end
    
  --   if object.name == "Start" then
  --     start = object
  --   end

  -- end
  
  -- local sprite = love.graphics.newImage("assets/img/player/orange.png")
  
  -- ---[[
  -- layer.player = {
  --   name = player.name,
  --   sprite = sprite,
  --   x = player.x,
  --   y = player.y,
  --   h = start.height,
  --   w = start.width,
  --   title = start.type
  -- }

  -- layer.start = {
  --   name = start.name,
  --   x = start.x,
  --   y = start.y,
  --   h = start.height,
  --   w = start.width,
  --   title = start.type
  -- }
  
  -- function layer:draw()
  --   love.graphics.setColor(255, 255, 255)
  --   love.graphics.draw(self.player.sprite, self.player.x, self.player.y, 0, 1,1)
  --   love.graphics.rectangle( "fill", self.start.x, self.start.y, self.start.w, self.start.h, 4, 4, 4 )
  --   love.graphics.setFont(ormontsmall)
  --   love.graphics.setColor(230, 149, 0)
  --   love.graphics.print( self.start.title, self.start.x, self.start.y - self.start.h/2)
  -- end
  -- --]]

  -- map:removeLayer("Objects")
  -- world:add(layer.player, layer.player.x, layer.player.y, layer.player.w, layer.player.h)
  -- world:add(layer.start, layer.start.x, layer.start.y, layer.start.w, layer.start.h)
  -- map:bump_init(world)

  -- -- Add controls to player
  -- ---[[
  -- function layer:update(dt)
  --       -- 96 pixels per second
  --       local speed = 128

  --       -- Move player up
  --       if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
  --           goalY = self.player.y - speed * dt
  --           local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
  --           self.player.y = actualY
  --           print(world:getRect(self.player))
  --       end

  --       -- Move player down
  --       if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
  --           goalY = self.player.y + speed * dt
  --           local actualX, actualY, cols, len = world:move(self.player, self.player.x, goalY)
  --           self.player.y = actualY
  --           print(world:getRect(self.player))
  --       end

  --       -- Move player left
  --       if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
  --           goalX = self.player.x - speed * dt
  --           function a(b, c )
  --             return "slide"
  --           end
  --           local actualX, actualY, cols, len = world:move(self.player, goalX, self.player.y)
  --           self.player.x = actualX
  --       end

  --       -- Move player right
  --       if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
  --           goalX = self.player.x + speed * dt
  --           local actualX, actualY, cols, len = world:move(self.player, goalX, self.player.y)
  --           self.player.x = actualX
  --       end
  --   end
  -- --]]

end

function love.update( dt )
  --map:update(dt)
  --layer:update(dt)
end

function love.draw()
  --map:draw()
  --layer:draw()
  --love.graphics.setColor(219, 112, 147)
  --map:bump_draw(world)
  --love.graphics.draw(layer.player.sprite, layer.player.x, layer.player.y, 0, 1,1)
end




-- --[[
--   Project:One Point Left - Activate all Robots
--   Author: Orhan Kücükyilmaz
--   Date: 28-May-2012
--   Version: 0.1 (codename: dns.opl)
--   Description: A Jump and Shoot Riddle Game
-- --]]

-- local sti = require "libs.Simple-Tiled-Implementation.sti"
-- local bump = require "libs.bump.bump"

-- -- Fonts
-- defaultFont = love.graphics.newFont("assets/font/Orial_Bold.otf", 24)
-- orial = love.graphics.newFont("assets/font/Orial_Bold.otf", 57)
-- ormont = love.graphics.newFont("assets/font/Ormont_Light.ttf", 38)
-- ormontsmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28)
-- orangekid = love.graphics.newFont("fonts/orangekid.ttf", 23)

-- function love.load()
--   --love.graphics.setColor(255, 255, 255)
--   love.graphics.setBackgroundColor(123, 231, 44, 255 )
--   love.keyboard.setKeyRepeat(false)
--   love.graphics.circle("fill", 300, 300, 50, 100) -- Draw white circle with 100 segments.

--   map = sti("assets/maps/start.lua", {"bump"})
--   world = bump.newWorld(32)
--   map:bump_init(world)
--   map:addCustomLayer("Sprite Layer", 4)
--   layer = map.layers["Sprite Layer"]

--   -- Get player spawn object
--   local player
--   for k, object in pairs(map.objects) do
--     if object.name == "Player" then
--       player = object

--       break
--     end
--   end

--   local sprite = love.graphics.newImage("assets/img/player/orange.png")
--   layer.player = {
--     sprite = sprite,
--     x = player.x,
--     y = player.y,
--     ox = 32,
--     oy = 32
--   }

--   function layer:draw()
--     --love.graphics.setColor(133, 22, 77)
--     love.graphics.draw(self.player.sprite,self.player.x,self.player.y, 0, 1, 1)

--     ---[[
--     -- that our sprite is offset properly
--         love.graphics.setPointSize(5)
--         --love.graphics.setColor(99, 0, 100, 255)
--         love.graphics.points(128, 128)
--     --]]
--     --love.graphics.setColor(255, 255, 255)
--     love.graphics.circle("fill", 300, 300, 50, 100) -- Draw white circle with 100 segments.
--     --love.graphics.setColor(255, 0, 0)
--     love.graphics.circle("fill", 300, 300, 50, 5)   -- Draw red circle with five segments.
--   end

--   map:removeLayer("Objects")

--   Quad = love.graphics.newQuad
 
--   --require("map")
--   require("collision")
--   require("sidecollision")
--   require("hero")
--   require("quadratO")
--   require("tiles")
--   require("enemies")

--   --[[ find position of player
--   for y = 1, #map do
--     for x = 1, #map[y] do
--         if map[y][x] == X then
--           hero.x = x * 32
--           hero.y = y * 32
--         end
--     end
--   end
--   --]]

-- end

-- function love.keypressed(key)
--     if key == "left" then
--         hero.x_vel = -hero.vel
--         hero.status = "shootLeft"
--     end

--     if key == "right" then
--         hero.x_vel = hero.vel
--         hero.status = "shootRight"
--     end

--     if (key == "up" or key =="a") and hero.y_vel == 0 then
--         hero.jump = 24
--         hero.iterator = 1
--     end

--     if key == " " or key == "s" then
--         hero.shoot()
--         hero.shooting = true
--     end

--     if key == "escape" then
--         love.event.push("quit")   -- actually causes the app to quit
--     end
-- end

-- function love.keyreleased(key)
--     if key == "left" then
--         hero.x_vel = 0

--     end

--     if key == "right" then
--         hero.x_vel = 0

--     end

--     if key == "s" or key == " " then
--         hero.shooting = false
--     end
-- end

-- function love.update(dt)
--     local remWall = {}
--     local remShot = {}
--     map:update(dt)

--     for i,v in ipairs(hero.shoots) do
--         -- move them
--         v.x = v.x + v.dir
--         if v.x + 8 > hero.x + 256 or v.x  < hero.x - 256 then
--             table.insert(remShot, i)
--         end
--         -- check for collision with Wall
--         for ii,vv in ipairs(tiles) do
--             if checkCollision(v.x,v.y,8,8,vv.x,vv.y,vv.w,vv.h) and vv.shootable == true then
--                 -- mark that tile for removal
--                 table.insert(remWall, ii)
--                 -- mark the shoot to be removed
--                 table.insert(remShot, i)
--             end
--         end
--     end

--     -- move enemies
--     for i,v in ipairs(enemies) do
--         v.move(v,i)
--     end

--      -- remove the marked Tiles
--      for i,v in ipairs(remWall) do
--         table.remove(tiles, v)
--      end

--      for i,v in ipairs(remShot) do
--         table.remove(hero.shoots, v)
--     end

--     if dt > 0.05 then
--         dt = 0.05
--     end
    
--     --hero.move(dt)
--     --quadratO.move()
  
    
-- end

-- function love.draw()
--   --love.graphics.setColor(0, 0, 0, 255)
--   map:draw()
--   -- Draw Collision Map (useful for debugging)
--   --love.graphics.setColor(255, 0, 0, 255)
--   map:bump_draw()

--     -- draw the tiles
--     -- love.graphics.setColor(184,134,11)
--     for i,tile in ipairs(tiles) do
--         --love.graphics.setColor(tile.color)
--         love.graphics.rectangle(tile.draw, tile.x, tile.y, tile.w, tile.h)
--         --love.graphics.setColor(173,212,88,125)
--         love.graphics.rectangle(tile.draw, (tile.x/8) +32, (tile.y/8) +32, 4, 4)
--     end

--     -- draw the shoots
--     for i,v in ipairs(hero.shoots) do
--         --love.graphics.setColor(255,127,0,255)
--         love.graphics.rectangle("fill", v.x, v.y, 8, 8)
--         --love.graphics.setColor(173,212,88,125)
--         love.graphics.rectangle("fill", (v.x/8) +32, (v.y/8) +32, 1, 1)
--     end

--     -- draw some text
--     love.graphics.setFont(orangekid)
--     --love.grapics.setColor(r,g,b, alpha)
--     --love.graphics.setColor(255,127,0,125)
--     love.graphics.print(message, hero.x + 24, hero.y - 48)
--     love.graphics.print(message, 32, 32)
--     love.graphics.print("robots", hero.x + 96, hero.y - 16)

--     -- draw the quadrat0
--     --love.graphics.rectangle("fill", quadratO.x, quadratO.y, quadratO.w, quadratO.h)
--     --love.graphics.setColor(173,212,88,125)
--     --love.graphics.rectangle("fill", quadratO.x/8 + 32, quadratO.y/8 + 32, quadratO.w/8, quadratO.h/8)
--     -- draw the enemies
--     --[[for i,v in ipairs(enemies) do
--         love.graphics.setColor(v.color)
--         love.graphics.rectangle(v.draw, v.x, v.y, v.w, v.h)
--         love.graphics.setColor(173,212,88,125)
--         love.graphics.rectangle(v.draw, v.x/8 +32, v.y/8 +32, v.w/8, v.h/8)
--     end--]]

--     --[[ draw the hero
--     love.graphics.setColor(255,255,255,255)
--     love.graphics.draw(hero.image, hero.quads[hero.direction][hero.iterator], hero.x,hero.y, hero.rotate, hero.zoom)
--     love.graphics.setColor(173,212,88,125)
--     love.graphics.draw(hero.image, hero.quads[hero.direction][hero.iterator], hero.x/8 + 32,hero.y/8 + 32, hero.rotate, hero.zoom/8)
--     --]]
--     ---[[
--     if hero.score == 1 then
--         love.graphics.print(".| one point left", hero.x + 32, hero.y - 64)
--         love.graphics.print(".| one point left", 0, 0)
--     else
--         love.graphics.print(".| " .. hero.score, 0, 0)
--     end
--     --]]
-- --[[
--     if hero.score == 1 then
--         love.graphics.print(".| one point left", 0, 0)
--     else
--         love.graphics.print(".| " .. hero.score, 0, 0)
--     end
-- ––]]

-- end

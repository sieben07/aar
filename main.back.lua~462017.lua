--[[
  Project:One Point Left - Activate all Robots
  Author: Orhan Kücükyilmaz
  Date: 27-Apri-2017
  Version: 0.0.1 (codename: dplhlx.aar)
  Description: A Jump and Shoot Riddle Game
--]]

local sti = require "libs.Simple-Tiled-Implementation.sti"
local bump = require "libs.bump.bump"
local Gamestate = require "libs.hump.gamestate"

local levels = {"start", "level0"}
local level = levels[1]
local map
local player
local layer

local game = {}

-- Fonts
defaultFont = love.graphics.newFont("assets/font/Orial_Bold.otf", 24)
orial = love.graphics.newFont("assets/font/Orial_Bold.otf", 57)
ormont = love.graphics.newFont("assets/font/Ormont_Light.ttf", 38)
ormontsmall = love.graphics.newFont("assets/font/Ormont_Light.ttf", 28)
orangekid = love.graphics.newFont("assets/font/orangekid.ttf", 23)

function game:enter()
  love.graphics.setColor(255,255,255)
  love.graphics.setBackgroundColor(105, 105, 105)
  map = sti("assets/maps/" .. level .. ".lua", {"bump"})
  layer = map:addCustomLayer("Sprites", 8)
  world = bump.newWorld(32)
  loadPlayer(map,layer)
  map:bump_init(world)
  map:removeLayer("Objects")
end

function game:leave()
  table.remove(levels, 1)
  level = levels[1]
end

function game:update(dt)
    layer:update(dt)
end

function game:draw()
  map:draw()
  love.graphics.setColor(7, 0, 7)
  love.graphics.setFont(orial)
  love.graphics.printf( "One Point Left", 0, 128, love.graphics.getWidth() , "center")
  love.graphics.setFont(ormont)
  love.graphics.setColor(255, 165, 7)
  love.graphics.printf( "activate all robots", 0, 167, love.graphics.getWidth() , "center")
  love.graphics.setColor(7, 0, 7)
end

function layer.update( dt )
  if love.keybord.isDown("return") then
        Gamestate.switch(game)
    end

    if key == 'right' then
      print(layer.player.x)
      moveRight(layer.player)
    end

    if key == 'left' then
      moveLeft()
    end
end


function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(game)
end

function love.update( dt )
  map:update(dt)
  layer:update(dt)
end

function love.draw()
  --love.graphics.setColor(219, 112, 147)
  --map:bump_draw(world)
  --love.graphics.draw(layer.player.sprite, layer.player.x, layer.player.y, 0, 1,1)
end



function moveLeft()
  print 'left'
end

function moveRight(entity)
  local speed = 128
  local goalX = entity.x + speed;
  print 'right'
  local actualX, actualY, cols, len = world:move(entity, goalX, entity.y)
  layer.player.x = actualX
end

function jump()
end

function shoot()
end

function loadPlayer(map, layer)

  for k, object in pairs(map.objects) do
    if object.name == "Player" then
      player = object
      break
    end
  end

  -- Create player object
  layer.player = {
    x      = player.x,
    y      = player.y,
    w     = 32,
    h     = 32
  }

  world:add(layer.player, layer.player.x, layer.player.y, layer.player.w, layer.player.h)
end

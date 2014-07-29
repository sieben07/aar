--[[
  Project:One Point Left - Activate all Robots
  Author: Orhan Kücükyilmaz
  Date: 28-May-2012
  Version: 0.1 (codename: dns.opl)
  Description: A Jump and Shoot Riddle Game
--]]

function love.load()
  bigTimer = 0
  Quad = love.graphics.newQuad
  orangekid = love.graphics.newFont("fonts/orangekid.ttf", 23)
    love.graphics.setBackgroundColor(123,71,20)
    require('map')
    require('collision')
    require('sidecollision')

    require('hero')
    require('quadratO')
    require('tiles')
    require('enemies')

    -- find position of player
    for y = 1, #map do
      for x = 1, #map[y] do
         if map[y][x] == X then
            hero.x = x * 32
            hero.y = y * 32
         end
      end
   end

end

function love.keypressed(key)
    if key == "left" then
        hero.x_vel = -hero.vel
        hero.status = "shootLeft"
    end

    if key == "right" then
        hero.x_vel = hero.vel
        hero.status = "shootRight"
    end

    if (key == "up" or key =="a") and hero.y_vel == 0 then
        hero.jump = 24
        hero.iterator = 1
    end

    if key == " " or key == "s" then
        hero.shoot()
        hero.shooting = true
    end

    if key == "escape" then
        love.event.push("quit")   -- actually causes the app to quit
    end
end

function love.keyreleased(key)
    if key == "left" then
        hero.x_vel = 0

    end

    if key == "right" then
        hero.x_vel = 0

    end

    if key == "s" or key == " " then
        hero.shooting = false
    end
end

function love.update(dt)
    local remWall = {}
    local remShot = {}

    for i,v in ipairs(hero.shoots) do
        -- move them
        v.x = v.x + v.dir
        if v.x + 8 > hero.x + 256 or v.x  < hero.x - 256 then
            table.insert(remShot, i)
        end
        -- check for collision with Wall
        for ii,vv in ipairs(tiles) do
            if checkCollision(v.x,v.y,8,8,vv.x,vv.y,vv.w,vv.h) and vv.shootable == true then
                -- mark that tile for removal
                table.insert(remWall, ii)
                -- mark the shoot to be removed
                table.insert(remShot, i)
            end
        end
    end

    -- move enemies
    for i,v in ipairs(enemies) do
        v.move(v,i)
    end

     -- remove the marked Tiles
     for i,v in ipairs(remWall) do
        table.remove(tiles, v)
     end

     for i,v in ipairs(remShot) do
        table.remove(hero.shoots, v)
    end

    bigTimer = bigTimer + dt
    if bigTimer >= 0.016 then -- 1 / 60 = 0.016 60 frames per second
        hero.move(dt)
        quadratO.move()
        bigTimer = 0
    end
end

function love.draw()

    -- draw the tiles
    love.graphics.setColor(184,134,11)
    for i,tile in ipairs(tiles) do
        love.graphics.setColor(tile.color)
        love.graphics.rectangle(tile.draw, tile.x, tile.y, tile.w, tile.h)
        love.graphics.setColor(173,212,88,125)
        love.graphics.rectangle(tile.draw, (tile.x/8) +32, (tile.y/8) +32, 4, 4)
    end

    -- draw the shoots
    for i,v in ipairs(hero.shoots) do
        love.graphics.setColor(255,127,0,255)
        love.graphics.rectangle("fill", v.x, v.y, 8, 8)
        love.graphics.setColor(173,212,88,125)
        love.graphics.rectangle("fill", (v.x/8) +32, (v.y/8) +32, 1, 1)
    end

    -- draw some text
    love.graphics.setFont(orangekid)
    --love.grapics.setColor(r,g,b, alpha)
    love.graphics.setColor(255,127,0,125)
    --love.graphics.print(message, hero.x + 24, hero.y - 48)
    --love.graphics.print(message, 32, 32)
    --love.graphics.print("robots", hero.x + 96, hero.y - 16)

    -- draw the quadrat0
    love.graphics.rectangle("fill", quadratO.x, quadratO.y, quadratO.w, quadratO.h)
    love.graphics.setColor(173,212,88,125)
    love.graphics.rectangle("fill", quadratO.x/8 + 32, quadratO.y/8 + 32, quadratO.w/8, quadratO.h/8)
    -- draw the enemies
    for i,v in ipairs(enemies) do
        love.graphics.setColor(v.color)
        love.graphics.rectangle(v.draw, v.x, v.y, v.w, v.h)
        love.graphics.setColor(173,212,88,125)
        love.graphics.rectangle(v.draw, v.x/8 +32, v.y/8 +32, v.w/8, v.h/8)
    end

    -- draw the hero
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(hero.image, hero.quads[hero.direction][hero.iterator], hero.x,hero.y, hero.rotate, hero.zoom)
    love.graphics.setColor(173,212,88,125)
    love.graphics.draw(hero.image, hero.quads[hero.direction][hero.iterator], hero.x/8 + 32,hero.y/8 + 32, hero.rotate, hero.zoom/8)

    ---[[
    if hero.score == 1 then
        love.graphics.print(".| one point left", hero.x + 32, hero.y - 64)
    else
        love.graphics.print(".| " .. hero.score, 0, 0)
    end
    --]]
--[[
    if hero.score == 1 then
        love.graphics.print(".| one point left", 0, 0)
    else
        love.graphics.print(".| " .. hero.score, 0, 0)
    end
––]]

end

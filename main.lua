--[[
	Project:One Point Left aka OPL / Activate all Robots aka AaR
	Author: Orhan Kücükyilmaz
	Date: 28-May-2012
	Version: 0.1
	Description: A Jump and Shoot Riddle Game
--]]

function  love.load()
	bigTimer = 0
	Quad = love.graphics.newQuad
	orangekid = love.graphics.newFont("fonts/orangekid.ttf", 45)
	love.graphics.setBackgroundColor(123,71,20)
	require('map')
	require('collision')

	require('hero')
	require('quadratO')
	require('tiles')

	-- find positon of player
	for y = 1, #map do
      for x = 1, #map[y] do
         if map[y][x] == X then
            hero.x = x * 32 - 32
            hero.y = y * 32 - 32
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
			if CheckCollision(v.x,v.y,8,8,vv.x,vv.y,vv.w,vv.h) and vv.shootable == true then
				-- mark that tile for removal
				table.insert(remWall, ii)
				-- mark the shoot to be removed
				table.insert(remShot, i)
			end
		end
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
	for i,v in ipairs(tiles) do
		love.graphics.setColor(v.color)
		love.graphics.rectangle(v.draw, v.x, v.y, v.w, v.h)
	end

	-- draw the shoots
	for i,v in ipairs(hero.shoots) do
		love.graphics.setColor(255,127,0,255)
		love.graphics.rectangle("fill", v.x, v.y, 8, 8)
	end

	-- draw some text
	love.graphics.setFont(orangekid)
	--love.grapics.setColor(r,g,b, alpha)
	love.graphics.setColor(255,127,0,255)
	love.graphics.print("activate all", 64, 64)
	love.graphics.print("robots", 96, 96)

	-- draw the quadrat0
	love.graphics.rectangle("fill", quadratO.x, quadratO.y, quadratO.w, quadratO.h)

	-- draw the hero
	love.graphics.setColor(255,255,255,255)
	love.graphics.drawq(hero.image, hero.quads[hero.direction][hero.iterator], hero.x,hero.y, hero.rotate, hero.zoom)


end

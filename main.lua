--[[  Project:One Point Left aka OPL / Activate all Robots aka AaR
      Author: Orhan Kücükyilmaz
      Date: 28-May-2012
      Version: 0.1

      Description: A Jump and Shoot Riddle Game
--]]

function  love.load()
	bigTimer = 0
	Quad = love.graphics.newQuad
	deftone = love.graphics.newFont("fonts/DEFTONE.ttf", 45)
	pacifico = love.graphics.newFont("fonts/Pacifico.ttf", 45)
	love.graphics.setBackgroundColor(123,71,20)
	require('map')
	require('collision')

	require('hero')
	require('quadratO')
	require('tiles')
	
	
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
	end
	
	if key == "right" then
		hero.x_vel = hero.vel
	end

	if key == "a" and hero.y_vel == 0 then
		hero.jump = 32
		hero.iterator = 1
	end

	if key == "s" then
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

	if key == "s" then
		hero.shooting = false
	end
end

function love.update(dt)
	local remWall = {}
	local remShot = {}

	for i,v in ipairs(hero.shoots) do
		-- move them
		v.x = v.x + 8
		if v.x + 8 > hero.x + 256 or v.x  < hero.x - 256 then
			table.insert(remShot, i)
		end
		-- check for collision with Wall
		for ii,vv in ipairs(tiles) do
			if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.w,vv.h) then
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
	--love.graphics.setColor(255,255,255,255)
	--love.graphics.draw(logo, 0, 0, 0, 2, 2)
	love.graphics.setColor(184,134,11)
	for i,v in ipairs(tiles) do
		love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
	end

	for i,v in ipairs(hero.shoots) do
		love.graphics.setColor(200,190,200,255)
		love.graphics.rectangle("fill", v.x, v.y, 8, 8)
		love.graphics.setColor(250,200,190,255)
		love.graphics.rectangle("line", v.x, v.y, 8, 8)
	end

	text = #hero.shoots

	love.graphics.setFont(deftone)
	--love.grapics.setColor(r,g,b, alpha)
	love.graphics.setColor(123,123,20,255)
	love.graphics.print("Activate all", quadratO.x + 2, quadratO.y + 2)
	love.graphics.setColor(20,72,123,255)
	love.graphics.print(text, quadratO.x, quadratO.y)
	
	love.graphics.setFont(pacifico)
	love.graphics.setColor(123,123,20,255)
	love.graphics.print("robots", quadratO.x + 62, quadratO.y + 27)
	love.graphics.setColor(20,72,123,255)
	love.graphics.print("robots", quadratO.x +60, quadratO.y +25)
	love.graphics.setColor(30,66,99,255)
	love.graphics.rectangle("fill", quadratO.x, quadratO.y, quadratO.w, quadratO.w)
	love.graphics.setColor(255,255,255,255)
	love.graphics.drawq(hero.image, hero.quads[hero.direction][hero.iterator], hero.x,hero.y, hero.rotate, hero.zoom)

end
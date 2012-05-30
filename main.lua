--[[  Project:One Point Left
      Author: Orhan Kücükyilmaz
      Date: 28-May-2012
      Version: 0.1

      Description: A Jump and Shoot Riddle Game
--]]
-- require functions from
require('collision')
require('map')

function love.load()

   local objects = require('hero')
	
   love.graphics.setBackgroundColor( 205,102,29 )
   font = love.graphics.newFont( "orangekid.ttf", 20)
   love.graphics.setFont(font)
   text = "Nothing yet"
   iterator = 1
	max = 5
	timer = 0
   bigTimer = 0

end -- functon love.load()

--[[
Here we move things arround in the Update
--]]
function love.update(dt)
   

   if hero.xvel ~= 0 and not hero.inAir  then
      timer = timer + dt
      if timer > 0.15 then
         timer = 0
         iterator = iterator + 1
         if iterator > max then
            iterator = 2
         end
      end
   end

bigTimer = bigTimer + dt

-- if the bigTimer reaches some Value we want we move things arround
if bigTimer >= 0.02 then
   bigTimer = 1


--[[ direction maybe a finite state machine would be better
--]]
if hero.xvel < 0 then
   if not hero.inAir then
      hero.direction ="left"
      elseif hero.inAir then
         hero.direction ="jumpLeftMoving"
      end
   end

if hero.xvel > 0 then
   if not hero.inAir then
      hero.direction ="right"
      elseif hero.inAir then
         hero.direction ="jumpRightMoving"
      end
   end

if hero.direction == "left" or hero.direction == "leftShooting" or hero.direction == "jumpLeft" or hero.direction =="jumpLeftShooting" or hero.direction =="jumpLeftMoving" then
   if not hero.shoot and not hero.inAir and hero.xvel == 0 then
      hero.direction = "left"
      elseif hero.shoot and not hero.inAir and hero.xvel == 0 then
         hero.direction = "leftShooting"
         elseif hero.shoot and not hero.inAir and hero.xvel < 0 then
            hero.direction = "leftShooting"
            elseif not hero.shoot and hero.inAir and hero.xvel < 0 then
               hero.direction = "jumpLeftMoving"
               elseif not hero.shoot and hero.inAir and hero.xvel == 0 then
                  hero.direction ="jumpLeft"
                  elseif (hero.shoot and hero.inAir and hero.xvel) or (hero.shooting and hero.inAir and hero.xvel < 0) then
                     hero.direction ="jumpLeftShooting"

   end
end

if hero.direction == "right" or hero.direction == "rightShooting" or hero.direction == "jumpRight" or hero.direction =="jumpRightShooting" or hero.direction =="jumpRightMoving" then
   if not hero.shoot and not hero.inAir and hero.xvel == 0 then
      hero.direction = "right"
      elseif hero.shoot and not hero.inAir and hero.xvel == 0 then
         hero.direction = "rightShooting"
         elseif hero.shoot and not hero.inAir and hero.xvel > 0 then
            hero.direction = "rightShooting"
            elseif not hero.shoot and hero.inAir and hero.xvel > 0 then
               hero.direction = "jumpRightMoving"
               elseif not hero.shoot and hero.inAir and hero.xvel == 0 then
                  hero.direction ="jumpRight"
                  elseif (hero.shoot and hero.inAir and hero.xvel) or (hero.shooting and hero.inAir and hero.xvel > 0) then
                     hero.direction ="jumpRightShooting"

   end
end


hero.x = hero.x + hero.xvel * bigTimer
if hero.x < 32 or hero.x + hero.w > 32*29 then
   hero.x = hero.x - hero.xvel * bigTimer
end

--let the hero jump
if not hero.Jump then
   hero.y = hero.y + hero.Gravity * bigTimer
   if hero.y < 0 or hero.y + hero.h > 32 * 17 then
      hero.y = hero.y - hero.Gravity * bigTimer
      hero.inAir = false
      hero.Jump = false

      hero.J_VEL = hero.jump_vel

---[[
      if hero.direction == "jumpRight" or hero.direction == "jumpRightMoving" then
         hero.direction = "right"
         elseif hero.direction == "jumpRightShooting" then
            hero.direction = "rightShooting"
         elseif hero.direction == "jumpLeft" or hero.direction=="jumpLeftMoving" then
            hero.direction = "left"
         elseif hero.direction == "jumpLeftShooting" then
            hero.direction = "leftShooting"
         end
         --]]



   end
end

if hero.Jump then
	hero.y = hero.y - hero.J_VEL * bigTimer
	hero.J_VEL = hero.J_VEL - 4 * bigTimer
	  if hero.J_VEL <= 0 then
	     hero.Jump = false
        elseif hero.y < 0 or hero.y + hero.h > 32*18 then
         hero.Jump = false
         hero.y = hero.y + hero.J_VEL * bigTimer
      end
end

bigTimer = 0
end --bigTimer

end -- end function love.update(dt)

function love.draw()


   love.graphics.setColor(85,107,47,255)
   for y=1, #map do
      for x=1, #map[y] do
         if map[y][x] == 1 then
            love.graphics.rectangle("fill", (x -1) * 32, (y-1) *32, 32, 32)
         end
      end
   end
   love.graphics.setColor(255,255,255,255)
--[[
   love.graphics.draw(bg)
--]]
--[[
   love.graphics.rectangle("fill", hero.x, hero.y, 32, 32)
--]]
-- love.graphics.drawq( image, quad, x, y, r, sx, sy, ox, oy, kx, ky )
   love.graphics.drawq(hero.image, hero.quads[hero.direction][iterator], hero.x,hero.y, hero.rotate, hero.zoom)
   love.graphics.print( text, 330, 300)
   love.graphics.print( "xvel", 10, 0 )
   love.graphics.print( hero.xvel, 20, 20)
   love.graphics.print( "hero.J_VEL", 10, 40 )
   love.graphics.print( hero.J_VEL, 20, 60)
   love.graphics.print("hero.Gravity", 10, 80)
   love.graphics.print( hero.Gravity, 20, 100)

      if hero.Jump then
         love.graphics.print( "hero.Jump true" , 10, 120)
            elseif not hero.Jump then
               love.graphics.print( "hero.Jump false" , 10, 120)
      end

      if hero.inAir then
         love.graphics.print( "hero.inAir true" , 10, 140)
            elseif not hero.inAir then
               love.graphics.print( "hero.inAir false" , 10, 140)
      end

      if hero.shoot then
         love.graphics.print( "shoot true" , 10, 160)
            elseif not hero.shoot then
               love.graphics.print( "shoot false" , 10, 160)
      end

      if hero.xvel ~= 0 then
         love.graphics.print( "moving true" , 10, 300)
            elseif not hero.shoot then
               love.graphics.print( "moving false" , 10, 300)
      end
      
      love.graphics.print( "x_hero_position", 10, 180 )
      love.graphics.print( hero.x, 10, 200)
      love.graphics.print( "y_hero_position", 10, 220 )
      love.graphics.print( hero.y, 10, 240)
      love.graphics.print( "bigTimer", 10, 260)
      love.graphics.print( bigTimer, 10, 280)

end -- end function.draw()

function love.keypressed( key )

	--right
   if key == "right" then
      text = "Right is being pressed!"
      hero.xvel = hero.VEL
   
    --left
   elseif key == "left" then
      text = "Left is being pressed!"
      hero.xvel = -hero.VEL
      
   --up is for up
   elseif key == "up" then
   text = "Up is being pressed!"   

    --down
	elseif key == "down" then
	text = "Down is being pressed!"
	
   -- a is for Jump
	elseif key =="a" then
      if not hero.Jump and not hero.inAir then
      hero.Jump = true
      hero.inAir = true
      iterator = 1
      end
   text = "a is being pressed!"

   -- s is for shoot
   elseif key =="s" then
      hero.shoot = true

   elseif key =="escape" then
      love.event.push('quit') -- Quit the game.
   end
end

function love.keyreleased(key)

   if key == "right" then
      text = "Right has been released!"
      if hero.xvel > 0 then
         hero.xvel = 0
         iterator = 1
      end
   
   elseif key == "left" then
      text = "Left has been released!"
      if hero.xvel < 0 then
         hero.xvel = 0
         iterator = 1
      end

   elseif key == "up" then
      text = "Up has been released!"
      
 	elseif key == "down" then
      text = "Down has been released!"
    elseif key =="s" then
	  hero.shoot = false
   elseif key =="a" then
      text = "a has been released!"
      hero.Jump = false

   end

end

Quad = love.graphics.newQuad
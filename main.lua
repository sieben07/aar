function love.load()
   local objects = require('hero')
	love.graphics.setBackgroundColor( 139, 71, 38 )

   font = love.graphics.newFont( "orangekid.ttf", 20)
   love.graphics.setFont(font)
    text = "Nothing yet"
    iterator = 1
	max = 5
	timer = 0
	moving = false

end -- functon love.load()

function love.update(dt)
   dt_now = math.floor(dt * 100)
   --[[
   hero.zoom = hero.zoom + dt
   if hero.zoom > 3 then
      hero.zoom = 1
   end
   --]]

   if moving then
      timer = timer + dt
		if timer > 0.15 then
			timer = 0
			iterator = iterator + 1
            if iterator > max then
				  iterator = 2
			   end
      end
   end

hero.x = hero.x + hero.xvel * (dt_now)
if hero.x < 0 or hero.x + hero.w > 1152 then
   hero.x = hero.x - hero.xvel * (dt_now)
end

--let the hero jump
if not hero.Jump then
   hero.y = hero.y + hero.Gravity * (dt_now)
   if hero.y < 0 or hero.y + hero.h > 16*44 then
      hero.y = hero.y - hero.Gravity * (dt_now)
      hero.inAir = false
      hero.Jump = false
      
      hero.J_VEL = hero.jump_vel
      

      if hero.direction == "jumpRight" then
         hero.direction = "right"
         elseif hero.direction == "jumpLeft" then
            hero.direction = "left"
         end

      

   end
end

if hero.Jump then
	hero.y = hero.y - hero.J_VEL * (dt_now)
	hero.J_VEL = hero.J_VEL - 8 * (dt_now)
	  if hero.J_VEL <= 0 then
	     hero.Jump = false
        elseif hero.y < 0 or hero.y + hero.h > 16*44 then
         hero.Jump = false
         hero.y = hero.y + hero.J_VEL * dt_now
      end
end

end -- end function love.update(dt)

function love.draw()


   love.graphics.setColor(255,255,255,255)
--[[
   love.graphics.draw(bg)
--]]
--[[
   love.graphics.rectangle("fill", hero.x, hero.y, 32, 32)
--]]
   love.graphics.drawq(hero.image, hero.quads[hero.direction][iterator], hero.x,hero.y, hero.rotate, hero.zoom )
   love.graphics.print( text, 330, 300)
   love.graphics.print( "xVel", 10, 0 )
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
      
      love.graphics.print( "x_hero_position", 10, 180 )
      love.graphics.print( hero.x, 10, 200)
      love.graphics.print( "y_hero_position", 10, 220 )
      love.graphics.print( hero.y, 10, 240)
      love.graphics.print( "dt_now", 10, 260)
      love.graphics.print( dt_now, 10, 280)

      -- let's draw some ground
   love.graphics.setColor(0,255,0,255)
   love.graphics.rectangle("fill", 0, 16*44, 16*72, 16)


end -- end function.draw()

function love.keypressed( key )

	--right
   if key == "right" then
      text = "Right is being pressed!"
      hero.xvel = hero.VEL
      --moving = true
      hero.direction = "right"
    --left
   elseif key == "left" then
      text = "Left is being pressed!"
      hero.xvel = -hero.VEL
      --moving = true
      hero.direction = "left"
   --up is for Jump
   elseif key == "up" then
   text = "up is being pressed!"   

    --down
	elseif key == "down" then
	text = "Down is being pressed!"
	-- a is for Jump
	elseif key =="a" then
	
   text = "a is being pressed!"
      if not hero.Jump and not hero.inAir then
      hero.Jump = true
      hero.inAir = true
      moving = false
      iterator = 1
      if hero.direction =="right" then
         hero.direction = "jumpRight"
      elseif hero.direction == "left" then
         hero.direction = "jumpLeft"
      end
   end

    -- s is for shoot
    elseif key =="s" then
    hero.shoot = true
   end

end

function love.keyreleased(key)


   if key == "right" then
      text = "Right has been released!"
      if hero.xvel > 0 then
      hero.xvel = 0
      moving = false
      iterator = 1

      end
   elseif key == "left" then
      text = "Left has been released!"
      if hero.xvel < 0 then
      hero.xvel = 0
      moving = false
      iterator = 1
      end
   elseif key == "up" then
      text = "Up has been released!"
      
 	elseif key == "down" then
      text = "Down has been released!"
    elseif key =="s" then
	  hero.shoot = false
   elseif key =="a" then
      hero.Jump = false

   end

end

Quad = love.graphics.newQuad


function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)

  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
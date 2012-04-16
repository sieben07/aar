Quad = love.graphics.newQuad

function love.load()
	local objects = require('hero')
	love.graphics.setBackgroundColor( 139, 71, 38 )
	love.graphics.setFont(12)
    text = "Nothing yet"
    iterator = 1
	max = 5
	timer = 0
	moving = false
	direction = "inair"

end -- functon love.load()

function love.update(dt)
if moving then

		timer = timer + dt
		if timer > 0.2 then
			timer = 0
			iterator = iterator + 1
			if iterator > max then
				iterator = 2
			end
		end
	end

hero.pos_X = hero.pos_X + (hero.xvel * dt)

if not hero.Jump then
hero.J_VEL = 400
--hero.pos_Y = hero.pos_Y + (hero.Gravity *dt)
end

if hero.Jump then
	hero.pos_Y = hero.pos_Y - (hero.J_VEL*dt)
	hero.J_VEL = hero.J_VEL - (8*hero.Gravity*dt)
	if hero.J_VEL <= 0 then
	hero.Jump = false
	end
	end



end

function love.draw()
	  love.graphics.drawq(hero.image, hero.quads[direction][iterator], hero.pos_X,hero.pos_Y, hero.rotate, hero.zoom )
      love.graphics.print( text, 330, 300)
      love.graphics.print( "xVel", 10, 0 )
      love.graphics.print( hero.xvel, 10, 10)
      love.graphics.print( "hero.J_VEL", 10, 20 )
      love.graphics.print( hero.J_VEL, 10, 30)
      if hero.Jump then
      love.graphics.print( "hero.Jump true" , 10, 40)
      elseif not hero.Jump then
      love.graphics.print( "hero.Jump false" , 10, 40)
      end

      if hero.inAir then
      love.graphics.print( "hero.inAir true" , 10, 50)
      elseif not hero.inAir then
      love.graphics.print( "hero.inAir false" , 10, 50)
      end

      if hero.shoot then
      love.graphics.print( "shoot true" , 10, 60)
      elseif not hero.shoot then
      love.graphics.print( "shoot false" , 10, 60)
      end
      love.graphics.print( "x_hero_position", 10, 70 )
      love.graphics.print( hero.pos_X, 10, 80)
      love.graphics.print( "y_hero_position", 10, 90 )
      love.graphics.print( hero.pos_Y, 10, 100)


end

function love.keypressed( key )


	--right
   if key == "right" then
      text = "Right is being pressed!"
      hero.xvel = hero.VEL
      moving = true
      direction = "right"
    --left
    elseif key == "left" then
      text = "Left is being pressed!"
      hero.xvel = -hero.VEL
      moving = true
      direction = "left"
   --up is for Jump
   elseif key == "up" then
      text = "Up is being pressed!"
      if not hero.Jump and not hero.inAir then
      hero.Jump = true
      hero.inAir = true
      moving = false
      iterator = 1
      direction = "jump"
      end

    --down
	elseif key == "down" then
	text = "Down is being pressed!"
	-- a is for Jump
	elseif key =="a" then
	if not hero.Jump and not hero.inAir then
      hero.Jump = true
      hero.inAir = true
      end
    -- g simulates ground
    elseif key =="g" then
    hero.inAir = false

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
      hero.Jump = false
 	elseif key == "down" then
      text = "Down has been released!"
    elseif key =="s" then
	  hero.shoot = false

   end

end
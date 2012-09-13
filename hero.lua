local hub = 32 -- Höhe und Breite eines Sprites
local big_hub = 256 -- Höhe und Breite des Spritesheets
local timer = 0 -- Zeit Variable fuer Animation

hero = {
	x = 0,
	y = 0,
	w = 32,
	h = 32,
	x_vel = 0,
	y_vel = 0,
	vel = 4,
	gravity = 4,
	jump = 0,
	shooting = false,
	shoots = {}, -- holds our fired shoots


	-- Animation
	iterator = 1,
    max = 5,
    direction = "left",
<<<<<<< HEAD
    s_direction= "sleft",
=======
    status = "shootLeft",
>>>>>>> shooting in two directions now works
    rotate = 0,
    zoom = 1,
    image = love.graphics.newImage "images/minimega.png",

	-- the frames of the hero
	quads =
    {

		right = {
			Quad( hub*4,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*5,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*6,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*7,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*6,  hub, hub, hub, big_hub, big_hub);

		};

		rightShooting = {
			Quad( hub*4,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*5,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*6,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*7,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*6,  hub*3, hub, hub, big_hub, big_hub);

		};


		left = {
			Quad( hub*3,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*2,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*1,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*0,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*1,  hub, hub, hub, big_hub, big_hub);
		};

		leftShooting = {
			Quad( hub*3,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*2,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*1,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*0,  hub*3, hub, hub, big_hub, big_hub);
			Quad( hub*1,  hub*3, hub, hub, big_hub, big_hub);
		};
	


		jumpRight = {
			Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
		};
		
		jumpLeft = {
			Quad( hub*3,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpRightMoving = {
			Quad( hub*5,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpLeftMoving = {
			Quad( hub*2,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpRightShooting = {
			Quad( hub*6,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpLeftShooting = {
			Quad( hub,  hub*2, hub, hub, big_hub, big_hub);
		};
		
	}

}

function hero.shoot()
	local shoot = {}
<<<<<<< HEAD
	if hero.s_direction == "sleft" then
		shoot.x = hero.x
		shoot.y = hero.y + 16
		shoot.dir = -8
		table.insert(hero.shoots, shoot)
	end
	if hero.s_direction == "sright" then
		shoot.x = hero.x + 32
		shoot.y = hero.y + 16
		shoot.dir = 8
=======
	if hero.status == "shootRight" then
		shoot.x = hero.x + hero.w
		shoot.y = hero.y + 16
		shoot.dir = 8
		table.insert(hero.shoots, shoot)
	end
	if hero.status == "shootLeft" then
		shoot.x = hero.x
		shoot.y = hero.y + 16
		shoot.dir = -8
>>>>>>> shooting in two directions now works
		table.insert(hero.shoots, shoot)
	end
end

function hero.move(dt)
	-- Animation Framerate
	if hero.x_vel ~= 0 and hero.y_vel == 0  then
		timer = timer + dt
		if timer > 0.15 then
			timer = 0
			hero.iterator = hero.iterator + 1
			if hero.iterator > hero.max then
				hero.iterator = 2
			end
		end
	end

	if hero.x_vel == 0 then
		hero.iterator = 1
	end

	if hero.y_vel ~= 0 then
		hero.iterator = 1
	end

	-- Animation Direciton
	if hero.x_vel < 0 then
		if hero.y_vel == 0 then
			hero.direction ="left"
			elseif hero.y_vel ~= 0 then
				hero.direction ="jumpLeftMoving"
		end
	end

	if hero.x_vel > 0 then
		if hero.y_vel == 0 then
			hero.direction ="right"
			elseif hero.y_vel ~= 0 then
				hero.direction ="jumpRightMoving"
		end
	end

   if hero.direction == "left" or hero.direction == "leftShooting" or hero.direction == "jumpLeft" or hero.direction =="jumpLeftShooting" or hero.direction =="jumpLeftMoving" then
      if not hero.shooting and hero.y_vel == 0 and hero.x_vel == 0 then
         hero.direction = "left"
         elseif hero.shooting and hero.y_vel == 0 and hero.x_vel == 0 then
            hero.direction = "leftShooting"
            elseif hero.shooting and hero.y_vel == 0 and hero.x_vel < 0 then
               hero.direction = "leftShooting"
               elseif not hero.shooting and hero.y_vel ~= 0 and hero.x_vel < 0 then
                  hero.direction = "jumpLeftMoving"
                  elseif not hero.shooting and hero.y_vel ~= 0 and hero.x_vel == 0 then
                     hero.direction ="jumpLeft"
                     elseif (hero.shooting and hero.y_vel ~= 0 and hero.x_vel) or (hero.shootinging and hero.y_vel ~= 0 and hero.x_vel < 0) then
                        hero.direction ="jumpLeftShooting"

      end
   end

   if hero.direction == "right" or hero.direction == "rightShooting" or hero.direction == "jumpRight" or hero.direction =="jumpRightShooting" or hero.direction =="jumpRightMoving" then
      if not hero.shooting and hero.y_vel == 0 and hero.x_vel == 0 then
         hero.direction = "right"
         elseif hero.shooting and hero.y_vel == 0 and hero.x_vel == 0 then
            hero.direction = "rightShooting"
            elseif hero.shooting and hero.y_vel == 0 and hero.x_vel > 0 then
               hero.direction = "rightShooting"
               elseif not hero.shooting and hero.y_vel ~= 0 and hero.x_vel > 0 then
                  hero.direction = "jumpRightMoving"
                  elseif not hero.shooting and hero.y_vel ~= 0 and hero.x_vel == 0 then
                     hero.direction ="jumpRight"
                     elseif (hero.shooting and hero.y_vel ~= 0 and hero.x_vel) or (hero.shootinging and hero.y_vel ~= 0 and hero.x_vel > 0) then
                        hero.direction ="jumpRightShooting"

      end
   end

	-- Move the Hero Right or Left
	hero.x = hero.x + hero.x_vel
	if hero.y_vel > hero.gravity then
		hero.y_vel = hero.y_vel - hero.gravity
	end
	for i,v in ipairs(tiles) do
		if CheckCollision(hero.x, hero.y, hero.w, hero.h, v.x, v.y, v.w, v.h) or hero.x + hero.w > 32 * 32 or hero.x < 0  then
			hero.x = hero.x - hero.x_vel
		end
	end
	
	if hero.jump ~= 0 then
		hero.jump = hero.jump - hero.gravity
		hero.y_vel = hero.jump
		hero.y = hero.y - hero.y_vel
		for i,v in ipairs(tiles) do
			if CheckCollision(hero.x, hero.y, hero.w, hero.h, v.x, v.y, v.w, v.h) then
				hero.y = hero.y + hero.y_vel
				
			end
		end
		
	end

	if hero.jump == 0 then
		hero.y_vel = hero.gravity
		hero.y = hero.y + hero.y_vel
		for i,v in ipairs(tiles) do
			if CheckCollision(hero.x, hero.y, hero.w, hero.h, v.x, v.y, v.w, v.h) then
				hero.y_vel = 0
				hero.y = hero.y - hero.gravity
			end
		end
	end
end


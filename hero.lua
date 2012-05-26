hub = 32
big_hub = 256

hero = {
	VEL = 4,
	J_VEL = 32,
	jump_vel= 32,
	Gravity = 4,
	xvel = 0,
	Jump = false,
    inAir = false,
    shoot = false,
    x = 32*2,
    y = 32*21,
    w = 32,
    h = 32,
    direction = "jumpRight",
    rotate = 0,
    zoom = 1,
    image = love.graphics.newImage "minimega.png",

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

		jumpRightmoving = {
			Quad( hub*5,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpLeftmoving = {
			Quad( hub*2,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpRigtshooting = {
			Quad( hub*6,  hub*2, hub, hub, big_hub, big_hub);
		};

		jumpLeftshooting = {
			Quad( hub,  hub*2, hub, hub, big_hub, big_hub);
		};
		
	}
}
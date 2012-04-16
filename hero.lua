hub = 16
big_hub = 128

hero = {
	VEL = 100,
	J_VEL = 400,
	Gravity = 100,
	xvel = 0,
	Jump = false,
    inAir = false,
    shoot = false,
    pos_X = 100,
    pos_Y = 400,
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
		left = {
			Quad( hub*3,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*2,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*1,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*0,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*1,  hub, hub, hub, big_hub, big_hub);
			};
		jump = {
			Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
			Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
			Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
			Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
			Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
			};
		inair = {
			Quad( hub*4,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*5,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*6,  hub, hub, hub, big_hub, big_hub);
			Quad( hub*7,  hub, hub, hub, big_hub, big_hub);
			};

		}
		}
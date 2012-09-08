quadratO = {
	x = 128,
	y = 128,
	w = 16,
	h = 16,
	x_vel = 1,
	y_vel = 2,
}

function quadratO.move()
	-- Move the quadratO Right or Left
	quadratO.x = quadratO.x + quadratO.x_vel
	-- Move the quadrat= Up or Down
	quadratO.y = quadratO.y + quadratO.y_vel
	for i,v in ipairs(tiles) do
		if CheckCollision(quadratO.x, quadratO.y, quadratO.w, quadratO.h, v.x, v.y, v.w, v.h) then
			quadratO.x = quadratO.x - quadratO.x_vel
			quadratO.y = quadratO.y - quadratO.y_vel
			quadratO.x_vel = quadratO.x_vel * -1
			quadratO.y_vel = quadratO.y_vel * -1
		end
	end
end
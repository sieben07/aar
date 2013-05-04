tiles = {}
for y = 1, #map do
	for x = 1, #map[y] do
		if map[y][x] == 1 then
			tile = {}
			tile.w = 32
			tile.h = 32
			tile.x = (x * 32) -32
			tile.y = (y * 32) -32
			tile.shootable = false
			tile.colideable = true
			tile.draw = "fill"
			tile.color = {11,134,184,255}
			table.insert(tiles, tile)
		end
		if map[y][x] == 2 then
			tile = {}
			tile.w = 32
			tile.h = 32
			tile.x = (x * 32) -32
			tile.y = (y * 32) -32
			tile.shootable = true
			tile.colideable = true
			tile.draw = "fill"
			tile.color = {184,134,11,255}
			table.insert(tiles, tile)
		end
		if map[y][x] == 3 then
			tile = {}
			tile.w = 32
			tile.h = 32
			tile.x = (x * 32) -32
			tile.y = (y * 32) -32
			tile.shootable = false
			tile.colideable = false
			tile.draw = "fill"
			tile.color = {11,184,134,255}
			table.insert(tiles, tile)
		end
	end
end

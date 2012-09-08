tiles = {}
for y = 1, #map do
	for x = 1, #map[y] do
		if map[y][x] == 1 then
			tile = {}
			tile.w = 32
			tile.h = 32
			tile.x = (x * 32) -32
			tile.y = (y * 32) -32
			table.insert(tiles, tile)
		end
	end
end
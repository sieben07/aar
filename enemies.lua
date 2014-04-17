enemies = {}
for y = 1, #map do
    for x = 1, #map[y] do
        if map[y][x] == 9 then
            enemy = {}
            enemy.x = (x * 32) -32
            enemy.y = (y * 32) -32
            enemy.w = 32
            enemy.h = 32
            enemy.x_vel = 1
            enemy.y_vel = 2
            enemy.shootable = false
            enemy.colideable = true
            enemy.draw = "fill"
            enemy.color = {99,134,184,255}
        function  enemy.move(self,i)
                self.action = {
                ["top"]     = function()
                    self.y = self.y - self.y_vel
                    self.y_vel = self.y_vel * -1
                end,
                ["right"]   = function()
                    self.x = self.x - self.x_vel
                    self.x_vel = self.x_vel * -1
                end,
                ["bottom"]  = function()
                    self.y = self.y - self.y_vel
                    self.y_vel = self.y_vel * -1 end,
                ["left"]    = function()
                    self.x = self.x - self.x_vel
                    self.x_vel = self.x_vel * -1
                end,
                ["invalid"] = function() message = "invalid" end
            }
                -- Move the enemy Right or Left
                self.x = self.x + (self.x_vel)
                -- Move the self Up or Down
                self.y = self.y + (self.y_vel)
                for i,v in ipairs(tiles) do
                    if tiles[i].colideable == true then
                        if checkCollision(self.x, self.y, self.w, self.h, tiles[i].x, tiles[i].y, tiles[i].w, tiles[i].h) then
                            self.action[sideCollision(self.x, self.y, self.w, self.h, tiles[i].x, tiles[i].y, tiles[i].w, tiles[i].h)]()
                        else
                            self.action["invalid"]()
                        end
                    end
                end
            end
            table.insert(enemies, enemy)
        end
    end
end

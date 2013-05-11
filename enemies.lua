enemies = {}
for y = 1, #map do
    for x = 1, #map[y] do
        if map[y][x] == 99 then
            enemy = {}
            enemy.x = (x * 32) -32
            enemy.y = (y * 32) -32
            enemy.w = 32
            enemy.h = 32
            enemy.x_vel = 0.5
            enemy.y_vel = 0
            enemy.shootable = false
            enemy.colideable = true
            enemy.draw = "fill"
            enemy.color = {99,134,184,255}
            function  enemy.move(self,i)
                -- Move the enemy Right or Left
                self.x = self.x + (self.x_vel * i)
                -- Move the self Up or Down
                self.y = self.y + self.y_vel
                for i,v in ipairs(tiles) do
                    if CheckCollision(self.x, self.y, self.w, self.h, v.x, v.y, v.w, v.h) then
                        self.x = self.x - self.x_vel
                        self.y = self.y - self.y_vel
                        self.x_vel = self.x_vel * -1
                        self.y_vel = self.y_vel * -1
                    end
                end
            end
            table.insert(enemies, enemy)
        end
    end
end

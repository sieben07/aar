local Projetictile = {
    direction = {
        x = 0,
        y = 0
    },
    properties = {collidable = false}
}

function Projetictile:new(x, y, directionX, directionY, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.x = x + 12 + (directionX * 26)
    self.y = y + 12 + (directionY * 26)
    self.x_vel = 8 * directionX
    self.y_vel = 8 * directionY
    self.direction.x = directionX
    self.direction.y = directionY
    return o
end

return Projetictile

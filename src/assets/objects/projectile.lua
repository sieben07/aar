local global = require "assets.objects.global"
local spriteSheet = global.world.spriteSheet
local world = global.world
local signal = global.signal

local SHOOT_WIDTH = global.SHOOT_WIDTH
local SHOOT_HEIGHT = global.SHOOT_HEIGHT

local Quad = love.graphics.newQuad

local cog = Quad(0, 32 * 4, 16, 16, 32 * 8, 32 *8)
local bolt = Quad(16, 32 * 4, 16, 16, 32 * 8, 32 * 8)
local nut = Quad(32, 32 * 4, 16, 16, 32 * 8, 32 * 8)
local items = {cog, bolt, nut}
local counter = 1;

local Projetictile = {
    direction = {
        x = 0,
        y = 0
    },
    properties = {collidable = false},
    index = math.random(1, 3)
}

function Projetictile:new(x, y, directionX, directionY, itemNumber, o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.x = x + 12 + (directionX * 26)
    o.y = y + 12 + (directionY * 26)
    o.x_vel = 8 * directionX
    o.y_vel = 8 * directionY
    o.direction.x = directionX
    o.direction.y = directionY
    o.type = "projectile"
    o.spriteSheet = spriteSheet
    o.width = SHOOT_WIDTH
    o.height = SHOOT_HEIGHT
    o.quad = items[itemNumber]
    o.itemNumber = itemNumber
    return o
end

function Projetictile:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.spriteSheet, self.quad, self.x + 8, self.y  + 8, math.rad(self.x), 1, 1, 7, 7)
end

function Projetictile:update()
    local goalX = self.x + self.x_vel
    local goalY = self.y + self.y_vel
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self.x = actualX
    self.y = actualY
    for _, col in ipairs(cols) do
        signal:emit("collision", col, self.direction)
    end

    if len ~= 0 then
        world:remove(self)
    end
end

return Projetictile

local root = require "assets.objects.root"
local spriteSheet = root.spriteSheet
local world = root.world
local signal = root.signal

local SHOOT_WIDTH = root.SHOOT_WIDTH
local SHOOT_HEIGHT = root.SHOOT_HEIGHT

local Quad = love.graphics.newQuad

local cog = Quad(0, 32 * 4, 16, 16, 32 * 8, 32 *8)
local bolt = Quad(16, 32 * 4, 16, 16, 32 * 8, 32 * 8)
local nut = Quad(32, 32 * 4, 16, 16, 32 * 8, 32 * 8)
local items = {cog, bolt, nut}
local counter = 1;

local Projectile = {
    direction = {
        x = 0,
        y = 0
    },
    properties = {collidable = false},
}

function Projectile:new(x, y, deg, itemNumber, o, id)
    o = o or {}
    setmetatable(o, self)
    o.startX = x + 16
    o.startY = y + 16
    local dx = math.cos(math.rad(deg))
    local dy = math.sin(math.rad(deg))
    self.__index = self
    o.x = x + 8 + (34 * dx)
    o.y = y + 8 + (34 * dy)
    o.x_vel = 8 * dx
    o.y_vel = 8 * dy
    o.direction.x = dx
    o.direction.y = dy
    o.type = "projectile"
    o.spriteSheet = spriteSheet
    o.width = SHOOT_WIDTH
    o.height = SHOOT_HEIGHT
    o.quad = items[itemNumber]
    o.itemNumber = itemNumber
    o.otherId = id
    return o
end

function Projectile:draw()
    love.graphics.setColor(root.projectileColor)
    love.graphics.draw(self.spriteSheet, self.quad, self.x + 8, self.y  + 8, math.rad(self.x), 1, 1, 7, 7)
end

function Projectile:update()
    local goalX = self.x + self.x_vel
    local goalY = self.y + self.y_vel
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, function(item, other)
        if item.otherId == other._id and other._id ~= nil then
            return false
        end
        return 'slide' end
    )
    self.x = actualX
    self.y = actualY
    for _, col in ipairs(cols) do
        if col.other.type == 'robot' then
            col.other:hit(col.normal)
        end
        signal:emit("collision", col)
    end

    if len ~= 0 then
        world:remove(self)
    end
end

return Projectile

local SIZE = 32
local BIG_SIZE = SIZE * 8
local Quad = love.graphics.newQuad

local hero = {
    falling = nil,
    name = nil,
    title = nil,
    x = 0,
    y = 0,
    WIDTH = 32,
    HEIGHT = 32,
    x_vel = 0,
    y_vel = 0,
    vel = 4,
    GRAVITY = 40,
    jump = 0,
    shooting = false,
    shoots = {}, -- holds our fired shoots
    animationTimer = 0, --
    -- Animation
    iterator = 1,
    max = 5,
    direction = "right",
    status = "shootRight",
    rotate = 0,
    zoom = 1,
    image = love.graphics.newImage "assets/img/minimega.png",
    -- the frames of the hero
    quads = {
        right = {
            Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 5, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 6, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 7, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 6, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        rightShooting = {
            Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 5, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 6, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 7, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 6, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        left = {
            Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 2, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 1, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 0, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 1, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        leftShooting = {
            Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 2, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 1, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 0, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
            Quad(SIZE * 1, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        jumpRight = {
            Quad(SIZE * 4, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        jumpLeft = {
            Quad(SIZE * 3, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        jumpRightMoving = {
            Quad(SIZE * 5, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        jumpLeftMoving = {
            Quad(SIZE * 2, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        jumpRightShooting = {
            Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        jumpLeftShooting = {
            Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
        },
        bulletLeft = {
            Quad(SIZE * 2, SIZE * 5, 14, 14, BIG_SIZE, BIG_SIZE)
        },
        bulletRight = {
            Quad(SIZE * 5, SIZE * 5, 14, 14, BIG_SIZE, BIG_SIZE)
        }
    }
}

function hero:shoot()
    Signal.emit('score', -1)
    local shoot = {}
    if self.status == "shootRight" then
        shoot.x = self.x + self.WIDTH
        shoot.y = self.y + 12
        shoot.WIDTH = 14
        shoot.HEIGHT = 14
        shoot.x_vel = 8
        shoot.type = "bullet"
        shoot.dir = "bulletRight"
        world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
    end
    if self.status == "shootLeft" then
        shoot.x = self.x - 14
        shoot.y = self.y + 12
        shoot.WIDTH = 14
        shoot.HEIGHT = 14
        shoot.x_vel = -8
        shoot.type = "bullet"
        shoot.dir = "bulletLeft"
        world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
    end
end

function hero:updateShoots()
    local shoots, _ = world:getItems()

    for i, shoot in pairs(shoots) do
        if shoot.type == "bullet" then
            -- move them
            local goalX = shoot.x + shoot.x_vel
            local actualX, actualY, cols, len = world:move(shoot, goalX, shoot.y)
            shoot.x = actualX

            for i = 1, len do
                local col = cols[i]
                print(col.other.active, col.other.type)
                if col.other.type == "robot" and col.other.active == false then
                    print('HERE')
                    col.other.active = true
                    Signal.emit('score', 7)
                end


                -- This is wrong, every Robot should know
                -- by himself what to do if hit.
                if col.other.name == "Start" then
                    col.other.falling = true
                end
                if col.other.name == "Jump" then
                    if col.other.jump ~= true then
                        col.other.jump = true
                        col.other.velocity = -128
                    end
                end
            end

            if len ~= 0 then
                world:remove(shoot)
            end
        end
    end
end

function hero:update(dt)
    self:updateShoots()
    -- Animation Framerate
    if self.x_vel ~= 0 and self.y_vel == 0 then
        self.animationTimer = self.animationTimer + dt
        if self.animationTimer > 0.04 then
            self.animationTimer = 0
            self.iterator = self.iterator + 1
            if self.iterator > self.max then
                self.iterator = 2
            end
        end
    end

    if self.x_vel == 0 then
        self.iterator = 1
    end

    if self.y_vel ~= 0 then
        self.iterator = 1
    end

    -- Animation Direciton
    if self.x_vel < 0 then
        if self.y_vel == 0 then
            self.direction = "left"
        elseif self.y_vel ~= 0 then
            self.direction = "jumpLeftMoving"
        end
    end

    if self.x_vel > 0 then
        if self.y_vel == 0 then
            self.direction = "right"
        elseif self.y_vel ~= 0 then
            self.direction = "jumpRightMoving"
        end
    end

    if
        self.direction == "left" or self.direction == "leftShooting" or self.direction == "jumpLeft" or
            self.direction == "jumpLeftShooting" or
            self.direction == "jumpLeftMoving"
     then
        if not self.shooting and self.y_vel == 0 and self.x_vel == 0 then
            self.direction = "left"
        elseif self.shooting and self.y_vel == 0 and self.x_vel == 0 then
            self.direction = "leftShooting"
        elseif self.shooting and self.y_vel == 0 and self.x_vel < 0 then
            self.direction = "leftShooting"
        elseif not self.shooting and self.y_vel ~= 0 and self.x_vel < 0 then
            self.direction = "jumpLeftMoving"
        elseif not self.shooting and self.y_vel ~= 0 and self.x_vel == 0 then
            self.direction = "jumpLeft"
        elseif
            (self.shooting and self.y_vel ~= 0 and self.x_vel) or
                (self.shootinging and self.y_vel ~= 0 and self.x_vel < 0)
         then
            self.direction = "jumpLeftShooting"
        end
    end

    if
        self.direction == "right" or self.direction == "rightShooting" or self.direction == "jumpRight" or
            self.direction == "jumpRightShooting" or
            self.direction == "jumpRightMoving"
     then
        if not self.shooting and self.y_vel == 0 and self.x_vel == 0 then
            self.direction = "right"
        elseif self.shooting and self.y_vel == 0 and self.x_vel == 0 then
            self.direction = "rightShooting"
        elseif self.shooting and self.y_vel == 0 and self.x_vel > 0 then
            self.direction = "rightShooting"
        elseif not self.shooting and self.y_vel ~= 0 and self.x_vel > 0 then
            self.direction = "jumpRightMoving"
        elseif not self.shooting and self.y_vel ~= 0 and self.x_vel == 0 then
            self.direction = "jumpRight"
        elseif
            (self.shooting and self.y_vel ~= 0 and self.x_vel) or
                (self.shootinging and self.y_vel ~= 0 and self.x_vel > 0)
         then
            self.direction = "jumpRightShooting"
        end
    end
    -- Move the Hero Right or Left
    local goalX = self.x + self.x_vel
    local actualX, actualY, cols, len = world:move(self, goalX, self.y)
    self.x = math.floor(actualX)

    if self.jump > 0 then
        self.jump = self.jump - self.GRAVITY / 3 * dt
        self.y_vel = self.jump

        goalY = self.y - self.y_vel
        local actualX, actualY, cols, len = world:move(self, self.x, goalY)
        self.y = math.floor(actualY)

        for i = 1, len do
            local col = cols[i]
            if (col.normal.y == 1) and self.jump > 1 then
                self.jump = 1
            end
        end
    end

    if self.jump <= 0 then
        self.y_vel = self.y_vel + self.GRAVITY / 3 * dt

        local goalY = self.y + self.y_vel
        local actualX, actualY, cols, len = world:move(self, self.x, goalY)
        self.y = math.floor(actualY)

        for i = 1, len do
            local col = cols[i]
            if (col.normal.y == -1) then
                self.y_vel = 0
            end
        end
    end
end

return hero

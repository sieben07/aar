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
  quadIndex = 1,
  max = 5,
  state = "right",
  shootState = "shootRight",
  rotate = 0,
  zoom = 1,
  image = love.graphics.newImage "assets/img/minimega.png",
  -- the frames of the hero
  quads = {
    -- 1
    right = {
      Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 2
    rightInAir = {
      Quad(SIZE * 4, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 4, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 3
    rightMoving = {
      Quad(SIZE * 4, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 7, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 4
    rightShooting = {
      Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 7, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 5
    rightInAirMoving = {
      Quad(SIZE * 5, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 6
    rightInAirShooting = {
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 7
    rightMovingShooting = {
      Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 5, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 7, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 8
    rightInAirMovingShooting = {
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 6, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 1
    left = {
      Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 2
    leftInAir = {
      Quad(SIZE * 3, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 3, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
    },
    -- 3
    leftMoving = {
      Quad(SIZE * 3, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 1, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 0, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 1, SIZE, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 4
    leftShooting = {
      Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 1, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 0, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 1, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
    },
    -- 5
    leftInAirMoving = {
      Quad(SIZE * 2, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 6
    leftInAirShooting = {
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 7
    leftMovingShooting = {
      Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 2, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 1, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 0, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE * 1, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
    },
    -- 7
    leftInAirMovingShooting = {
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
      Quad(SIZE, SIZE * 2, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
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
  Signal.emit("score", -1)
  local shoot = {}
  if self.shootState == "shootRight" then
    shoot.x = self.x + self.WIDTH
    shoot.y = self.y + 12
    shoot.WIDTH = 14
    shoot.HEIGHT = 14
    shoot.x_vel = 8
    shoot.type = "bullet"
    shoot.dir = "bulletRight"
    world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
  end
  if self.shootState == "shootLeft" then
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

  for _, shoot in pairs(shoots) do
    if shoot.type == "bullet" then
      -- move them
      local goalX = shoot.x + shoot.x_vel
      local actualX, actualY, cols, len = world:move(shoot, goalX, shoot.y)
      shoot.x = actualX

      for i = 1, len do
        local col = cols[i]
        if col.other.type == "robot" and col.other.active == false then
          col.other.active = true
          Signal.emit("score", 7)
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
  -- Check if falling
  if self.falling and string.match(heroState.current, "InAir") == nil then
    print(heroState.current)
    heroState.jumpPress()
  end
  -- Animation Framerate
  self.animationTimer = self.animationTimer + dt
  if self.animationTimer > 0.07 then
    self.animationTimer = 0
    self.quadIndex = self.quadIndex + 1
    if self.quadIndex > self.max then
      self.quadIndex = 2
    end
  end

  -- Animation Direciton
  self.state = heroState.current

  -- Move the Hero Right or Left
  local goalX = self.x + self.x_vel
  local actualX, actualY, cols, len = world:move(self, goalX, self.y)
  self.x = math.floor(actualX)

  if self.jump > 0 then
    self.falling = true
    self.jump = self.jump - self.GRAVITY / 3 * dt
    self.y_vel = self.jump

    local goalY = self.y - self.y_vel
    local actualX, actualY, cols, len = world:move(self, self.x, goalY)
    self.y = math.floor(actualY)

    for col in ipairs(cols) do
      if (col.normal.y == 1) and self.jump > 1 then
        self.jump = 1
      end
    end
  end

  if self.jump <= 0 then
    self.falling = true
    self.y_vel = self.y_vel + self.GRAVITY / 3 * dt

    local goalY = self.y + self.y_vel
    local actualX, actualY, cols, len = world:move(self, self.x, goalY)
    self.y = math.floor(actualY)

    for _, col in ipairs(cols) do
      if (col.normal.y == -1) then
        self.y_vel = 0
        self.jump = 0
        self.falling = false
      if string.match(heroState.current, "InAir") ~= nil then
          heroState.collisionGround()
      end
      end
    end
  end
end

return hero

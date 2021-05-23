local global = require "assets.obj.global"
local signal = global.signal

local SIZE = 32
local BIG_SIZE = SIZE * 8
local Quad = love.graphics.newQuad

local machine = require("assets.libs.lua-fsm.src.fsm")

local hero = {
   name = "mini",
   title = "Robot",
   x = 0,
   y = 0,
   WIDTH = global.WIDTH,
   HEIGHT =global.HEIGHT,
   x_vel = 0,
   y_vel = 1,
   vel = 4,
   jump_vel = -7,
   GRAVITY = -0.2,
   animationTimer = 0,
   stick_to = "", -- the platform takes controll over movement while sticky

   -- Animation
   quadIndex = 1,
   max = 5,
   projectileDirection = {x = 1, y = 0},
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
         Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
         Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
         Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
         Quad(SIZE * 4, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE)
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
         Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
         Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
         Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
         Quad(SIZE * 3, SIZE * 3, SIZE, SIZE, BIG_SIZE, BIG_SIZE),
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
      -- 8
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

function hero:animate(dt)
   self.animationTimer = self.animationTimer + dt
   if self.animationTimer > 0.07 then
      self.animationTimer = 0
      self.quadIndex = self.quadIndex + 1
      if self.quadIndex > self.max then
         self.quadIndex = 2
      end
   end
end

 -- the states of the hero
hero.fsm = machine.create({
   initial = "right",
   events = {
      { name = "collisionGround", from = "leftInAir", to = "left" },
      { name = "collisionGround", from = "leftInAirMoving", to = "leftMoving" },
      { name = "collisionGround", from = "leftInAirMovingShooting", to = "leftMovingShooting" },
      { name = "collisionGround", from = "leftInAirShooting", to = "leftShooting" },
      { name = "collisionGround", from = "rightInAir", to = "right" },
      { name = "collisionGround", from = "rightInAirMoving", to = "rightMoving" },
      { name = "collisionGround", from = "rightInAirMovingShooting", to = "rightMovingShooting" },
      { name = "collisionGround", from = "rightInAirShooting", to = "rightShooting" },
      { name = "jumpPressed", from = "left", to = "leftInAir" },
      { name = "jumpPressed", from = "leftMoving", to = "leftInAirMoving" },
      { name = "jumpPressed", from = "leftMovingShooting", to = "leftInAirMovingShooting" },
      { name = "jumpPressed", from = "leftShooting", to = "leftInAirShooting" },
      { name = "jumpPressed", from = "right", to = "rightInAir" },
      { name = "jumpPressed", from = "rightMoving", to = "rightInAirMoving" },
      { name = "jumpPressed", from = "rightMovingShooting", to = "rightInAirMovingShooting" },
      { name = "jumpPressed", from = "rightShooting", to = "rightInAirShooting" },
      { name = "leftPressed", from = "left", to = "leftMoving" },
      { name = "leftPressed", from = "leftInAir", to = "leftInAirMoving" },
      { name = "leftPressed", from = "leftInAirShooting", to = "leftInAirMovingShooting" },
      { name = "leftPressed", from = "leftShooting", to = "leftMovingShooting" },
      { name = "leftPressed", from = "right", to = "leftMoving" },
      { name = "leftPressed", from = "rightInAir", to = "leftInAirMoving" },
      { name = "leftPressed", from = "rightInAirMoving", to = "leftInAirMoving" },
      { name = "leftPressed", from = "rightInAirMovingShooting", to = "leftInAirMovingShooting" },
      { name = "leftPressed", from = "rightInAirShooting", to = "leftInAirMovingShooting" },
      { name = "leftPressed", from = "rightMoving", to = "leftMoving" },
      { name = "leftPressed", from = "rightMovingShooting", to = "leftMovingShooting" },
      { name = "leftPressed", from = "rightShooting", to = "leftMovingShooting" },
      { name = "leftReleased", from = "leftInAirMoving", to = "leftInAir" },
      { name = "leftReleased", from = "leftInAirMovingShooting", to = "leftInAirShooting" },
      { name = "leftReleased", from = "leftMoving", to = "left" },
      { name = "leftReleased", from = "leftMovingShooting", to = "leftShooting" },
      { name = "rightPressed", from = "left", to = "rightMoving" },
      { name = "rightPressed", from = "leftInAir", to = "rightInAirMoving" },
      { name = "rightPressed", from = "leftInAirMoving", to = "rightInAirMoving" },
      { name = "rightPressed", from = "leftInAirMovingShooting", to = "rightInAirMovingShooting" },
      { name = "rightPressed", from = "leftInAirShooting", to = "rightInAirMovingShooting" },
      { name = "rightPressed", from = "leftMoving", to = "rightMoving" },
      { name = "rightPressed", from = "leftMovingShooting", to = "rightMovingShooting" },
      { name = "rightPressed", from = "leftShooting", to = "rightMovingShooting" },
      { name = "rightPressed", from = "right", to = "rightMoving" },
      { name = "rightPressed", from = "rightInAir", to = "rightInAirMoving" },
      { name = "rightPressed", from = "rightInAirShooting", to = "rightInAirMovingShooting" },
      { name = "rightPressed", from = "rightShooting", to = "rightMovingShooting" },
      { name = "rightReleased", from = "rightInAirMoving", to = "rightInAir" },
      { name = "rightReleased", from = "rightInAirMovingShooting", to = "rightInAirShooting" },
      { name = "rightReleased", from = "rightMoving", to = "right" },
      { name = "rightReleased", from = "rightMovingShooting", to = "rightShooting" },
      { name = "shootPressed", from = "left", to = "leftShooting" },
      { name = "shootPressed", from = "leftInAir", to = "leftInAirShooting" },
      { name = "shootPressed", from = "leftInAirMoving", to = "leftInAirMovingShooting" },
      { name = "shootPressed", from = "leftMoving", to = "leftMovingShooting" },
      { name = "shootPressed", from = "right", to = "rightShooting" },
      { name = "shootPressed", from = "rightInAir", to = "rightInAirShooting" },
      { name = "shootPressed", from = "rightInAirMoving", to = "rightInAirMovingShooting" },
      { name = "shootPressed", from = "rightMoving", to = "rightMovingShooting" },
      { name = "shootReleased", from = "leftInAirMovingShooting", to = "leftInAirMoving" },
      { name = "shootReleased", from = "leftInAirShooting", to = "leftInAir" },
      { name = "shootReleased", from = "leftMovingShooting", to = "leftMoving" },
      { name = "shootReleased", from = "leftShooting", to = "left" },
      { name = "shootReleased", from = "rightInAirMovingShooting", to = "rightInAirMoving" },
      { name = "shootReleased", from = "rightInAirShooting", to = "rightInAir" },
      { name = "shootReleased", from = "rightMovingShooting", to = "rightMoving" },
      { name = "shootReleased", from = "rightShooting", to = "right" }
   },
   callbacks = {
      on_rightPressed = function()
         hero.x_vel = hero.vel
         hero.projectileDirection = {x = 1, y = 0}
      end,
      on_rightReleased = function()
         hero.x_vel = 0
      end,
      on_leftPressed = function()
         hero.x_vel = -hero.vel
         hero.projectileDirection = {x = -1, y = 0} -- how to math this
      end,
      on_leftReleased = function()
          hero.x_vel = 0
      end,
      on_jumpPressed = function(_, _, _, _, falling)
         hero.y_vel = hero.jump_vel + (falling * (-hero.jump_vel + 1))
         hero.stick_to = ""
         hero.iterator = 1
      end,
      on_jumpReleased = function()
         hero.y_vel = 1
      end
   }
})

signal:register("leftPressed", function()
   hero.fsm.leftPressed()
end)
signal:register("rightPressed", function()
   hero.fsm.rightPressed()
end)
signal:register("jumpPressed", function()
   hero.fsm.jumpPressed(0)
end)
signal:register("shootPressed", function()
   hero.fsm.shootPressed()
end)

signal:register("leftReleased", function()
   hero.fsm.leftReleased()
end)
signal:register("rightReleased", function()
   hero.fsm.rightReleased()
end)
signal:register("jumpReleased", function()
   hero.fsm.on_jumpReleased()
end)
signal:register("shootReleased", function()
   hero.fsm.shootReleased()
end)

signal:register("hit", function()
   signal:emit("score", 7)
end)

return hero

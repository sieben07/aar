local SIZE = 32
local BIG_SIZE = SIZE * 8
local Quad = love.graphics.newQuad

local machine = require("assets.libs.lua-fsm.src.fsm")

local hero = {
   falling = nil,
   name = nil,
   title = nil,
   x = 0,
   y = 0,
   WIDTH = 32,
   HEIGHT = 32,
   x_vel = 0,
   y_vel = 1,
   vel = 4,
   jump_vel = -6,
   GRAVITY = -0.2,
   shoots = {}, -- holds our fired shoots
   animationTimer = 0,
   stick_to = '', -- the platform takes controll over movement while sticky

   -- Animation
   quadIndex = 1,
   max = 5,
   shootState = "shootRight",
   rotate = 0,
   zoom = 1,
   image = love.graphics.newImage "assets/img/minimega.png",
   bulletImage = love.graphics.newImage "assets/img/white.png",


   -- the states of the hero
   fsm = machine.create({
      initial = "right",
      events = {
         { name = "jumpPress", from = "right", to = "rightInAir" },
         { name = "rightPress", from = "right", to = "rightMoving" },
         { name = "shootPress", from = "right", to = "rightShooting" },
         { name = "collisionGround", from = "rightInAir", to = "right" },
         { name = "rightPress", from = "rightInAir", to = "rightInAirMoving" },
         { name = "shootPress", from = "rightInAir", to = "rightInAirShooting" },
         { name = "rightReleased", from = "rightMoving", to = "right" },
         { name = "jumpPress", from = "rightMoving", to = "rightInAirMoving" },
         { name = "shootPress", from = "rightMoving", to = "rightMovingShooting" },
         { name = "shootReleased", from = "rightShooting", to = "right" },
         { name = "jumpPress", from = "rightShooting", to = "rightInAirShooting" },
         { name = "rightPress", from = "rightShooting", to = "rightMovingShooting" },
         { name = "rightReleased", from = "rightInAirMoving", to = "rightInAir" },
         { name = "shootPress", from = "rightInAirMoving", to = "rightInAirMovingShooting" },
         { name = "collisionGround", from = "rightInAirMoving", to = "rightMoving" },
         { name = "shootReleased", from = "rightInAirShooting", to = "rightInAir" },
         { name = "collisionGround", from = "rightInAirShooting", to = "rightShooting" },
         { name = "rightPress", from = "rightInAirShooting", to = "rightInAirMovingShooting" },
         { name = "rightReleased", from = "rightMovingShooting", to = "rightShooting" },
         { name = "shootReleased", from = "rightMovingShooting", to = "rightMoving" },
         { name = "jumpPress", from = "rightMovingShooting", to = "rightInAirMovingShooting" },
         { name = "shootReleased", from = "rightInAirMovingShooting", to = "rightInAirMoving" },
         { name = "rightReleased", from = "rightInAirMovingShooting", to = "rightInAirShooting" },
         { name = "collisionGround", from = "rightInAirMovingShooting", to = "rightMovingShooting" },
         { name = "jumpPress", from = "left", to = "leftInAir" },
         { name = "leftPress", from = "left", to = "leftMoving" },
         { name = "shootPress", from = "left", to = "leftShooting" },
         { name = "collisionGround", from = "leftInAir", to = "left" },
         { name = "leftPress", from = "leftInAir", to = "leftInAirMoving" },
         { name = "shootPress", from = "leftInAir", to = "leftInAirShooting" },
         { name = "leftReleased", from = "leftMoving", to = "left" },
         { name = "jumpPress", from = "leftMoving", to = "leftInAirMoving" },
         { name = "shootPress", from = "leftMoving", to = "leftMovingShooting" },
         { name = "shootReleased", from = "leftShooting", to = "left" },
         { name = "jumpPress", from = "leftShooting", to = "leftInAirShooting" },
         { name = "leftPress", from = "leftShooting", to = "leftMovingShooting" },
         { name = "leftReleased", from = "leftInAirMoving", to = "leftInAir" },
         { name = "shootPress", from = "leftInAirMoving", to = "leftInAirMovingShooting" },
         { name = "collisionGround", from = "leftInAirMoving", to = "leftMoving" },
         { name = "shootReleased", from = "leftInAirShooting", to = "leftInAir" },
         { name = "collisionGround", from = "leftInAirShooting", to = "leftShooting" },
         { name = "leftPress", from = "leftInAirShooting", to = "leftInAirMovingShooting" },
         { name = "leftReleased", from = "leftMovingShooting", to = "leftShooting" },
         { name = "shootReleased", from = "leftMovingShooting", to = "leftMoving" },
         { name = "jumpPress", from = "leftMovingShooting", to = "leftInAirMovingShooting" },
         { name = "shootReleased", from = "leftInAirMovingShooting", to = "leftInAirMoving" },
         { name = "leftReleased", from = "leftInAirMovingShooting", to = "leftInAirShooting" },
         { name = "collisionGround", from = "leftInAirMovingShooting", to = "leftMovingShooting" },
         { name = "leftPress", from = "right", to = "leftMoving" },
         { name = "leftPress", from = "rightInAir", to = "leftInAirMoving" },
         { name = "leftPress", from = "rightInAirMoving", to = "leftInAirMoving" },
         { name = "leftPress", from = "rightInAirMovingShooting", to = "leftInAirMovingShooting" },
         { name = "leftPress", from = "rightInAirShooting", to = "leftInAirMovingShooting" },
         { name = "leftPress", from = "rightMoving", to = "leftMoving" },
         { name = "leftPress", from = "rightMovingShooting", to = "leftMovingShooting" },
         { name = "leftPress", from = "rightShooting", to = "leftMovingShooting" },
         { name = "rightPress", from = "left", to = "rightMoving" },
         { name = "rightPress", from = "leftInAir", to = "rightInAirMoving" },
         { name = "rightPress", from = "leftInAirMoving", to = "rightInAirMoving" },
         { name = "rightPress", from = "leftInAirMovingShooting", to = "rightInAirMovingShooting" },
         { name = "rightPress", from = "leftInAirShooting", to = "rightInAirMovingShooting" },
         { name = "rightPress", from = "leftMoving", to = "rightMoving" },
         { name = "rightPress", from = "leftMovingShooting", to = "rightMovingShooting" },
         { name = "rightPress", from = "leftShooting", to = "rightMovingShooting" },
      }
      -- ,
      -- callbacks = {
      --    on_right = function(self, event, from, to, msg) print(self, event, from, to, msg) end,
      --    on_rightInAir = function() end,
      --    on_rightMoving = function() end,
      --    on_rightShooting = function() end,
      --    on_rightInAirMoving = function() end,
      --    on_rightInAirShooting = function() end,
      --    on_rightMovingShooting = function() end,
      --    on_rightInAirMovingShooting = function() end,
      --    on_left = function(self, event, from, to, msg) print(self, event, from, to, msg) end,
      --    on_leftInAir = function() end,
      --    on_leftMoving = function() end,
      --    on_leftShooting = function() end,
      --    on_leftInAirMoving = function() end,
      --    on_leftInAirShooting = function() end,
      --    on_leftMovingShooting = function() end,
      --    on_leftInAirMovingShooting = function() end
      -- }
   }),

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

function hero:draw()
   -- player
   love.graphics.draw(self.image, self.quads[self.fsm.current][self.quadIndex], self.x, self.y, self.rotate, self.zoom)

   -- shoots
   local shoots, _ = world:getItems()

   for _, shoot in ipairs(shoots) do
      if shoot.type == "bullet" then
      love.graphics.draw(self.bulletImage, shoot.x, shoot.y)
      end
   end
end

return hero

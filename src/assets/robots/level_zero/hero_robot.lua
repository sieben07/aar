local global = require "assets.objects.global"

local Robot = require "assets.robots.robot"
local machine = require "assets.libs.lua-fsm.src.fsm"
local projectile = require "src.assets.objects.projectile"
local spriteSheet = global.world.spriteSheet
local signal = global.signal

local FRAME_SIZE = 32
local SPRITE_SHEET_SIZE = FRAME_SIZE * 8
local Quad = love.graphics.newQuad

local world = global.world

local heroRobot = {
   name = "mini",
   animationTimer = 0,
   GRAVITY = -0.2,
   HEIGHT = global.PLAYER_HEIGHT,
   image = spriteSheet,
   jump_vel = -7,
   max = 5,
   projectileDirection = {x = 1, y = 0},
   quadIndex = 1,
   rotate = 0,
   stick_to = "",
   vel = 4,
   WIDTH = global.PLAYER_W,
   x = 0,
   x_vel = 0,
   y = 0,
   y_vel = 1,
   zoom = 1,
   quads = {
      -- 1
      right = {
         Quad(FRAME_SIZE * 4, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 2
      rightInAir = {
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 3
      rightMoving = {
         Quad(FRAME_SIZE * 4, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 5, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 7, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 4
      rightShooting = {
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 5
      rightInAirMoving = {
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 6
      rightInAirShooting = {
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 7
      rightMovingShooting = {
         Quad(FRAME_SIZE * 4, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 7, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 8
      rightInAirMovingShooting = {
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 6, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 1
      left = {
         Quad(FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 2
      leftInAir = {
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
      },
      -- 3
      leftMoving = {
         Quad(FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 1, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 0, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 1, FRAME_SIZE, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 4
      leftShooting = {
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
      },
      -- 5
      leftInAirMoving = {
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 6
      leftInAirShooting = {
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 7
      leftMovingShooting = {
         Quad(FRAME_SIZE * 3, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 1, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 0, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE * 1, FRAME_SIZE * 3, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      -- 8
      leftInAirMovingShooting = {
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE),
         Quad(FRAME_SIZE, FRAME_SIZE * 2, FRAME_SIZE, FRAME_SIZE, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      bulletLeft = {
         Quad(FRAME_SIZE * 2, FRAME_SIZE * 5, 14, 14, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      },
      bulletRight = {
         Quad(FRAME_SIZE * 5, FRAME_SIZE * 5, 14, 14, SPRITE_SHEET_SIZE, SPRITE_SHEET_SIZE)
      }
   }
}

local HeroRobot = Robot:new(heroRobot)

function HeroRobot:animate(dt)
   self.animationTimer = self.animationTimer + dt
   if self.animationTimer > 0.07 then
      self.animationTimer = 0
      self.quadIndex = self.quadIndex + 1
      if self.quadIndex > self.max then
         self.quadIndex = 2
      end
   end
end

function HeroRobot:update(dt)
   self:animate(dt)

   if self.stick_to ~= "" and self.stick_to.name ~= nil and self.stick_to.name ~= 'Reset' then
      self.y = self.stick_to.y - 32
   end

   local goalX = self.x + self.x_vel

   self.y = self.y + self.y_vel
   self.y_vel = self.y_vel - self.GRAVITY
   local goalY = self.y
   local actualX, actualY, cols, len = world:move(self, goalX, goalY)
   self.x = actualX
   self.y = actualY

   if len == 0 and self.fsm.can("jumpPressed") then
      self.fsm.jumpPressed(1)
      self.stick_to = nil
   end

   for _, col in ipairs(cols) do
      if (col.normal.y ~= 0) then
         self.y_vel = 1
         if col.normal.y == -1 and self.fsm.can("collisionGround") then
            self.stick_to = col.other
            self.fsm.collisionGround()
         end
      end
   end
end

function HeroRobot:draw()
   love.graphics.setColor(global.color.red ,global.color.green, global.color.blue)
   love.graphics.draw(self.image, self.quads[self.fsm.current][self.quadIndex], self.x, self.y, self.rotate, self.zoom)
end

 -- the states of the HeroRobot
function setFsm(o)
   return machine.create({
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
         o.x_vel = o.vel
         o.projectileDirection = {x = 1, y = 0}
      end,
      on_rightReleased = function()
         o.x_vel = 0
      end,
      on_leftPressed = function()
         o.x_vel = -o.vel
         o.projectileDirection = {x = -1, y = 0} -- how to calculate directions with vectors?
      end,
      on_leftReleased = function()
          o.x_vel = 0
      end,
      on_jumpPressed = function(_, _, _, _, falling)
         o.y_vel = o.jump_vel + (falling * (-o.jump_vel + 1))
         o.stick_to = ""
         o.iterator = 1
      end,
      on_jumpReleased = function()
         o.y_vel = 1
      end,
      on_shootPressed = function()
         signal:emit(
            "addProjectile",
            projectile:new(
               o.x,
               o.y,
               o.projectileDirection.x,
               o.projectileDirection.y)
            )
         signal:emit("score", -1)
      end
   }
})
end

function registerSignals(o)
   signal:clear("leftPressed")
   signal:clear("rightPressed")
   signal:clear("jumpPressed")
   signal:clear("shootPressed")
   signal:clear("leftReleased")
   signal:clear("rightReleased")
   signal:clear("jumpReleased")
   signal:clear("shootReleased")
   signal:clear("hit")
   -- press
   signal:register("leftPressed", function()
      o.fsm.leftPressed()
   end)
   signal:register("rightPressed", function()
      o.fsm.rightPressed()
   end)
   signal:register("jumpPressed", function()
      if o.fsm.can("jumpPressed") then
         o.fsm.jumpPressed(0)
      end
   end)
   signal:register("shootPressed", function()
      o.fsm.shootPressed()
   end)

   -- release
   signal:register("leftReleased", function()
      if string.match(o.fsm.current, "left") ~= nil then
         o.fsm.leftReleased()
      end
   end)
   signal:register("rightReleased", function()
      if string.match(o.fsm.current, "right") ~= nil then
         o.fsm.rightReleased()
      end
   end)
   signal:register("jumpReleased", function()
      if o.y_vel < 0 then
         o.fsm.on_jumpReleased()
      end
   end)
   signal:register("shootReleased", function()
      o.fsm.shootReleased()
   end)

   signal:register("hit", function() end)
end

function HeroRobot:new(o)
   o = o or {}
   self.fsm = setFsm(o)
   registerSignals(o)
   setmetatable(o, self)
   self.__index = self

   return o
end

return HeroRobot

local global = require "assets.obj.global"
local machine = require "assets.libs.lua-fsm.src.fsm"
local PLAYER_WIDTH = global.PLAYER_WIDTH
local SHOOT_WIDTH = global.SHOOT_WIDTH
local SHOOT_HEIGHT = global.SHOOT_HEIGHT
local OFFSET_X = 14
local OFFSET_Y = 12
local bulletImage = love.graphics.newImage "assets/img/white.png"

local signal = global.signal
local world = global.world
local shoots = {}
shoots.fsm = machine.create({
    initial = "right",
    events = {
        {name = "rightPressed", from = {"left", "right"}, to = "right"},
        {name = "leftPressed", from = {"left", "right"}, to = "left"}
    }
})
shoots.items = {}

shoots.addShootToWorld = function(position)
    local shoot = {}
    shoot.y = position.y + OFFSET_Y
    shoot.type = "bullet"
    shoot.direction = shoots.fsm.current
    if shoots.fsm.current == "right" then
        shoot.x = position.x + PLAYER_WIDTH
        shoot.x_vel = 8
        table.insert(shoots.items, shoot)
        world:add(shoot, shoot.x, shoot.y, SHOOT_WIDTH, SHOOT_HEIGHT)
    end
    if shoots.fsm.current == "left" then
        shoot.x = position.x - OFFSET_X
        shoot.x_vel = -8
        table.insert(shoots.items, shoot)
        world:add(shoot, shoot.x, shoot.y, SHOOT_WIDTH, SHOOT_HEIGHT)
    end
end

function shoots.update()
   for i, shoot in ipairs(shoots.items) do
      -- move them
      local goalX = shoot.x + shoot.x_vel
      local actualX, _, cols, len = world:move(shoot, goalX, shoot.y, function(_, _) return "cross" end )
      shoot.x = actualX
      for _, col in ipairs(cols) do
         signal:emit("hit", col.touch, shoot.direction)
         if col.other.type == "robot" and col.other.active == false then
            col.other.active = true
            signal:emit("score", 7)
         end

         -- This is wrong, every Robot should know
         -- by himself what to do if hit.
         if col.other.name == "Start" then
            col.other.falling = true
         end
         if col.other.name == "Jump" or col.other.name == "High Jump" then
            if col.other.jump ~= true then
               col.other.jump = true
               signal:emit("bounce", col.other)
            end
         end
      end

      if len ~= 0 then
         world:remove(shoot)
         table.remove(shoots.items, i)
      end
   end
end

shoots.draw = function()
   for _, shoot in ipairs(shoots.items) do
         love.graphics.draw(bulletImage, shoot.x, shoot.y)
   end
end

signal:register("shootPressed", function(player)
   shoots.addShootToWorld(player)
end)
signal:register("leftPressed", function()
    shoots.fsm.leftPressed()
end)
signal:register("rightPressed", function()
    shoots.fsm.rightPressed()
end)

return shoots

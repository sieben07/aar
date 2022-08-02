Signal = require "assets.libs.hump.signal"
local bump = require "assets.libs.bump.bump"
local DIMENSIONS = 32

local TweenWorld = {
   robots = {}
}

function TweenWorld:add(robot)
   table.insert(self.robots, robot)
end

function TweenWorld:draw()
   for _, robot in ipairs(self.robots) do
      robot:draw()
   end
end

function TweenWorld:remove(robot)
   for i, v in ipairs(self.robots) do
      if v == robot then
         table.remove(self.robots, i)
      end
   end
end

local global = {
   background = {color = {red   = 76 / 255,green = 77 / 255,blue  = 78 / 255,alpha = 1}},
   color = {red   = 0,green = 0,blue  = 0,alpha = 1},
   countdown = 4,
   fonts = require "assets.font.fonts",
   game = { version = "0.0.11" },
   hitAnimation = { time = 0.5, alpha = 1 },
   hits = {},
   level = {current = 1},
   PLAYER_HEIGHT = DIMENSIONS,
   PLAYER_WIDTH = DIMENSIONS,
   score = 7,
   SHOOT_HEIGHT = 14,
   SHOOT_WIDTH = 14,
   signal = Signal.new(),
   transition = { start =  false },
   world = bump.newWorld(DIMENSIONS),
   tweenWorld = TweenWorld,
   spriteSheet = nil,
   projectileDirections = {
      ["0"] = 0, -- right
      ["1"] = 45, -- down right
      ["2"] = 90, -- down
      ["3"] = 135, -- down left
      ["4"] = 180, -- left
      ["5"] = 225, -- up left
      ["6"] = 270, -- up
      ["7"] = 315 -- up right
   }
}

function global.world:m (item, goalX, goalY, filter)
   local actualX, actualY, cols, length = self:move(item, goalX, goalY, filter);
   item.x, item.y = actualX, actualY
   return cols, length
end

return global

Signal = require "assets.libs.hump.signal"
local bump = require "assets.libs.bump.bump"
local DIMENSIONS = 32

local global = {
   background = {color = {red   = 76 / 255,green = 77 / 255,blue  = 78 / 255,alpha = 1}},
   color = {red   = 0,green = 0,blue  = 0,alpha = 1},
   countdown = 4,
   game = { version = "0.0.10" },
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
}

function global.world:m (item, goalX, goalY, filter)
   local actualX, actualY, cols, length = self:move(item, goalX, goalY, filter);
   item.x, item.y = actualX, actualY
   return cols, length
end

return global

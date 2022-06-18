Signal = require "assets.libs.hump.signal"
local bump = require "assets.libs.bump.bump"
local DIMENSIONS = 32

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
   spriteSheet = nil,
   projectileDirections = {
      ["0"] = {x = 0, y = -1},
      ["1"] = {x = 0.707, y = -0.707},
      ["2"] = {x = 1, y = 0},
      ["3"] = {x = 0.707, y = 0.707},
      ["4"] = {x = 0, y = 1},
      ["5"] = {x = -0.707, y = 0.707},
      ["6"] = {x = -1, y = 0},
      ["7"] = {x = -0.707, y = -0.707}
   }
}

function global.world:m (item, goalX, goalY, filter)
   local actualX, actualY, cols, length = self:move(item, goalX, goalY, filter);
   item.x, item.y = actualX, actualY
   return cols, length
end

return global

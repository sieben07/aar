Signal = require "assets.libs.hump.signal"
local COLORS = require "assets.styles.colors"
local bump = require "assets.libs.bump.bump"
local DIMENSIONS = 32

local root = {
   versionColor = COLORS.GRAY,
   textColor = COLORS.TEXT,
   projectileColor = {0, 0, 0},
   heroColor = {0,0,0},
   particleColor = {1, 0, 0},
   scoreColor = {1, 0.64, 0.02},
   backgroundColor = COLORS.BACKGROUND,
   color = {0, 0, 0},
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

function root.world:m (item, goalX, goalY, filter)
   local actualX, actualY, cols, length = self:move(item, goalX, goalY, filter);
   item.x, item.y = actualX, actualY
   return cols, length
end

return root

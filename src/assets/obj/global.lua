Signal = require "assets.libs.hump.signal"
local bump = require "assets.libs.bump.bump"
local DIMENSIONS = 32

local global = {
   world = bump.newWorld(DIMENSIONS),
   signal = Signal.new(),
   hits = {},
   level = {
      current = 1
   },
   color = {
      red   = 0,
      green = 0,
      blue  = 0,
      alpha = 1
   },
   background = {
      color = {
         red   = 76 / 255,
         green = 77 / 255,
         blue  = 78 / 255,
         alpha = 1
      }
   },
   countdown = 4,
   score = 7,
   PLAYER_WIDTH = DIMENSIONS,
   PLAYER_HEIGHT = DIMENSIONS,
   SHOOT_WIDTH = 14,
   SHOOT_HEIGHT = 14
}

return global

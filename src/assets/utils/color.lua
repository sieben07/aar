local COLORS = require "assets.styles.colors"

local color = {}

local colorIndex = 0;

function color.invertColor(color)
   return { 1 - color[1], 1 - color[2], 1 - color[3], color[4] }
end

function color.nextColor()
   local _COLORS = {COLORS.a, COLORS.b, COLORS.c, COLORS.d, COLORS.e}
   if colorIndex == #_COLORS then
      colorIndex = 0
   end
   colorIndex = colorIndex + 1
   return _COLORS[colorIndex]
end

return color

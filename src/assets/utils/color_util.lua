local COLORS = require "assets.styles.colors"

local ColorUtil = {}

local colorIndex = 0;

function ColorUtil.invertColor(color)
   return { 1 - color[1], 1 - color[2], 1 - color[3], color[4] }
end

function ColorUtil.nextColor()
   local _COLORS = {COLORS.A, COLORS.B, COLORS.C, COLORS.D, COLORS.E}
   if colorIndex == #_COLORS then
      colorIndex = 0
   end
   colorIndex = colorIndex + 1
   return _COLORS[colorIndex]
end

return ColorUtil

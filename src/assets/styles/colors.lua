local function hexToRgb(colorHex)
   local _, _, r, g, b = colorHex:find("(%x%x)(%x%x)(%x%x)")
   r, g, b = love.math.colorFromBytes(
    tonumber(r,16),
    tonumber(g,16),
    tonumber(b,16))
   return {r, g, b, 1}
end

local COLORS = {
    WHITE = {1, 1, 1},
    A = {0.2078,0.3137,0.4392},
    B = {0.4275,0.349,0.4784},
    C = {0.7098,0.3961,0.4627},
    D = {0.898,0.4196,0.4353},
    E = {0.9176,0.6745,0.5451},
    GRAY = { 76/255, 77/255, 78/255 },
    BLACK = { 0, 0, 0 },
    TEXT = hexToRgb("#252422"),  -- { 0.9176,0.6745,0.5451 },
    BACKGROUND = hexToRgb("#9bbbcc"),
    FOREGROUND = { 0, 0, 0 },
    HERO_COLOR = {1, 1, 1, 1},
    ORANGE = {1, 0.64, 0.02},
}

return COLORS

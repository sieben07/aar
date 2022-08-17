local function hexToRgb(colorHex)
   local _, _, r, g, b = colorHex:find("(%x%x)(%x%x)(%x%x)")
   r, g, b = love.math.colorFromBytes(
    tonumber(r,16),
    tonumber(g,16),
    tonumber(b,16))
   return {r, g, b, 1}
end
--[[
    #c38b72
    #ba9280
    #b0998f
    #a3a09d
    #95a7ac
    #83aebb
    #6bb4ca
]]--

local COLORS = {
    WHITE = {1, 1, 1},
    A = {0.2078,0.3137,0.4392},
    B = {0.4275,0.349,0.4784},
    C = {0.7098,0.3961,0.4627},
    D = {0.898,0.4196,0.4353},
    E = {0.9176,0.6745,0.5451},
    GRAY = { 0.1976, 0.1977, 0.1978 },
    BLACK = { 0, 0, 0 },
    TEXT = hexToRgb("#ccac9b"),  -- { 0.9176,0.6745,0.5451 },
    BACKGROUND = hexToRgb("#9bbbcc"),
    FOREGROUND = { 0, 0, 0 },
    HERO_COLOR = {1, 1, 1, 1},
}

return COLORS


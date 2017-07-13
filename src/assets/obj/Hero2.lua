local Hero = {}; Hero.__index = Hero

local function construct()
    local self = setmetatable({}, Hero)
    return self
end

setmetatable(Hero, {__call = construct})

Hero.falling = nil
Hero.name = nil
Hero.title = nil

Hero.x = 0
Hero.y = 0

Hero.xVel = 0
Hero.yVel = 0

Hero.GRAVITY = 40
Hero.HEIGHT = 32
Hero.WIDTH = 32


return Hero
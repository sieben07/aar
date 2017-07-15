local Robot = {}; Robot.__index = Robot

local function construct()
    local self = setmetatable({}, Robot)
    return self
end

setmetatable(Robot, {__call = construct})

Robot.falling = nil
Robot.name = nil
Robot.title = nil

Robot.x = 0
Robot.y = 0

Robot.xVel = 0
Robot.yVel = 0

Robot.GRAVITY = 40
Robot.HEIGHT = 32
Robot.WIDTH = 32

-- Animation
-- Can direction be complex object ?
Robot.direction = "right"
Robot.image = love.graphics.newImage "assets/img/minimega.png"
Robot.iterator = 1
Robot.status = ""

Robot.MAX_ITERATOR = 5

Robot.rotate = 0
Robot.zoom = 1



return Robot
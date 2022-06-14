local global = require "assets.objects.global"

local resetRobot = require "assets.robots.level_zero.reset_robot"

local signal = global.signal
local world = global.world

local addRobotToWorld = function(robot)
   world:add(robot, robot.x, robot.y, robot.width, robot.height)
end

signal:register("zero", function()
   addRobotToWorld(resetRobot)
   signal:clear("zero")
end)

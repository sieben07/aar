--[[--
# The Robot Module.
## Every Robot should have the same base fields
@module Robot
--]]--
local Robot = {};

--- return the robot entity
-- @field velocity the velocity
function Robot.new()
    local self = {};

    self.velocity = 0;
    self.jumpVelocity = -128
    self.gravity = -200

    return self;
end

return Robot;

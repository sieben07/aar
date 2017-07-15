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
    self.jumpVelocity = -128 -- the jump Velocity
    self.gravity = -200 -- the gravity

    return self;
end

return Robot;

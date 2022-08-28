local root = require "assets.objects.root"
local COLORS = require "assets.styles.colors"

local Robot = require "assets.robots.robot"

local HeroRobot = require "assets.robots.level_zero.hero_robot"
local StartRobot = require "assets.robots.level_zero.start_robot"
local ResetRobot = require "assets.robots.level_zero.reset_robot"
local ZeroFour = require "assets.robots.level_zero.zero_four"
local ZeroFive = require "assets.robots.level_zero.zero_five"
local TextRobot = require "assets.robots.level_zero.text_robot"

local JumpRobot = require "assets.robots.level_one.jump_robot"
local JumpShootRobot = require "assets.robots.level_one.jump_shoot_robot"
local JumpBossRobot = require "assets.robots.level_one.jump_boss_robot"

local TwoZero = require "assets.robots.level_two.two_zero"
local TwoOne = require "assets.robots.level_two.two_one"
local TwoTwo = require "assets.robots.level_two.two_two"
local TwoThree = require "assets.robots.level_two.two_three"
local TwoFour = require "assets.robots.level_two.two_four"
local TwoFive = require "assets.robots.level_two.two_five"

local ThreeZero = require "assets.robots.level_three.three_zero"
local ThreeOne = require "assets.robots.level_three.three_one"
local ThreeTwo = require "assets.robots.level_three.three_two"
local ThreeThree = require "assets.robots.level_three.three_three"
local ThreeFour = require "assets.robots.level_three.three_four"
local ThreeFive = require "assets.robots.level_three.three_five"

local FourZero = require "assets.robots.level_four.four_zero"
local FourOne = require "assets.robots.level_four.four_one"
local FourTwo = require "assets.robots.level_four.four_two"
local FourThree = require "assets.robots.level_four.four_three"
local FourFour = require "assets.robots.level_four.four_four"
local FourFive = require "assets.robots.level_four.four_five"

local FiveZero = require "assets.robots.level_five.five_zero"
local FiveOne = require "assets.robots.level_five.five_one"
local FiveTwo = require "assets.robots.level_five.five_two"
local FiveThree = require "assets.robots.level_five.five_three"
local FiveFour = require "assets.robots.level_five.five_four"
local FiveFive = require "assets.robots.level_five.five_five"

local Projectile = require "assets.objects.projectile"

local signal = root.signal

local util = {}


local function areAllRobotsActive(t)
   local allTrue = 0
   for _, value in ipairs(t) do
      if value == true then
         allTrue = allTrue + 1
      end
   end

   if allTrue == #t and #t > 0 then
      return true
   else
      return false
   end
end

function util.merge(first, second)
   for key ,value in pairs(second) do
      first[key] = value
    end
end


local newJumpRobot = function(o)
   o.jumpVelocity = -128
   return JumpRobot:new(o)
end

local newHighJumpRobot = function(o)
   o.jumpVelocity = -256
   return JumpRobot:new(o)
end

local newJumpShootRobot = function(o)
   o.jumpVelocity = -128
   return JumpShootRobot:new(o)
end

local newGravityJumpRobot = function(o)
   o.jumpVelocity = 128
   o.gravity = -200
   return JumpRobot:new(o)
end

local newGravityHighJumpRobot = function(o)
   o.jumpVelocity = 256
   o.gravity = -200
   return JumpRobot:new(o)
end

local newGravityJumpShootRobot = function(o)
   o.jumpVelocity = 128
   o.gravity = -200
   o.up = true
   function o:getTurningPoint(velocity)
      return velocity > 0
   end

   return JumpShootRobot:new(o)
end

local newStartRobot = function(obj)
   return StartRobot:new(obj)
end

local newExitRobot = function(obj)
   return Robot:new(obj)
end

local newHeroRobot = function(obj)
   return HeroRobot:new(obj)
end

local newResetRobot = function(obj)
   return ResetRobot:new(obj)
end

local newArcTan2JumpShootRobot = function(o)
   o.jumpVelocity = -128
   function o:shoot(dt)
      local deg = math.deg(math.atan2(self.y - root.hero[1].y, self.x - root.hero[1].x))
      signal:emit("addProjectile", Projectile:new(self.x, self.y, deg, 1))
   end

   return JumpShootRobot:new(o)
end

local newTextRobot = function(obj)
   if obj.type == "h1" then
      obj.font = "orial"
      obj.color = COLORS.BLACK
   end

   if obj.type == "h2" then
      obj.font = "ormont"
      obj.color = COLORS.ORANGE
   end
   return TextRobot:new(obj)
end

local createRobot = {
   Mini = newHeroRobot,
   Start = newStartRobot,
   Text = newTextRobot,
   Reset = newResetRobot,
   Exit = newExitRobot,
   Jump = newJumpRobot,
   High_Jump = newHighJumpRobot,
   Jump_Shoot = newJumpShootRobot,
   Gravity_Jump = newGravityJumpRobot,
   Gravity_High_Jump = newGravityHighJumpRobot,
   Gravity_Jump_Shoot = newGravityJumpShootRobot,
   ArcTan2_Jump_Shoot = newArcTan2JumpShootRobot,
   Jump_Boss = newJumpBossRobot
}

function util.getSpritesFromMap(map)
   local robots = {}
   for _,object in pairs(map) do
      local robot = createRobot[object.name](object)
      table.insert(robots, robot)
   end
   return robots
end

function util.update(robots, dt)
   local allActive = {}
   for _, robot in pairs(robots) do
      if robot.type ~= "" then
         robot:update(dt)
         if robot.type == "robot" then
            table.insert(allActive, robot:getIsActive())
         end
      end
   end

   if areAllRobotsActive(allActive) then
      signal:emit("allActive")
   end
end

return util

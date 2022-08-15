local root = require "assets.objects.root"

local Robot = require "assets.robots.robot"

local HeroRobot = require "assets.robots.level_zero.hero_robot"
local StartRobot = require "assets.robots.level_zero.start_robot"
local ZeroTwo = require "assets.robots.level_zero.zero_two"
local ResetRobot = require "assets.robots.level_zero.reset_robot"
local ZeroFour = require "assets.robots.level_zero.zero_four"
local ZeroFive = require "assets.robots.level_zero.zero_five"
local TextRobot = require "assets.robots.level_zero.text_robot"

local JumpRobot = require "assets.robots.level_one.jump_robot"
local JumpShootRobot = require "assets.robots.level_one.jump_shoot_robot"
local GravityJumpRobot = require "assets.robots.level_one.gravity_jump_robot"
local GravityJumpShootRobot = require "assets.robots.level_one.gravity_jump_shoot_robot"
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


local newJumpRobot = function(obj)
   return JumpRobot:new(obj)
end

local newHighJumpRobot = function(obj)
   return JumpRobot:new(obj, -256)
end

local newJumpShootRobot = function(obj)
   return JumpShootRobot:new(obj)
end

local newGravityJumpRobot = function(obj)
   return GravityJumpRobot:new(obj)
end

local newGravityHighJumpRobot = function(obj)
   return GravityJumpRobot:new(obj, 256)
end

local newGravityJumpShootRobot = function(obj)
   return GravityJumpShootRobot:new(obj)
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

local newTextRobot = function(obj)
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

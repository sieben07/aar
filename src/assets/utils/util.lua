local global = require "assets.objects.global"

local flux = require "assets.libs.flux.flux"
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

local signal = global.signal
local transition = global.transition
local world = global.world
local tweenWorld = global.tweenWorld

local colorIndex = 0;
local tween = {}
local util = {}

local group = nil;

local function areAllRobotsActive(t)
   local allTrue = 0
   for _, value in ipairs(t) do
      if value == false then
         allTrue = allTrue + 1
      end
   end

   if allTrue == 0 then
      return true
   else
      return false
   end
end

local function hexToRgba(colorHex)
   local _, _, a, r, g, b = colorHex:find("(%x%x)(%x%x)(%x%x)(%x%x)")
   local rgba = {}
   rgba.red = tonumber(r,16) / 255
   rgba.green = tonumber(g,16) / 255
   rgba.blue = tonumber(b,16) / 255
   rgba.alpha = tonumber(a,16) / 255
   return rgba
end

local function randomColor()
  return { red = math.random(), green = math.random(), blue = math.random(), 1 }
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

   if areAllRobotsActive(allActive) and transition.start == false then
      signal:emit("allActive")
   end
end

function util.nextColor()
   local a = {0.2078,0.3137,0.4392}
   local b = {0.4275,0.349,0.4784}
   local c = {0.7098,0.3961,0.4627}
   local d = {0.898,0.4196,0.4353}
   local e = {0.9176,0.6745,0.5451}
   local colors = {a, b, c, d, e}
   if colorIndex == #colors then
      colorIndex = 0
   end
   colorIndex = colorIndex + 1
   local j = colors[colorIndex]
   return {red = j[1], green = j[2], blue = j[3]}
end

function tween.start()
   global.countdown = 4
   global.color.red = 0
   global.color.green = 0
   global.color.blue = 0
   f = flux.to(global, 0.5, {countdown = 0})
   :onupdate(
      function()
         global.color = randomColor()
      end)
   :oncomplete(
      function()
         global.color = hexToRgba("#FFFFFFFF")
         global.background.color = hexToRgba("#FF9bbbcc")
         global.countdown = 4
         signal:emit("nextLevel")
      end)
end

function tween.insertRobot(robot)
   local y = robot.y
   local x = robot.x
   local width = robot.width
   local height = robot.height

   robot.x = 0
   robot.y = 0
   robot.width = love.graphics.getWidth()
   robot.height = love.graphics.getHeight()
   robot.alpha = 0

   tweenWorld:add(robot)
   flux.to(robot, 2, {x = x, y = y, width = width, height = height, alpha = 1}):ease("elasticout")
   :oncomplete(
      function()
         tweenWorld:remove(robot)
         world:add(robot, robot.x, robot.y, robot.width, robot.height)
      end
   )
end

function tween.update(dt)
   flux.update(dt)
end

function tween.particles(particles, dt)
    for index, hit in ipairs(particles) do
        if hit.time >= 0 then
            hit.time = hit.time - dt
            hit.alpha = hit.alpha - dt
        else
            table.remove(particles, index)
        end
    end
end

util.tween = tween

return util

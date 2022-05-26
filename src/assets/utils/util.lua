local global = require "assets.objects.global"

local flux = require "assets.libs.flux.flux"
local Robot = require "assets.robots.robot"

local ZeroZero = require "assets.robots.level_zero.zero_zero"
local StartRobot = require "assets.robots.level_zero.start_robot"
local ZeroTwo = require "assets.robots.level_zero.zero_two"
local ResetRobot = require "assets.robots.level_zero.reset_robot"
local ZeroFour = require "assets.robots.level_zero.zero_four"
local ZeroFive = require "assets.robots.level_zero.zero_five"

local OneZero = require "assets.robots.level_one.one_zero"
local OneOne = require "assets.robots.level_one.one_one"
local OneTwo = require "assets.robots.level_one.one_two"
local OneThree = require "assets.robots.level_one.one_three"
local OneFour = require "assets.robots.level_one.one_four"
local OneFive = require "assets.robots.level_one.one_five"

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

local JumpRobot = require "assets.robots.level_one.jump_robot"

local signal = global.signal
local transition = global.transition
local world = global.world

local colorIndex = 0;
local tween = {}
local util = {}

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

local updateHero = function(robot, dt)
   robot:animate(dt)

   if robot.stick_to ~= "" and robot.stick_to.name ~= nil then
      robot.y = robot.stick_to.y - 32
   end

   local goalX = robot.x + robot.x_vel
   local actualX = world:move(robot, goalX, robot.y)
   robot.x = actualX

   robot.y = robot.y + robot.y_vel
   robot.y_vel = robot.y_vel - robot.GRAVITY

   local goalY = robot.y
   local _, actualY, cols, len = world:move(robot, robot.x, goalY)
   robot.y = actualY

   if len == 0 and robot.fsm.can("jumpPressed") then
      robot.fsm.jumpPressed(1)
   end

   for _, col in ipairs(cols) do
      if (col.normal.y ~= 0) then
         robot.y_vel = 1
         if col.normal.y == -1 and robot.fsm.can("collisionGround") then
            robot.stick_to = col.other
            robot.fsm.collisionGround()
         end
      end
   end
end

local updateText = function(_, _) end

local updateRobot = function(robot, dt)
   robot:update(dt)
end

local updateAction = {
   hero = updateHero,
   robot = updateRobot,
   text = updateText
}

local newJumpRobot = function(obj)
   return JumpRobot:new(obj)
end

local newStartRobot = function(obj)
   return StartRobot:new(obj)
end

local newExitRobot = function(obj)
   return Robot:new(obj)
end

local newZeroZero = function(obj)
   return ZeroZero:new(obj)
end

local newZeroOne = function(obj)
   return ZeroOne:new(obj)
end

local newZeroTwo = function(obj)
   return ZeroTwo:new(obj)
end

local newResetRobot = function(obj)
   -- ResetRobot
   return ResetRobot:new(obj)
end

local newZeroFour = function(obj)
   return ZeroFour:new(obj)
end

local newZeroFive = function(obj)
   return ZeroFive:new(obj)
end

local newOneZero = function(obj)
   return OneZero:new(obj)
end

local newOneOne = function(obj)
   return OneOne:new(obj)
end

local newOneTwo = function(obj)
   return OneTwo:new(obj)
end

local newOneThree = function(obj)
   return OneThree:new(obj)
end

local newOneFour = function(obj)
   return OneFour:new(obj)
end

local newOneFive = function(obj)
   return OneFive:new(obj)
end

local newTwoZero = function(obj)
   return TwoZero:new(obj)
end

local newTwoOne = function(obj)
   return TwoOne:new(obj)
end

local newTwoTwo = function(obj)
   return TwoTwo:new(obj)
end

local newTwoThree = function(obj)
   return TwoThree:new(obj)
end

local newTwoFour = function(obj)
   return TwoFour:new(obj)
end

local newTwoFive = function(obj)
   return TwoFive:new(obj)
end

local newThreeZero = function(obj)
   return ThreeZero:new(obj)
end

local newThreeOne = function(obj)
   return ThreeOne:new(obj)
end

local newThreeTwo = function(obj)
   return ThreeTwo:new(obj)
end

local newThreeThree = function(obj)
   return ThreeThree:new(obj)
end

local newThreeFour = function(obj)
   return ThreeFour:new(obj)
end

local newThreeFive = function(obj)
   return ThreeFive:new(obj)
end

local newFourZero = function(obj)
   return FourZero:new(obj)
end

local newFourOne = function(obj)
   return FourOne:new(obj)
end

local newFourTwo = function(obj)
   return FourTwo:new(obj)
end

local newFourThree = function(obj)
   return FourThree:new(obj)
end

local newFourFour = function(obj)
   return FourFour:new(obj)
end

local newFourFive = function(obj)
   return FourFive:new(obj)
end

local newFiveZero = function(obj)
   return FiveZero:new(obj)
end

local newFiveOne = function(obj)
   return FiveOne:new(obj)
end

local newFiveTwo = function(obj)
   return FiveTwo:new(obj)
end

local newFiveThree = function(obj)
   return FiveThree:new(obj)
end

local newFiveFour = function(obj)
   return FiveFour:new(obj)
end

local newFiveFive = function(obj)
   return FiveFive:new(obj)
end

local createRobot = {
   Jump = newJumpRobot,
   High_Jump = newJumpRobot,
   Start = newStartRobot,
   Exit = newExitRobot,
   zero_zero = newZeroZero,
   zero_one = newZeroOne,
   zero_two = newZeroTwo,
   Reset = newResetRobot,
   zero_four = newZeroFour,
   zero_five = newZeroFive,
   one_zero = newOneZero,
   one_one = newOneOne,
   one_two = newOneTwo,
   one_three = newOneThree,
   one_four = newOneFour,
   one_five = newOneFive,
   two_zero = newTwoZero,
   two_one = newTwoOne,
   two_two = newTwoTwo,
   two_three = newTwoThree,
   two_four = newTwoFour,
   two_five = newTwoFive,
   three_zero = newThreeZero,
   three_one = newThreeOne,
   three_two = newThreeTwo,
   three_three = newThreeThree,
   three_four = newThreeFour,
   three_five = newThreeFive,
   four_zero = newFourZero,
   four_one = newFourOne,
   four_two = newFourTwo,
   four_three = newFourThree,
   four_four = newFourFour,
   four_five = newFourFive,
   five_zero = newFiveZero,
   five_one = newFiveOne,
   five_two = newFiveTwo,
   five_three = newFiveThree,
   five_four = newFiveFour,
   five_five = newFiveFive
}

function util.getSpritesFromMap(map)
   local hero
   local robots = {}
   local texts = {}
   for _,object in pairs(map) do
      if object.type == "hero" then
         hero = object
      end
      if object.type == "robot" then
         local robot = createRobot[object.name](object)
         table.insert(robots, robot)
      end
      if object.type == "text" then
         table.insert(texts, object)
      end
   end
   return hero, robots, texts
end

function util.update(robots, dt)
   local allActive = {}
   for _, robot in ipairs(robots) do
      if robot.type == "robot" then
         table.insert(allActive, robot:getIsActive())
      end
      updateAction[robot.type](robot, dt);
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
    if transition.start == false then
        transition.start = true
        global.countdown = 4
        global.color.red = 0
        global.color.green = 0
        global.color.blue = 0
        flux.to(global, 0.5, {countdown = 0})
    end
end

function tween.update(dt)
    if transition.start == true then
        flux.update(dt)
        global.color = randomColor()
    end

    if global.countdown == 0 then
        global.color = hexToRgba("#FFFFFFFF")
        global.background.color = hexToRgba("#FF9bbbcc")
        signal:emit("nextLevel")
        global.countdown = 4
        transition.start = false
    end
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

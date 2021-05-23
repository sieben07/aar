local flux = require "assets.libs.flux.flux"
local global = require "assets.obj.global"
local Robot = require "assets.obj.Robot"
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

local function filterUp(_ , other)
   if other.type == "hero" or other.type == "bullet" then
      return "cross"
   else
      return "slide"
   end
end

local function filterDown(_, other)
   if other.type == "bullet" then
      return "cross"
   else
      return "slide"
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

local updateText = function(robot, dt) end

local updateRobot = function(robot, dt)
   if robot:getIsFalling() == true then
      robot.velocity = robot.velocity + 33.3 * dt
      local goalY = robot.y + robot.velocity
      local _, len = world:m(robot, robot.x, goalY)

      if len ~= 0 then
         robot:setIsFalling(false)
      end
   end

   if robot.jump == true then
      if robot.velocity < 0 then
         local goalY = robot.y + robot.velocity * dt
         robot:updateVelocity(-dt)
         local cols, _ = world:m(robot, robot.x, goalY, filterUp)
         local dy

         for _, col in ipairs(cols) do
            if col.other.type == "robot" then
               robot:setVelocity(0)
            end

            dy = goalY - 32
            if col.other.type == "hero" then
               world:m(col.other, col.other.x, col.other.y + dy)
            end
         end
      end

      if robot:getVelocity() >= 0 then
         local goalY = robot.y + robot.velocity * dt
         robot:updateVelocity(-dt)
         local _, len = world:m(robot, robot.x, goalY, filterDown)

         if len ~= 0 then
            signal:emit("bounce", robot)
         end
      end
   end
end

local updateAction = {
   hero = updateHero,
   robot = updateRobot,
   text = updateText
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
         local robot = Robot:new(object)
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

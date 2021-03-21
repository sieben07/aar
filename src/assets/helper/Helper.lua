--[[--
# Helper.
## Has some functions that help.
@module Helper
--]]--
local Helper = {}

--[[--
merges into `first` table values from the `second` table.
@function merge
@param first the first table
@param second the second table
--]]--
function Helper.merge(first, second)
   for key ,value in pairs(second) do
      first[key] = value
    end
end

--[[--
sorts and loads `robots`.
it sorts the robot tables returned from sti
robot.types are:

+ hero
+ robot
+ text

robot.names are:

+ Start
+ Jump

@function getSpritesFromMap
@tparam object mapRobots the robot table loaded from sti
--]]--
function Helper.getSpritesFromMap(map)
   local entity = require "assets.obj.robot"
   local hero
   local robots = {}
   local texts = {}
   for _,object in pairs(map) do
      if object.type == "hero" then
         hero = object
      end
      if object.type == "robot" then
         Helper.merge(object, entity)
         object.falling = object.properties.falling
         object.active = object.properties.active
         table.insert(robots, object)
      end
      if object.type == 'text' then
         table.insert(texts, object)
      end
   end
   return hero, robots, texts
end

--[[--
hex color string to rgba color string
@function hexToArgb
@param colorHex a color coded in a hex string with alpha value as first hex number
@treturn {number,...} a table with the r g b a colors as number
--]]--
function Helper.hexToRgba(colorHex)
   local x, y, a, r, g, b = colorHex:find('(%x%x)(%x%x)(%x%x)(%x%x)')
   local rgba = {}
   rgba.red = tonumber(r,16) / 255
   rgba.green = tonumber(g,16) / 255
   rgba.blue = tonumber(b,16) / 255
   rgba.alpha = tonumber(a,16) / 255
   return rgba
end

--[[--
@function randomColor
@treturn {number,...} a table with r g b a colors as numbers
--]]--
function Helper.randomColor()
  return { red = math.random(), green = math.random(), blue = math.random(), 1 }
end

local colorIndex = 0;

function Helper.nextColor()
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
   j = colors[colorIndex]
   return {red = j[1], green = j[2], blue = j[3]}
end

function Helper.areAllRobotsActive(t)
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

Helper.shoots = {}

-- move and update the hero
function Helper.shoot(hero, world)
   Signal.emit("score", -1)
   local shoot = {}
   shoot.y = hero.y + 12
   shoot.WIDTH = 14
   shoot.HEIGHT = 14
   if hero.shootState == "shootRight" then
      shoot.x = hero.x + hero.WIDTH
      shoot.x_vel = 8
      shoot.dir = "bulletRight"
      table.insert(Helper.shoots, shoot)
      world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
   end
   if hero.shootState == "shootLeft" then
      shoot.x = hero.x - 14
      shoot.x_vel = -8
      shoot.dir = "bulletLeft"
      table.insert(Helper.shoots, shoot)
      world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
   end
end

function Helper.updateShoots(hero, world)

   for i, shoot in ipairs(Helper.shoots) do
      -- move them
      local goalX = shoot.x + shoot.x_vel
      local actualX, _, cols, len = world:move(shoot, goalX, shoot.y, function(_, _) return "cross" end )
      shoot.x = actualX
      for _, col in ipairs(cols) do
         Signal.emit("hit", col.touch, shoot.dir)
         if col.other.type == "robot" and col.other.active == false then
            col.other.active = true
            Signal.emit("score", 7)
         end

         -- This is wrong, every Robot should know
         -- by himself what to do if hit.
         if col.other.name == "Start" then
            col.other.falling = true
         end
         if col.other.name == "Jump" or col.other.name == "High Jump" then
            if col.other.jump ~= true then
               col.other.jump = true
               Signal.emit("bounce", col.other)
            end
         end
      end

      if len ~= 0 then
         world:remove(shoot)
         table.remove(Helper.shoots, i)
      end
   end
end

function Helper.update(dt, hero, world)
   -- Handle Shooting
   Helper.updateShoots(hero, world)

   -- Animation Framerate
   hero.animationTimer = hero.animationTimer + dt
   if hero.animationTimer > 0.07 then
      hero.animationTimer = 0
      hero.quadIndex = hero.quadIndex + 1
      if hero.quadIndex > hero.max then
         hero.quadIndex = 2
      end
   end

   if hero.stick_to ~= '' and hero.stick_to.name ~= nil then
      -- TO DO add or remove the delta of x and y direction?
      hero.y = hero.stick_to.y - 32
   end

   -- Check if falling
   if hero.falling and hero.fsm.can("jumpPress") then
      hero.fsm.jumpPress(1)
   end

   -- Move the Hero LEFT or RIGHT
   local goalX = hero.x + hero.x_vel
   local actualX, _, _, len = world:move(hero, goalX, hero.y)
   hero.x = actualX

   -- TODO: DON'T TEST ON y_vel find something else
   if hero.y_vel ~= 0 then
      hero.falling = true
      --hero.fsm.fallingAction()
      hero.y = hero.y + hero.y_vel
      hero.y_vel = hero.y_vel - hero.GRAVITY

      local goalY = hero.y
      local aX, aY, cols, len = world:move(hero, hero.x, goalY)
      hero.y = aY

      if len > 0 then
         hero.falling = false
         hero.y_vel = 1
         for _, col in ipairs(cols) do
            if (col.normal.y ~= 1) then
               hero.stick_to = col.other
               if hero.fsm.can('collisionGround') then
                  hero.fsm.collisionGround()
               end
            end
         end
      end
   end
end

function Helper.drawShoots(bulletImage)
   for _, shoot in ipairs(Helper.shoots) do
         love.graphics.draw(bulletImage, shoot.x, shoot.y)
   end
end

return Helper

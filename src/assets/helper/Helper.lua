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

@function getTextsFromMapObjects
@tparam object mapRobots the robot table loaded from sti
@tparam object robotEntity a robot table from Robot
--]]--
function Helper.getTextsFromMapObjects(mapObjects)
   local texts = {}

   for _,object in pairs(mapObjects) do
      if object.type == 'text' then
         table.insert(texts, object)
      end
   end
   return texts
end

--[[--
@function getHeroFromMapObjects
@tparam object mapRobots the robot table loaded from sti
@tparam object robotEntity a robot table from Robot
--]]--
function Helper.getHeroFromMapObjects(mapObjects)
   for _,object in pairs(mapObjects) do
      if object.type == "hero" then
         return object
      end
   end
end

--[[--
@function getRobotsFromMapObjects
@tparam object mapRobots the robot table loaded from sti
@tparam object robotEntity a robot table from Robot
--]]--
function Helper.getRobotsFromMapObjects(mapObjects, entity)
   local robots = {}
   for _,object in pairs(mapObjects) do
      if object.type == "robot" then
         Helper.merge(object, entity)
         object.falling = object.properties.falling
         object.active = object.properties.active
         table.insert(robots, object)
      end
   end
   return robots
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
   local rgba = {}
   rgba.red = math.random()
   rgba.green = math.random()
   rgba.blue =  math.random()
   rgba.alpha = 1
   return rgba
end

function Helper.randomColorTable()
  return { math.random(), math.random(), math.random(), 1 }
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


function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

-- move and update the hero

function Helper.shoot(hero, world)
   Signal.emit("score", -1)
   local shoot = {}
   if hero.shootState == "shootRight" then
      shoot.x = hero.x + hero.WIDTH
      shoot.y = hero.y + 12
      shoot.WIDTH = 14
      shoot.HEIGHT = 14
      shoot.x_vel = 8
      shoot.type = "bullet"
      shoot.dir = "bulletRight"
      world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
   end
   if hero.shootState == "shootLeft" then
      shoot.x = hero.x - 14
      shoot.y = hero.y + 12
      shoot.WIDTH = 14
      shoot.HEIGHT = 14
      shoot.x_vel = -8
      shoot.type = "bullet"
      shoot.dir = "bulletLeft"
      world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
   end
end

function Helper.updateShoots(hero, world)
   local shoots, _ = world:getItems()

   for _, shoot in pairs(shoots) do
      if shoot.type == "bullet" then
         -- move them
         local goalX = shoot.x + shoot.x_vel
         local actualX, _, cols, len = world:move(shoot, goalX, shoot.y, function(_, _) return "cross" end )
         shoot.x = actualX

         for _, col in ipairs(cols) do
            Signal.emit("hit", col.touch, hero.shootState)
            if col.other.type == "robot" and col.other.active == false then
               col.other.active = true
               Signal.emit("score", 7)
            end

            -- This is wrong, every Robot should know
            -- by himself what to do if hit.
            if col.other.name == "Start" then
               col.other.falling = true
            end
            if col.other.name == "Jump" then
               if col.other.jump ~= true then
                  col.other.jump = true
                  col.other.velocity = -128
               end
            end
         end

         if len ~= 0 then
            world:remove(shoot)
         end
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
      hero.stick_to = ''
      hero.fsm.jumpPress()
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

function Helper.drawFactory(robot, world)
   local draw = function ()
      -- player
      love.graphics.draw(robot.image, robot.quads[robot.fsm.current][robot.quadIndex], robot.x, robot.y, robot.rotate, robot.zoom)

      -- shoots
      local shoots, _ = world:getItems()

      for _, shoot in ipairs(shoots) do
         if shoot.type == "bullet" then
            love.graphics.draw(robot.bulletImage, shoot.x, shoot.y)
         end
      end
   end
   return draw
end

return Helper



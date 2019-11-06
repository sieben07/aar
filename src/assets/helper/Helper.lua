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



return Helper



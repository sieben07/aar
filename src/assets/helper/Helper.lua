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

robot.names are

+ Start
+ Jump

@function loadRobots
@tparam object mapRobots the robot table loaded from sti
@tparam object robotEntity a robot table from Robot
--]]--
function Helper.loadRobots(mapRobots, robotEntity)
    local hero = {}
    local robots = {}
    local texts = {}

    for _, mapRobot in pairs(mapRobots) do
        if mapRobot.type == "hero" then
            hero = mapRobot
        end

        if mapRobot.type == "robot" then
            Helper.merge(mapRobot, robotEntity)
            mapRobot.falling = mapRobot.properties.falling
            mapRobot.active = mapRobot.properties.active
            table.insert(robots, mapRobot)
        end

        if mapRobot.type == 'text' then
            mapRobot.properties.color = Helper.hexToRgba(mapRobot.properties.color)
            table.insert(texts, mapRobot)
        end
    end

    return hero, robots, texts
end

--[[--
hex color string to rgba color string
@function hexToArgb
@param colorHex a color coded in a hex string
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



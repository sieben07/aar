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
    rgba.red = tonumber(r,16)
    rgba.green = tonumber(g,16)
    rgba.blue = tonumber(b,16)
    rgba.alpha = tonumber(a,16)
    return rgba
end

return Helper



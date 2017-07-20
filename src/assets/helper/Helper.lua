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

function Helper.LoadRobots(objects, robotEntity)
    local hero = {}
    local robots = {}
    local texts = {}

    for _, object in pairs(objects) do
        if object.type == "hero" then
            hero = object
        end

        if object.type == "robot" then
            Helper.merge(object, robotEntity)
            object.falling = object.properties.falling
            table.insert(robots, object)
        end

        if object.type == 'text' then
            object.properties.color = Helper.hexToArgb(object.properties.color)
            table.insert(texts, object)
        end
    end

    return hero, robots, texts
end

function Helper.hexToArgb(colorHex)
    local _, _, a, r, g, b = colorHex:find('(%x%x)(%x%x)(%x%x)(%x%x)')
    return {tonumber(r,16),tonumber(g,16),tonumber(b,16),tonumber(a,16)}
end

return Helper



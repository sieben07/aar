--[[--
# Helper Object.
## Has some functions that help.
@module Helper
--]]--
local Helper = {}

--[[--
merges the `first` table into the `second` table.
@function merge
@param first the first table
@param second the second table
@return second merged table
--]]--
function Helper.merge(first, second)
    for k,v in pairs(first) do second[k] = v end;
    return second
end

return Helper

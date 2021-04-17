local flux = require "assets.libs.flux.flux"
local global = require "assets.obj.global"
local signal = global.signal
local transition = global.transition

local tween = {}
local util = {}

function util.move(w, r, gx, gy, filter)
   local ax, ay, cs, l = w:move(r, gx, gy, filter)
   r.x, r.y = ax, ay
   return cs, l
end

function util.clear(world)
   local items, _ = world:getItems()
   for _, item in pairs(items) do
      world:remove(item)
   end
end

function util.merge(first, second)
   for key ,value in pairs(second) do
      first[key] = value
    end
end

function util.getSpritesFromMap(map)
   local entity = require "assets.obj.robot"
   local hero
   local robots = {}
   local texts = {}
   for _,object in pairs(map) do
      if object.type == "hero" then
         hero = object
      end
      if object.type == "robot" then
         util.merge(object, entity)
         object.falling = object.properties.falling
         object.active = object.properties.active
         table.insert(robots, object)
      end
      if object.type == "text" then
         table.insert(texts, object)
      end
   end
   return hero, robots, texts
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

local colorIndex = 0;

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

function util.areAllRobotsActive(t)
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

function util.update(dt, hero, world)
   -- Animation Framerate
   hero.animationTimer = hero.animationTimer + dt
   if hero.animationTimer > 0.07 then
      hero.animationTimer = 0
      hero.quadIndex = hero.quadIndex + 1
      if hero.quadIndex > hero.max then
         hero.quadIndex = 2
      end
   end

   if hero.stick_to ~= "" and hero.stick_to.name ~= nil then
      -- TO DO add or remove the delta of x and y direction?
      hero.y = hero.stick_to.y - 32
   end

   -- Check if falling
   if hero.falling and hero.fsm.can("jumpPressed") then
      hero.fsm.jumpPressed(1)
   end

   -- Move the Hero LEFT or RIGHT
   local goalX = hero.x + hero.x_vel
   local actualX = world:move(hero, goalX, hero.y)
   hero.x = actualX

   -- TODO: DON#T TEST ON y_vel find something else
   if hero.y_vel ~= 0 then
      hero.falling = true
      --hero.fsm.fallingAction()
      hero.y = hero.y + hero.y_vel
      hero.y_vel = hero.y_vel - hero.GRAVITY

      local goalY = hero.y
      local _, aY, cols, len = world:move(hero, hero.x, goalY)
      hero.y = aY

      if len > 0 then
         hero.falling = false
         hero.y_vel = 1
         for _, col in ipairs(cols) do
            if (col.normal.y ~= 1) then
               hero.stick_to = col.other
               if hero.fsm.can("collisionGround") then
                  hero.fsm.collisionGround()
               end
            end
         end
      end
   end
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
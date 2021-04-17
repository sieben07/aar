local flux = require "assets.libs.flux.flux"
local helper = require "assets.helper.Helper"
local global = require "assets.obj.global"
local signal = global.signal
local transition = global.transition

local tween = {}

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
        global.color = helper.randomColor()
    end

    if global.countdown == 0 then
        global.color = helper.hexToRgba("#FFFFFFFF")
        global.background.color = helper.hexToRgba("#FF9bbbcc")
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

return tween

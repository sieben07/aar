flux = require "assets.libs.flux.flux"
Helper = require "assets.helper.Helper"

local transitions = {
    shouldstart = false
}

local tween = nil

--[[--
transitions:selector select the transition.
@param state
@param transitiontype
@param Gamestate
@param global
@param dt delta time
--]]
function transitions:selector(state, transitiontype, Gamestate, global, dt)
    if tween == nil then
        global.color.red = 0
        global.color.green = 0
        global.color.blue = 0

        color = {
            red = 0,
            green = 0,
            blue = 0,
            alpha = 255
        }

        tween = flux.to(color, 1, {red = 255, green = 255, blue = 255, alpha = 255})
        countdown = flux.to(global, 1, {countdown = 0})
    end

    -- Random Color Level Transition
    if transitiontype == "randomColor" then
        flux.update(dt)
        global.color = Helper.randomColor()
    end

    if global.countdown == 0 then
        tween = nil
        global.countdown = 4

        transitions.shouldstart = false

        self.A = 255
        self.B = 0

        global.color = Helper.hexToRgba("#FFFFFFFF")
        global.background.color = Helper.hexToRgba("#FF9bbbcc")

        Gamestate.switch(state)
    end
end

function transitions:hitsTween(hits, dt)
    for index, hit in ipairs(hits) do
        if hit.time >= 0 then
            hit.time = hit.time - dt
            hit.zoom = hit.zoom + 0.001
            hit.rotate = hit.rotate + 15
            hit.alpha = hit.alpha - dt
        else
            table.remove(hits, index)
        end
    end
end

return transitions

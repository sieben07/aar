flux = require "assets.libs.flux.flux"

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
        global.color.red = love.math.random(color.red) / 255
        global.color.green = love.math.random(color.green) / 255
        global.color.blue = love.math.random(color.blue) / 255
        print(global.color.red, color.red);
    end

    if global.countdown == 0 then
        tween = nil
        global.countdown = 4

        transitions.shouldstart = false

        self.A = 255
        self.B = 0

        global.color.red = 1
        global.color.green = 1
        global.color.blue = 1

        global.background.color.red = 77 / 255
        global.background.color.green = 77 / 255
        global.background.color.blue = 77 / 255

        Gamestate.switch(state)
    end
end

return transitions

flux = require "assets.libs.flux.flux"

local transitions = {
    shouldstart = false,
}

local tween = nil

function transitions:selector(state, transitiontype, Gamestate, global, dt)

    if tween == nil then
        tween = flux.to(global.color,4, {red = 255, green = 255, blue = 255, alpha=255})
    end

    -- Random Color Level Transition
    if transitiontype == "randomColor" then
        flux.update(dt)
        print(global.color.red)
        --flux.to(global.background.color,4, {red = 77, green = 77, blue = 77, alpha=255})
    end

    if global.color.red == 255 then
        tween = nil
        love.timer.sleep(1.7)

        transitions.shouldstart = false

        self.A = 255
        self.B = 0

        global.color.red = 255
        global.color.green = 255
        global.color.blue = 255


        global.background.color.red = 77
        global.background.color.green = 77
        global.background.color.blue = 77

        Gamestate.switch(state)
    end
end

return transitions

transitions = {
    shouldstart = false,
    A = 255,
    B = 0,
    secondshelper = 2
}
require "assets.states.start"
require "assets.states.level0"

function transitions:selector(level, transitiontype, dt)
    -- Random Color Level Transition
    if transitiontype == "randomColor" then
        self.A = self.A - (255/self.secondshelper*dt)
        self.B = self.B + (255/self.secondshelper*dt)
        love.graphics.setColor(math.random(self.A), math.random(self.A), math.random(self.A), self.A)
        love.graphics.setBackgroundColor(self.B, self.B, self.B, self.A)
    end

    if self.A < 0 then
        love.timer.sleep(1.7)

        transitions.shouldstart = false
        -- find level name
        world.level = string.match(level, "[^.]+$")
        -- switch to level

        if world.level == "start" then
            gamestate.switch(start)
        elseif world.level == "level0" then
            gamestate.switch(level0)
        end
    end
end

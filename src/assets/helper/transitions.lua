local transitions = {
    shouldstart = false,
    A = 255,
    B = 0,
    secondshelper = 2
}

function transitions:selector(state, transitiontype, Gamestate, dt)
    -- Random Color Level Transition
    if transitiontype == "randomColor" then
        self.A = self.A - (255/self.secondshelper*dt)
        self.B = self.B + (255/self.secondshelper*dt)
        print(math.random(self.A))
        love.graphics.setColor(math.random(self.A), math.random(self.A), math.random(self.A))
        love.graphics.setBackgroundColor(self.B, self.B, self.B, self.A)
    end

    if self.A < 0 then
        print('self A smaller than zeor')
        love.timer.sleep(1.7)

        transitions.shouldstart = false

        self.A = 255
        self.B = 0

        Gamestate.switch(state)
    end
end

return transitions

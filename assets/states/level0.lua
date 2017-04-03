level0 = {}
local state = level0

function state:init()
    -- only once
end

function state:enter()
    objLayer = nil
    -- How do I save the level?
    love.graphics.setBackgroundColor( 211, 211, 211 )
    map = loader.load("level0.tmx")
    objLayer = map("Objects")

    objLayer:toCustomLayer(converter)
    love.graphics.setBackgroundColor( 99, 99, 99 )

    ---[[
    function objLayer:draw()
        for k, obj in pairs(self.objects) do
            obj:draw()
        end
        love.graphics.setColor(255, 255, 255)
    end


    function objLayer:update(dt)
        for k, obj in pairs(self.objects) do
            obj:update(dt)
        end
    end
    --]]
end

function state:update(dt)
    if world.pause then
        return
    end
    if transitions.shouldstart then
        transitions:selector('assets.states.start', 'randomColor', dt)
    else
        objLayer:update(dt)
    end
end

function state:draw()

end

function state:leave()
    -- set colors back to normal
    transitions.A = 255
    transitions.B = 0
    love.graphics.setColor(255,255,255,255)
    love.graphics.setBackgroundColor(211, 211, 211, 255)
end

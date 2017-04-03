start = {}
local state = start

function state:init()
    -- only once
end

function state:enter()
    player.x = 32 * 11 - 16
    player.y = 32 * 15 - 16
    map = loader.load("start.tmx")
    objLayer = map("Objects")

    objLayer:toCustomLayer(converter)
    -- How do I save the level?
    love.graphics.setBackgroundColor( 99, 99, 99 )

    function objLayer:draw()
        for k, obj in pairs(self.objects) do
            obj:draw()
        end
    end

    function objLayer:update(dt)
        for k, obj in pairs(self.objects) do
            obj:update(dt)
        end
    end
end

function state:update(dt)
    if world.pause then return end
    if transitions.shouldstart then
        transitions:selector('assets.states.level0', 'randomColor', dt)
    else
        objLayer:update(dt)
    end
end

function state:draw()
    love.graphics.setColor(7, 0, 7)
    love.graphics.setFont(orial)
    love.graphics.printf( "One Point Left", 0, 128, love.window.getWidth() , 'center')
    love.graphics.setFont(ormont)
    love.graphics.setColor(255, 165, 7)
    love.graphics.printf( "activate all robots", 0, 167, love.window.getWidth() , 'center')
    love.graphics.setColor(7, 0, 7)
end


function state:leave()
    for i = 1, #objLayer.objects do
        table.remove(objLayer.objects, i)
    end
    -- set colors back to normal
    transitions.A = 255
    transitions.B = 0
    love.graphics.setColor(255,255,255,255)
    love.graphics.setBackgroundColor(211, 211, 211, 255)
end

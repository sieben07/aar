function converter(tiledObject)
-- Start Robot
    if tiledObject.type == "Start Robot" then
        block           = Solid(tiledObject.x, tiledObject.y, tiledObject.width, tiledObject.height )
        block.name      = tiledObject.name
        block.type      = tiledObject.type
        block.speed     = 256
        block.flySpeed  = 512

        function block:draw()
        if self.gravity then
            love.graphics.setColor(255, 165, 7)
            love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
        else
            love.graphics.setColor(7, 0, 7)
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
            love.graphics.setFont(ormontsmall)
            love.graphics.setColor(255, 165, 7)
            love.graphics.print(self.name, self.x, self.y - self.height/2)
        end
    end

    function block:isColliding(map, x, y)
        local layer = map.layers["Solid"]
        local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
        local tile = layer:get(tileX, tileY)
        return not(tile == nil)
    end

    function block:update(dt)
        if self.gravity == true then
            local halfX = self.width/2
            local halfY = self.height/2
            self.yVel = self.yVel + (world.gravity * dt)
            self.yVel = myMath.clamp(self.yVel, -self.flySpeed, self.flySpeed)
            local nextY = self.y + (self.yVel*dt)
            if self.yVel > 0 then
                if not (self:isColliding(map, self.x-halfX, nextY + halfY))
                    and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
                    self.y = nextY
                else
                    self.y = nextY - ((nextY + halfY) % map.tileHeight)
                    random:play()
                    transitions.shouldstart = true
                end
            end
        end
    end
-- Jump Robot
    elseif tiledObject.type == "Jump Robot" then
        block           = Solid(tiledObject.x, tiledObject.y, tiledObject.width, tiledObject.height )
        block.name      = tiledObject.name
        block.type      = tiledObject.type
        block.speed     = 256
        block.flySpeed  = 512

        function block:draw()
            if self.gravity then
                love.graphics.setColor( 7, 133, 255)
                love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
                love.graphics.setFont(ormontsmall)
            else
                love.graphics.setColor(255, 165, 7)
                love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
                love.graphics.setFont(ormontsmall)
                love.graphics.setColor(255, 255, 255)
                love.graphics.print(self.type, self.x  + 8, self.y - 32)
                --love.graphics.print(string.format("%.2f", self.yVel), self.x + 8, self.y - 16)
            end
        end

        function block:isColliding(map, x, y)
            local layer = map.layers["Solid"]
            local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
            local tile = layer:get(tileX, tileY)
            return not(tile == nil)
        end

        function block:update(dt)
            if self.gravity == true then
                local halfX = self.width/2
                local halfY = self.height/2
                self.yVel = self.yVel + (world.gravity * dt)
                self.yVel = myMath.clamp(self.yVel, -self.flySpeed, self.flySpeed)
                local nextY = self.y + (self.yVel*dt)

                if self.yVel < 0 then
                    if not (self:isColliding(map, self.x - halfX, nextY - halfY))
                        and not (self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
                        self.y = nextY
                    else
                        self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
                        self:collide("ceiling")
                    end
                end

                if self.yVel > 0 then
                    if not (self:isColliding(map, self.x-halfX, nextY + halfY))
                        and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
                        self.y = nextY
                    else
                        love.graphics.setBackgroundColor(math.random(230, 255) , math.random(130, 165), math.random(7, 110))
                        self.yVel = -2 * self.flySpeed
                        self.y = nextY - ((nextY + halfY) % map.tileHeight)
                    end
                end
            end
        end

    else
    end
    return block
end

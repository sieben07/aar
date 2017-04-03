local player = {
    x          = 64,
    y          = 64,
    width      = 32,
    height     = 32,
    xVel       = 0,
    yVel       = 0,
    jumpVel    = -512,
    speed      = 256,
    flySpeed   = 512,
    state      = "inAirRight",
    bulletDir  = "right",
    score      = 7,
    standing   = false,
    lastDir    = "right",
    weapon     = "normal",
    shooting   = false,
    bullets    = {},
    remBullets = {}
}

local animations = {
    left               = newAnimation(love.graphics.newImage("assets/img/player/left.png"), 32, 32, 0.2, 0),
    right              = newAnimation(love.graphics.newImage("assets/img/player/right.png"), 32, 32, 0.2, 0),
    standLeft          = newAnimation(love.graphics.newImage("assets/img/player/standLeft.png"), 32, 32, 0.4, 0),
    standRight         = newAnimation(love.graphics.newImage("assets/img/player/standRight.png"), 32, 32, 0.4, 0),
    movingInAirLeft    = newAnimation(love.graphics.newImage("assets/img/player/movingInAirLeft.png"), 32, 32, 0.2, 0),
    movingInAirRight   = newAnimation(love.graphics.newImage("assets/img/player/movingInAirRight.png"), 32, 32, 0.2, 0),
    inAirLeft          = newAnimation(love.graphics.newImage("assets/img/player/inAirLeft.png"), 32, 32, 0.2, 0),
    inAirRight         = newAnimation(love.graphics.newImage("assets/img/player/inAirRight.png"), 32, 32, 0.2, 0),
    shootingRight      = newAnimation(love.graphics.newImage("assets/img/player/shootingRight.png"), 32, 32, 0.2, 0),
    shootingLeft       = newAnimation(love.graphics.newImage("assets/img/player/shootingLeft.png"), 32, 32, 0.2, 0),
    standShootingLeft  = newAnimation(love.graphics.newImage("assets/img/player/standShootingLeft.png"), 32, 32, 0.2, 0),
    standShootingRight = newAnimation(love.graphics.newImage("assets/img/player/standShootingRight.png"), 32, 32, 0.2, 0),
    inAirShootingLeft  = newAnimation(love.graphics.newImage("assets/img/player/inAirShootingLeft.png"), 32, 32, 0.2, 0),
    inAirShootingRight = newAnimation(love.graphics.newImage("assets/img/player/inAirShootingRight.png"), 32, 32, 0.2, 0)
}

local bulletImage = {
    left = newAnimation(love.graphics.newImage("assets/img/player/heartLeft.png"), 14, 14, 0.2, 0),
    right = newAnimation(love.graphics.newImage("assets/img/player/heartRight.png"), 14, 14, 0.2, 0),
}

function player:collide(event)
    if event == "floor" then
        self.yVel = 0
        self.standing = true
    end
    if event == "ceiling" then
        self.yVel = 0
    end
end

function player:update(dt)
    local halfX = self.width/2
    local halfY = self.height/2

    self.yVel = self.yVel + (world.gravity * dt)

    self.xVel = myMath.clamp(self.xVel, -self.speed, self.speed)
    self.yVel = myMath.clamp(self.yVel, -self.flySpeed, self.flySpeed)

    local nextY = self.y + (self.yVel*dt)

    if self.yVel < 0 then
        if not (self:isColliding(map, self.x - halfX, nextY - halfY))
            and not (self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
            self.y = nextY
            self.standing = false
        else
            self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
            self:collide("ceiling")
        end
    end

    if self.yVel > 0 then
        if not (self:isColliding(map, self.x-halfX, nextY + halfY))
            and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
                self.y = nextY
                self.standing = false
        else
            self.y = nextY - ((nextY + halfY) % map.tileHeight)
            self:collide("floor")
        end
    end

    local nextX = self.x + (self.xVel * dt)

    if self.xVel > 0 then
        if not(self:isColliding(map, nextX + halfX, self.y - halfY))
            and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1)) then
            self.x = nextX
        else
            self.x = nextX - ((nextX + halfX) % map.tileWidth)
        end
    elseif self.xVel < 0 then
        if not(self:isColliding(map, nextX - halfX, self.y - halfY))
            and not(self:isColliding(map, nextX - halfX, self.y + halfY - 1)) then
            self.x = nextX
        else
            self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
        end
    end
    self.state, self.bulletDir, self.lastDir = self:getState()
    animations[self.state]:update(dt)

    -- update the bullets
    local remBullets = {}
    local remObj = {}

    for i, bullet in ipairs(self.bullets) do
        if self.weapon == "normal" then
            if bullet.dir == "right" then
                bullet.x = bullet.x + self.speed * 2 * dt
                --bullet.y = bullet.y + 1.5 * math.sin(math.rad(bullet.x))
            elseif bullet.dir == "left" then
                bullet.x = bullet.x - self.speed * 2 * dt
            end
        end

        for i = 1, #objLayer.objects do
            --if objLayer.objects[i].name == "Start" then
                if checkCollision(bullet.x - bullet.width/2, bullet.y - bullet.height/2, bullet.width, bullet.height, objLayer.objects[i].x - objLayer.objects[i].width/2, objLayer.objects[i].y - objLayer.objects[i].height/2, objLayer.objects[i].width, objLayer.objects[i].height ) then
                    if not objLayer.objects[i].gravity then
                        objLayer.objects[i].gravity = true
                        self.score = player.score + 4
                        coin:play()
                        table.insert(remBullets, i)
                    end
                    --table.insert(remObj, i)
              --  end
            end
        end

        -- mark bullets for removement
        ---[[
        if self:isColliding(map, bullet.x, bullet.y) then
            table.insert(remBullets, i)
        end
        --]]
    end
    ---[[ Remove Bullets
    for _, b in ipairs(remBullets) do
        table.remove(self.bullets, b)
    end
    --]]
    ---[[ Remove Obj
    for _, o in ipairs(remObj) do
        table.remove(objLayer.objects, o)
    end
    --]]

end

function player:jump()
    if self.standing then
        self.yVel = self.jumpVel
        self.standing = false
    end
end

function player:right()
    self.xVel = self.speed
end

function player:left()
    self.xVel = -1 * self.speed
end

function player:stop()
    self.xVel = 0
end

function player:freeze()
    self.xVel = 0
    self.yVel = 0

end

function player:getState()
    local tempState = self.state
    local tempBulletDir = self.bulletDir
    local tempDir = self.lastDir
    if self.standing then
        if self.xVel > 0 and self.shooting == false then
            tempState = "right"
            tempBulletDir = "right"
            tempDir = "right"
        elseif self.xVel > 0 and self.shooting == true then
            tempState = "shootingRight"
            tempBulletDir = "right"
            tempDir = "right"
        elseif self.xVel < 0 and self.shooting == false then
            tempState = "left"
            tempBulletDir = "left"
            tempDir = "left"
        elseif self.xVel < 0 and self.shooting == true then
            tempState = "shootingLeft"
            tempBulletDir = "left"
            tempDir = "left"
        elseif self.xVel == 0 and tempDir == "left" and self.shooting == false then
            tempState = "standLeft"
        elseif self.xVel == 0 and tempDir == "left" and self.shooting == true then
            tempState = "standShootingLeft"
        elseif self.xVel == 0 and tempDir == "right" and not self.shooting then
            tempState = "standRight"
        elseif self.xVel == 0 and tempDir == "right" and self.shooting then
            tempState = "standShootingRight"
        end
    elseif not self.standing and not self.shooting then
        if self.xVel > 0 then
            tempState = "movingInAirRight"
            tempBulletDir = "right"
            tempDir = "right"
        elseif self.xVel > 0 then
            tempState = "movingInAirRight"
            tempBulletDir = "right"
            tempDir = "right"
        elseif self.xVel < 0 then
            tempState = "movingInAirLeft"
            tempBulletDir = "left"
            tempDir = "left"
        elseif self.xVel == 0 and tempDir == "right" then
            tempState = "inAirRight"
        elseif self.xVel == 0 and tempDir == "left" then
            tempState = "inAirLeft"

        end
    elseif not self.standing and self.shooting then
        if tempDir == "left" then
            tempState = "inAirShootingLeft"
        elseif tempDir == "right" then
            tempState = "inAirShootingRight"
        end
    end
    return tempState, tempBulletDir, tempDir
end

function player:isColliding(map, x, y)
    local layer = map.layers["Solid"]
    local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
    local tile = layer:get(tileX, tileY)
    return not(tile == nil)
end

function player:draw()
    if transitions.shouldstart then
        love.graphics.setColor(transitions.B,transitions.B,transitions.B,transitions.B)
        animations[self.state]:draw(self.x - self.width/2, self.y - self.height/2)
        love.graphics.setColor(transitions.A, transitions.A, transitions.A, transitions.A)
    else
        animations[self.state]:draw(self.x - self.width/2, self.y - self.height/2)
    end
end

function player:drawBullets()
    for _, bullet in ipairs(self.bullets) do
        bulletImage[bullet.dir]:draw(bullet.x - bulletImage[bullet.dir]:getWidth()/2, bullet.y - bulletImage[bullet.dir]:getHeight()/2)
    end
end

-- maybe this belongs in player update?
function player:shoot()
    if #self.bullets >= 25 then return end
    self.score = self.score -1
    local bullet = {}
        bullet.x = self.bulletDir =="right" and self.x + self.width/2 or self.x - self.width/2
        bullet.y = self.y + self.height/8
        bullet.width = 16
        bullet.height = 16
        bullet.dir = self.bulletDir
    table.insert(self.bullets, bullet)
end

return player

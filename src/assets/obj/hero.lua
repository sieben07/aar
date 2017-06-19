local WNH = 32 -- WIDTH 'n' HEIGHT of Sprites
local BIG_WNH  = 256 -- WIDTH 'n' HEIGHT of the Sprite-sheet
local Quad = love.graphics.newQuad

local hero = {

    falling = nil,
    name = nil,
    title = nil,
    
    x = 0,
    y = 0,
    WIDTH = 32,
    HEIGHT = 32,
    x_vel = 0,
    y_vel = 0,
    vel = 4,
    GRAVITY = 40,
    jump = 0,
    shooting = false,
    shoots = {}, -- holds our fired shoots
    score = 7,
    timer = 0, -- Zeit Variable fuer Animation
    
    -- Animation
    iterator = 1,
    max = 5,
    direction = "right",
    status = "shootRight",
    rotate = 0,
    zoom = 1,
    image = love.graphics.newImage "assets/img/minimega.png",

    -- the frames of the hero
    quads =
    {   right = {
            Quad( WNH * 4,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 5,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 6,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 7,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 6,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );

        };

        rightShooting = {
            Quad( WNH * 4,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 5,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 6,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 7,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 6,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );

        };

        left = {
            Quad( WNH * 3,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 2,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 1,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 0,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 1,  WNH , WNH , WNH , BIG_WNH , BIG_WNH );
        };

        leftShooting = {
            Quad( WNH * 3,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 2,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 1,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 0,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
            Quad( WNH * 1,  WNH * 3, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        jumpRight = {
            Quad( WNH * 4,  WNH * 2, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        jumpLeft = {
            Quad( WNH * 3,  WNH * 2, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        jumpRightMoving = {
            Quad( WNH * 5,  WNH * 2, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        jumpLeftMoving = {
            Quad( WNH * 2,  WNH * 2, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        jumpRightShooting = {
            Quad( WNH * 6,  WNH * 2, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        jumpLeftShooting = {
            Quad( WNH ,  WNH * 2, WNH , WNH , BIG_WNH , BIG_WNH );
        };

        bulletLeft = {
            Quad( WNH  * 2, WNH  * 5, 14, 14, BIG_WNH , BIG_WNH )
        };

        bulletRight = {
            Quad( WNH  * 5, WNH  * 5, 14, 14, BIG_WNH , BIG_WNH )
        };

    }

}

function hero:shoot()
    self.score = self.score - 1
    local shoot = {}
    if self.status == "shootRight" then
        shoot.x = self.x + self.WIDTH
        shoot.y = self.y + 12
        shoot.WIDTH = 14
        shoot.HEIGHT = 14
        shoot.x_vel = 8
        shoot.type = "bullet"
        shoot.dir = "bulletRight"
        world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
    end
    if self.status == "shootLeft" then
        shoot.x = self.x - 14
        shoot.y = self.y + 12
        shoot.WIDTH = 14
        shoot.HEIGHT = 14
        shoot.x_vel = -8
        shoot.type ="bullet"
        shoot.dir = "bulletLeft"
        world:add(shoot, shoot.x, shoot.y, shoot.WIDTH, shoot.HEIGHT)
    end
end

function hero:updateShoots()
    local shoots, _ = world:getItems() 

    for i, shoot in pairs(shoots) do
        if shoot.type == 'bullet' then
            -- move them
            local goalX = shoot.x + shoot.x_vel
            local actualX, actualY, cols, len = world:move(shoot, goalX, shoot.y)
            shoot.x = actualX

            for i=1, len do
                local col = cols[i]
                
                if col.other.name == "Start" then
                    col.other.falling = true
                end
                if col.other.name == "Jump" then
                    col.other.jump = true
                    col.other.vel = -128
                end

            end
            
            if len ~= 0 then
                world:remove(shoot)
            end

        end

    end

end


function hero:update(dt)
    self:updateShoots()
    -- Animation Framerate
    if self.x_vel ~= 0 and self.y_vel == 0  then
        self.timer = self.timer + dt
        if self.timer > 0.04 then
            self.timer = 0
            self.iterator = self.iterator + 1
            if self.iterator > self.max then
                self.iterator = 2
            end
        end
    end

    if self.x_vel == 0 then
        self.iterator = 1
    end

    if self.y_vel ~= 0 then
        self.iterator = 1
    end

    -- Animation Direciton
    if self.x_vel < 0 then
        if self.y_vel == 0 then
            self.direction ="left"
            elseif self.y_vel ~= 0 then
                self.direction ="jumpLeftMoving"
        end
    end

    if self.x_vel > 0 then
        if self.y_vel == 0 then
            self.direction ="right"
            elseif self.y_vel ~= 0 then
                self.direction ="jumpRightMoving"
        end
    end

   if self.direction == "left" or self.direction == "leftShooting" or self.direction == "jumpLeft" or self.direction =="jumpLeftShooting" or self.direction =="jumpLeftMoving" then
      if not self.shooting and self.y_vel == 0 and self.x_vel == 0 then
         self.direction = "left"
         elseif self.shooting and self.y_vel == 0 and self.x_vel == 0 then
            self.direction = "leftShooting"
            elseif self.shooting and self.y_vel == 0 and self.x_vel < 0 then
               self.direction = "leftShooting"
               elseif not self.shooting and self.y_vel ~= 0 and self.x_vel < 0 then
                  self.direction = "jumpLeftMoving"
                  elseif not self.shooting and self.y_vel ~= 0 and self.x_vel == 0 then
                     self.direction ="jumpLeft"
                     elseif (self.shooting and self.y_vel ~= 0 and self.x_vel) or (self.shootinging and self.y_vel ~= 0 and self.x_vel < 0) then
                        self.direction ="jumpLeftShooting"

      end
   end

   if self.direction == "right" or self.direction == "rightShooting" or self.direction == "jumpRight" or self.direction =="jumpRightShooting" or self.direction =="jumpRightMoving" then
      if not self.shooting and self.y_vel == 0 and self.x_vel == 0 then
         self.direction = "right"
         elseif self.shooting and self.y_vel == 0 and self.x_vel == 0 then
            self.direction = "rightShooting"
            elseif self.shooting and self.y_vel == 0 and self.x_vel > 0 then
               self.direction = "rightShooting"
               elseif not self.shooting and self.y_vel ~= 0 and self.x_vel > 0 then
                  self.direction = "jumpRightMoving"
                  elseif not self.shooting and self.y_vel ~= 0 and self.x_vel == 0 then
                     self.direction ="jumpRight"
                     elseif (self.shooting and self.y_vel ~= 0 and self.x_vel) or (self.shootinging and self.y_vel ~= 0 and self.x_vel > 0) then
                        self.direction ="jumpRightShooting"

      end
   end
   -- Move the Hero Right or Left
    local goalX = self.x + self.x_vel
    local actualX, actualY, cols, len = world:move(self, goalX, self.y)
    self.x = math.floor(actualX)

    if self.jump > 0 then
        self.jump = self.jump - self.GRAVITY / 3 * dt
        self.y_vel = self.jump
        
        goalY = self.y - self.y_vel
        local actualX, actualY, cols, len = world:move(self, self.x, goalY)
        self.y = math.floor(actualY)
        
        for i=1,len do
            local col = cols[i]
                if(col.normal.y == 1) and self.jump > 1 then
                    self.jump = 1
                end
        end
    end

    if self.jump <= 0 then
        self.y_vel = self.y_vel + self.GRAVITY / 3 * dt
        
        local goalY = self.y + self.y_vel
        local actualX, actualY, cols, len = world:move(self, self.x, goalY)
        self.y = math.floor(actualY)
        
        for i=1,len do
            local col = cols[i]
            if(col.normal.y == -1) then
                self.y_vel = 0
            end
        end
    end
end

return hero

local hub = 32 -- Höhe und Breite eines Sprites
local big_hub = 256 -- Höhe und Breite des Spritesheets

message = ""
local Quad = love.graphics.newQuad

local hero = {
    action = {
        ["top"]     = function() message = "wup wup" end,
        ["right"]   = function() self.x = self.x - self.x_vel end,
        ["bottom"]  = function() message = "down down" end,
        ["left"]    = function() self.x = self.x - self.x_vel end,
        ["invalid"] = function() message = "invalid" end
    },
    falling = nil,
    name = nil,
    sprite = nil,
    title = nil,
    jumpVelocity = 128,

    x = 0,
    y = 0,
    width = 32,
    height = 32,
    x_vel = 0,
    y_vel = 0,
    vel = 4,
    gravity = 4,
    jump = 0,
    shooting = false,
    shoots = {}, -- holds our fired shoots
    score = 7,
    timer = 0, -- Zeit Variable fuer Animation
    
    -- Animation
    iterator = 1,
    max = 5,
    direction = "left",
    status = "shootLeft",
    rotate = 0,
    zoom = 1,
    image = love.graphics.newImage "assets/img/minimega.png",

    -- the frames of the hero
    quads =
    {

        right = {
            Quad( hub*4,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*5,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*6,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*7,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*6,  hub, hub, hub, big_hub, big_hub);

        };

        rightShooting = {
            Quad( hub*4,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*5,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*6,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*7,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*6,  hub*3, hub, hub, big_hub, big_hub);

        };


        left = {
            Quad( hub*3,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*2,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*1,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*0,  hub, hub, hub, big_hub, big_hub);
            Quad( hub*1,  hub, hub, hub, big_hub, big_hub);
        };

        leftShooting = {
            Quad( hub*3,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*2,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*1,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*0,  hub*3, hub, hub, big_hub, big_hub);
            Quad( hub*1,  hub*3, hub, hub, big_hub, big_hub);
        };



        jumpRight = {
            Quad( hub*4,  hub*2, hub, hub, big_hub, big_hub);
        };

        jumpLeft = {
            Quad( hub*3,  hub*2, hub, hub, big_hub, big_hub);
        };

        jumpRightMoving = {
            Quad( hub*5,  hub*2, hub, hub, big_hub, big_hub);
        };

        jumpLeftMoving = {
            Quad( hub*2,  hub*2, hub, hub, big_hub, big_hub);
        };

        jumpRightShooting = {
            Quad( hub*6,  hub*2, hub, hub, big_hub, big_hub);
        };

        jumpLeftShooting = {
            Quad( hub,  hub*2, hub, hub, big_hub, big_hub);
        };

    }

}

function hero:shoot()
    self.score = self.score - 1
    local shoot = {}
    if self.status == "shootRight" then
        shoot.x = self.x + self.width
        shoot.y = self.y + 16
        shoot.dir = 8
        table.insert(self.shoots, shoot)
    end
    if self.status == "shootLeft" then
        shoot.x = self.x
        shoot.y = self.y + 16
        shoot.dir = -8
        table.insert(self.shoots, shoot)
    end
end

function hero:update(dt)
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

   function love.keypressed(key)
    if key == "left" then
        self.x_vel = -self.vel
        self.status = "shootLeft"
    end

    if key == "right" then
        self.x_vel = self.vel
        self.status = "shootRight"
    end

    if (key == "up" or key =="a") and self.y_vel == 0 then
        self.jump = 24
        self.iterator = 1
    end

    if key == "space" or key == "s" then
        self:shoot()
        self.shooting = true
    end

    if key == "escape" then
        love.event.push("quit")   -- actually causes the app to quit
    end
end

function love.keyreleased(key)
    if key == "left" then
        self.x_vel = 0
    end

    if key == "right" then
        self.x_vel = 0
    end

    if key == "s" or key == "space" then
        self.shooting = false
    end
end

-- Move the Hero Right or Left
    goalX = self.x + self.x_vel
    local actualX, actualY, cols, len = world:move(self, goalX, self.y)
    self.x = actualX

    if self.y_vel > self.gravity then
        self.y_vel = self.y_vel - self.gravity
    end

    if self.jump ~= 0 then
        self.jump = self.jump - (self.gravity / 2)
        self.y_vel = self.jump
        
        goalY = self.y - self.y_vel
        local actualX, actualY, cols, len = world:move(self, self.x, goalY)
        self.y = actualY
        
        for i=1,len do
            local col = cols[i]
                if(col.normal.y == 1) then
                    self.jump = 0
                end
        end
    end

    if self.jump == 0 then
        self.y_vel = self.gravity
        
        goalY = self.y + self.y_vel
        local actualX, actualY, cols, len = world:move(self, self.x, goalY)
        self.y = actualY
        
        for i=1,len do
            local col = cols[i]
            if(col.normal.y == -1) then
                self.y_vel = 0
            end
        end
    end
end

return hero

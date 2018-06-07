function love.conf(t)
    t.title             = "One Point Left"  -- The title of the window the game is in (string)
    t.author            = "Orhan.K"         -- The author of the game (string)
    t.identity          = "opl"             -- The name of the save directory (string)
    t.version           = "11.1"          -- The LÖVE version this game was made for (string)
    t.release           = false             -- Enable release mode (boolean)
    t.appendidentity = true

    t.window.icon = "assets/img/mini.png"
    t.window.width      = 32*32             -- The window width (number)
    t.window.height     = 32*20             -- The window height (number)
    t.window.fullscreen = false             -- Enable fullscreen (boolean)
    t.window.vsync      = true              -- Enable vertical sync (boolean)
    t.window.fsaa       = 0                 -- The number of FSAA-buffers (number)

    t.modules.joystick  = false             -- Enable the joystick module (boolean)
    t.modules.audio     = true              -- Enable the audio module (boolean)
    t.modules.keyboard  = true              -- Enable the keyboard module (boolean)
    t.modules.event     = true              -- Enable the event module (boolean)
    t.modules.image     = true              -- Enable the image module (boolean)
    t.modules.graphics  = true              -- Enable the graphics module (boolean)
    t.modules.timer     = true              -- Enable the timer module (boolean)
    t.modules.mouse     = false             -- Enable the mouse module (boolean)
    t.modules.sound     = true              -- Enable the sound module (boolean)
    t.modules.physics   = false             -- Enable the physics module (boolean)
end

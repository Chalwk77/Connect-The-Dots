function love.conf(t)
    t.title = "Connect The Dots"-- The title of the window the game is in (string)
    t.author = "jericho.crosby227@gmail.com" -- The author of the game (string)
    t.identity = "Connect The Dots" -- The name of the save directory (string)
    t.version = "11.2" -- The LÖVE version this game was made for (number)
    t.console = true -- Attach a console (boolean, Windows only)
    t.window.msaa = 1 -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.fsaa = 1 -- The number of samples to use with multi-sampled antialiasing (number)
    t.modules.audio = true -- Enable the audio module (boolean)
    t.modules.keyboard = true -- Enable the keyboard module (boolean)
    t.modules.event = true -- Enable the event module (boolean)
    t.modules.image = true -- Enable the image module (boolean)
    t.modules.graphics = true -- Enable the graphics module (boolean)
    t.modules.mouse = true -- Enable the mouse module (boolean)
    t.modules.sound = true -- Enable the sound module (boolean)
end

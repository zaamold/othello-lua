-- Full list of conf variables here: https://www.love2d.org/wiki/Config_Files
function love.conf(t)
    --t.window.width = 1024
    --t.window.height = 768
    -- disabling uneeded modules
    t.modules.joystick = false
    t.modules.physics = false
    t.window.title = "Othello"
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
end
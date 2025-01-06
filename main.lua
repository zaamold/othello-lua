--game = Game()

-- Called on script load
function love.load()
    -- importing classic library for class connections
    Object = require "classic"
    -- setting background color of game canvas
    love.graphics.setBackgroundColor(239, 241, 240)
    
    require "game"
    
    game = Game()
end

-- Updates game state every frame
function love.update(dt) -- Delta time - fps can vary between systems, affecting game speed
    game:update(dt)
end

-- Draws screen every frame
function love.draw()
    game:draw()
    
    local score = game:getScore()
    love.graphics.print("White Score: "..score.white, 0, 25)
    love.graphics.print("Black Score: "..score.black, 200, 25)
end
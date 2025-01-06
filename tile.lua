-- pass Object as first argument
Tile = Object.extend(Object)

-- constructor
function Tile:new(row, column, team)
    tick = require "tick"
    print("NEW TILE INCOMING: [" .. row .. ", " .. column .. "]")
    print("TEAM: " .. team)
    self.row = row
    self.column = column
    self.team = team
    self.spaceWidth = 50
    self.radius = 18
    self.baseX = 150
    self.baseY = 50
    self.flipDelay = 0
    self.flipSpeed = 20
end

function Tile:update(dt)
    tick.update(dt)
    
    if self.flipDelay > 0 then
      self.flipDelay = self.flipDelay - self.flipSpeed * dt
    end
end

function Tile:draw()
    if self.team == "none" then
      return
    end
    
    local teamCheck = self.team
    
    if self.flipDelay > 0 then
      if teamCheck == "black" then
        teamCheck = "white"
      else
        teamCheck = "black"
      end
    end
    
    -- tile color is determined by team
    if teamCheck == "white" then
        -- setting color to white
        love.graphics.setColor(1, 1, 1)
    else
      -- setting color to black
      love.graphics.setColor(0, 0, 0)
    end
    -- drawing box
    love.graphics.circle("fill",
      self.baseX + self.spaceWidth / 2 + self.spaceWidth * self.row, 
      self.baseY + self.spaceWidth / 2 + self.spaceWidth * self.column,
      self.radius
    )
    if teamCheck == "white" then
      -- setting color to black
      love.graphics.setColor(0, 0, 0, 0.8)
    else
      -- setting color to white
      love.graphics.setColor(1, 1, 1, 0.8)
    end
    -- drawing outline
    love.graphics.circle("line",
      self.baseX + self.spaceWidth / 2 + self.spaceWidth * self.row,
      self.baseY + self.spaceWidth / 2 + self.spaceWidth * self.column,
      self.radius
    )
end--change

function Tile:setTeam(team)
    self.team = team
end


function Tile:flip(timeDelay)
  if self.team == "black" then
    self.team = "white"
  elseif self.team == "white" then
    self.team = "black"
  end
  self.flipDelay = timeDelay
end


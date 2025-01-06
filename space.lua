-- pass Object as first argument
Space = Object.extend(Object)

-- constructor
function Space:new(row, column)
    tick = require "tick"
    print("NEW SPACE INCOMING: [" .. row .. ", " .. column .. "]")
    self.row = row
    self.column = column
    self.baseX = 150
    self.baseY = 50
    self.width = 50
    self.height = 50
    self.isClicked = false
    self.isHovered = false
    self.isValid = false
end

function Space:update(dt)
    tick.update(dt)
    
    if self.isClicked == true then
      tick.delay(function() self.isClicked = false end, 20)
    --elseif self.isHovered == true then
      --tick.delay(function() self.isHovered = false end, 10)
    end
    
    self.isHovered = false
    
end

function Space:draw()
    -- setting color to green
    love.graphics.setColor(108/255, 163/255, 101/255)
    if self.isClicked == true then
      -- light green on click (+30)
      love.graphics.setColor(138/255, 193/255, 131/255)
    elseif self.isHovered == true then
      -- dark green on hover (-10)
      love.graphics.setColor(98/255, 153/255, 91/255)
    end
    
    -- drawing box
    love.graphics.rectangle("fill",
      self.baseX + self.width * self.row, 
      self.baseY + self.height * self.column,
      self.width,
      self.height
    )
    -- setting color to black
    love.graphics.setColor(0, 0, 0, 1)
    -- drawing outline
    love.graphics.rectangle("line",
      self.baseX + self.width * self.row,
      self.baseY + self.height * self.column,
      self.width,
      self.height
    )
    
    if self.isValid then
      love.graphics.circle("line",
        self.baseX + self.width / 2 + self.width * self.row, 
        self.baseY + self.height / 2 + self.height * self.column,
        5
      )
    end
end

function Space:checkForCursor(mouseX, mouseY)
    
    if mouseX > self.baseX + self.width * self.row and mouseX < self.baseX + self.width * (self.row + 1) then
      if mouseY > self.baseY + self.height * self.column and mouseY < self.baseY + self.height * (self.column + 1) then
        return true
      end
    end
    
    return false
end


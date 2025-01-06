-- pass Object as first argument
Game = Object.extend(Object)

local function getEnemyTeam(self)
  if self.currentPlayer == "black" then
    return self.team.white
  else
    return self.team.black
  end
end

function Game:getScore()
  local whiteTiles = 0
  local blackTiles = 0
  for i=1,#self.tiles do
    for k=1,#self.tiles[i] do
      if self.tiles[i][k].team == "white" then
        whiteTiles = whiteTiles + 1
      elseif self.tiles[i][k].team == "black" then
        blackTiles = blackTiles + 1
      end
    end
  end
  local score = {}
  score["white"] = whiteTiles
  score["black"] = blackTiles
  return score
end

local function getDistanceBetweenTwoSpaces(row1, column1, row2, column2)
  return math.sqrt((row2 - row1) ^ 2 + (column2 - column1) ^ 2)
end

local function checkIsSpaceOccupied(self, row, column)
    local tile = self.tiles[row][column]
    if tile.team == "none" then
      return false
    end
    return true
end

local function findValidSpaces(self, row, column)
  -- only checking starting from current player's pieces
  if self.tiles[row][column].team ~= self.currentPlayer then
    return false
  end
  
  local directions = {{0,1},{1,1},{1,0},{1,-1},{0,-1},{-1,-1},{-1,0},{-1,1}}
  local moves = {}
  
  
  for j, direction in ipairs(directions) do
    local directionValid = true
    local isLineStarted = false
    local xDir = direction[1]
    local yDir = direction[2]
    local flips = {}
    
    while directionValid do
      
      if row + xDir < 1 or row + xDir > 8 or column + yDir < 1 or column + yDir > 8 then
        directionValid = false
        break
      end
      
      -- continue moving in the given direction as long as an enemy line has formed
      if self.tiles[row + xDir][column + yDir].team == getEnemyTeam(self) then
        isLineStarted = true
        -- insert enemy tiles into list of potentially flipped values
        table.insert(flips, {row + xDir, column + yDir})
      elseif isLineStarted and self.tiles[row + xDir][column + yDir].team == self.team.none then
        -- valid path found!
        self.spaces[row+xDir][column+yDir].isValid = true
        -- add flips to move: either an existing one at this space, or a new move
        local move = Move(row + xDir, column + yDir, flips)
        table.insert(self.moves, move)
        break
      else 
        -- if enemy line breaks or doesn't occur, this direction is not valid
        directionValid = false
        break
      end
      -- iterate direction values
      xDir = xDir + direction[1]
      yDir = yDir + direction[2]
    end
  end
end

local function resetValidMoves(self)
  for i=1,8 do
    for k=1,8 do
      self.spaces[i][k].isValid = false
    end
  end
  self.moves = {}
end

local function checkValidMoves(self)
  resetValidMoves(self)
  for i=1,8 do
    for k=1,8 do
      findValidSpaces(self, i,k)
    end
  end
  -- returning true if any moves are available
  return table.getn(self.moves) ~= 0
end

local function executeMoves(self, row, column)
  for i, move in ipairs(self.moves) do
    if move.row == row and move.column == column then
      for k, spaceToFlip in ipairs(move.flips) do
        -- determining time delay to flip based on distance to new piece
        local timeDelay = getDistanceBetweenTwoSpaces(row, column, spaceToFlip[1], spaceToFlip[2]) * 6
        self.tiles[spaceToFlip[1]][spaceToFlip[2]]:flip(timeDelay)
      end
    end
  end
end


-- constructor
function Game:new(row, column)
    print("Game state initializing...")
    -- importing classes
    tick = require "tick"
    require "space"
    require "tile"
    require "move"
    -- initializing game objects
    self.spaces = {}
    self.tiles = {}
    self.team = {}
    self.team["black"] = "black"
    self.team["white"] = "white"
    self.team["none"] = "none"
    self.currentPlayer = self.team.black
    self.moves = {}
    self.disablePlay = false
    self.playDisableTime = 2
    
    -- generating game board (spaces) and tile objects
    for i = 1,8 do
      self.spaces[i] = {}
      self.tiles[i] = {}
      for k = 1,8 do
        self.spaces[i][k] = Space(i, k)
        self.tiles[i][k] = Tile(i, k, self.team.none)
      end
    end
    
    -- adding default tiles
    self.tiles[4][4]:setTeam(self.team.white)
    self.tiles[5][4]:setTeam(self.team.black)
    self.tiles[4][5]:setTeam(self.team.black)
    self.tiles[5][5]:setTeam(self.team.white)
    
    checkValidMoves(self)
end

local function toggleCurrentPlayer(self)
  if self.currentPlayer == self.team.black then
    self.currentPlayer = self.team.white
  else
    self.currentPlayer = self.team.black
  end
end

local function takeTurn(self, row, column)
  if self.spaces[row][column].isValid then
    self.tiles[row][column]:setTeam(self.currentPlayer)
    executeMoves(self, row, column)
    toggleCurrentPlayer(self)
    -- if player can't take turn, play reverts to other player
    if not checkValidMoves(self) then
      toggleCurrentPlayer(self)
      -- if neither player has any valid moves, the game is over
      if not checkValidMoves(self) then
        print ("GAME OVER")
      end
    end
  end
end

function Game:update(dt)
    tick.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    for i=1,#self.spaces do
      for k=1,#self.spaces[i] do
        local space = self.spaces[i][k]
        if space:checkForCursor(mouseX, mouseY) then
          if love.mouse.isDown(1) then
            space.isClicked = true
            -- place tile at space
            takeTurn(self, space.row, space.column)
          else
            space.isHovered = true
          end
        end
      end
    end
    -- Updating space grid
    for i=1,#self.spaces do
      for k=1,#self.spaces[i] do
        -- using a colon (:) automatically passes the object left of the colon as the first argument
        self.spaces[i][k]:update(dt)
        self.tiles[i][k]:update(dt)
      end
    end
    
    
end

function Game:draw()
    -- Drawing space grid
    for i=1,#self.spaces do
      for k=1,#self.spaces[i] do
        -- using a colon (:) automatically passes the object left of the colon as the first argument
        self.spaces[i][k]:draw()
      end
    end
    
    for i=1,#self.tiles do
      for k=1,#self.tiles[i] do
        self.tiles[i][k]:draw()
      end
    end
end
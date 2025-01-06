-- pass Object as first argument
Move = Object.extend(Object)

-- constructor
function Move:new(row, column, flips)
    self.row = row
    self.column = column
    self.flips = flips
end

function Move:addFlips(flips)
    for i, flip in ipairs(flips) do
      local alreadyAccountedFor = false
      for k, accountedFlip in ipairs(self.flips) do
        if accountFlip[1] == flip[1] and accountedFlip[2] == flip[2] then
          alreadyAccountedFor = true
          break
        end
      end
      if not alreadyAccountedFor then
        table.insert(self.flips, flip)
      end
    end
end


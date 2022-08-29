local function getIndex(i, j)

  if i < 1 or i > MAZE_WIDTH or j < 1 or j > MAZE_HEIGHT then
    return -1
  else
    return i + (j-1)*MAZE_HEIGHT
  end

end

local Cell = {

  x,
  y,
  index,
  visited,
  current,
  walls,

  new = function(self, i, j, index)
    local _cell = {}

    setmetatable(_cell, self)
    self.__index = self

    _cell.i = i
    _cell.j = j
    _cell.x = (i -1) * CELL_SIZE
    _cell.y = (j -1) * CELL_SIZE
    _cell.index = index
    _cell.visited = false
    _cell.walls = {
      left  = true,
      top   = true,
      right = true,
      bottom  = true
    }

    return _cell
  end,

  update = function(self, dt)
  end,

  draw = function(self)
    love.graphics.push()

    if self.current then
      love.graphics.setColor(0, 1, 0, 0.5)
    elseif self.visited then
      love.graphics.setColor(1, 0, 0, 0.3)
    else
      love.graphics.setColor(1, 1, 1, 0.3)
    end



    love.graphics.rectangle('fill', self.x, self.y, CELL_SIZE, CELL_SIZE)

    love.graphics.setColor(1, 1, 1, 1)
    if(self.walls.left)   then love.graphics.line(self.x, self.y, self.x, self.y + CELL_SIZE) end
    if(self.walls.top)    then love.graphics.line(self.x, self.y, self.x + CELL_SIZE, self.y) end
    if(self.walls.right)  then love.graphics.line(self.x + CELL_SIZE, self.y, self.x + CELL_SIZE, self.y + CELL_SIZE) end
    if(self.walls.bottom) then love.graphics.line(self.x, self.y + CELL_SIZE, self.x + CELL_SIZE, self.y + CELL_SIZE) end

    love.graphics.pop()
  end,

  setCurrent = function(self)
    self.current = true
    self.visited = true
    if current_cell then current_cell.current = false end
    return self
  end,

  removeWalls = function(self, next)
    local _current_i  = self.i
    local _current_j  = self.j
    local _next_i     = next.i
    local _next_j     = next.j

    if _current_i < _next_i and _current_j == _next_j then
      self.walls.right = false
      next.walls.left = false
    end

    if _current_i > _next_i and _current_j == _next_j then
      self.walls.left = false
      next.walls.right = false
    end

    if _current_i == _next_i and _current_j < _next_j then
      self.walls.bottom = false
      next.walls.top = false
    end

    if _current_i == _next_i and _current_j > _next_j then
      self.walls.top = false
      next.walls.bottom = false
    end


  end,

  getUnvisitedNeighboors = function(self)

    local neighboors = {}

    --local _index = i + (j-1)*MAZE_HEIGHT

    local _topIndex     = getIndex(self.i, self.j-1)
    local _bottomIndex  = getIndex(self.i, self.j+1)
    local _leftIndex    = getIndex(self.i-1, self.j)
    local _rightIndex   = getIndex(self.i+1, self.j)

    local _topCell = MAZE[_topIndex]
    local _bottomCell = MAZE[_bottomIndex]
    local _leftCell = MAZE[_leftIndex]
    local _rightCell = MAZE[_rightIndex]

    if _leftCell then
      if not _leftCell.visited then table.insert(neighboors, _leftCell) end
    end

    if _topCell then
      if not _topCell.visited then table.insert(neighboors, _topCell) end
    end

    if _rightCell then
      if not _rightCell.visited then table.insert(neighboors, _rightCell) end
    end

    if _bottomCell then
      if not _bottomCell.visited then table.insert(neighboors, _bottomCell) end
    end

    return neighboors

  end

}

return Cell

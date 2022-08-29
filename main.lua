require "librairies/tableUtils"

local Cell = require "cell"

function love.load()

  math.randomseed(os.time())

  CELL_SIZE = 20
  MAZE = {}
  STACK = {}

  MAZE_WIDTH = 30 -- En nombre de cellules
  MAZE_HEIGHT = 30 -- En nombre de cellules
  MAZE_SIZE = MAZE_WIDTH * MAZE_HEIGHT

  for j=1, MAZE_HEIGHT do
    for i=1, MAZE_WIDTH do
      local _index = i + (j-1)*MAZE_HEIGHT
      local _cell = Cell:new(i, j, _index)
      table.insert(MAZE, _cell)
    end
  end

  current_cell = MAZE[1]:setCurrent()
end

function love.update(dt)
  makeMaze()
end

function love.draw()

  love.graphics.push()

  love.graphics.translate(love.graphics.getWidth()/2 - (CELL_SIZE * MAZE_WIDTH /2), love.graphics.getHeight()/2 - (CELL_SIZE * MAZE_HEIGHT /2))

  for index, cell in ipairs(MAZE) do
    cell:draw()
  end

  love.graphics.pop()

end

function makeMaze()
  -- 1. Récupération des voisins "non visités"
  local neighboors = current_cell:getUnvisitedNeighboors()
  local nbOfUnvisitedNeighboors = table.length(neighboors)

  if nbOfUnvisitedNeighboors > 0 then

    -- 2. Si j'ai des voisins "non visités"

    -- 2.1. On choisit aléatoirement l'un des voisins
    local nextIndex = math.floor(math.random(1, nbOfUnvisitedNeighboors))
    local next = neighboors[nextIndex]

    -- 2.2. On ajoute la cellule actuelle au "stack"
    table.insert(STACK, current_cell)

    -- 2.3. On supprime le mur
    current_cell:removeWalls(next)

    -- 2.4. La cellule choisie devient la cellule actuelle
    current_cell = next:setCurrent()
  else
    -- 3. Si ne n'ai pas de voisins non visités
    local nbOfCellInStack = table.length(STACK)
    if nbOfCellInStack > 0 then
      -- 3.1. Si j'ai des éléments dans le "stack"
      local lastCellOfStack = STACK[nbOfCellInStack]
      current_cell = lastCellOfStack:setCurrent()
      table.remove(STACK, nbOfCellInStack)
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then

  end
end

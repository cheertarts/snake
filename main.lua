grid_size = 8
snake_increment_size = 8

Square = {}

function Square:new(x, y)
  obj = {}
  obj.x = x
  obj.y = y
  self.__index = self
  return setmetatable(obj, self)
end

function Square:draw()
  love.graphics.rectangle('fill', self.x, self.y, grid_size, grid_size)
end

function love.load()
  -- Setup snake table
  snake = {
    Square:new(
      math.floor(
        (love.graphics.getWidth() / 2 - grid_size / 2) / grid_size + 0.5)
      * grid_size,
      math.floor(
        (love.graphics.getHeight() / 2 - grid_size / 2) / grid_size + 0.5)
      * grid_size)
  }
  snake.xvel = 0
  snake.yvel = grid_size
  snake.squares_pending = snake_increment_size - 1

  -- Create apple
  apple = Square:new(grid_size * 5, grid_size * 8)

  -- Save score
  score = 0
end

function love.update(dt)
  -- Add new snake squares
  if snake.squares_pending > 0 then
    snake[#snake + 1] = Square:new()
    snake.squares_pending = snake.squares_pending - 1
  end

  -- Update snake movement
  for i = #snake, 2, -1 do
    snake[i].x = snake[i - 1].x
    snake[i].y = snake[i - 1].y
  end

  snake[1].x = snake[1].x + snake.xvel
  snake[1].y = snake[1].y + snake.yvel

  if snake[1].x < 0 then
    snake[1].x = love.graphics.getWidth() - grid_size
  elseif snake[1].x > love.graphics.getWidth() - grid_size then
    snake[1].x = 0
  end

  if snake[1].y < grid_size * 3 then
    snake[1].y = love.graphics.getHeight() - grid_size
  elseif snake[1].y > love.graphics.getHeight() - grid_size then
    snake[1].y = grid_size * 3
  end

  -- Apple logic
  if apple.x == snake[1].x and apple.y == snake[1].y then
    snake.squares_pending = snake_increment_size
    score = score + 1
    apple.x = math.random(0, (love.graphics.getWidth() - grid_size) / grid_size) * grid_size
    apple.y = math.random(grid_size * 3, (love.graphics.getHeight() - grid_size) / grid_size) * grid_size
  end

  -- Losing
  for i = 2, #snake do
    if snake[1].x == snake[i].x and snake[1].y == snake[i].y then
      love.load()
      break
    end
  end

  -- Lock framerate
  love.timer.sleep(1 / 60)
end

function love.keypressed(key)
  if key == 'w' or key == 'up' then
    snake.xvel = 0
    snake.yvel = -grid_size
  elseif key == 's' or key == 'down' then
    snake.xvel = 0
    snake.yvel = grid_size
  elseif key == 'a' or key == 'left' then
    snake.xvel = -grid_size
    snake.yvel = 0
  elseif key == 'd' or key == 'right' then
    snake.xvel = grid_size
    snake.yvel = 0
  end

  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  -- Draw scoreboard
  love.graphics.setColor(0, 255, 255)
  for i = 1, score do
    love.graphics.rectangle('fill', i * grid_size * 2 - grid_size, grid_size, grid_size, grid_size)
  end

  -- Draw apple
  love.graphics.setColor(255, 0, 255)
  apple:draw()

  -- Draw snake
  love.graphics.setColor(255, 255, 255)
  for i = 1, #snake do
    snake[i]:draw()
  end
end

player = {
    x = 0,
    y = 0,
    width = 32,
    height = 64,
    gravity = 700,
    dy = 0,
    runSpeed = 600
}

function player:setPosition(x, y)
    self.x, self.y = x, y
end

function player:update(dt)
    self:move(dt)
    self:applyGravity(dt)
end

function player:move(dt)
    local dx = 0
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        dx = dx - 1
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        dx = dx + 1
    end
    player.x = player.x + player.runSpeed * dx * dt
end

function player:applyGravity(dt)
    player.dy = player.dy + player.gravity * dt
    player.y = player.y + player.dy * dt
    player.y = player.y % love.graphics.getHeight()
end

function player:draw()
    love.graphics.setColor(0, 0.75, 0.75)
    love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', player.x, player.y, player.width, player.height)
    love.graphics.setColor(1, 1, 1)
end

function love.load()
    player:setPosition(love.graphics.getWidth() / 2 - player.width / 2, 20)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
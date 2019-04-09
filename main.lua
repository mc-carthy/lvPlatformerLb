player = {
    x = 0,
    y = 0,
    width = 32,
    height = 64,
    gravity = 700,
    dx = 0,
    dy = 0,
    terminalVelocity = 500,
    runSpeed = 600
}

function player:setPosition(x, y)
    self.x, self.y = x, y
end

function player:update(dt)
    self:move(dt)
    self:applyGravity(dt)
    player.x = player.x + player.dx * dt
    player.y = player.y + player.dy * dt
    player.y = player.y % love.graphics.getHeight()
end

function player:move(dt)
    player.dx = 0
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        player.dx = player.dx - player.runSpeed
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        player.dx = player.dx + player.runSpeed
    end
end

function player:applyGravity(dt)
    if math.abs(player.dy) < player.terminalVelocity then
        player.dy = player.dy + player.gravity * dt
    end
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
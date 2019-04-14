local Bump = require('src.lib.bump')
world = Bump.newWorld()

player = {
    x = 0,
    y = 0,
    width = 32,
    height = 64,
    gravity = 2000,
    dx = 0,
    dy = 0,
    terminalVelocity = 1000,
    runSpeed = 600,
    grounded = false,
    jumpSpeed = -800
}

local floor = {
    x = love.graphics.getWidth() / 2 - 150,
    y = love.graphics.getHeight() - 40,
    width = 300,
    height = 40,
}

function player:setPosition(x, y)
    self.x, self.y = x, y
end

function player:update(dt)
    self:move(dt)
    self:applyGravity(dt)
    self:collide(dt)
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

function player:collide(dt)
    local futureX, futureY = player.x + player.dx * dt, player.y + player.dy * dt
    local nextX, nextY, cols, len = world:move(player, futureX, futureY)

    player.grounded = false
    for i = 1, len do
        local col = cols[i]
        if math.abs(col.normal.y) == 1 then
            player.dy = 0
        end
        if col.normal.y == -1 then
            player.grounded = true
        end
    end

    player.x, player.y = nextX, nextY
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
    world:add(player, player.x, player.y, player.width, player.height)
    world:add(floor, floor.x, floor.y, floor.width, floor.height)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
    love.graphics.setColor(0.25, 0.25, 0.25)
    love.graphics.rectangle('fill', floor.x, floor.y, floor.width, floor.height)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        if player.grounded then
            player.dy = player.jumpSpeed
            player.grounded = false
        end
    end
end
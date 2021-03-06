local Bump = require('src.lib.bump')
local level1 = require('src.levels.1')

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

function loadTiledLevel(level)
    for k, v in pairs(level.layers[1].objects) do
        world:add(v, v.x, v.y, v.width, v.height)
    end
end

function drawTiledLevel(level)
    for k, v in pairs(level.layers[1].objects) do
        love.graphics.rectangle('fill', v.x, v.y, v.width, v.height)
    end
end

function player:setPosition(x, y)
    self.x, self.y = x, y
end

function player:update(dt)
    self:move(dt)
    self:applyGravity(dt)
    self:collide(dt)
end

function player:move(dt)
    player.dx = 0
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.dx = self.dx - self.runSpeed
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.dx = self.dx + self.runSpeed
    end
end

function player:applyGravity(dt)
    if math.abs(self.dy) < self.terminalVelocity then
        self.dy = self.dy + self.gravity * dt
    end
end

function player:jump()
    if self.grounded then
        self.dy = self.jumpSpeed
        self.grounded = false
    end
end

function player:collide(dt)
    local futureX, futureY = self.x + self.dx * dt, self.y + self.dy * dt
    local nextX, nextY, cols, len = world:move(self, futureX, futureY)

    self.grounded = false
    for i = 1, len do
        local col = cols[i]
        if math.abs(col.normal.y) == 1 then
            self.dy = 0
        end
        if col.normal.y == -1 then
            self.grounded = true
        end
    end

    self.x, self.y = nextX, nextY
end

function player:draw()
    love.graphics.setColor(0, 0.75, 0.75)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

function love.load()
    player:setPosition(love.graphics.getWidth() / 2 - player.width / 2, 20)
    world:add(player, player.x, player.y, player.width, player.height)
    loadTiledLevel(level1)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
    love.graphics.setColor(0.25, 0.25, 0.25)
    drawTiledLevel(level1)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        player:jump()
    end
end
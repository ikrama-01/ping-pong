ball = class {}

function ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return fasle
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return fasle
    end

    return true
end

function ball:reset()
    self.x = virtual_width / 2 - 2
    self.y = virtual_height / 2 - 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

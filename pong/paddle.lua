paddle = class {}

function paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)

    else
        self.y = math.min(virtual_height - self.height, self.y + self.dy * dt)
    end
end

function paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

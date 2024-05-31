push = require 'push'
class = require 'class'
require 'paddle'
require 'ball'

window_width = 1280
window_height = 720
virtual_width = 432
virtual_height = 243
paddle_speed = 200

function love.load()
    love.window.setTitle('PONG')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    smallfont = love.graphics.newFont('font.ttf', 8)
    scorefont = love.graphics.newFont('font.ttf', 32)
    largefont = love.graphics.newFont('font.ttf', 16)
    love.graphics.setFont(smallfont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
    }
    
    push:setupScreen(virtual_width, virtual_height, window_width, window_height, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1score = 0
    player2score = 0
    servingplayer = 1

    player1 = paddle(5, 30, 5, 20)
    player2 = paddle(virtual_width - 10, virtual_height - 30, 5, 20)

    ball = ball(virtual_width / 2 - 2, virtual_height / 2 - 2, 4, 4)

    gamestate = 'start'
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    if gamestate == 'serve' then
        ball.dy = math.random(-50,50)
        if servingplayer == 1 then 
            ball.dx = math.random(140,200)
        else
            ball.dx = -math.random(140,200)
        end

    elseif gamestate == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        if ball.y >= virtual_height - 4 then
            ball.y = virtual_height - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x <0 then
            servingplayer = 1
            player2score = player2score +1
            sounds['score']:play()

            if player2score == 10 then
                winningplayer = 2
                gamestate = 'done'
            else
                gamestate = 'serve'
                ball:reset()
            end 
        end
        if ball.x > virtual_width then
            servingplayer=2
            player1score = player1score +1
            sounds['score']:play()

            if player1score == 10 then
                winningplayer = 1
                gamestate = 'done'
            else
                gamestate = 'serve'
                ball:reset()
            end
        end
    end

    if love.keyboard.isDown('w') then
        player1.dy = -paddle_speed
    elseif love.keyboard.isDown('s') then
        player1.dy = paddle_speed
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -paddle_speed
    elseif love.keyboard.isDown('down') then
        player2.dy = paddle_speed
    else
        player2.dy = 0
    end

    if gamestate == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' then
            gamestate = 'serve'
        elseif gamestate == 'serve' then
            gamestate = 'play'
        elseif gamestate == 'done' then
            gamestate = 'serve'
            ball:reset()
            player1score = 0
            player2score = 0

            if winningplayer == 1 then
                servingplayer = 2
            else
                servingplayer = 1
            end
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallfont)
    love.graphics.printf('player 2',-10, 20 ,virtual_width,'right')
    love.graphics.printf('player 1',10, 20 ,virtual_width,'left')

    displayscore()

    if gamestate == 'start' then
        love.graphics.setFont(smallfont)
        love.graphics.printf('Welcome to Pong!', 0, 10, virtual_width, 'center')
        love.graphics.printf('start state!', 0, 20, virtual_width, 'center')
    elseif gamestate == 'serve' then
        love.graphics.setFont(smallfont)
        love.graphics.printf('player: '..tostring(servingplayer).."'s serve",0,10,virtual_width,'center')
        love.graphics.printf('press Enter to serve', 0, 20, virtual_width, 'center')
    elseif gamestate == 'play' then
        love.graphics.setFont(smallfont)
         love.graphics.printf('play state!', 0, 20, virtual_width, 'center')
    elseif gamestate == 'done' then
        love.graphics.setFont(largefont)
        love.graphics.printf('winner is player '..tostring(winningplayer),0,10,virtual_width,'center')
        love.graphics.setFont(smallfont)
        love.graphics.printf('press Enter to restart', 0, 30, virtual_width, 'center')
    end

    

    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()), 10,0)
end

function displayscore()
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1score), virtual_width / 2 - 50, virtual_height / 3)
    love.graphics.print(tostring(player2score), virtual_width / 2 + 30, virtual_height / 3)
end
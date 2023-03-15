--[[
    A platformer composed of stages meant to stress my programming skills
    and also a form of thanks to the CS50 team!
]]

Class = require 'class'
push = require 'push'

require 'Util'
require 'Stage1'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

stage1 = Stage1()

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()

    -- setup screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    love.window.setTitle('Thank You CS50!')     -- window title

    love.keyboard.keysPressed = {}

end

function love.update(dt)

    stage1:update(dt)
    
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()

    push:apply('start')

    love.graphics.translate(math.floor(-stage1.camX), math.floor(-stage1.camY))

    love.graphics.clear(20/255, 20/255, 40/255, 1)
    stage1:render()

    push:apply('end')

end
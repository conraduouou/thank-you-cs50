--[[
    The player class for Thank You CS50! game
]]
Player = Class{}

require 'Animation'

local MOVE_SPEED = 120
local JUMP_VELOCITY = 400
local GRAVITY = 17

function Player:init(map)

    self.map = map      -- connect map

    self.width = 16     -- the player width
    self.height = 27    -- the player height

    self.x = 0      -- player x position, determine in map
    self.y = 0      -- player y position, determine in map

    self.texture = love.graphics.newImage('graphics/char.png')      -- player spritesheet
    self.frames = generateQuads(self.texture, self.width, self.height)      -- spritesheet quads

    self.direction = 'right'        -- player direction

    self.state = 'idle'     -- set state to idle at init
    
    self.dx = 0     -- player x velocity
    self.dy = 0     -- player y velocity

    -- animation initialize based on state
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1],
                self.frames[2],
                self.frames[3],
                self.frames[4],
                self.frames[5],
                self.frames[6],
                self.frames[7],
                self.frames[8],
                self.frames[9],
                self.frames[10]
            },
            interval = 0.15
        },
        ['walking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[11],
                self.frames[12],
                self.frames[13],
                self.frames[14],
                self.frames[15],
                self.frames[16],
                self.frames[17],
                self.frames[18]
            },
            interval = 0.05
        },
        ['jumping'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[23],
                self.frames[24],
                self.frames[25],
                self.frames[26],
                self.frames[27]
            },
            interval = 0.15
        },
        ['falling'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[28],
                self.frames[29],
                self.frames[30]
            },
            interval = 0.15
        }
    }

    self.animation = self.animations['idle']        -- set animation to idle

    self.playermovement = true      -- determines if player can move or not

    -- state machine; also determines what state in order for love to animate needed frame
    self.behaviors = {
        ['idle'] = function(dt)
            if (love.keyboard.wasPressed('w') or love.keyboard.wasPressed('space')) and self.playermovement == true then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations[self.state]
                self.animation:restart()
            elseif love.keyboard.isDown('a') and self.playermovement == true then
                self.dx = -MOVE_SPEED
                self.state = 'walking'
                self.direction = 'left'
                self.animation = self.animations[self.state]
            elseif love.keyboard.isDown('d') and self.playermovement == true then
                self.dx = MOVE_SPEED
                self.state = 'walking'
                self.direction = 'right'
                self.animation = self.animations[self.state]
            else
                self.dx = 0
                self.animation = self.animations[self.state]
            end
        end,
        ['walking'] = function(dt)
            if (love.keyboard.wasPressed('w') or love.keyboard.wasPressed('space')) and self.playermovement == true then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations[self.state]
                self.animation:restart()
            elseif love.keyboard.isDown('a') and self.playermovement == true then
                self.dx = -MOVE_SPEED
                self.direction = 'left'
            elseif love.keyboard.isDown('d') and self.playermovement == true then
                self.dx = MOVE_SPEED
                self.direction = 'right'
            else
                self.state = 'idle'
                self.dx = 0
                self.animation = self.animations[self.state]
            end

            self:checkRightCollision()
            self:checkLeftCollision()

            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                self.state = 'falling'
                self.animation = self.animations[self.state]
            end
        end,
        ['jumping'] = function(dt)
            if love.keyboard.isDown('a') and self.playermovement == true then
                self.dx = -MOVE_SPEED
                self.direction = 'left'
            elseif love.keyboard.isDown('d') and self.playermovement == true then
                self.dx = MOVE_SPEED
                self.direction = 'right'
            else
                self.dx = 0
            end

            self.dy = self.dy + GRAVITY

            if self.dy >= 0 then
                self.state = 'falling'
                self.animation = self.animations[self.state]
                self.animation:restart()
            end

            self:checkRightCollision()
            self:checkLeftCollision()

        end,
        ['falling'] = function(dt)
            if love.keyboard.isDown('a') and self.playermovement == true then
                self.dx = -MOVE_SPEED
                self.direction = 'left'
            elseif love.keyboard.isDown('d') and self.playermovement == true then
                self.dx = MOVE_SPEED
                self.direction = 'right'
            else
                self.dx = 0
            end

            self.dy = self.dy + GRAVITY

            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations[self.state]
                self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
            end

            self:checkRightCollision()
            self:checkLeftCollision()
        end
    }
end

-- checks right of player whether it is a collidable tile
function Player:checkRightCollision()
    if self.dx > 0 then
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then

            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

-- checks left of player whether it is a collidable tile
function Player:checkLeftCollision()
    if self.dx < 0 then
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

function Player:update(dt)

    self.behaviors[self.state](dt)      -- update state
    self.animation:update(dt)           -- update animation according to state

    self.x = self.x + self.dx * dt      -- player x position update with respect to time
    self.y = self.y + self.dy * dt      -- player y position update with respect to time

    if self.dy < 0 then
        if self.map:collides(self.map:tileAt(self.x, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y)) then

            self.dy = 0

        end

    end
end

function Player:render()

    local scaleX = 0
    local xOffset = self.width / 2
    local yOffset = self.height / 2

    if self.direction == 'right' then
        scaleX = 1
    elseif self.direction == 'left' then
        scaleX = -1
    end
    
    
    love.graphics.draw(self.texture, self.animation:getcurrentFrame(), math.floor(self.x + xOffset), 
        math.floor(self.y + yOffset), 0, scaleX, 1, math.floor(xOffset), math.floor(yOffset))

end